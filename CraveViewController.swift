//
//  CraveViewController.swift
//  WhatYouCraving
//
//  Created by Midhet Sulemani on 29/12/16.
//  Copyright © 2016 MCreations. All rights reserved.
//

import UIKit

class CraveViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    var suggestions: [[String: Any]] = []
    var cityName: String = ""
    var picker: UIPickerView!
    var cuisineId: Int!
    let alerts = Alert()
    var activity = UIActivityIndicatorView()
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var mainStack: UIStackView!
    @IBOutlet weak var dishTextField: UITextField!
    
    @IBAction func changeCity(_ sender: Any) {
        
        showAlertBox()
    }
    @IBAction func getRestaurants(_ sender: Any) {
        
        dishTextField.resignFirstResponder()
        if cuisineId != nil {
            
            performSegue(withIdentifier: "getPlaces", sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        showAlertBox()
        getCityName()
        
        picker = UIPickerView()
        picker.delegate = self
        dishTextField.inputView = picker
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 35))
        let leftButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(CraveViewController.cancelPicker(sender:)))
        let middleButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let rightButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(CraveViewController.donePicker(sender:)))
        toolbar.setItems([leftButton, middleButton, rightButton], animated: false)
        dishTextField.inputAccessoryView = toolbar
        
        NotificationCenter.default.addObserver(self, selector: #selector(CraveViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CraveViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.navigationController!.isNavigationBarHidden = true
        
        activity = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        activity.center = self.view.center
        activity.color = UIColor.black
        self.view.addSubview(activity)
        activity.isHidden = true
        
    }
    
    func showAlertBox() {
        
//        let alert = UIAlertController(title: "Enter your city", message: nil, preferredStyle: .alert)
//        
//        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { (action:UIAlertAction) -> Void in
//            
//            let textField = alert.textFields!.first
//            self.cityName = textField!.text!
//            self.cityLabel.text = "I'm in \(textField!.text!)!"
//            self.activity.isHidden = false
//            self.activity.startAnimating()
//            self.getCityName()
//        })
//        
//        alert.addTextField {(textField: UITextField) -> Void in
//        }
//        
//        alert.addAction(saveAction)
//        present(alert, animated: true, completion: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let orientation = UIApplication.shared.statusBarOrientation
        
        if orientation.isPortrait {
            
            mainStack.axis = .vertical
        }
        else if orientation.isLandscape {
            
            mainStack.axis = .horizontal
        }
    }
    
    func keyboardWillShow(_ notification: Notification) {
        
        if let keyboardSize = (((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) {
            
            let orientation = UIApplication.shared.statusBarOrientation
            
            if  orientation.isLandscape {
                
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            let orientation = UIApplication.shared.statusBarOrientation
            
            if orientation.isLandscape {
                
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return suggestions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let cuisineObject = suggestions[row]["cuisine"] as! [String: Any]
        return cuisineObject["cuisine_name"] as? String
    }
    
    func getCuisineSuggestions(id: Int) {
        
        request.getZomatoCuisineId(cityId: 3, controller: self, completion: {response in
            
            DispatchQueue.main.async {
                
                if response["code"] != nil {
                    self.alerts.showAlert(title: "Error", message: response["message"] as! String, vc: self)
                }
                else {
                    self.activity.stopAnimating()
                    self.activity.isHidden = true
                    self.suggestions = response["cuisines"] as! [[String: Any]]
                    self.picker.reloadAllComponents()
                }
            }
        })
    }
    
    func getCityName() {
        
        request.getZomatoCityId(cityName: "Mumbai", controller: self, completion: {response in
            
            DispatchQueue.main.async {
                
                self.activity.isHidden = true
                self.activity.stopAnimating()
                
                if response["code"] != nil {
                    self.alerts.showAlert(title: "Error", message: response["message"] as! String, vc: self)
                }
                else if let suggestions = response["location_suggestions"] as? [[String: Any]] {
                    if suggestions.count > 0 {
                        
                        self.getCuisineSuggestions(id: suggestions[0]["id"] as! Int)
                    }
                    else {
                        
                        self.alerts.showAlert(title: "Sorry", message: "No suggestions found!", vc: self)
                        self.showAlertBox()
                    }
                }
            }
        })
    }
    
    func cancelPicker(sender: UIBarButtonItem) {
        
        dishTextField.resignFirstResponder()
    }
    
    func donePicker(sender: UIBarButtonItem) {
        
        dishTextField.resignFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let cuisineObject = suggestions[row]["cuisine"] as! [String: Any]
        cuisineId = cuisineObject["cuisine_id"]! as! Int
        dishTextField.text = cuisineObject["cuisine_name"] as? String
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "getPlaces" {
            
            let vc = segue.destination as! UITabBarController
            let mapVC = vc.viewControllers?.first as! MapViewController
            mapVC.cuisineName = dishTextField.text!
            mapVC.cityName = cityName
        }
    }
}
