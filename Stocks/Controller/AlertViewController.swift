//
//  AlertViewController.swift
//  Stocks
//
//  Created by Алексей on 11.09.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public func createCustomAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString("Close", comment: "Close action"), style: .cancel, handler: { _ in
        NSLog("The \"OK\" alert occured.")
        })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
