//
//  HelperAlerts.swift
//  WhatYouCraving
//
//  Created by Midhet Sulemani on 16/01/17.
//  Copyright © 2017 MCreations. All rights reserved.
//

import Foundation
import UIKit

class Alert {
    
    func showAlert(title: String, message: String, vc: UIViewController) {
        
        var alert = UIAlertController()
        
        if title == "" {
            
            alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        }
        else if message == "" {
            alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        }
        else {
            alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        }
        
        let saveAction = UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction) -> Void in
        })
        alert.addAction(saveAction)
        vc.present(alert, animated: true, completion: nil)
    } 
}
