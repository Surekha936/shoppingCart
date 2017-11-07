//
//  Products+CoreDataProperties.swift
//  ShoppingCart
//
//  Created by Encoding on 06/11/17.
//  Copyright © 2017 surekha Ramchandra Shinde. All rights reserved.
//

import Foundation
import CoreData


extension Products {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Products> {
        return NSFetchRequest<Products>(entityName: "Products")
    }

    @NSManaged public var productName: String?
    @NSManaged public var productPrice: String?
    @NSManaged public var vendorName: String?
    @NSManaged public var vendorAddress: String?
    @NSManaged public var productImagePath: String?
    @NSManaged public var productImage: NSData?
    @NSManaged public var quantitity: String?
    @NSManaged public var productID: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var productToGallery: NSSet?

}

// MARK: Generated accessors for productToGallery
extension Products {

    @objc(addProductToGalleryObject:)
    @NSManaged public func addToProductToGallery(_ value: ProductGallery)

    @objc(removeProductToGalleryObject:)
    @NSManaged public func removeFromProductToGallery(_ value: ProductGallery)

    @objc(addProductToGallery:)
    @NSManaged public func addToProductToGallery(_ values: NSSet)

    @objc(removeProductToGallery:)
    @NSManaged public func removeFromProductToGallery(_ values: NSSet)

}
