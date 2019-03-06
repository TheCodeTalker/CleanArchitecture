//
//  ManagedOrder+CoreDataProperties.swift
//  CleanArchitecture
//
//  Created by Chitaranjan Sahu on 25/02/19.
//  Copyright © 2019 Chitaranjan Sahu. All rights reserved.
//
//

import Foundation
import CoreData


extension ManagedOrder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedOrder> {
        return NSFetchRequest<ManagedOrder>(entityName: "ManagedOrder")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var email: String?
    @NSManaged public var phone: String?
    @NSManaged public var id: String?

}
