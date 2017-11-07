//
//  ProductGallery+CoreDataProperties.swift
//  ShoppingCart
//
//  Created by Encoding on 06/11/17.
//  Copyright © 2017 surekha Ramchandra Shinde. All rights reserved.
//

import Foundation
import CoreData


extension ProductGallery {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductGallery> {
        return NSFetchRequest<ProductGallery>(entityName: "ProductGallery")
    }

    @NSManaged public var galleryID: String?
    @NSManaged public var productID: String?
    @NSManaged public var galleryPath: String?

}
