//
//  ListViewModel.swift
//  SampleApp
//
//  Created by prashanthi M on 04/08/20.
//  Copyright © 2020 unilever. All rights reserved.
//

import Foundation
import UIKit

class ListViewModel {
    
    var apiManager = APIManager()
    var responseData = [Rows]()
    
    func getDataFromAPI(url: String,finish: @escaping (ListModel) -> Void){
        apiManager.callAPI(url: url) {(listData) in
            if listData.rows?.count != 0 {
                self.responseData = (listData.rows)!
            }
            finish(listData)
        }
    }
    
    func getNumberOfRowsInSection() -> Int{
        
        return responseData.count
    }
    
    func getUserAtIndex(index : Int) -> Rows{
        
        let user = responseData[index]
        return user
    }
    
    
    
}

