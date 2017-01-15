//
//  APIModel.swift
//  WhatYouCraving
//
//  Created by Midhet Sulemani on 14/01/17.
//  Copyright © 2017 MCreations. All rights reserved.
//

import Foundation

var request = Navigation()

class Navigation {
    
    var apiKey = "50aa89dec8c92e84ba1ecd838dff9909"
    var zomatoRequestUrl = "https://developers.zomato.com/api/v2.1/"
    
    func getZomatoCuisineId(cityId: Int, completion: @escaping (([String: Any]) -> Void)) {
        
        let request = NSMutableURLRequest(url: URL(string: "\(zomatoRequestUrl)cuisines?city_id=\(cityId)")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(apiKey, forHTTPHeaderField: "user-key")
        request.httpBody = "".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            if error != nil {
                
                print("Error: \(error)")
//                helper.giveErrorAlerts(errorString: "Request failed", errorMessage: error!.localizedDescription, vc: controller)
                return
            }
            print("cuisine id", NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
            do {
                let result = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                print("response: \(result)")
                completion(result)
                
            } catch {
                print("Error: \(error)")
            }
        }
        task.resume()
    }
    
    func getZomatoCityId(cityName: String, completion: @escaping (([String: Any]) -> Void)) {
        
        let request = NSMutableURLRequest(url: URL(string: "\(zomatoRequestUrl)cities?q=\(cityName)")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(apiKey, forHTTPHeaderField: "user-key")
        request.httpBody = "".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            if error != nil {
                
                print("Error: \(error)")
                //                helper.giveErrorAlerts(errorString: "Request failed", errorMessage: error!.localizedDescription, vc: controller)
                return
            }
            print("city id", NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
            do {
                let result = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                print("response: \(result)")
                completion(result)
                
            } catch {
                print("Error: \(error)")
            }
        }
        task.resume()
    }
    
    func getZomatoRestaurantList(lat: Double, long: Double, cuisineId: String, completion: @escaping (([String: Any]) -> Void)) {
        
        let request = NSMutableURLRequest(url: URL(string: "\(zomatoRequestUrl)search?count=25&cuisines=\(cuisineId)")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(apiKey, forHTTPHeaderField: "user-key")
        request.httpBody = "".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            if error != nil {
                
                print("Error: \(error)")
                //                helper.giveErrorAlerts(errorString: "Request failed", errorMessage: error!.localizedDescription, vc: controller)
                return
            }
            print("main response", NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
            do {
                let result = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                print("response: \(result)")
                completion(result)
                
            } catch {
                print("Error: \(error)")
            }
        }
        task.resume()
    }
}
