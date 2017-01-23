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
    static let sharedInstance = AppManager()
    let baseURL = "http://gojek-contacts-app.herokuapp.com"
    
    func showSnackbar(message:String)->Void{
        let snackbar = TTGSnackbar.init(message: message, duration: .long)
        snackbar.show()
    }
    
    func callPhoneNumber(phoneNumber:String) -> Void {
        if let url = NSURL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url as URL) {
            UIApplication.shared.openURL(url as URL)
        }else{
            self.showSnackbar(message: "Sorry, Phone call does not supports")
        }
    }
    
    func sendEmail(receiver:String) -> Void {
        print(receiver)
    }
    
    func emailValidate(emailStr:String)->Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailStr)
    }
    
    func phoneNumberValidate(phoneNumber: String) -> Bool {
        let index = phoneNumber.index(phoneNumber.startIndex, offsetBy: 2)
        if(phoneNumber.substring(to: index) == "+0"){return false}
        
        let phoneRegEx = "[0-9+][0-9]{5,20}"
        let phoneCheck = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
        return  phoneCheck.evaluate(with: phoneNumber)
    }
    
    func saveImage (image: UIImage, path: String ) -> Bool{
        let pngImageData = UIImagePNGRepresentation(image)
        try! pngImageData?.write(to: URL.init(string: path)!, options: Data.WritingOptions.atomicWrite)
        return true
    }
    
    func documentsDirectory() -> String {
        let documentsFolderPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        return documentsFolderPath
    }
    
    func fileInDocumentsDirectory(filename: String) -> String {
        return documentsDirectory() + filename
    }
    
}
