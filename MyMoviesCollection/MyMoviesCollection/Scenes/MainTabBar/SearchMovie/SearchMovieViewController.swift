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

final class SearchMovieViewController: UIViewController {

    // MARK: - Properties

    private let observerName = "reloadSearch"
    public var searchString = ""
    public var totalResults = 0
    private let reuseIdentifier = "movcell"
    private let itemsPerRow: CGFloat = 2
    private let numOfSects = 2
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 5.0, right: 10.0)
    private var movies = [Movie]()
    var interactor: SearchMovieBusinessLogic?
    var router: (NSObjectProtocol & SearchMovieRoutingLogic & SearchMovieDataPassing)?
    public var movieToPresent: Movie?
    private var isPrefetching = false
    private var isPrefetchingDisabled = false

    private var currentPage = 0 {
        didSet {
            if currentPage > 1 {
                let request = SearchMovie.Fetch.Request(page: currentPage)
                interactor?.fetchSearchMovies(request: request)
            }
        }
    }
    
    private var viewState: ViewState = .loading {
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
        if currentPage == 0 {
            interactor?.fetchSearchMovies(request: SearchMovie.Fetch.Request(page: 1))
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let navTopItem = navigationController?.navigationBar.topItem {
            navTopItem.titleView = .none
            navTopItem.title = "\u{22}\(searchString)\u{22}"
        }
    }
    
    override func loadView() {
        super.loadView()
        setUpSubViews()
    }
    
    // MARK: Initializers
    
    init(configurator: SearchMovieConfigurator = SearchMovieConfigurator.shared) {
        super.init(nibName: nil, bundle: nil)
        configurator.configure(viewController: self)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCollection), name: NSNotification.Name(rawValue: observerName), object: nil)
        collectionView.register(SearchMovieCollectionCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        setUpSubViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        SearchMovieConfigurator.shared.configure(viewController: self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: observerName), object: nil)
        movies.removeAll()
        currentPage = 0
        searchString = ""
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
        noResultsView.backgroundColor = .white
        noResultsView.addSubview(imageView)
        noResultsView.addSubview(label)
        NSLayoutConstraint.activate([
            noResultsView.topAnchor.constraint(equalTo: view.topAnchor),
            noResultsView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            noResultsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noResultsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: noResultsView.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: noResultsView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: noResultsView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: (view.frame.height / 4)),
            label.topAnchor.constraint(equalTo: noResultsView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: noResultsView.leadingAnchor, constant: 45),
            label.trailingAnchor.constraint(equalTo: noResultsView.trailingAnchor, constant: -45),
            label.heightAnchor.constraint(equalToConstant: (view.frame.height / 4))
        ])
        label.text = "Sua busca por \u{22}\(searchString)\u{22} não resultou em nenhum resultado."
        
    }
    
    @objc func reloadCollection() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
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
        isPrefetching = false
        guard !(currentPage > 1 && viewModel.movies.isEmpty) else {
            isPrefetchingDisabled = true
            return
        }
        movies.append(contentsOf: viewModel.movies)
        searchString = viewModel.keyWord
        totalResults = viewModel.totalResults
        currentPage += 1
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
        movieToPresent = movies[indexPath.row]
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
        return movies.count
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
        cell.movieTitle = movies[indexPath.row].title
        return cell
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
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

// MARK: - UITableViewDataSourcePrefetching

extension SearchMovieViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard !isPrefetching && !isPrefetchingDisabled && movies.count < totalResults else { return }
        let fetchMovies = indexPaths.contains { ($0.row >= movies.count - 1) }
        
        if fetchMovies {
            isPrefetching = true
            currentPage += 1
        }
    }
    
}
