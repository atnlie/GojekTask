//
//  ContactList.swift
//  First Step
//
//  Created by Atnlie on 1/21/17.
//  Copyright © 2017 atnlie. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON
import TTGSnackbar


@available(iOS 10.0, *)
class ContactListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //MARK: Variables
    @IBOutlet weak var contactTableView: UITableView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var localContacts = [ContactList]()
    var appManager:AppManager = AppManager()
    
    //MARK: View Behavior
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contactTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.title = "Contact List"
        appManager.showSnackbar(message: "Please wait, contacting server...")
        self.clearCoreData()
        self.fetchContactList()
        //self.test()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.title = "Contact List"
        self.readContactList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func test()->Void{
        let responseDescriptor:RKResponseDescriptor = RKResponseDescriptor.init(mapping: ContactListModel.mapping(), method: RKRequestMethod.any, pathPattern: nil, keyPath: nil, statusCodes: RKStatusCodeIndexSetForClass(RKStatusCodeClass.successful))
        let contactUrl:URL = URL(string:AppManager.sharedInstance.baseURL + "contacts.json")!
        let requestUrl:NSURLRequest = NSURLRequest.init(url: contactUrl)
        let objRequestOperation:RKObjectRequestOperation = RKObjectRequestOperation.init(request: requestUrl as URLRequest!, responseDescriptors:[responseDescriptor])
        objRequestOperation.setCompletionBlockWithSuccess({ (operation:RKObjectRequestOperation?, result:RKMappingResult?) in
            print(RKMappingResult.array(result!))
            print("Berhasil")
        }) { (operation:RKObjectRequestOperation?, error:Error?) in
            print("Gagal \(error)")
        }
    }
    
    //MARK: Connect to API server
    func fetchContactList()->Void{
        let manager = AFHTTPSessionManager()
        manager.get(AppManager.sharedInstance.baseURL + "contacts.json", parameters: nil,
                    progress: {(NSProgress) in },
                    success: {
                        (operation:URLSessionDataTask, responseObject:Any?) in
                        if (JSON(responseObject!).count > 0){
                            self.contactListJsonParse(jsonData: JSON(responseObject!))
                        }else{
                            self.appManager.showSnackbar(message: "No contact found")
                        }
                        self.readContactList()
                    }) { (session:URLSessionDataTask?, error:Error) in
                        self.appManager.showSnackbar(message: "Not able to connect Server")
                        self.readContactList()
        }        
    }
    
    func contactListJsonParse(jsonData:JSON)->Void{
        for (_,jsonDictionary):(String, JSON) in jsonData {
            let contactList:ContactListModel = ContactListModel()
            contactList.id = (jsonDictionary["id"].type != Type.null) ? (jsonDictionary["id"].int!) : 0
            contactList.first_name = (jsonDictionary["first_name"].type != Type.null) ? (jsonDictionary["first_name"].string!) : "-"
            contactList.last_name = (jsonDictionary["last_name"].type != Type.null) ? (jsonDictionary["last_name"].string!) : "-"
            contactList.url = (jsonDictionary["url"].type != Type.null) ? (jsonDictionary["url"].string!) : "-"
            contactList.profile_pic = (jsonDictionary["profile_pic"].type != Type.null) ? (jsonDictionary["profile_pic"].string!) : "-"
            //default value
            contactList.phone_number = (jsonDictionary["phone_number"].type != Type.null) ? (jsonDictionary["phone_number"].string!) : "-"
            contactList.favorite = (jsonDictionary["favorite"].type != Type.null) ? (jsonDictionary["favorite"].bool!) : false
            contactList.created_at = (jsonDictionary["created_at"].type != Type.null) ? (jsonDictionary["created_at"].string!) : "-"
            contactList.updated_at = (jsonDictionary["updated_at"].type != Type.null) ? (jsonDictionary["updated_at"].string!) : "-"
            self.saveToCoreData(objContact: contactList)
        }
    }
    
    //MARK: CoreData
    func saveToCoreData(objContact:Any)->Void{
        let managedContext = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: "ContactList", in: managedContext)
        let options = NSManagedObject(entity: entity!, insertInto:managedContext)
        //options.setValue(name, forKey: "first_name")
        
        if(objContact is ContactListModel){
            let contacList:ContactListModel = objContact as! ContactListModel
            options.setValue(contacList.id, forKey: "id")
            options.setValue(contacList.first_name, forKey: "first_name")
            options.setValue(contacList.last_name, forKey: "last_name")
            options.setValue(contacList.url, forKey: "url")
            options.setValue(contacList.profile_pic, forKey: "profile_pic")
            options.setValue(contacList.phone_number, forKey: "phone_number")
            options.setValue(contacList.favorite, forKey: "favorite")
            options.setValue(contacList.created_at, forKey: "created_at")
            options.setValue(contacList.updated_at , forKey: "updated_at")
        }else{
            return
        }
        
        do {
            try managedContext.save()
        } catch{
            self.appManager.showSnackbar(message: "Save contact to Database failed.")
        }
    }
    
    func clearCoreData()->Void{
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ContactList")
        if let result = try? managedContext.fetch(fetchRequest) {
            for object in result {
                managedContext.delete(object as! NSManagedObject)
            }
        }
    }
    
    func readContactList()->Void{
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ContactList")
        if let result = try? managedContext.fetch(fetchRequest) {
            self.localContacts = result as! [ContactList]
            self.localContacts.sort{$0.first_name! < $1.first_name! && $0.last_name! < $1.last_name!}
            self.contactTableView.reloadData()
        }
    }
    
    //MARK: TableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.contactTableView.dequeueReusableCell(withIdentifier:"cell")! as UITableViewCell
        let cInfo:ContactList = self.localContacts[indexPath.row]
        cell.textLabel?.text = cInfo.first_name! + " " + cInfo.last_name!
        let placeHolderImg = UIImage.init(named: "default_icon")
        let urlRequest = NSURLRequest.init(url: URL.init(string:AppManager.sharedInstance.baseURL + cInfo.profile_pic!)!)
        cell.imageView?.setImageWith(urlRequest as URLRequest!, placeholderImage: placeHolderImg, success: { (request:URLRequest?, response:HTTPURLResponse?, downloadedImage:UIImage?) in
                cell.imageView?.image = downloadedImage
        }, failure: { (request:URLRequest?, response:HTTPURLResponse?, error:Error?) in
            cell.imageView?.image = placeHolderImg
        })
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.localContacts.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Kamu Mencet \(indexPath.row)")
        let cInfo:ContactList = self.localContacts[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller:ContactDetailViewController = storyboard.instantiateViewController(withIdentifier: "CONTACTDETAILVC") as! ContactDetailViewController
        controller.contactDetail = cInfo
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
