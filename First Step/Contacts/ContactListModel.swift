//
//  ContactListModel.swift
//  First Step
//
//  Created by Atnlie on 1/21/17.
//  Copyright © 2017 atnlie. All rights reserved.
//

import UIKit

class ContactListModel: NSObject {
    
    class func mapping() -> RKObjectMapping {
        let mapping = RKObjectMapping(for: self)
        return mapping!
    }
}
