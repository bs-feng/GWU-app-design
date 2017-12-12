//
//  SearchTimeineViewController.swift
//  WhatIsThat
//
//  Created by Baosheng Feng on 12/12/17.
//  Copyright © 2017 gwu. All rights reserved.
//

import UIKit
import TwitterKit

class SearchTimeineViewController: TWTRTimelineViewController {
    
    var searchItem = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let client = TWTRAPIClient()
        self.dataSource = TWTRSearchTimelineDataSource(searchQuery: searchItem, apiClient: client)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
