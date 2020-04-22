//
//  FavoritesTableViewCell.swift
//  MyMoviesCollection
//
//  Created by Filipe Merli on 12/03/20.
//  Copyright © 2020 Filipe Merli. All rights reserved.
//

import UIKit

class FavoritesTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    private lazy var bannerView: UIImageView = {
       let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
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
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .left
        label.textColor = ColorSystem.cBlueDark
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var overview: UITextView = {
        let descrp = UITextView()
        descrp.translatesAutoresizingMaskIntoConstraints = false
        descrp.isEditable = false
        descrp.textColor = ColorSystem.cBlueDark
        descrp.backgroundColor = .systemGray4
        return descrp
    }()
    
    private lazy var year: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .right
        label.textColor = ColorSystem.cBlueDark
        label.numberOfLines = 1
        return label
    }()
    
    var movieText: String? {
        didSet {
            DispatchQueue.main.async {
                self.titleText.text = self.movieText
            }
        }
    }
    
    var overviewText: String? {
        didSet {
            DispatchQueue.main.async {
                self.overview.text = self.overviewText
            }
        }
    }
    
    var yearText: String? {
        didSet {
            DispatchQueue.main.async {
                self.year.text = self.yearText
            }
        }
    }
    
    var bannerImage: UIImage? {
        didSet {
            DispatchQueue.main.async {
                self.bannerView.image = self.bannerImage
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configSubViews()
        configConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
    }
    
    // MARK: - Class Functions
    
    private func configSubViews() {
        backgroundColor = .systemGray4
        contentView.addSubview(bannerView)
        bannerView.addSubview(activityIndicator)
        contentView.addSubview(infosView)
        infosView.addSubview(titleText)
        infosView.addSubview(overview)
        infosView.addSubview(year)
        
    }
    
    func configConstraints() {
        NSLayoutConstraint.activate([
            bannerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bannerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bannerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1),
            bannerView.widthAnchor.constraint(equalToConstant: 110),
            activityIndicator.centerYAnchor.constraint(equalTo: bannerView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: bannerView.centerXAnchor),
            infosView.topAnchor.constraint(equalTo: contentView.topAnchor),
            infosView.leadingAnchor.constraint(equalTo: bannerView.trailingAnchor),
            infosView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            infosView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1),
            titleText.topAnchor.constraint(equalTo: infosView.topAnchor, constant: 10),
            titleText.leadingAnchor.constraint(equalTo: infosView.leadingAnchor, constant: 10),
            titleText.trailingAnchor.constraint(equalTo: infosView.trailingAnchor, constant: -55),
            titleText.heightAnchor.constraint(equalToConstant: 45),
            overview.bottomAnchor.constraint(equalTo: infosView.bottomAnchor, constant: -10),
            overview.leadingAnchor.constraint(equalTo: infosView.leadingAnchor, constant: 10),
            overview.trailingAnchor.constraint(equalTo: infosView.trailingAnchor, constant: -10),
            overview.topAnchor.constraint(equalTo: titleText.bottomAnchor, constant: 3),
            year.trailingAnchor.constraint(equalTo: infosView.trailingAnchor, constant: -10),
            year.heightAnchor.constraint(equalToConstant: 45),
            year.topAnchor.constraint(equalTo: infosView.topAnchor, constant: 10),
            year.widthAnchor.constraint(equalToConstant: 55)
        ])
    }

}
