//
//  PhotoIdentificationDetailsViewController.swift
//  WhatIsThat
//
//  Created by Baosheng Feng on 12/11/17.
//  Copyright © 2017 gwu. All rights reserved.
//

import UIKit

class PhotoIdentificationDetailsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var identificationLabel: UILabel!
    
    var getImage = UIImage()
    var getIdentification = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = getImage
        identificationLabel.text = getIdentification
        
    }

    @IBAction func favoriteManager(_ sender: Any) {
        let alert = UIAlertController(title: "Favorite", message: "Added to Favorites List", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style:.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
}
