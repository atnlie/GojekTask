//
//  RequestAPIData.swift
//  First Step
//
//  Created by Atnlie on 1/21/17.
//  Copyright © 2017 atnlie. All rights reserved.
//

import UIKit
import TTGSnackbar
import SwiftyJSON

class AppManager: NSObject {
//    var objectManager:RKObjectManager;
    static let sharedInstance = AppManager()
    let baseURL = "http://gojek-contacts-app.herokuapp.com/"
    
    func showSnackbar(message:String)->Void{
        let snackbar = TTGSnackbar.init(message: message, duration: .long)
        snackbar.show()
    }
    
    func callPhoneNumber(phoneNumber:String) -> Void {
        if let url = NSURL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url as URL) {
            UIApplication.shared.openURL(url as URL)
        }
    }
    
    func sendEmail(receiver:String) -> Void {
        print(receiver)
    }
}
