//
//  AppUtils.swift
//  SampleApp
//
//  Created by prashanthi M on 04/08/20.
//  Copyright © 2020 unilever. All rights reserved.
//

import UIKit

class Apputils: NSObject {
    
    
   static let sharedInstance = Apputils()
    
    static func topMostController() -> UIViewController {
        
        var topVC = UIApplication.shared.keyWindow?.rootViewController
        while((topVC!.presentedViewController) != nil){
            topVC = topVC!.presentedViewController
        }
        
        return topVC!;
    }
    static func showAlertMessage(message : String) {
        
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "Okay", style: UIAlertAction.Style.cancel, handler: nil)
            alertController.addAction(okAction);
            topMostController().present(alertController, animated: true, completion: nil)
        }
    }
    
    let networkIndicator = UIActivityIndicatorView()
    var holdingView : UIView!
    
    private func setupLoader() {
        removeLoader()
        DispatchQueue.main.async {
            self.networkIndicator.hidesWhenStopped = true
            self.networkIndicator.style = .whiteLarge
        }
    }
    
    func showLoader() {
        setupLoader()
        DispatchQueue.main.async {
            let window = UIApplication.shared.keyWindow!
            self.holdingView = UIView(frame: window.bounds)
            self.holdingView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
            self.holdingView.center = window.center
            self.holdingView.layer.shadowColor = UIColor.white.cgColor
            self.holdingView.layer.shadowOffset = CGSize.zero
            self.holdingView.layer.shadowOpacity = 0.5
            self.holdingView.layer.shadowRadius = 5
            self.holdingView.layer.cornerRadius = 5.0
            self.holdingView.clipsToBounds = true
            self.holdingView.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
            self.holdingView.addSubview(self.networkIndicator)
            window.addSubview(self.holdingView)
        }
    }
    
    func removeLoader(){
        DispatchQueue.main.async {
            if(self.holdingView != nil) {
                self.networkIndicator.stopAnimating()
                self.networkIndicator.removeFromSuperview()
                self.holdingView.removeFromSuperview()
            }
        }
    }
    
    
    static  func checkStatusCode(statusCode:Int) -> Bool {
        
        switch statusCode {
        case 200:
            return true
        case 403:
            return false
        case 401:
            return false
        case 500:
            return false
        case 503:
            return false
        default:
            break
        }
        return true
        
    }
}



