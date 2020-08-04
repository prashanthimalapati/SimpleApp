//
//  NetworkManager.swift
//  SampleApp
//
//  Created by prashanthi M on 04/08/20.
//  Copyright © 2020 unilever. All rights reserved.
//

import Foundation
import AVKit


class APIManager {
    
    
    func callAPI(url:String,finish: @escaping (ListModel) -> Void)
    {
        NetworkManager.sharedInstance.reachability.whenUnreachable = { reachability in
            Apputils.showAlertMessage(message: Constants.NoInternetMessage)
        }
        
        if let unwrappedUrl = URL(string: url){
            
            URLSession.shared.dataTask(with: unwrappedUrl, completionHandler: { (data, response, error) in
                do
                {
                    if let jsonData = data
                    {
                        guard let _ = data, error == nil else {
                            Apputils.showAlertMessage(message: Constants.NoData)
                            return
                        }
                        let httpResponse = response as? HTTPURLResponse
                        let status = Apputils.checkStatusCode(statusCode: httpResponse!.statusCode)
                        if status == true {
                            let utf8Data = String(decoding: jsonData, as: UTF8.self).data(using: .utf8)
                            let listResponse = try JSONDecoder().decode(ListModel.self, from: utf8Data!)
                            print(listResponse)
                            if listResponse.rows?.count != 0{
                                finish(listResponse)
                            }
                        }else {
                            Apputils.showAlertMessage(message: Constants.SERVERERROR)
                        }
                    }
                }
                catch
                {
                    Apputils.showAlertMessage(message: Constants.SERVERERROR)
                }
                
            }).resume()
        }
    }
}
