//
//  GoogleVisionAPIManager.swift
//  WhatIsThat
//
//  Created by Baosheng Feng on 12/10/17.
//  Copyright © 2017 gwu. All rights reserved.
//

import Foundation
import SwiftyJSON


protocol GoogleVisionAPIManagerDelegate {
    func labelsFound(labels: [Label])
    func labelsNotFound(reason:GoogleVisionAPIManager.FailureReason)
}

class GoogleVisionAPIManager{
    
    //failure reasons
    enum FailureReason: String{
        case networkRequestFailed = "Request failed, try again later."
        case noData = "No data received!"
        case badJSONResponse = "Bad JSON Data!"
    }
    
    var delegate:GoogleVisionAPIManagerDelegate?
    
    //parse the JSON using Codable
    func fetchLabelsFromGoogleVisionAPI(photoEncoded: String){
        
        var googleAPIKey = "AIzaSyDnXMPOlKy_UG4d9P0ZjNYTU5hCdQ3yWGU"
        var googleURL: URL {
            return URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(googleAPIKey)")!
        }
        
        //api request
        let jsonRequest = [
            "requests": [
                "image": [
                    "content": photoEncoded
                ],
                "features": [
                    [
                        "type": "LABEL_DETECTION",
                        "maxResults": 10
                    ]
                ]
            ]
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonRequest)

        //request
        var request = URLRequest(url:googleURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        request.httpBody = jsonData
        
        
        //parse
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                self.delegate?.labelsNotFound(reason: .networkRequestFailed)
                return
            }
            
            guard let data = data else {
                self.delegate?.labelsNotFound(reason: .noData)
                return
            }
            
            let decoder = JSONDecoder()
            let decodedRoot = try? decoder.decode(Root.self, from: data)
            
            
            guard let root = decodedRoot else {
                self.delegate?.labelsNotFound(reason: .badJSONResponse)
                return
            }
            
            let labelAnnotations = root.responses[0].labelAnnotations
            var labels = [Label]()
            
            for labelAnnotation in labelAnnotations {
                let label = Label(description: labelAnnotation.description, score: labelAnnotation.score)
                labels.append(label)
            }
            self.delegate?.labelsFound(labels: labels)
        }
        task.resume()
    }

}

/*
 References:
 https://medium.com/@stasost/ios-three-ways-to-pass-data-from-model-to-controller-b47cc72a4336
 https://www.raywenderlich.com/172145/encoding-decoding-and-serialization-in-swift-4
 https://github.com/GoogleCloudPlatform/cloud-vision/tree/master/ios/
 https://github.com/gw-mobile-17/pushup-tracker
 */
