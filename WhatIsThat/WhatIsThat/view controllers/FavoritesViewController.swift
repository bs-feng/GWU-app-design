//
//  FavoritesViewController.swift
//  WhatIsThat
//
//  Created by Baosheng Feng on 12/13/17.
//  Copyright © 2017 gwu. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapButton: UIButton!
    
    var favorites = [Favorite]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        userDefaultsDataFetch()
        
    }

    //get favorite info from UserDefault
    func userDefaultsDataFetch(){
        for (key, value) in UserDefaults.standard.dictionaryRepresentation(){
            if let data = UserDefaults.standard.dictionary(forKey: key){
                favorites.append(Favorite(title: data["title"] as! String, imageFileName: data["imageFileName"] as! String, imageFilePath: data["imageFilePath"] as! String, longitude: data["longitude"] as! Double, latitude: data["latitude"] as! Double))
            }
        }
    }
    
    ///table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesCell", for: indexPath) as! FavoritesTableViewCell
        
        cell.cellTitle.text = favorites[indexPath.row].title
        cell.cellImage.image = UIImage(contentsOfFile: favorites[indexPath.row].imageFilePath)

        return cell
    }
    
    ///pass data to details or map
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "FavoritestoDetailsSegue"){
            if let indexPath = self.tableView.indexPathForSelectedRow{
                
                let destinationViewController = segue.destination as? PhotoIdentificationDetailsViewController
                
                if(UIImage(contentsOfFile: favorites[indexPath.row].imageFilePath) != nil){
                destinationViewController?.getImage = UIImage(contentsOfFile: favorites[indexPath.row].imageFilePath)!
                }else{
                    destinationViewController?.getImage = UIImage()
                }
                destinationViewController?.getIdentification = favorites[indexPath.row].title
                destinationViewController?.getlongitude = favorites[indexPath.row].longitude
                destinationViewController?.getlatitude = favorites[indexPath.row].latitude
                
            }
        }
        if (segue.identifier == "FavoritesToMap"){
   
                let destinationViewController = segue.destination as? mapFavoritesViewController
                destinationViewController?.favorites = favorites
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
}
