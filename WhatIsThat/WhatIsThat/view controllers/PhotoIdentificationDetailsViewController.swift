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
    @IBOutlet weak var twitterSearchTimeline: UIButton!
    
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
        
        if(getPageID.isEmpty){
            //pageid is empty, should get pageid first
            let alert = UIAlertController(title: "Wikipedia", message: "No pageid! Get Wikipedia Summary first!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style:.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }else{
        
        //open safari with pageid
        let url = URL(string: "https://en.wikipedia.org/?curid=\(getPageID)")
        
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        
        let wikiWeb = SFSafariViewController(url: url!, configuration: config)
        present(wikiWeb, animated: true)
            
        }
    }
    
    //twitter button
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if segue.identifier == "twitterSearchTimelineSegue"{
            
            let destinationViewController = segue.destination as? SearchTimeineViewController
            destinationViewController?.searchItem = getIdentification
        }
    }
    
    //share button
    @IBAction func shareIdentification(_ sender: Any) {
        
        let sharedText = getIdentification
        let sharedImage = getImage
        
        let shareActivityController = UIActivityViewController(activityItems: [sharedText,sharedImage], applicationActivities: nil)
        present(shareActivityController, animated: true, completion: nil)
        
    }
    
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
            
            //no extract data
            
            if(wikipediaResult.extract.isEmpty){
                
                let alert = UIAlertController(title: "Wikipedia Summary", message: "No extract data from API for wikipedia summary! Use wikipedia button to get more information about this identification!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style:.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
        
        }
    }
    func wikiNotFound(reason: WikipediaAPIManager.FailureReason) {
        print(reason)
        let alert = UIAlertController(title: "Wikipedia Summary", message: "Bad network or Data analysis Error! Please try later!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style:.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}


/*
 references:
 https://stackoverflow.com/questions/35931946/basic-example-for-sharing-text-or-image-with-uiactivityviewcontroller-in-swift
 https://www.raywenderlich.com/133825/uiactivityviewcontroller-tutorial
 https://www.youtube.com/watch?v=KxPavuI4t8o
 https://stackoverflow.com/questions/24022479/how-would-i-create-a-uialertview-in-swift
 */

