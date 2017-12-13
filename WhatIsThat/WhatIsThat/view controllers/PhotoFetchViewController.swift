//
//  PhotoFetchViewController.swift
//  WhatIsThat
//
//  Created by Baosheng Feng on 12/8/17.
//  Copyright © 2017 gwu. All rights reserved.
//

import UIKit
import Photos
import CoreLocation

class PhotoFetchViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate{

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var googleVisionButton: UIButton!
    
    var longitude = Double()
    var latitude = Double()
    let locationManager = CLLocationManager()
    var location: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //current location permission
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .notDetermined{
            locationManager.requestWhenInUseAuthorization()
            
        }
        
        //photo library permission
        let photoStatus = PHPhotoLibrary.authorizationStatus()
        if photoStatus == .notDetermined{
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                }else{
                    return
                }
            })
        }
        
        //camera permission
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                
            } else {
                return
            }
        }
        
        //get current gps
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    
    
    @IBAction func chooseImage(_ sender: Any) {
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose", preferredStyle: .actionSheet)
        //image picker controller
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        //choose photos from library or camera
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action:UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }
            else{
                print("Camera Not Available!!")
            }
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        //choose image
        let photo = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = photo
        
        //initialize
        longitude = 0.0
        latitude = 0.0
        
        //get gps information from the photo
        if(picker.sourceType == .photoLibrary){
        if let URL = info[UIImagePickerControllerReferenceURL] as? URL{
            let opts = PHFetchOptions()
            opts.fetchLimit = 1
            let assets = PHAsset.fetchAssets(withALAssetURLs: [URL], options: opts)
            for assetIndex in 0..<assets.count{
                if(assets[assetIndex].location?.coordinate != nil){
                self.latitude = (assets[assetIndex].location?.coordinate.latitude)!
                self.longitude = (assets[assetIndex].location?.coordinate.longitude)!
                }
            }
            }
            print("gps from photo")
        }
        
        //get gps from current location for photo from camera
        if( picker.sourceType == .camera){
            
            if let location = location{
                self.latitude = location.coordinate.latitude
                self.longitude = location.coordinate.longitude
            }
            print("gps from camera, current gps")
        }
    
        //to check the location
        print("Image's longitude: \(longitude)")
        print("Image's latitude: \(latitude)")
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func googleVisionButtonManager(_ sender: Any) {
        
        let button = sender as! UIButton
        
        if(imageView.image == nil){
            let alert = UIAlertController(title: "Alert", message: "Import an image first!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style:.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            button.isEnabled = true
        }
    }
    
    //pass image to image identification
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "photoIdentificationSegue"{
            
            if let data = imageView.image{
            let destinationViewController = segue.destination as? PhotoIdentificationViewController
                destinationViewController?.data = data
                destinationViewController?.getlatitude = latitude
                destinationViewController?.getlongitude = longitude
            }
        }
    }
    
    //current location
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        location = newLocation
    }
    
    /////
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

/*
 References:
 UIImage PickerController: https://www.youtube.com/watch?v=4CbcMZOSmEk
 
 location for photo:
 https://www.youtube.com/watch?v=ggptRs89DNk
 https://www.youtube.com/watch?v=XyncTJdXbbw
 https://stackoverflow.com/questions/35089796/extract-gps-data-from-photo-ios-swift
 https://stackoverflow.com/questions/26760410/extract-gps-data-from-photo
 https://gist.github.com/sumitlni/6421aece205ebefa647abe701d2429e0
 ios apprentice 6th edition, Chapter22, 23, 30, Raywenderlich Com Team, Razeware LLC, 2017
 
 others:
 https://stackoverflow.com/questions/39631256/request-permission-for-camera-and-library-in-ios-10-info-plist/39631642
 */
