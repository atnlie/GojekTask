//
//  ContactListModel.swift
//  First Step
//
//  Created by Atnlie on 1/21/17.
//  Copyright © 2017 atnlie. All rights reserved.
//

import UIKit

class ContactListModel: NSObject {
    var id = 0
    var first_name = ""
    var last_name = ""
    var email = ""
    var phone_number = ""
    var profile_pic = ""
    var favorite = false
    var created_at = ""
    var updated_at = ""
    var url = ""
    
    static func mapping() -> RKObjectMapping {
        let mapping = RKObjectMapping(for: self)
        mapping? .addAttributeMappings(from: [
            "id"            : "id",
            "first_name"    : "first_name",
            "last_name"     : "last_name",
            "email"         : "email",
            "phone_number"  : "phone_number",
            "profile_pic"   : "profile_pic",
            "favorite"      : "favorite",
            "created_at"    : "created_at",
            "updated_at"    : "updated_at",
            "url"    : "url"
            ])
        return mapping!
    }
}
