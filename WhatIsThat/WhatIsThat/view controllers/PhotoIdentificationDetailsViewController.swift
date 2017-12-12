//
//  PhotoIdentificationDetailsViewController.swift
//  WhatIsThat
//
//  Created by Baosheng Feng on 12/11/17.
//  Copyright © 2017 gwu. All rights reserved.
//

import UIKit
import SafariServices

class PhotoIdentificationDetailsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var identificationLabel: UILabel!
    @IBOutlet weak var wikiSummary: UILabel!
    
    var getImage = UIImage()
    var getIdentification = String()
    var getPageID = String()
    
    let wikipediaAPIManager = WikipediaAPIManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = getImage
        identificationLabel.text = getIdentification
        
        wikipediaAPIManager.delegate = self
        wikipediaAPIManager.fetchInfoFromWIkipediaAPI(identification: getIdentification)
        
    }

    //favorite button
    @IBAction func favoriteManager(_ sender: Any) {
        let alert = UIAlertController(title: "Favorite", message: "Added to Favorites List", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style:.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //wikipedia safari
    @IBAction func wikipediaSafari(_ sender: Any) {
        let url = URL(string: "https://en.wikipedia.org/?curid=\(getPageID)")
        
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        
        let wikiWeb = SFSafariViewController(url: url!, configuration: config)
        present(wikiWeb, animated: true)
    }
    //twitter button
    
    
    //share button
    
    
    
    /////
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
}


//wikipedia api result
extension PhotoIdentificationDetailsViewController: WikipediaAPIManagerDelegate{
    func wikiFound(wikipediaResult: wikipediaResult) {
        DispatchQueue.main.async {
            self.wikiSummary.text = wikipediaResult.extract
            self.getPageID = wikipediaResult.pageid
        }
    }
    func wikiNotFound(reason: WikipediaAPIManager.FailureReason) {
        print(reason)
        let alert = UIAlertController(title: "Wikipedia Summary", message: "Bad network or Data analysis Error! Please try later!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style:.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}



