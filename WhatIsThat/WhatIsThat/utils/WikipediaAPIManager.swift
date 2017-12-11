//
//  WikipediaAPIManager.swift
//  WhatIsThat
//
//  Created by Baosheng Feng on 12/11/17.
//  Copyright © 2017 gwu. All rights reserved.
//

import Foundation

protocol WikipediaAPIManagerDelegate {
    func wikiFound()
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
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
}
