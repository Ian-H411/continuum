//
//  ICloudAlerts.swift
//  Continuum
//
//  Created by Ian Hall on 8/29/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    func presentSimpleAlertWith(title: String, message: String?){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OKAY", style: .cancel, handler: nil)
        alertController.addAction(okayAction)
        present(alertController, animated: true)
    }
}
