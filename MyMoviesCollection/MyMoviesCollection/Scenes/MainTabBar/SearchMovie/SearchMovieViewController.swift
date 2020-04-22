//
//  SearchMovieViewController.swift
//  MyMoviesCollection
//
//  Created by Filipe Merli on 16/03/20.
//  Copyright © 2020 Filipe Merli. All rights reserved.
//

import UIKit

protocol SearchMovieDisplayLogic: class {
    func renderMoviesList(viewModel: SearchMovie.Fetch.ViewModel)
    func renderMovieBanner(viewModel: SearchMovie.MovieInfo.ViewModelBanner)
    func renderFavoriteFeedback(viewModel: SearchMovie.MovieInfo.ViewModelFavorite)
}

class SearchMovieViewController: UIViewController {

    // MARK: - Properties

    public var searchString = ""
    private let reuseIdentifier = "movcell"
    private let itemsPerRow: CGFloat = 2
    private let numOfSects = 2
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 5.0, right: 10.0)
    private(set) var movies = [Movie]()
    var interactor: SearchMovieBusinessLogic?
    var router: (NSObjectProtocol & SearchMovieRoutingLogic & SearchMovieDataPassing)?
    public var movieToPresent: Movie?
    
    private(set) var viewState: ViewState = .loading {
        didSet {
            switch viewState {
            case .loaded:
                DispatchQueue.main.async {
                    self.loadingIndicator.stopAnimating()
                    self.collectionView.isHidden = false
                }
                break
            case .loading:
                DispatchQueue.main.async {
                    self.loadingIndicator.startAnimating()
                    self.collectionView.isHidden = true
                }
                break
            case .empty:
                DispatchQueue.main.async {
                    self.loadingIndicator.stopAnimating()
                    self.collectionView.isHidden = true
                    self.setUpNoResultsView()
                }
                break
            }
        }
    }
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .white
        return collection
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        return indicator
    }()
    
    lazy var noResultsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = #imageLiteral(resourceName: "search_icon")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 26.0)
        label.textColor = ColorSystem.cBlueDark
        label.numberOfLines = 3
        label.textAlignment = .center
        return label
    }()
    
    // MARK:  ViewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if viewState != .loaded {
            viewState = .loading
        }
        interactor?.fetchSearchMovies()
    }
    
    override func loadView() {
        super.loadView()
        setUpSubViews()
    }
    
    // MARK: Initializers
    
    init(configurator: SearchMovieConfigurator = SearchMovieConfigurator.shared) {
        super.init(nibName: nil, bundle: nil)
        configurator.configure(viewController: self)
        collectionView.register(SearchMovieCollectionCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        setUpSubViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        SearchMovieConfigurator.shared.configure(viewController: self)
    }
    
    // MARK: Class Funcitons
    
    private func setUpSubViews() {
        view.addSubview(loadingIndicator)
        view.addSubview(collectionView)
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.widthAnchor.constraint(equalToConstant: 35.0),
            loadingIndicator.heightAnchor.constraint(equalToConstant: 35.0),
            view.topAnchor.constraint(equalTo: collectionView.topAnchor),
            view.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor)
        ])
    }

    private func setUpNoResultsView() {
        view.addSubview(noResultsView)
        noResultsView.addSubview(imageView)
        noResultsView.addSubview(label)
        
        noResultsView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        noResultsView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        noResultsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        noResultsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        imageView.bottomAnchor.constraint(equalTo: noResultsView.centerYAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: noResultsView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: noResultsView.trailingAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: (view.frame.height / 4)).isActive = true
        
        label.topAnchor.constraint(equalTo: noResultsView.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: noResultsView.leadingAnchor, constant: 45).isActive = true
        label.trailingAnchor.constraint(equalTo: noResultsView.trailingAnchor, constant: -45).isActive = true
        label.heightAnchor.constraint(equalToConstant: (view.frame.height / 4)).isActive = true
        
        label.text = "Sua busca por \u{22}\(searchString)\u{22} não resultou em nenhum resultado."
        
    }

}

// MARK: - SearchMovieDisplayLogic

extension SearchMovieViewController: SearchMovieDisplayLogic {
    
    func renderFavoriteFeedback(viewModel: SearchMovie.MovieInfo.ViewModelFavorite) {
        if let cell = viewModel.cell as? SearchMovieCollectionCell {
            cell.isFavorite = viewModel.isFavorite
        }
    }
    
    func renderMoviesList(viewModel: SearchMovie.Fetch.ViewModel) {
        guard !(viewModel.movies.isEmpty) else {
            return
        }
        movies.append(contentsOf: viewModel.movies)
        viewState = movies.isEmpty ? .empty : .loaded
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func renderMovieBanner(viewModel: SearchMovie.MovieInfo.ViewModelBanner) {
        if let cell = viewModel.cell as? SearchMovieCollectionCell {
            cell.bannerImage = viewModel.image
        }
    }
    
}

// MARK: - CollectionView Delegate

extension SearchMovieViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellIndex = (indexPath.row == 0 ? (indexPath.section * Int(itemsPerRow)) : (indexPath.section * Int(itemsPerRow)) + 1)
        movieToPresent = movies[cellIndex]
        guard movieToPresent != nil else {
            showErrorAlert(with: "Filme vazio")
            return
        }
        router?.routeToDetail(source: self)
    }
}

// MARK: - CollectionView DataSource

extension SearchMovieViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count > 0 ? Int(itemsPerRow) : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SearchMovieCollectionCell = {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? SearchMovieCollectionCell else {
                return SearchMovieCollectionCell()
            }
            return cell
        }()
        guard movies.count > 0 else {
            return cell
        }
        let cellIndex = (indexPath.row == 0 ? (indexPath.section * 2) : ((indexPath.section * 2) + 1))
        guard cellIndex < movies.count else {
            return cell
        }
        cell.movieTitle = movies[cellIndex].title
        return cell
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if (movies.count > 0) {
            return movies.count % Int(itemsPerRow) == 0 ? (movies.count / Int(itemsPerRow)) : ((movies.count + 1) / Int(itemsPerRow))
        }else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cellIndex = (indexPath.row == 0 ? (indexPath.section * 2) : ((indexPath.section * 2) + 1))
        guard cellIndex < movies.count else {
            return
        }
        let movie = movies[cellIndex]
        let requestBanner = SearchMovie.MovieInfo.RequestBanner(cell: cell, posterUrl: movie.posterUrl ?? "https://")
        let requestFavorite = SearchMovie.MovieInfo.RequestFavorite(cell: cell, movieId: movie.id ?? 0)
        interactor?.fetchBannerImage(request: requestBanner)
        interactor?.checkIfFavorite(request: requestFavorite)
    }
    
}

// MARK: - CollectionView Delegate FlowLayout

extension SearchMovieViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: (widthPerItem * 1.5))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
}
