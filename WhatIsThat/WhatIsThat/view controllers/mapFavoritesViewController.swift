//
//  mapFavoritesViewController.swift
//  WhatIsThat
//
//  Created by Baosheng Feng on 12/13/17.
//  Copyright © 2017 gwu. All rights reserved.
//

import UIKit
import MapKit

class mapFavoritesViewController: UIViewController, MKMapViewDelegate{

    @IBOutlet weak var mapView: MKMapView!
    
    
    var favorites = [Favorite]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapAnnotation(favorites: favorites)
        
    }
    
    func mapAnnotation(favorites:[Favorite]){
        
        for favorite in favorites{
            
            let annotation = MKPointAnnotation()
            
            annotation.coordinate.latitude = favorite.latitude
            annotation.coordinate.longitude = favorite.longitude
        
            mapView.addAnnotation(annotation)
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
