//
//  business_information.swift
//  Virtual Closeout
//
//  Created by Apple on 09/06/22.
//

import UIKit
import Alamofire
import SDWebImage

import QCropper

class business_information: UIViewController  , UINavigationControllerDelegate, UIImagePickerControllerDelegate , CropperViewControllerDelegate {
    
    var img_data_logo : Data!
    var img_Str_logo : String!
    
    var str_which_profile:String!
    
    // ***************************************************************** // nav
    
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = navigation_color
            navigationBar.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            navigationBar.layer.shadowOpacity = 1.0
            navigationBar.layer.shadowRadius = 15.0
            navigationBar.layer.masksToBounds = false
        }
    }
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.tintColor = .white
            btnBack.isHidden = false
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "Business information"
            lblNavigationTitle.textColor = .white
        }
    }
    
    // ***************************************************************** // nav
    
    @IBOutlet weak var tablView:UITableView! {
        didSet {
            tablView.delegate = self
            tablView.dataSource = self
            tablView.backgroundColor = .clear
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        // self.btnBack.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        
        // print(self.str_which_profile as Any)
        
        if String(self.str_which_profile) == "edit_business" {
            self.lblNavigationTitle.text = "Edit business profile"
        }
        
        self.manage_profile(self.btnBack)
        
    }
    
    
    // MARK: - OPEN CAMERA OR GALLERY -
    @objc func open_camera_gallery() {
        
        let actionSheet = NewYorkAlertController(title: "Upload", message: nil, style: .actionSheet)
        
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image_data = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        let cropper = CropperViewController(originalImage: image_data!)
        
        cropper.delegate = self
        
        picker.dismiss(animated: true) {
            self.present(cropper, animated: true, completion: nil)
            
        }
        
    }
    
    func cropperDidConfirm(_ cropper: CropperViewController, state: CropperState?) {
        cropper.dismiss(animated: true, completion: nil)
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! business_information_table_cell
        
        if let state = state,
           let image = cropper.originalImage.cropped(withCropperState: state) {
            
            cell.img_profile.image = image
            
            let imageData:Data = image.pngData()!
            self.img_data_logo = imageData
            
            // self.upload_club_logo_to_server()
            
        } else {
            print("Something went wrong")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func validation_before_upload_business_information() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! business_information_table_cell
        
        if String(cell.txt_shop_name.text!) == "" {
            
            self.validations_for_forms(str_title: "Shop name")
            
        } else if String(cell.txt_phone_number.text!) == "" {
            
            self.validations_for_forms(str_title: "Phone number")
            
        } else if String(cell.txt_address.text!) == "" {
            
            self.validations_for_forms(str_title: "Address")
            
        } else if String(cell.txt_country.text!) == "" {
            
            self.validations_for_forms(str_title: "Country")
            
        } else if String(cell.txt_state.text!) == "" {
            
            self.validations_for_forms(str_title: "State")
            
        } else if String(cell.txt_city.text!) == "" {
            
            self.validations_for_forms(str_title: "City")
            
        } else if String(cell.txt_pin_code.text!) == "" {
            
            self.validations_for_forms(str_title: "Pincode")
            
        } else {
            
            if String(self.str_which_profile) == "edit_business" {
                
                if self.img_data_logo == nil {
                    self.update_shop_Details_without_image()
                } else {
                    self.edit_shop_profile()
                }
                
                
            } else {
                
                if self.img_data_logo == nil {
                    
                    let alert = NewYorkAlertController(title: String("Alert"), message: "Please upload a profile picture", style: .alert)
                    let cancel = NewYorkButton(title: "dismiss", style: .cancel)
                    alert.addButtons([cancel])
                    self.present(alert, animated: true)
                    
                } else {
                    
                    self.upload_business_information()
                    
                }
                
            }
            
        }
        
    }
    
    @objc func upload_business_information() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! business_information_table_cell
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        //Set Your URL
        let api_url = APPLICATION_BASE_URL
        guard let url = URL(string: api_url) else {
            return
        }
        
        if let person = UserDefaults.standard.value(forKey: key_user_default_value) as? [String:Any] {
            // let str:String = person["role"] as! String
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            
            // let indexPath = IndexPath.init(row: 0, section: 0)
            // let cell = self.tablView.cellForRow(at: indexPath) as! AddTableTableViewCell
            
            //Set Your Parameter
            let parameterDict = NSMutableDictionary()
            parameterDict.setValue("editprofile", forKey: "action")
            parameterDict.setValue(String(myString), forKey: "userId")
            
            parameterDict.setValue(String(cell.txt_shop_name.text!), forKey: "businessName")
            parameterDict.setValue(String(cell.txt_phone_number.text!), forKey: "contactNumber")
            parameterDict.setValue(String(cell.txt_address.text!), forKey: "address")
            parameterDict.setValue(String(cell.txt_city.text!), forKey: "city")
            parameterDict.setValue(String(cell.txt_state.text!), forKey: "state")
            parameterDict.setValue(String(cell.txt_pin_code.text!), forKey: "zipCode")
            parameterDict.setValue(String(cell.txt_country.text!), forKey: "country")
            
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
                multiPart.append(self.img_data_logo, withName: "image", fileName: "add_business_information", mimeType: "image/png")
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
                        
                        let defaults = UserDefaults.standard
                        defaults.setValue(nil, forKey: key_user_default_value)
                        defaults.setValue("", forKey: key_user_default_value)
                        
                        var dict: Dictionary<AnyHashable, Any>
                        dict = dictionary["data"] as! Dictionary<AnyHashable, Any>
                        
                        defaults.setValue(dict, forKey: key_user_default_value)
                        
                        var strSuccess2 : String!
                        strSuccess2 = dictionary["msg"]as Any as? String
                        
                        
                        
                        let alert = NewYorkAlertController(title: String("Success"), message: String(strSuccess2)+". Please enter your bank information.", style: .alert)
                        let cancel = NewYorkButton(title: "Ok", style: .cancel) {
                            _ in
                            
                            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "bank_information_id") as? bank_information
                            push!.str_which_profile_bank_info = ""
                            self.navigationController?.pushViewController(push!, animated: true)
                            
                        }
                        alert.addButtons([cancel])
                        self.present(alert, animated: true)
                        
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
    
    @objc func edit_shop_profile() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! business_information_table_cell
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        //Set Your URL
        let api_url = APPLICATION_BASE_URL
        guard let url = URL(string: api_url) else {
            return
        }
        
        if let person = UserDefaults.standard.value(forKey: key_user_default_value) as? [String:Any] {
            // let str:String = person["role"] as! String
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            
            
            // let indexPath = IndexPath.init(row: 0, section: 0)
            // let cell = self.tablView.cellForRow(at: indexPath) as! AddTableTableViewCell
            
            //Set Your Parameter
            let parameterDict = NSMutableDictionary()
            parameterDict.setValue("editprofile", forKey: "action")
            parameterDict.setValue(String(myString), forKey: "userId")
            
            parameterDict.setValue(String(cell.txt_shop_name.text!), forKey: "businessName")
            parameterDict.setValue(String(cell.txt_phone_number.text!), forKey: "contactNumber")
            parameterDict.setValue(String(cell.txt_address.text!), forKey: "address")
            parameterDict.setValue(String(cell.txt_city.text!), forKey: "city")
            parameterDict.setValue(String(cell.txt_state.text!), forKey: "state")
            parameterDict.setValue(String(cell.txt_pin_code.text!), forKey: "zipCode")
            parameterDict.setValue(String(cell.txt_country.text!), forKey: "country")
            
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
                multiPart.append(self.img_data_logo, withName: "image", fileName: "edit_business_information", mimeType: "image/png")
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
                        
                        let defaults = UserDefaults.standard
                        defaults.setValue(nil, forKey: key_user_default_value)
                        defaults.setValue("", forKey: key_user_default_value)
                        
                        var dict: Dictionary<AnyHashable, Any>
                        dict = dictionary["data"] as! Dictionary<AnyHashable, Any>
                        
                        defaults.setValue(dict, forKey: key_user_default_value)
                        
                        var strSuccess2 : String!
                        strSuccess2 = dictionary["msg"]as Any as? String
                        
                        if String(self.str_which_profile) == "edit_business" {
                            
                            let alert = NewYorkAlertController(title: String("Success"), message: "Data edited successfully.", style: .alert)
                            let cancel = NewYorkButton(title: "Ok", style: .cancel)
                            alert.addButtons([cancel])
                            self.present(alert, animated: true)
                            
                        } else {
                            
                            let alert = NewYorkAlertController(title: String("Success"), message: String(strSuccess2)+". Please enter your bank information.", style: .alert)
                            let cancel = NewYorkButton(title: "Ok", style: .cancel) {
                                _ in
                                
                                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "bank_information_id") as? bank_information
                                push!.str_which_profile_bank_info = ""
                                self.navigationController?.pushViewController(push!, animated: true)
                                
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
                
                
            }
            )
            
        }
        
    }
    
    
    @objc func update_shop_Details_without_image() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! business_information_table_cell
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        if let person = UserDefaults.standard.value(forKey: key_user_default_value) as? [String:Any] {
            // let str:String = person["role"] as! String
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let params = edit_business_information_params(action: "editprofile",
                                                          userId: String(myString),
                                                          businessName: String(cell.txt_shop_name.text!),
                                                          contactNumber: String(cell.txt_phone_number.text!),
                                                          address: String(cell.txt_address.text!),
                                                          city: String(cell.txt_city.text!),
                                                          state: String(cell.txt_state.text!),
                                                          zipCode: String(cell.txt_pin_code.text!),
                                                          country: String(cell.txt_country.text!))
            
            
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
                        defaults.setValue(dict, forKey: key_user_default_value)
                        
                        let alert = NewYorkAlertController(title: String("Success"), message: "Data edited successfully.", style: .alert)
                        let cancel = NewYorkButton(title: "Ok", style: .cancel)
                        alert.addButtons([cancel])
                        self.present(alert, animated: true)
                        
                    } else {
                        
                        print("no")
                        ERProgressHud.sharedInstance.hide()
                        
                        var strSuccess2 : String!
                        strSuccess2 = JSON["msg"]as Any as? String
                        
                        let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: String(strSuccess2), style: .alert)
                        let cancel = NewYorkButton(title: "dismiss", style: .cancel)
                        alert.addButtons([cancel])
                        self.present(alert, animated: true)
                        
                    }
                    
                case let .failure(error):
                    print(error)
                    ERProgressHud.sharedInstance.hide()
                    
                    self.please_check_your_internet_connection()
                    
                }
            }
        }
    }
}

