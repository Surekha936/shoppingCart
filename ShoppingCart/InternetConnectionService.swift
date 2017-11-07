//
//  InternetConnectionService.swift
//  leadpedia15_10
//
//  Created by surekha Ramchandra Shinde on 19/10/2017.
//  Copyright © 2017 surekha Ramchandra Shinde. All rights reserved.
//

import UIKit

class InternetConnectionService: NSObject
{
    func checkNetworkStatus() -> Bool
    {
      let status =  Reach().connectionStatus()
        switch status
        {
        case .unknown, .offline:
            return false
        case .online(.wwan):
           return true
        case .online(.wiFi):
            return true
        
        }
    }
    func checkFornetConnectionWithStatus()-> Bool
    {
        let currentStatus = checkNetworkStatus()
        
        if currentStatus == false
        {
//            let alert  = UIAlertController(title: "No Internet Connection!", message: "Please check your internet connection and try again.", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
//            UIApplication.topViewController()?.present(alert, animated: false, completion: nil)
        }
        return currentStatus
    }
    
    func checkFornetConnectionWithStatusWitoutAlert() -> Bool
    {
        return checkNetworkStatus()
    }
}
