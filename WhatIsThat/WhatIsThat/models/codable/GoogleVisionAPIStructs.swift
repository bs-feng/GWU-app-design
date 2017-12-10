//
//  GoogleVisionAPIStructs.swift
//  WhatIsThat
//
//  Created by Baosheng Feng on 12/10/17.
//  Copyright © 2017 gwu. All rights reserved.
//
//http://danieltmbr.github.io/JsonCodeGenerator/



import Foundation

struct Root: Codable {
    
    let responses: [Responses]
    
}

struct Responses: Codable {
    
    let labelAnnotations: [LabelAnnotations]
    
}

struct LabelAnnotations: Codable {
    
    let description: String
    let mid: String
    let score: Double
    
}
