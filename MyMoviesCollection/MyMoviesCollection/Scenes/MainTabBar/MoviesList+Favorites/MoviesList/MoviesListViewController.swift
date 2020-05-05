//
//  MoviesListViewController.swift
//  MyMoviesCollection
//
//  Created by Filipe Merli on 24/03/20.
//  Copyright © 2020 Filipe Merli. All rights reserved.
//

import UIKit

protocol MoviesListDisplayLogic: class {
    func renderMoviesList(viewModel: MoviesList.Fetch.ViewModel)
    func renderMovieBanner(viewModel: MoviesList.MovieInfo.ViewModelBanner)
    func renderFavoriteFeedback(viewModel: MoviesList.MovieInfo.ViewModelFavorite)
}

final class MoviesListViewController: UIViewController {
    
    // MARK:  Properties
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.style = .large
        return indicator
    }()
    
    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.tintColor = ColorSystem.cYellowDark
        bar.placeholder = "Search"
        bar.searchBarStyle = .minimal
        bar.backgroundColor = ColorSystem.cYellowDark
        return bar
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .white
        return collection
    }()
    
    private let observerName = "reloadMovies"
    var interactor: MoviesListBusinessLogic?
    var router: (NSObjectProtocol & MoviesListRoutingLogic & MoviesListDataPassing)?
    fileprivate var totalResults = 0
    fileprivate let itemsPerRow: CGFloat = 2
    fileprivate let numOfSects = 2
    fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 5.0, right: 10.0)
    fileprivate var movies = [Movie]()
    fileprivate let reuseIdentifier = "movcell"
    fileprivate let collectionLayout = UICollectionViewFlowLayout()
    public var movieToPresent: Movie?
    public var keyWord: String?
    
    fileprivate var isPrefetching = false
    fileprivate var currentPage = 0 {
        didSet {
            if currentPage == 0 {
                currentPage += 1
            }            
            let request = MoviesList.Fetch.Request(page: currentPage)
            interactor?.fetchPopularMovies(request: request)
        }
    }
    private(set) var isPrefetchingDisabled = false
    
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
                }
                break
            }
        }
    }
    
    // MARK: Initializers
    
    init(configurator: MoviesListConfigurator = MoviesListConfigurator.shared) {
        super.init(nibName: nil, bundle: nil)
        configurator.configure(viewController: self)
        collectionView.register(MoviesCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.collectionViewLayout = collectionLayout
        searchBar.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCollection), name: NSNotification.Name(rawValue: observerName), object: nil)
        setUpSubViews()
        setUpConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        MoviesListConfigurator.shared.configure(viewController: self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: observerName), object: nil)
        //interactor?.cancelAllDownloads() - To Do
    }
    
    // MARK: ViewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
        currentPage = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        if viewState != .loaded {
            viewState = .loading
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let navTopItem = navigationController?.navigationBar.topItem {
            navTopItem.titleView = .none
            navTopItem.title = "Movies"
        }
    }
    
    // MARK: Class Funcitons
    
    private func setUpSubViews() {
        view.addSubview(loadingIndicator)
        view.addSubview(searchBar)
        view.addSubview(collectionView)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.widthAnchor.constraint(equalToConstant: 35.0),
            loadingIndicator.heightAnchor.constraint(equalToConstant: 35.0),
            searchBar.topAnchor.constraint(equalTo: navigationController?.navigationBar.bottomAnchor ?? self.view.topAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 40),
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
    @objc func reloadCollection() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

}

// MARK: - MoviesListDisplayLogic

extension MoviesListViewController: MoviesListDisplayLogic {
    
    func renderFavoriteFeedback(viewModel: MoviesList.MovieInfo.ViewModelFavorite) {
        if let cell = viewModel.cell as? MoviesCollectionViewCell {
            cell.isFavorite = viewModel.isFavorite
        }
    }
    
    func renderMoviesList(viewModel: MoviesList.Fetch.ViewModel) {
        isPrefetching = false
        guard !(currentPage > 1 && viewModel.movies.isEmpty) else {
            isPrefetchingDisabled = true
            return
        }
        let lowerRange = movies.count
        movies.append(contentsOf: viewModel.movies)
        totalResults = viewModel.totalResults
        let upperRange = movies.count
        
        let indexPaths = (lowerRange..<upperRange)
            .map { IndexPath(item: $0, section: 0) }
        viewState = movies.isEmpty ? .empty : .loaded
        
        DispatchQueue.main.async {
            if lowerRange == 0 {
                self.collectionView.reloadData()
            } else {
                self.collectionView.performBatchUpdates({
                    self.collectionView.insertItems(at: indexPaths)
                }) { completed in
                    guard completed else {
                        self.collectionView.reloadData()
                        return
                    }
                }
            }
        }
        
    }
    
    func renderMovieBanner(viewModel: MoviesList.MovieInfo.ViewModelBanner) {
        if let cell = viewModel.cell as? MoviesCollectionViewCell {
            cell.bannerImage = viewModel.image
        }
    }
    
}

// MARK: - CollectionView Delegate

extension MoviesListViewController: UICollectionViewDelegate {
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

extension MoviesListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MoviesCollectionViewCell = {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? MoviesCollectionViewCell else {
                return MoviesCollectionViewCell()
            }
            return cell
        }()
        guard movies.count > 0 else {
            return cell
        }
        let movieCell = movies[indexPath.row]
        cell.movieTitle = movieCell.title
        if let movieBanner = movieCell.posterUrl {
            interactor?.fetchBannerImage(request: MoviesList.MovieInfo.RequestBanner(cell: cell, posterUrl: movieBanner))
        }
        if let movieId = movieCell.id {
            interactor?.checkIfFavorite(request: MoviesList.MovieInfo.RequestFavorite(cell: cell, movieId: movieId))
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
}

// MARK: - CollectionView Delegate FlowLayout

extension MoviesListViewController: UICollectionViewDelegateFlowLayout {
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

extension MoviesListViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard !isPrefetching && !isPrefetchingDisabled && movies.count < totalResults else { return }
        
        let fetchMovies = indexPaths.contains { (($0.row) + 1) >= movies.count }
        
        if fetchMovies {
            isPrefetching = true
            currentPage += 1
        }
    }
    
}

// MARK: - SearchBar Delegate

extension MoviesListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        keyWord = searchBar.text ?? ""
        router?.routeToSearch(source: self)
    }
}
