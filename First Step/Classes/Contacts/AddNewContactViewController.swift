//
//  AddNewContactViewController.swift
//  First Step
//
//  Created by Atnlie on 1/22/17.
//  Copyright © 2017 atnlie. All rights reserved.
//

import UIKit
import AFNetworking
import AssetsLibrary


class AddNewContactViewController: UIViewController,UIImagePickerControllerDelegate,UIGestureRecognizerDelegate,
    UINavigationControllerDelegate{
    @IBOutlet weak var contactPictureImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    var fileName:String=""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setRoundedImage()
        self.setGesture()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        let appManager:AppManager = AppManager()
        let spacesChecker = self.firstNameTextField.text?.replacingOccurrences(of: " ", with: "")
        
        if  (spacesChecker?.characters.count == 0){
            appManager.showSnackbar(message: "First Name not valid, only spaces")
        }else if(((self.firstNameTextField.text?.characters.count)! < 3)){
            appManager.showSnackbar(message: "First Name not valid, less 3 chars")
        }else if (!appManager.phoneNumberValidate(phoneNumber: self.phoneNumberTextField.text!)){
            appManager.showSnackbar(message: "Mobile Phone Number not valid")
        }else if (!appManager.emailValidate(emailStr: self.emailTextField.text!)){
            appManager.showSnackbar(message: "Email not valid")
        }else{
            appManager.showSnackbar(message: "Processing...")
            DispatchQueue.main.async {
                self.saveImageProcess()
            }
            self.saveProcess()
        }
        //self.navigationController?.popToRootViewController(animated: true)
    }
    
    func saveImageProcess()->Void{
        let appManager:AppManager = AppManager()
        let request:NSMutableURLRequest = try! AFHTTPRequestSerializer.init().multipartFormRequest(withMethod: "POST", urlString: appManager.baseURL + "/contacts", parameters: nil, constructingBodyWith: { (formData:AFMultipartFormData) in
            try! formData.appendPart(withFileURL: URL.init(string: self.fileName)!, name: self.phoneNumberTextField.text!)
        }, error: NSErrorPointer.none)
        
        let manager:AFURLSessionManager = AFURLSessionManager.init(sessionConfiguration:URLSessionConfiguration?.none)
        var uploadTask:URLSessionUploadTask = URLSessionUploadTask()
        uploadTask = manager.uploadTask(withStreamedRequest: request as URLRequest, progress: { (uploadProgress:Progress) in
            DispatchQueue.main.async {
                appManager.showSnackbar(message: "Uploading image to server")
            }
        }) { (response:URLResponse, responseObject:Any?, error:Error?) in
            uploadTask.resume()
        }
    }
    
    func saveProcess()->Void{
        let appManager:AppManager = AppManager()
        let client:AFRKHTTPClient = AFRKHTTPClient.init(baseURL: URL.init(string:appManager.baseURL))
        client.parameterEncoding = AFRKFormURLParameterEncoding
        let manager:AFHTTPSessionManager = AFHTTPSessionManager.init()
        manager.securityPolicy.allowInvalidCertificates = true
        
        let request:NSMutableURLRequest = client.request(withMethod: "POST", path: appManager.baseURL + "/contacts", parameters: ["first_name" : self.firstNameTextField.text!, "last_name" : self.lastNameTextField.text!, "email" : self.emailTextField.text!, "phone_number" : self.phoneNumberTextField.text!,"profile_pic": appManager.baseURL + "images/missing.png", "favorite" : false])
        let operation:AFRKHTTPRequestOperation = AFRKHTTPRequestOperation.init(request: request as URLRequest!)
        client.registerHTTPOperationClass(AFRKHTTPRequestOperation.self)
        
        operation.setCompletionBlockWithSuccess({ (operation:AFRKHTTPRequestOperation?, responseObject:Any?) in
            print(responseObject!)
            self.navigationController?.popToRootViewController(animated: true)
        }) { (operation:AFRKHTTPRequestOperation?, error:Error?) in
            print("Gagal")
        }
    }
    
    //MARK: rounded contact
    func setRoundedImage()->Void{
        self.contactPictureImageView.layer.cornerRadius = self.contactPictureImageView.frame.height/2
        self.contactPictureImageView.layer.borderWidth = 1
        self.contactPictureImageView.layer.masksToBounds = false
        self.contactPictureImageView.clipsToBounds = true
        self.contactPictureImageView.layer.borderColor = UIColor.black.cgColor
    }
    
    //MARK: set Gesture
    private func setGesture()->Void{
        self.contactPictureImageView.isUserInteractionEnabled = true
        let imageContactTapGesture = UITapGestureRecognizer(target: self, action:#selector(self.openCamereAndLibrary(sender:)))
        contactPictureImageView.addGestureRecognizer(imageContactTapGesture)
        imageContactTapGesture.delegate = self
        imageContactTapGesture.numberOfTapsRequired = 1
    }
    
    func openCamereAndLibrary(sender:UITapGestureRecognizer)->Void{
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }else if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.contactPictureImageView.contentMode = .scaleToFill
            self.contactPictureImageView.image = pickedImage
            
            self.dismiss(animated: true, completion: nil);
//            let appManager:AppManager = AppManager()
//            if (appManager.saveImage(image: pickedImage, path: appManager.fileInDocumentsDirectory(filename: "pickedImage"))){
//                fileName = appManager.fileInDocumentsDirectory(filename: "pickedImage")
//            }
        }
    }
    
}
