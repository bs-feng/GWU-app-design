//
//  PhotoIdentificationViewController.swift
//  WhatIsThat
//
//  Created by Baosheng Feng on 12/8/17.
//  Copyright © 2017 gwu. All rights reserved.
//

import UIKit

class PhotoIdentificationViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    var data = UIImage()

    var labels = [Label]()
    let googleVisionAPIManager = GoogleVisionAPIManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = data
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let imageEncoded = encodeImage(data)
        
        googleVisionAPIManager.delegate = self
        googleVisionAPIManager.fetchLabelsFromGoogleVisionAPI(photoEncoded: imageEncoded)

    }

    //////////////image to string
    
    func imageResizer(_ imageSize: CGSize, image: UIImage) -> Data {
        UIGraphicsBeginImageContext(imageSize)
        image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        let new = UIGraphicsGetImageFromCurrentImageContext()
        let newImage = UIImagePNGRepresentation(new!)
        UIGraphicsEndImageContext()
        return newImage!
    }

    //image size limit to 2MB
    func encodeImage(_ image: UIImage) -> String{
        var imageData = UIImagePNGRepresentation(image)
        
        if(imageData?.count > 2097152){
            let old: CGSize = image.size
            let new: CGSize = CGSize(width: 800, height: old.height/old.width*800)
            imageData = imageResizer(new, image: image)
        }
        return imageData!.base64EncodedString(options: .endLineWithCarriageReturn)
    }

    //////////////Table view
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoogleVisionResultsCell", for: indexPath) as! GoogleVisionResultsTableViewCell
        
        let label = labels[indexPath.row]
        cell.name.text = label.description
        cell.score.text = String(format:"%.3f",label.score)
        
        return cell
    }

    ////pass data
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "IdentificationDetailSegue"){
            if let indexPath = self.tableView.indexPathForSelectedRow{
            
            let destinationViewController = segue.destination as? PhotoIdentificationDetailsViewController
            destinationViewController?.getImage = data
            destinationViewController?.getIdentification = labels[indexPath.row].description
            }
        }
    }
    
    //////
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// to GoogleVisionAPIManagerDelegate
extension PhotoIdentificationViewController: GoogleVisionAPIManagerDelegate{

    func labelsFound(labels: [Label]){
        self.labels = labels
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        print(labels)
        
    }

    func labelsNotFound(reason:GoogleVisionAPIManager.FailureReason){
        print(reason)
    }
}


/*
 references:
 https://github.com/GoogleCloudPlatform/cloud-vision/tree/master/ios/
 https://medium.com/@stasost/ios-three-ways-to-pass-data-from-model-to-controller-b47cc72a4336
 https://github.com/gw-mobile-17/pushup-tracker
 https://stackoverflow.com/questions/28430663/send-data-from-tableview-to-detailview-swift
 https://www.youtube.com/watch?v=czWu1RXnnUE
 */

////////////////////////////
//The code below is from: https://github.com/GoogleCloudPlatform/cloud-vision/tree/master/ios/
//Without the code below, there will be an error in "imageData?.count"
//explanation: https://stackoverflow.com/questions/39251005/strange-generic-function-appear-in-view-controller-after-converting-to-swift-3

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}
