//
//  UIViewController+Alerts.swift
//  MyMoviesCollection
//
//  Created by Filipe Merli on 25/03/20.
//  Copyright © 2020 Filipe Merli. All rights reserved.
//

import UIKit

protocol ShowAlert {
    func showErrorAlert(with message: String)
}

extension UIViewController: ShowAlert {
    func showErrorAlert(with message: String) {
        guard presentedViewController == nil else {
            return
        }
        let alertController = UIAlertController(title: "Alerta", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}