//MARK:- TABLE VIEW -
extension business_information: UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:business_information_table_cell = tableView.dequeueReusableCell(withIdentifier: "business_information_table_cell") as! business_information_table_cell
        
        cell.backgroundColor = .clear
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        cell.accessoryType = .none
        
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(business_information.open_camera_gallery))
        cell.img_profile.isUserInteractionEnabled = true
        cell.img_profile.addGestureRecognizer(tapGestureRecognizer1)
        
        /*
         ["email": ios_s_01@mailinator.com, "country": India , "contactNumber": 8287632340, "deviceToken": , "image": , "fullName": ios_s_01, "businessName": dishu_shop_1, "socialType": , "address": dwarka, "zipCode": 110075, "AccountNo": 12341234, "AccountHolderName": dishu bank name, "state": Delhi , "lastName": , "wallet": 0, "BankName": HDFC, "AVGRating": , "longitude": , "RoutingNo": 1234-qwerty, "city": Delhi, "dob": , "device": iOS, "latitude": , "userId": 126, "socialId": , "middleName": , "role": Seller, "gender": , "PayPalAccount": ]
         */
        
        if let person = UserDefaults.standard.value(forKey: key_user_default_value) as? [String:Any] {
            
            if String(self.str_which_profile) == "edit_business" {
                cell.btn_save_and_continue.setTitle("Edit business profile", for: .normal)
                
                cell.img_profile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                cell.img_profile.sd_setImage(with: URL(string: (person["image"] as! String)), placeholderImage: UIImage(named: "logo"))
                
                cell.txt_shop_name.text = (person["businessName"] as! String)
                cell.txt_phone_number.text = (person["contactNumber"] as! String)
                cell.txt_address.text = (person["address"] as! String)
                cell.txt_country.text = (person["country"] as! String)
                cell.txt_state.text = (person["state"] as! String)
                cell.txt_city.text = (person["city"] as! String)
                cell.txt_pin_code.text = (person["zipCode"] as! String)
                
            }
            
        }
        
        cell.btn_save_and_continue.addTarget(self, action: #selector(validation_before_upload_business_information), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1200
    }
    
}

