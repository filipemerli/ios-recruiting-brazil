//
//  MoviesCollectionViewCell.swift
//  MyMoviesCollection
//
//  Created by Filipe Merli on 12/03/20.
//  Copyright © 2020 Filipe Merli. All rights reserved.
//

import UIKit

class MoviesCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    lazy private var bannerView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var infosView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = ColorSystem.cYellowDark
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var favoriteButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let iconForNormal = #imageLiteral(resourceName: "favorite_gray_icon")
        button.setImage(iconForNormal, for: .normal)
        let iconForSelected = #imageLiteral(resourceName: "favorite_full_icon")
        button.setImage(iconForSelected, for: .selected)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.style = .medium
        indicator.startAnimating()
        return indicator
    }()
    
    var bannerImage: UIImage? {
        didSet {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.bannerView.image = self.bannerImage
            }
        }
    }
    
    var isFavorite: Bool? {
        didSet {
            DispatchQueue.main.async {
                self.favoriteButton.isSelected = self.isFavorite ?? false
            }
        }
    }
    
    var movieTitle: String? {
        didSet {
            DispatchQueue.main.async {
                self.titleText.text = self.movieTitle
            }
        }
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubViews()
        setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bannerView.image = #imageLiteral(resourceName: "placeholder")
        favoriteButton.isSelected = false
    }

    // MARK: - Class Functions
    
    fileprivate func setUpSubViews(){
        backgroundColor = ColorSystem.cBlueDark
        contentView.addSubview(bannerView)
        bannerView.addSubview(activityIndicator)
        contentView.addSubview(infosView)
        infosView.addSubview(titleText)
        infosView.addSubview(favoriteButton)
        
    }
    
    fileprivate func setUpConstraints() {
        NSLayoutConstraint.activate([
            bannerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bannerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bannerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bannerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bannerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -60),
            activityIndicator.centerYAnchor.constraint(equalTo: bannerView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: bannerView.centerXAnchor),
            infosView.topAnchor.constraint(equalTo: bannerView.bottomAnchor),
            infosView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            infosView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            infosView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleText.topAnchor.constraint(equalTo: infosView.topAnchor, constant: 5),
            titleText.leadingAnchor.constraint(equalTo: infosView.leadingAnchor, constant: 3),
            titleText.trailingAnchor.constraint(equalTo: infosView.trailingAnchor, constant: -30),
            titleText.bottomAnchor.constraint(equalTo: infosView.bottomAnchor, constant: -5),
            favoriteButton.centerYAnchor.constraint(equalTo: infosView.centerYAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: infosView.trailingAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: 35.0),
            favoriteButton.heightAnchor.constraint(equalToConstant: 35.0)
        ])
        
    }
    
}
