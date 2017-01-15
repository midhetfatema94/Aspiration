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
    var cityName: String = "" {
        didSet {
            getCityName()
        }
    }
    var picker: UIPickerView!
    var cuisineId: Int!
    
    @IBOutlet weak var dishTextField: UITextField!
    @IBAction func getRestaurants(_ sender: Any) {
        
        if cuisineId != nil {
            
            performSegue(withIdentifier: "getPlaces", sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker = UIPickerView()
        picker.delegate = self
        dishTextField.inputView = picker
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 35))
        let leftButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(CraveViewController.cancelPicker(sender:)))
        let middleButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let rightButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(CraveViewController.donePicker(sender:)))
        toolbar.setItems([leftButton, middleButton, rightButton], animated: false)
        dishTextField.inputAccessoryView = toolbar
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let alert = UIAlertController(title: "New Name", message: "Add a new name", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { (action:UIAlertAction) -> Void in
            
            let textField = alert.textFields!.first
            self.cityName = textField!.text!
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addTextField {(textField: UITextField) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return suggestions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let cuisineObject = suggestions[row]["cuisine"] as! [String: Any]
        return cuisineObject["cuisine_name"] as? String
    }
    
    func getCuisineSuggestions(id: Int) {
        
        request.getZomatoCuisineId(cityId: 3, completion: {response in
            
            DispatchQueue.main.async {
                
                if response["code"] != nil {
                }
                else {
                    self.suggestions = response["cuisines"] as! [[String: Any]]
                    self.picker.reloadAllComponents()
                }
            }
        })
    }
    
    func getCityName() {
        
        request.getZomatoCityId(cityName: cityName, completion: {response in
            
            DispatchQueue.main.async {
                
                if response["code"] != nil {
                }
                else {
                    let location = response["location_suggestions"] as! [[String: Any]]
                    self.getCuisineSuggestions(id: location[0]["id"] as! Int)
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
        }
    }
}
