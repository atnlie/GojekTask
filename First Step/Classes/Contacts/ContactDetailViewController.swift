//
//  ContactDetailViewController.swift
//  First Step
//
//  Created by Atnlie on 1/21/17.
//  Copyright © 2017 atnlie. All rights reserved.
//

import UIKit
import SwiftyJSON
import TTGSnackbar

class ContactDetailViewController: UIViewController,UIGestureRecognizerDelegate {
    @IBOutlet var contactImageView: UIImageView!
    @IBOutlet var contactNameLabel: UILabel!
    @IBOutlet var contactPhoneLabel: UILabel!
    @IBOutlet var contactEmailLabel: UILabel!
    @IBOutlet var contactPhoneImageView: UIImageView!
    @IBOutlet var contactEmailImageView: UIImageView!
    
    var contactDetail:ContactList = ContactList()
    var appManager:AppManager = AppManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareGesture()
        self.collectDetailInfo(urlDetail: contactDetail.url!)
        self.setRoundedImage()
        self.updateInfoDetail()
        self.setContactImage()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: PhoneCall
    @objc private func phoneCall(sender:UITapGestureRecognizer)->Void{
        appManager.callPhoneNumber(phoneNumber: self.contactPhoneLabel.text!)
    }
    
    @objc private func sendEmail(sender:UITapGestureRecognizer)->Void{
        appManager.sendEmail(receiver: self.contactEmailLabel.text!)
    }
    //MARK: update values
    private func updateInfoDetail()->Void{
        self.contactNameLabel.text = contactDetail.first_name! + " " + contactDetail.last_name!
        self.contactPhoneLabel.text = contactDetail.phone_number
        self.contactEmailLabel.text = contactDetail.email
    }
    
    private func setContactImage()->Void{
        let placeHolderImg = UIImage.init(named: "default_icon")
        let urlRequest = NSURLRequest.init(url: URL.init(string:AppManager.sharedInstance.baseURL + contactDetail.profile_pic!)!)
        self.contactImageView.setImageWith(urlRequest as URLRequest!, placeholderImage: placeHolderImg, success: { (request:URLRequest?, response:HTTPURLResponse?, downloadedImage:UIImage?) in
            self.contactImageView.image = downloadedImage
        }, failure: { (request:URLRequest?, response:HTTPURLResponse?, error:Error?) in
            self.contactImageView.image = placeHolderImg
        })
    }
    
    //MARK: setGesture
    private func prepareGesture()->Void{
        self.contactPhoneLabel.isUserInteractionEnabled = true
        let phoneCallTapGesture = UITapGestureRecognizer(target: self, action:#selector(self.phoneCall(sender:)))
        contactPhoneLabel.addGestureRecognizer(phoneCallTapGesture)
        phoneCallTapGesture.delegate = self
        phoneCallTapGesture.numberOfTapsRequired = 1
        
        self.contactPhoneImageView.isUserInteractionEnabled = true
        let phoneCallIMTapGesture = UITapGestureRecognizer(target: self, action:#selector(self.phoneCall(sender:)))
        contactPhoneImageView.addGestureRecognizer(phoneCallIMTapGesture)
        phoneCallIMTapGesture.delegate = self
        phoneCallIMTapGesture.numberOfTapsRequired = 1
        
        self.contactEmailLabel.isUserInteractionEnabled = true
        let emailTapGesture = UITapGestureRecognizer(target: self, action:#selector(self.sendEmail(sender:)))
        contactEmailLabel.addGestureRecognizer(emailTapGesture)
        emailTapGesture.delegate = self
        emailTapGesture.numberOfTapsRequired = 1
        
        self.contactEmailImageView.isUserInteractionEnabled = true
        let emailIMTapGesture = UITapGestureRecognizer(target: self, action:#selector(self.sendEmail(sender:)))
        contactEmailImageView.addGestureRecognizer(emailIMTapGesture)
        emailIMTapGesture.delegate = self
        emailIMTapGesture.numberOfTapsRequired = 1
        
        
    }
    
    //MARK: rounded contact
    private func setRoundedImage()->Void{
        self.contactImageView.layer.cornerRadius = self.contactImageView.frame.height/2
        self.contactImageView.layer.borderWidth = 1
        self.contactImageView.layer.masksToBounds = false
        self.contactImageView.clipsToBounds = true
        self.contactImageView.layer.borderColor = UIColor.black.cgColor
    }
    
    //MARK: collect detail info
    private func collectDetailInfo(urlDetail:String)->Void{
        let manager = AFHTTPSessionManager()
        manager.get(urlDetail, parameters: nil, progress: nil, success: { (operation:URLSessionDataTask, responseObject:Any?) in
            if (JSON(responseObject!).count > 0){
                self.showDetailInfo(jsonData: JSON(responseObject!))
            }else{
                self.appManager.showSnackbar(message: "No contact found")
            }
        }) { (session:URLSessionDataTask?, error:Error) in
            self.appManager.showSnackbar(message: "Not able to connect Server.")
        }
    }
    
    private func showDetailInfo(jsonData:JSON)->(Void){
        print(jsonData)
        let detailInfo:JSON = jsonData
        self.contactPhoneLabel.text = (detailInfo["phone_number"].type != Type.null) ? (detailInfo["phone_number"].string!) : "-"
        self.contactEmailLabel.text = (detailInfo["email"].type != Type.null) ? (detailInfo["email"].string!) : "-"
    }
}
