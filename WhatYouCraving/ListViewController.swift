//
//  ListViewController.swift
//  WhatYouCraving
//
//  Created by Midhet Sulemani on 29/12/16.
//  Copyright © 2016 MCreations. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {
    
    var restaurantList: [RestaurantDetails] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController!.isNavigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return restaurantList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RestaurantTableViewCell
        cell.name.text = restaurantList[indexPath.row].name
        cell.cuisine.text = restaurantList[indexPath.row].cuisine
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let app = UIApplication.shared
        if let toOpen = restaurantList[indexPath.row].zomatoUrl {
            print("media url: \(toOpen)")
            
            if toOpen != "" {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
}

class RestaurantTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var cuisine: UILabel!
    
}
