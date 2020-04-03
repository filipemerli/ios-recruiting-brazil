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
}

class MoviesListViewController: UIViewController {
    
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
    
    var interactor: MoviesListBusinessLogic?
    var router: (NSObjectProtocol & MoviesListRoutingLogic & MoviesListDataPassing)?
    private let itemsPerRow: CGFloat = 2
    private let numOfSects = 2
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 5.0, right: 10.0)
    private(set) var movies = [Movie]()
    private let reuseIdentifier = "movcell"
    private let collectionLayout = MoviesListFlowLayout()
    
    private(set) var isPrefetching = false
    private(set) var currentPage = 0 {
        didSet {
            if currentPage == 0 {
                currentPage += 1
            }
            
            
            let request = MoviesList.Fetch.Request(page: currentPage, limit: 0)
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
        
        setUpSubViews()
        setUpConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        MoviesListConfigurator.shared.configure(viewController: self)
    }
    
    deinit {
        //interactor?.cancelAllDownloads()
        //To Do
    }
    
    // MARK: ViewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }

}

// MARK: - MoviesListDisplayLogic

extension MoviesListViewController: MoviesListDisplayLogic {
    
    func renderMoviesList(viewModel: MoviesList.Fetch.ViewModel) {
        isPrefetching = false
        guard !(currentPage > 1 && viewModel.movies.isEmpty) else {
            isPrefetchingDisabled = true
            return
        }
        movies.append(contentsOf: viewModel.movies)
        viewState = movies.isEmpty ? .empty : .loaded
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
}

// MARK: - CollectionView Delegate

extension MoviesListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var cellIndex: Int = 0
            if (indexPath.row == 0) {
                cellIndex = (indexPath.section * Int(itemsPerRow))
            } else{
                cellIndex = ((indexPath.section * Int(itemsPerRow)) + 1)
            }
            let movieToPresent = movies[cellIndex]
            let detailViewController = MovieDetailViewController()
            detailViewController.movieToPresent = movieToPresent
            navigationController?.pushViewController(detailViewController, animated: true)
    }
}

// MARK: - CollectionView DataSource

extension MoviesListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count > 0 ? Int(itemsPerRow) : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MoviesCollectionViewCell
        guard movies.count > 0 else {
            cell.setCell(with: .none)
            return cell
        }
        let cellIndex = (indexPath.row == 0 ? (indexPath.section * 2) : ((indexPath.section * 2) + 1))
            cell.setCell(with: movies[cellIndex])
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if (movies.count > 0) {
            if (movies.count % Int(itemsPerRow) == 0) {
                return (movies.count / Int(itemsPerRow))
            } else{
                return ((movies.count + 1) / Int(itemsPerRow))
            }
        }else {
            return 1
        }
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

// MARK: UITableViewDataSourcePrefetching
extension MoviesListViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard !isPrefetching && !isPrefetchingDisabled else { return }
        
        let fetchMovies = indexPaths.contains { (($0.section * 2) + 3) >= movies.count }
        
        if fetchMovies {
            isPrefetching = true
            currentPage += 1
        }
    }
    
}
