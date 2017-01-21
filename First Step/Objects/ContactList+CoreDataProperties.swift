//
//  ContactList+CoreDataProperties.swift
//  
//
//  Created by Atnlie on 1/21/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension ContactList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ContactList> {
        return NSFetchRequest<ContactList>(entityName: "ContactList");
    }

    @NSManaged public var created_at: String?
    @NSManaged public var email: String?
    @NSManaged public var favorite: Bool
    @NSManaged public var first_name: String?
    @NSManaged public var id: Int32
    @NSManaged public var last_name: String?
    @NSManaged public var phone_number: String?
    @NSManaged public var profile_pic: String?
    @NSManaged public var updated_at: String?
    @NSManaged public var url: String?

}
