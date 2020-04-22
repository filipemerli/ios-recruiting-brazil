//
//  FavoritesViewController.swift
//  MyMoviesCollection
//
//  Created by Filipe Merli on 18/04/20.
//  Copyright © 2020 Filipe Merli. All rights reserved.
//

import UIKit

protocol FavoritesDisplayLogic: class {
    func renderFavorites(viewModel: Favorites.Fetch.ViewModel)
    func renderFavoritesBanner(viewModel: Favorites.MovieInfo.ViewModelBanner)
    func deleteFavorite(viewModel: Favorites.DeleteFavorite.ViewModel)
}


class FavoritesViewController: UIViewController, Alerts {
    
    // MARK:  Properties
    
    var interactor: FavoritesBusinessLogic?
    var router: (NSObjectProtocol & FavoritesRoutingLogic & FavoritesDataPassing)?
    var favorites: [FavoriteMovie] = []
    private let reuseIdentifier = "favcell"

    
    private lazy var tableView: UITableView = {
        let collection = UITableView(frame: .zero)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.style = .large
        return indicator
    }()
    
    private(set) var viewState: ViewState = .loading {
        didSet {
            switch viewState {
            case .loaded:
                DispatchQueue.main.async {
                    self.loadingIndicator.stopAnimating()
                    self.tableView.isHidden = false
                }
                break
            case .loading:
                DispatchQueue.main.async {
                    self.loadingIndicator.startAnimating()
                    self.tableView.isHidden = true
                }
                break
            case .empty:
                DispatchQueue.main.async {
                    self.loadingIndicator.stopAnimating()
                    self.tableView.isHidden = true
                }
                break
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        favorites = []
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favorites = []
        interactor?.fetchFavorites()
    }
    
    // MARK: Initializers
    
    init(configurator: FavoritesConfigurator = FavoritesConfigurator.shared) {
        super.init(nibName: nil, bundle: nil)
        configurator.configure(viewController: self)
        tableView.register(FavoritesTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        setUpSubViews()
        setUpConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        FavoritesConfigurator.shared.configure(viewController: self)
    }

    // MARK: - Class Functions
    
    private func setUpSubViews() {
        if let navTopItem = navigationController?.navigationBar.topItem {
            navTopItem.titleView = .none
            navTopItem.title = "Favorites"
        }
        view.addSubview(loadingIndicator)
        view.addSubview(tableView)
        loadingIndicator.style = .large
        loadingIndicator.startAnimating()
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.widthAnchor.constraint(equalToConstant: 35.0),
            loadingIndicator.heightAnchor.constraint(equalToConstant: 35.0),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
}

// MARK: - FavoritesDisplayLogic

extension FavoritesViewController: FavoritesDisplayLogic {
    
    func renderFavorites(viewModel: Favorites.Fetch.ViewModel) {
        favorites.append(contentsOf: viewModel.movies)
        viewState = favorites.isEmpty ? .empty : .loaded
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func renderFavoritesBanner(viewModel: Favorites.MovieInfo.ViewModelBanner) {
        if let cell = viewModel.cell as? FavoritesTableViewCell {
            cell.bannerImage = viewModel.image
        }
    }
    
    func deleteFavorite(viewModel: Favorites.DeleteFavorite.ViewModel) {
        if viewModel.movieToDelete && viewModel.indexToDelete != [] {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadMovies"), object: nil)
            favorites.remove(at: viewModel.indexToDelete.row)
            DispatchQueue.main.async {
                self.tableView.deleteRows(at: [viewModel.indexToDelete], with: .automatic)
            }
        }
        
    }
    
}

extension FavoritesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FavoritesTableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? FavoritesTableViewCell else {
                return FavoritesTableViewCell()
            }
            return cell
        }()
        let movie = favorites[indexPath.row]
        cell.movieText = movie.title
        cell.overviewText = movie.overview
        cell.yearText = movie.year
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
         return "Unfavorite"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let action = UIAlertAction(title: "Desfavoritar", style: .destructive) { (result) in
                let movieId = self.favorites[indexPath.row].id
                self.interactor?.deleteFavorite(request: Favorites.DeleteFavorite.Request(movieId: movieId, indexPath: indexPath))
            }
            let actionCancel = UIAlertAction(title: "Não desejo", style: .default, handler: nil)
            displayAlert(with: "Alerta", message: kUnfavoriteConfirmation, actions: [action, actionCancel])
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let movie = favorites[indexPath.row]
        let requestBanner = Favorites.MovieInfo.RequestBanner(cell: cell, posterUrl: movie.posterUrl ?? "https://")
        interactor?.fetchBannerImage(request: requestBanner)
    }

}

extension FavoritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
}
