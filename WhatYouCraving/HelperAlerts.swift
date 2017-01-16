//
//  HelperAlerts.swift
//  WhatYouCraving
//
//  Created by Midhet Sulemani on 16/01/17.
//  Copyright © 2017 MCreations. All rights reserved.
//

import Foundation
import UIKit
import CDAlertView

class Alert {
    
    func showAlert(title: String, message: String, vc: UIViewController) {
        
        var alert = CDAlertView()
        
        if title == "" {
            
            alert = CDAlertView(title: nil, message: message, type: .error)
        }
        else if message == "" {
            alert = CDAlertView(title: title, message: nil, type: .error)
        }
        else {
            alert = CDAlertView(title: title, message: message, type: .error)
        }
        
        let saveAction = CDAlertViewAction(title: "OK")
        alert.add(action: saveAction)
        alert.show()
    }
}
