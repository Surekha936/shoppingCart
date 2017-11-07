//
//  ProductsAPI.swift
//  ShoppingCart
//
//  Created by surekha Ramchandra Shinde on 05/11/2017.
//  Copyright © 2017 surekha Ramchandra Shinde. All rights reserved.
//

import UIKit
typealias  CompletionBlock = (NSArray?) -> ()

class ProductsAPI: NSObject
{
     func getProducts(completion:@escaping CompletionBlock )->()
     {
        DispatchQueue.global().async
            {
            let productsURL : NSURL = NSURL(string: "https://mobiletest-hackathon.herokuapp.com/getdata/")!
                do
                {
                    URLSession.shared.dataTask(with: productsURL as URL)
                    {
                        data, response, error in
                        do
                        {
                            let res = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                            if (res?["products"]) != nil
                                
                            {
                                DispatchQueue.main.sync
                                    {
                                        completion(res?["products"] as! NSArray?)
                                }
                            }
                            else
                            {
                                completion( [])
                            }
                            
                            
                        }
                            
                        catch let error
                        {
                            print("error: \(error.localizedDescription)")
                        }
                       
                        
                        }.resume()
                }
        }
     }
}

