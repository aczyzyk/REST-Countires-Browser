//
//  CustomViewController.swift
//  REST Countries Browser
//
//  Created by Andrzej Czyżyk on 09/05/2019.
//  Copyright © 2019 Andrzej Czyżyk. All rights reserved.
//

import UIKit

class CustomViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    func showAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated:  true)
        
    }

}
