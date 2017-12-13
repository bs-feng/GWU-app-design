//
//  WikipediaAPIManager.swift
//  WhatIsThat
//
//  Created by Baosheng Feng on 12/11/17.
//  Copyright © 2017 gwu. All rights reserved.
//

import Foundation

protocol WikipediaAPIManagerDelegate {
    func wikiFound(wikipediaResult: wikipediaResult)
    func wikiNotFound(reason:WikipediaAPIManager.FailureReason)
}

class WikipediaAPIManager{
    
    enum FailureReason: String{
        case networkRequestFailed = "Request failed, try again later."
        case noData = "No data received!"
        case badJSONResponse = "Bad JSON Data!"
    }
    
    var delegate : WikipediaAPIManagerDelegate?
    
    func fetchInfoFromWIkipediaAPI(identification: String){
        
        //url
        let wikipediaTitle = identification.replacingOccurrences(of: " ", with: "_")
        var wikipediaURL: URL {
            return URL(string: "https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exintro=&explaintext=&titles=\(wikipediaTitle)")!
        }
        
        //url request
        let request = URLRequest(url: wikipediaURL)
        
        //parse the result
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                self.delegate?.wikiNotFound(reason: .networkRequestFailed)
                return
            }
            
            guard let data = data, let wikipediaResultObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else {
                self.delegate?.wikiNotFound(reason: .noData)
                return
            }
            
            guard let queryJsonObject = wikipediaResultObject!["query"] as? [String:Any], let pagesJsonArrayObject = queryJsonObject["pages"] as? [String:Any] else {
                self.delegate?.wikiNotFound(reason: .badJSONResponse)
                return
            }
            
            //get the detail results
            let firstKey = pagesJsonArrayObject.keys.first as String?
            let detailJsonArrayObject = pagesJsonArrayObject[firstKey!] as? [String:Any]
            
            let title = detailJsonArrayObject!["title"] as? String
            let pageid = firstKey
            let extract = detailJsonArrayObject!["extract"] as? String
            
            let wikipediaResultPages = wikipediaResult(pageid: pageid!, title: title!, extract: extract!)
            
            self.delegate?.wikiFound(wikipediaResult: wikipediaResultPages)
        }
        task.resume()
    }
}
