//
//  CartAPI.swift
//  ShoppingCart
//
//  Created by Encoding on 06/11/17.
//  Copyright © 2017 surekha Ramchandra Shinde. All rights reserved.
//

import UIKit
import CoreData
class CartAPI: NSObject
{
    func removeFromCart(productId : String)->(Bool)
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else
        {
            return false
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest: NSFetchRequest<Products> = Products.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "productID = %@", "\(productId)")
        let objects = try! managedContext.fetch(fetchRequest)
        for object in objects
        {
            managedContext.delete(object)
        }
        
        do {
            try managedContext.save() // <- remember to put this :)
             return true
        } catch
        {
            // Do something... fatalerror
             return false
        }
       
    }
    func getCartData() -> ([NSManagedObject])
    {
         var cartData: [NSManagedObject] = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return cartData
        }
       
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Products")
        do {
            cartData = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
         return cartData
    }
    
    func save(productDict: NSDictionary) -> Bool{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        
        let entity = NSEntityDescription.entity(forEntityName: "Products",
                                                in: managedContext)!
        
        let product = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        /*
         productImage
         productToGallery*/
        
        product.setValue(NSUUID().uuidString, forKeyPath: "productID")
        product.setValue("1", forKeyPath: "quantitity")
        if productDict["productname"] != nil
        {
              product.setValue(productDict["productname"], forKeyPath: "productName")
        }
        if productDict["productImage"] != nil
        {
            product.setValue(productDict["productImage"], forKeyPath: "productImage")
        }
        if productDict["price"] != nil
        {
            product.setValue(productDict["price"], forKeyPath: "productPrice")
        }
        if productDict["phoneNumber"] != nil
        {
            product.setValue(productDict["phoneNumber"], forKeyPath: "phoneNumber")
        }
        if productDict["productImg"] != nil
        {
            product.setValue(productDict["productImg"], forKeyPath: "productImagePath")
        }
        if productDict["vendoraddress"] != nil
        {
            product.setValue(productDict["vendoraddress"], forKeyPath: "vendorAddress")
        }
        if productDict["vendorname"] != nil
        {
            product.setValue(productDict["vendorname"], forKeyPath: "vendorName")
        }
        
        if productDict["productGallery"] != nil
        {
//            product.setValue(productDict["price"], forKeyPath: "productPrice")
        }
        do {
            try managedContext.save()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
        return true
    }
    
}
