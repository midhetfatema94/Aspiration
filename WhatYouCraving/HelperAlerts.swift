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
            print("here 1")
            alert = CDAlertView(title: nil, message: message, type: .error)
        }
        else if message == "" {
            print("here 2")
            alert = CDAlertView(title: title, message: nil, type: .error)
        }
        else {
            print("here 3")
            alert = CDAlertView(title: title, message: message, type: .error)
        }
        
        let saveAction = CDAlertViewAction(title: "OK")
        alert.add(action: saveAction)
        alert.show()
    }
}
