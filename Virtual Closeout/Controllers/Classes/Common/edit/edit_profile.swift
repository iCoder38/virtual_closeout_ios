//
//  edit_profile.swift
//  Virtual Closeout
//
//  Created by Apple on 27/06/22.
//

import UIKit
import Alamofire

// MARK:- LOCATION -
import CoreLocation

import QCropper

class edit_profile_common: UIViewController , UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate , CropperViewControllerDelegate {
    
    var strPassImgString:String!
    var imageStr:String!
    var imgData:Data!
    
    let locationManager = CLLocationManager()
    
    // MARK:- SAVE LOCATION STRING -
    var strSaveLatitude:String!
    var strSaveLongitude:String!
    var strSaveCountryName:String!
    var strSaveLocalAddress:String!
    var strSaveLocality:String!
    var strSaveLocalAddressMini:String!
    var strSaveStateName:String!
    var strSaveZipcodeName:String!
    
    var strEditDriverPortal:String!
    
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = navigation_color
        }
    }
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "Edit Profile"
        }
    }
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.setTitle("", for: .normal)
            btnBack.setImage(UIImage(systemName:"arrow.left"), for: .normal)
            btnBack.tintColor = .white
        }
    }
    
    @IBOutlet weak var imgProfile:UIImageView! {
        didSet {
            imgProfile.layer.cornerRadius = 60
            imgProfile.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var txtRestaurantName:UITextField! {
        didSet {
            // txtRestaurantName.layer.cornerRadius = 6
            // txtRestaurantName.clipsToBounds = true
            
            // txtRestaurantName.layer.borderColor = UIColor.clear.cgColor
            // txtRestaurantName.layer.borderWidth = 0.8
            txtRestaurantName.setLeftPaddingPoints(40)
            txtRestaurantName.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            txtRestaurantName.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            txtRestaurantName.layer.shadowOpacity = 1.0
            txtRestaurantName.layer.shadowRadius = 15.0
            txtRestaurantName.layer.masksToBounds = false
            txtRestaurantName.layer.cornerRadius = 15
            txtRestaurantName.backgroundColor = .white
            txtRestaurantName.textColor = .black
            
        }
    }
    
    @IBOutlet weak var txtEmail:UITextField! {
        didSet {
            txtEmail.setLeftPaddingPoints(40)
            txtEmail.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            txtEmail.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            txtEmail.layer.shadowOpacity = 1.0
            txtEmail.layer.shadowRadius = 15.0
            txtEmail.layer.masksToBounds = false
            txtEmail.layer.cornerRadius = 15
            txtEmail.backgroundColor = .white
            txtEmail.isUserInteractionEnabled = false
            txtEmail.textColor = .black
        }
    }
    
    @IBOutlet weak var txtPhone:UITextField! {
        didSet {
            txtPhone.setLeftPaddingPoints(40)
            txtPhone.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            txtPhone.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            txtPhone.layer.shadowOpacity = 1.0
            txtPhone.layer.shadowRadius = 15.0
            txtPhone.layer.masksToBounds = false
            txtPhone.layer.cornerRadius = 15
            txtPhone.backgroundColor = .white
            txtPhone.textColor = .black
        }
    }
    @IBOutlet weak var txtAddress:UITextField! {
        didSet {
            txtAddress.setLeftPaddingPoints(40)
            txtAddress.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            txtAddress.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            txtAddress.layer.shadowOpacity = 1.0
            txtAddress.layer.shadowRadius = 15.0
            txtAddress.layer.masksToBounds = false
            txtAddress.layer.cornerRadius = 15
            txtAddress.backgroundColor = .white
            txtAddress.textColor = .black
        }
    }
    
    @IBOutlet weak var btnEditYourProfile:UIButton! {
        didSet {
            btnEditYourProfile.layer.cornerRadius = 6
            btnEditYourProfile.clipsToBounds = true
            btnEditYourProfile.setTitle("Update", for: .normal)
            btnEditYourProfile.setTitleColor(.white, for: .normal)
            btnEditYourProfile.backgroundColor = button_dark
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.strPassImgString = "0"
        
        self.strSaveLatitude = "0"
        self.strSaveLongitude = "0"
        
        self.txtRestaurantName.delegate = self
        self.txtPhone.delegate = self
        self.txtAddress.delegate = self
        
        self.view.backgroundColor = .white
        // btnBack.addTarget(self, action: #selector(sideBarMenuClick), for: .touchUpInside)
        btnEditYourProfile.addTarget(self, action: #selector(editRestaurantProfileWB), for: .touchUpInside)
        
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            // print(person as Any)
            /*
             ["zipCode": , "AutoInsurance": , "dob": , "companyBackground": http://demo2.evirtualservices.com/food-delivery/site/img/uploads/users/1587560500Corona.png, "BankName": djdgsgs, "userId": 99, "socialId": , "gender": , "RoutingNo": vstvush6sg6, "AccountNo": 8505858545884555, "ssnImage": , "contactNumber": 9494645544, "firebaseId": , "image": http://demo2.evirtualservices.com/food-delivery/site/img/uploads/users/1587560500Corona.png, "drivlingImage": , "AccountHolderName": jjsjs, "fullName": restaurent, "address": Gwalior, Madhya Pradesh 474008, India, "state": , "middleName": , "wallet": 0, "role": Restaurant, "country": India, "email": restaurent@gmail.com, "accountType": Saving, "socialType": , "logitude": 78.1694957, "longitude": 78.1694957, "lastName": , "latitude": 26.2313245, "device": , "deviceToken": , "foodTag": Veg]
             */
            
            if (person["role"] as! String) == "Club" {
                
                // self.btnEditYourBusinessProfile.isHidden = false
                // btnEditYourBusinessProfile.addTarget(self, action: #selector(editYourBusinessProfileClickMethod), for: .touchUpInside)
                
            } else {
                
                // self.btnEditYourBusinessProfile.isHidden = true
                
            }
            
            self.txtRestaurantName.text = (person["fullName"] as! String)
            self.txtEmail.text = (person["email"] as! String)
            self.txtPhone.text = (person["contactNumber"] as! String)
            self.txtAddress.text = (person["address"] as! String)
            
            imgProfile.sd_setImage(with: URL(string: (person["image"] as! String)), placeholderImage: UIImage(named: "user"))
            
            
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(edit_profile_common.cellTappedMethod(_:)))
            
            imgProfile.isUserInteractionEnabled = true
            
            imgProfile.addGestureRecognizer(tapGestureRecognizer)
            
            self.manage_profile(self.btnBack)

            self.iAmHereForLocationPermission()
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    @objc func iAmHereForLocationPermission() {
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
                self.strSaveLatitude = "0"
                self.strSaveLongitude = "0"
                
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
                
            @unknown default:
                break
            }
        }
    }
    // MARK:- GET CUSTOMER LOCATION
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        let location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        location.fetchCityAndCountry { city, country, zipcode,localAddress,localAddressMini,locality, error in
            guard let city = city, let country = country,let zipcode = zipcode,let localAddress = localAddress,let localAddressMini = localAddressMini,let locality = locality, error == nil else { return }
            
            self.strSaveCountryName     = country
            self.strSaveStateName       = city
            self.strSaveZipcodeName     = zipcode
            
            self.strSaveLocalAddress     = localAddress
            self.strSaveLocality         = locality
            self.strSaveLocalAddressMini = localAddressMini
            
            let doubleLat = locValue.latitude
            let doubleStringLat = String(doubleLat)
            
            let doubleLong = locValue.longitude
            let doubleStringLong = String(doubleLong)
            
            self.strSaveLatitude = String(doubleStringLat)
            self.strSaveLongitude = String(doubleStringLong)
            
            // print("local address ==> "+localAddress as Any) // south west delhi
            print("local address mini ==> "+localAddressMini as Any) // new delhi
            // print("locality ==> "+locality as Any) // sector 10 dwarka
            
            // print(self.strSaveCountryName as Any) // india
            // print(self.strSaveStateName as Any) // new delhi
            // print(self.strSaveZipcodeName as Any) // 110075
            
            //MARK:- STOP LOCATION -
            self.locationManager.stopUpdatingLocation()
            
            
            
            let addressIs:String = String(self.strSaveLocality)+" "+String(self.self.strSaveLocalAddress)
            self.txtAddress.text = String(addressIs)
        }
    }
    
    @objc func editYourBusinessProfileClickMethod() {
//        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "club_edit_profile_id") as? club_edit_profile
//        // push!.areYouFromDriverEdit = "yesFromDriverEdit"
//        self.navigationController?.pushViewController(push!, animated: true)
    }
    
    @objc func cellTappedMethod(_ sender:AnyObject){
        print("you tap image number: \(sender.view.tag)")
        
        let actionSheet = NewYorkAlertController(title: "Upload profile picture", message: nil, style: .actionSheet)
        
        // actionSheet.addImage(UIImage(named: "camera"))
        
        let cameraa = NewYorkButton(title: "Camera", style: .default) { _ in
            // print("camera clicked done")
            
            self.open_camera_or_gallery(str_type: "c")
        }
        
        let gallery = NewYorkButton(title: "Gallery", style: .default) { _ in
            // print("camera clicked done")
            
            self.open_camera_or_gallery(str_type: "g")
        }
        
        let cancel = NewYorkButton(title: "Cancel", style: .cancel)
        
        actionSheet.addButtons([cameraa, gallery, cancel])
        
        self.present(actionSheet, animated: true)
        
    }
    
    // MARK: - OPEN CAMERA or GALLERY -
    @objc func open_camera_or_gallery(str_type:String) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if str_type == "c" {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // let indexPath = IndexPath.init(row: 0, section: 0)
        // let cell = self.tbleView.cellForRow(at: indexPath) as! RAddMenuTableCell
        
        imgProfile.isHidden = false
        
        let image_data = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        let cropper = CropperViewController(originalImage: image_data!)
        
        cropper.delegate = self
        
        picker.dismiss(animated: true) {
            self.present(cropper, animated: true, completion: nil)
            
        }
        
        /*imgProfile.image = image_data // show image on profile
         let imageData:Data = image_data!.pngData()!
         imageStr = imageData.base64EncodedString()
         self.dismiss(animated: true, completion: nil)
         imgData = image_data!.jpegData(compressionQuality: 0.2)!*/
        //print(type(of: imgData)) // data
        
        self.strPassImgString = "1"
        
        // self.cropToBounds(image: image_data!, width: 200.0, height: 200.0)
        
        // self.uploadWithImage()
    }
    
    func cropperDidConfirm(_ cropper: CropperViewController, state: CropperState?) {
        cropper.dismiss(animated: true, completion: nil)
        
        if let state = state,
           let image = cropper.originalImage.cropped(withCropperState: state) {
            self.imgProfile.image = image
            
            let imageData:Data = image.pngData()!
            
            self.imgData = imageData
            
        } else {
            print("Something went wrong")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func sideBarMenuClick() {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @objc func editRestaurantProfileWB() {
        if self.strPassImgString == "1" {
            self.editWithImageProfileWB()
        } else {
            self.editWithoutImageProfileWB()
        }
    }
    
    // MARK:- RESTAURANT LOGIN -
    @objc func editWithoutImageProfileWB() {
        /*ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
         
         self.view.endEditing(true)
         
         let urlString = APPLICATION_BASE_URL
         
         var parameters:Dictionary<AnyHashable, Any>!
         
         if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
         
         let x : Int = person["userId"] as! Int
         let myString = String(x)
         
         parameters = [
         "action"          : "editprofile",
         "userId"          : String(myString),
         "fullName"        : String(txtRestaurantName.text!),
         "contactNumber"   : String(txtPhone.text!),
         "address"         : String(txtAddress.text!),
         "device"          : String("iOS"),
         "latitude"        : String(self.strSaveLatitude),////String(self.strSaveLatitude),
         "longitude"       : String(self.strSaveLongitude),//"77.0500",//String(self.strSaveLongitude)
         ]
         }
         print("parameters-------\(String(describing: parameters))")
         
         Alamofire.request(urlString, method: .post, parameters: parameters as? Parameters).responseJSON {
         response in
         
         switch(response.result) {
         case .success(_):
         if let data = response.result.value {
         
         let JSON = data as! NSDictionary
         print(JSON as Any)
         
         var strSuccess : String!
         strSuccess = JSON["status"]as Any as? String
         
         // var strSuccessAlert : String!
         // strSuccessAlert = JSON["msg"]as Any as? String
         
         if strSuccess == String("success") {
         print("yes")
         
         ERProgressHud.sharedInstance.hide()
         
         
         var dict: Dictionary<AnyHashable, Any>
         dict = JSON["data"] as! Dictionary<AnyHashable, Any>
         
         let defaults = UserDefaults.standard
         defaults.setValue(dict, forKey: "keyLoginFullData")
         
         }
         else {
         print("no")
         ERProgressHud.sharedInstance.hide()
         
         }
         }
         
         case .failure(_):
         print("Error message:\(String(describing: response.result.error))")
         
         ERProgressHud.sharedInstance.hide()
         
         let alertController = UIAlertController(title: nil, message: "Server Issue", preferredStyle: .actionSheet)
         
         let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
         UIAlertAction in
         NSLog("OK Pressed")
         }
         
         alertController.addAction(okAction)
         
         self.present(alertController, animated: true, completion: nil)
         
         break
         }
         }*/
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            self.view.endEditing(true)
            ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
            
            let params = edit_profile(action: "editprofile",
                                      userId: String(myString),
                                      fullName: String(self.txtRestaurantName.text!),
                                      contactNumber: String(self.txtPhone.text!),
                                      address: String(self.txtAddress.text!),
                                      latitude:String(self.strSaveLatitude),
                                      longitude: String(self.strSaveLongitude))
            
            print(params as Any)
            
            AF.request(APPLICATION_BASE_URL,
                       method: .post,
                       parameters: params,
                       encoder: JSONParameterEncoder.default).responseJSON { response in
                // debugPrint(response.result)
                
                switch response.result {
                case let .success(value):
                    
                    let JSON = value as! NSDictionary
                    print(JSON as Any)
                    
                    var strSuccess : String!
                    strSuccess = (JSON["status"]as Any as? String)?.lowercased()
                    print(strSuccess as Any)
                    
                    if strSuccess == String("success") {
                        print("yes")
                        
                        ERProgressHud.sharedInstance.hide()
                        
                        var dict: Dictionary<AnyHashable, Any>
                        dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                        
                        let defaults = UserDefaults.standard
                        defaults.setValue(dict, forKey: "keyLoginFullData")
                        
                        if (dict["role"] as! String) == "Customer" {
                            
                            var strSuccess2 : String!
                            strSuccess2 = JSON["msg"]as Any as? String
                            
                            let alert = NewYorkAlertController(title: "Success", message: String(strSuccess2), style: .alert)
                            
                            // alert.addImage(UIImage.gif(name: "success3"))
                            
                            let cancel = NewYorkButton(title: "Ok", style: .cancel) { _ in
                                
                                // SPConfetti.stopAnimating()
                                
                                self.navigationController?.popViewController(animated: true)
                            }
                            alert.addButtons([cancel])
                            
                            self.present(alert, animated: true)
                            
                            
                        }
                        
                        else  {
                            
                            ERProgressHud.sharedInstance.hide()
                            
                            var strSuccess2 : String!
                            strSuccess2 = JSON["msg"]as Any as? String
                            
                            let alert = NewYorkAlertController(title: "Success", message: String(strSuccess2), style: .alert)
                            
                            // alert.addImage(UIImage.gif(name: "success3"))
                            
                            let cancel = NewYorkButton(title: "Ok", style: .cancel) { _ in
                                
                                // SPConfetti.stopAnimating()
                                
                                self.navigationController?.popViewController(animated: true)
                            }
                            alert.addButtons([cancel])
                            
                            self.present(alert, animated: true)
                            
                            
                            
                        }
                        
                        
                    } else {
                        print("no")
                          ERProgressHud.sharedInstance.hide()
                        
                        var strSuccess2 : String!
                        strSuccess2 = JSON["msg"]as Any as? String
                        
                        if strSuccess2 == "Your Account is Inactive. Please contact admin.!!" ||
                            strSuccess2 == "Your Account is Inactive. Please contact admin.!" ||
                            strSuccess2 == "Your Account is Inactive. Please contact admin." {
                            
                            
                        } else {
                            
                            let alert = UIAlertController(title: String(strSuccess).uppercased(), message: String(strSuccess2), preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                            
                            self.present(alert, animated: true)
                            
                        }
                    }
                    
                case let .failure(error):
                    print(error)
                    ERProgressHud.sharedInstance.hide()
                    
                    // Utils.showAlert(alerttitle: SERVER_ISSUE_TITLE, alertmessage: SERVER_ISSUE_MESSAGE, ButtonTitle: "Ok", viewController: self)
                }
            }
        }
        
        
    }
    
    
    
    // MARK:- EDIT BUSINESS DETAILS WITH IMAGE -
    @objc func editWithImageProfileWB() {
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        //Set Your URL
        let api_url = APPLICATION_BASE_URL
        guard let url = URL(string: api_url) else {
            return
        }
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // let str:String = person["role"] as! String
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            
            
            // let indexPath = IndexPath.init(row: 0, section: 0)
            // let cell = self.tbleView.cellForRow(at: indexPath) as! CEditTotalTableCell
            
            var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            
            //Set Your Parameter
            let parameterDict = NSMutableDictionary()
            parameterDict.setValue("editprofile", forKey: "action")
            parameterDict.setValue(String(myString), forKey: "userId")
            parameterDict.setValue(String(self.txtRestaurantName.text!), forKey: "fullName")
            parameterDict.setValue(String(self.txtPhone.text!), forKey: "contactNumber")
            parameterDict.setValue(String(self.txtAddress.text!), forKey: "address")
            
            //Set Image Data
            // let imgData = self.img_photo.image!.jpegData(compressionQuality: 0.5)!
            
            /*
             let params = EditUserWithoutImage(action: "editprofile",
             userId: String(myString),
             fullName: String(cell.txtUsername.text!),
             contactNumber: String(cell.txtPhoneNumber.text!),
             address: String(cell.txtAddress.text!))
             */
            // Now Execute
            AF.upload(multipartFormData: { multiPart in
                for (key, value) in parameterDict {
                    if let temp = value as? String {
                        multiPart.append(temp.data(using: .utf8)!, withName: key as! String)
                    }
                    if let temp = value as? Int {
                        multiPart.append("\(temp)".data(using: .utf8)!, withName: key as! String)
                    }
                    if let temp = value as? NSArray {
                        temp.forEach({ element in
                            let keyObj = key as! String + "[]"
                            if let string = element as? String {
                                multiPart.append(string.data(using: .utf8)!, withName: keyObj)
                            } else
                            if let num = element as? Int {
                                let value = "\(num)"
                                multiPart.append(value.data(using: .utf8)!, withName: keyObj)
                            }
                        })
                    }
                }
                multiPart.append(self.imgData, withName: "image", fileName: "bookit_edit_profile.png", mimeType: "image/png")
            }, with: urlRequest)
            .uploadProgress(queue: .main, closure: { progress in
                //Current upload progress of file
                print("Upload Progress: \(progress.fractionCompleted)")
            })
            .responseJSON(completionHandler: { data in
                
                switch data.result {
                    
                case .success(_):
                    do {
                        
                        let dictionary = try JSONSerialization.jsonObject(with: data.data!, options: .fragmentsAllowed) as! NSDictionary
                        
                        print("Success!")
                        print(dictionary)
                        
                        ERProgressHud.sharedInstance.hide()
                        
                        var dict: Dictionary<AnyHashable, Any>
                        dict = dictionary["data"] as! Dictionary<AnyHashable, Any>
                        
                        let defaults = UserDefaults.standard
                        defaults.setValue(dict, forKey: "keyLoginFullData")
                        
                        if (dict["role"] as! String) == "Customer" {
                            
                            var strSuccess2 : String!
                            strSuccess2 = dictionary["msg"]as Any as? String
                            
                            let alert = NewYorkAlertController(title: "Success", message: String(strSuccess2), style: .alert)
                            
                            // alert.addImage(UIImage.gif(name: "success3"))
                            
                            let cancel = NewYorkButton(title: "Ok", style: .cancel) { _ in
                                
                                // SPConfetti.stopAnimating()
                                
                                self.navigationController?.popViewController(animated: true)
                            }
                            alert.addButtons([cancel])
                            
                            self.present(alert, animated: true)
                            
                            /*let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NPHomeVC") as? NPHomeVC
                             self.navigationController?.pushViewController(settingsVCId!, animated: true)*/
                            
                        } else {
                            
                            var strSuccess2 : String!
                            strSuccess2 = dictionary["msg"]as Any as? String
                            
                            let alert = NewYorkAlertController(title: "Success", message: String(strSuccess2), style: .alert)
                            
                            // alert.addImage(UIImage.gif(name: "success3"))
                            
                            let cancel = NewYorkButton(title: "Ok", style: .cancel) { _ in
                                
                                // SPConfetti.stopAnimating()
                                
                                self.navigationController?.popViewController(animated: true)
                            }
                            alert.addButtons([cancel])
                            
                            self.present(alert, animated: true)
                            
                        }
                        
                        
                    }
                    catch {
                        // catch error.
                        print("catch error")
                        ERProgressHud.sharedInstance.hide()
                    }
                    break
                    
                case .failure(_):
                    print("failure")
                    ERProgressHud.sharedInstance.hide()
                    break
                    
                }
                
                
            })
            
        }}
    
}
