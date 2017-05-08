//
//  UIViewController+Extensions.swift
//  MyMood
//
//  Created by Christian Sjøgreen on 07/05/2017.
//  Copyright © 2017 Bitfarm ApS. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentAlert(title: String, text: String?) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(dismiss)
        self.present(alert, animated: true, completion: nil)
    }
}
