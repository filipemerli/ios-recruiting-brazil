//
//  MovieDetailViewController.swift
//  MyMoviesCollection
//
//  Created by Filipe Merli on 13/03/20.
//  Copyright © 2020 Filipe Merli. All rights reserved.
//

import UIKit

protocol MovieDetailDisplayLogic: class {
    func renderMovieDetail(viewModel: MovieDetail.ShowMovieDetail.ViewModel)
    func renderMovieGenre(viewModel: MovieDetail.ShowMovieDetail.MovieGenres)
    func renderMovieBanner(viewModel: MovieDetail.ShowMovieDetail.MovieBanner)
    func renderFavoriteButtonFeedback(viewModel: MovieDetail.ShowMovieDetail.MovieFavButtonFeedback)
}

class MovieDetailViewController: UIViewController, Alerts {
    
    // MARK: - Properties
    
    private lazy var imageView: UIImageView = {
        let poster = UIImageView()
        poster.translatesAutoresizingMaskIntoConstraints = false
        poster.contentMode = .scaleAspectFit
        return poster
    }()
    
    
    private lazy var infosView: UIView = {
        let infos = UIView()
        infos.translatesAutoresizingMaskIntoConstraints = false
        return infos
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var yearLabel: UILabel = {
        let year = UILabel()
        year.translatesAutoresizingMaskIntoConstraints = false
        return year
    }()
    
    private lazy var overview: UITextView = {
        let descrp = UITextView()
        descrp.translatesAutoresizingMaskIntoConstraints = false
        descrp.isEditable = false
        return descrp
    }()
    
    private lazy var genres: UILabel = {
        let gen = UILabel()
        gen.translatesAutoresizingMaskIntoConstraints = false
        gen.numberOfLines = 1
        gen.adjustsFontSizeToFitWidth = true
        return gen
    }()
    
    private lazy var favButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        let iconNormal = #imageLiteral(resourceName: "favorite_empty_icon")
        btn.setImage(iconNormal, for: .normal)
        let iconSelected = #imageLiteral(resourceName: "favorite_full_icon")
        btn.setImage(iconSelected, for: .selected)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.isEnabled = false
        return btn
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let ind = UIActivityIndicatorView()
        ind.translatesAutoresizingMaskIntoConstraints = false
        ind.style = .medium
        ind.hidesWhenStopped = true
        return ind
    }()
    
    private var isFavorite: Bool = false
    var router: (NSObjectProtocol & MovieDetailRoutingLogic & MovieDetailDataPassing)?
    var interactor: MovieDetailBusinessLogic?

    // MARK: Initializers
    
    init(configurator: MovieDetailConfigurator = MovieDetailConfigurator.shared) {
        super.init(nibName: nil, bundle: nil)
        configurator.configure(viewController: self)
        setUpSubViews()
        setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        MovieDetailConfigurator.shared.configure(viewController: self)    }
    
    // MARK: - ViewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setUpFavButton()
    }
    
    override func viewDidLayoutSubviews() {
        setUpBorders()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.fetchMovieDetails()
        interactor?.fetchMovieGenres()
        interactor?.fetchBannerImage()
    }
    
    // MARK: - Class Functions
    
    private func setUpSubViews() {
        self.view.backgroundColor = .white
        view.addSubview(imageView)
        view.addSubview(infosView)
        infosView.addSubview(titleLabel)
        infosView.addSubview(yearLabel)
        infosView.addSubview(genres)
        infosView.addSubview(overview)
        infosView.addSubview(favButton)
        imageView.addSubview(loadingIndicator)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            imageView.bottomAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            infosView.topAnchor.constraint(equalTo: view.centerYAnchor),
            infosView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            infosView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            infosView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            titleLabel.topAnchor.constraint(equalTo: infosView.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: infosView.trailingAnchor, constant: -45),
            titleLabel.leadingAnchor.constraint(equalTo: infosView.leadingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 45),
            yearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            yearLabel.trailingAnchor.constraint(equalTo: infosView.trailingAnchor),
            yearLabel.leadingAnchor.constraint(equalTo: infosView.leadingAnchor),
            yearLabel.heightAnchor.constraint(equalToConstant: 45),
            genres.topAnchor.constraint(equalTo: yearLabel.bottomAnchor),
            genres.trailingAnchor.constraint(equalTo: infosView.trailingAnchor),
            genres.leadingAnchor.constraint(equalTo: infosView.leadingAnchor),
            genres.heightAnchor.constraint(equalToConstant: 45),
            overview.topAnchor.constraint(equalTo: genres.bottomAnchor),
            overview.trailingAnchor.constraint(equalTo: infosView.trailingAnchor),
            overview.leadingAnchor.constraint(equalTo: infosView.leadingAnchor),
            overview.bottomAnchor.constraint(equalTo: infosView.bottomAnchor),
            favButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            favButton.trailingAnchor.constraint(equalTo: infosView.trailingAnchor),
            favButton.widthAnchor.constraint(equalToConstant: 45),
            favButton.heightAnchor.constraint(equalToConstant: 45),
            loadingIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            loadingIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor)
        ])
    }
    
    private func setUpFavButton() {
        favButton.addTarget(self, action: #selector(favoriteMovie), for: .touchUpInside)
        favButton.isEnabled = true  // TO DO adjust
        //checkIfFavorite()
    }
    
    private func updateFavButtonFeedback() {
        DispatchQueue.main.async {
            self.favButton.isSelected = self.isFavorite
            self.favButton.isEnabled = true
        }
    }
    
    private func setUpBorders() {
        titleLabel.layer.addBottomBorders()
        yearLabel.layer.addBottomBorders()
        favButton.layer.addBottomBorders()
        genres.layer.addBottomBorders()
    }
        
    @objc func favoriteMovie(sender: UIButton!) {
        if !isFavorite {
            interactor?.favoriteMovie()
        }
    }
    
}

// MARK: - MovieDetailDisplayLogic

extension MovieDetailViewController: MovieDetailDisplayLogic {
    
    func renderMovieBanner(viewModel: MovieDetail.ShowMovieDetail.MovieBanner) {
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
            self.imageView.image = viewModel.image
        }
    }
    
    func renderMovieGenre(viewModel: MovieDetail.ShowMovieDetail.MovieGenres) {
        DispatchQueue.main.async {
            self.genres.text = viewModel.genres
        }
    }
    
    func renderMovieDetail(viewModel: MovieDetail.ShowMovieDetail.ViewModel) {
        let movieToPresent = viewModel.movie
        DispatchQueue.main.async {
            self.yearLabel.text = movieToPresent.releaseDate
            self.overview.text = movieToPresent.overview
            self.titleLabel.text = movieToPresent.title
        }
    }
    
    func renderFavoriteButtonFeedback(viewModel: MovieDetail.ShowMovieDetail.MovieFavButtonFeedback) {
        favButton.isEnabled = true
        isFavorite = viewModel.favButtonFeedback
        DispatchQueue.main.async {
            self.favButton.isSelected = viewModel.favButtonFeedback
        }
        if viewModel.favButtonFeedback {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadMovies"), object: nil)
        }
    }
    
}