class business_information_table_cell:UITableViewCell {
    
    @IBOutlet weak var img_profile:UIImageView! {
        didSet {
            img_profile.layer.cornerRadius = 100
            img_profile.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var txt_shop_name:UITextField! {
        didSet {
            Utils.text_field_UI(text_field: txt_shop_name)
        }
    }
    
    @IBOutlet weak var txt_phone_number:UITextField! {
        didSet {
            Utils.text_field_UI(text_field: txt_phone_number)
        }
    }
    
    @IBOutlet weak var txt_address:UITextField! {
        didSet {
            Utils.text_field_UI(text_field: txt_address)
        }
    }
    
    @IBOutlet weak var txt_city:UITextField! {
        didSet {
            Utils.text_field_UI(text_field: txt_city)
        }
    }
    
    @IBOutlet weak var txt_state:UITextField! {
        didSet {
            Utils.text_field_UI(text_field: txt_state)
        }
    }
    
    @IBOutlet weak var txt_country:UITextField! {
        didSet {
            Utils.text_field_UI(text_field: txt_country)
        }
    }
    
    @IBOutlet weak var txt_pin_code:UITextField! {
        didSet {
            Utils.text_field_UI(text_field: txt_pin_code)
        }
    }
    
    @IBOutlet weak var btn_save_and_continue:UIButton! {
        didSet {
            btn_save_and_continue.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            btn_save_and_continue.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            btn_save_and_continue.layer.shadowOpacity = 1.0
            btn_save_and_continue.layer.shadowRadius = 15.0
            btn_save_and_continue.layer.masksToBounds = false
            btn_save_and_continue.layer.cornerRadius = 22
            btn_save_and_continue.backgroundColor = button_dark
            btn_save_and_continue.setTitleColor(.white, for: .normal)
            btn_save_and_continue.setTitle("Save & Continue", for: .normal)
        }
    }
    
}
