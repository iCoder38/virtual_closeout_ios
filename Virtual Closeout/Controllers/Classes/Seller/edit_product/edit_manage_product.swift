//
//  edit_manage_product.swift
//  Virtual Closeout
//
//  Created by Apple on 21/06/22.
//

import UIKit
import Alamofire
import SDWebImage

import OpalImagePicker
import BSImagePicker
import Photos
import QCropper

class edit_manage_product: UIViewController , UITextFieldDelegate , OpalImagePickerControllerDelegate , UINavigationControllerDelegate, UIImagePickerControllerDelegate , UITextViewDelegate , CropperViewControllerDelegate {
    
    var arr_mut_add_new_product:NSMutableArray! = []
    var arr_sub_category:NSArray!
    
    var page : Int! = 1
    var loadMore : Int! = 1
    
    // var arr_mut_list_of_all_products:NSMutableArray! = []
    
    var str_category_id:String! = ""
    var str_sub_category_id:String! = ""
    var str_product_id:String! = ""
    
    var img_data : Data!
    var img_Str : String!
    
    var arrImages : NSMutableArray! = []
    
    var arrImagesThumbnail : NSMutableArray! = []
    var data:Data!
    var arrTest : NSMutableArray! = []
    
    var get_full_product_details:NSDictionary!
    
    // var str_category_id:String!
    //var str_sub_category_id:String!
    
    var arr_mut_save_images:NSMutableArray! = []
    var str_which_image_cell_select:String = "0"
    
    var img_data_logo : Data!
    var img_Str_logo : String!
    
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
            lblNavigationTitle.text = "Add product"
            lblNavigationTitle.textColor = .white
        }
    }
    
    
    // ***************************************************************** // nav
    
    @IBOutlet weak var tablView:UITableView! {
        didSet {
            // tablView.delegate = self
            // tablView.dataSource = self
            tablView.backgroundColor = .clear
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.btnBack.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        
        // self.list_of_all_category(pageNumber: 1)
        
        self.str_product_id = "\(self.get_full_product_details["productId"]!)"
        self.product_details_WB(str_loader: "yes")
        
        // print(self.get_full_product_details as Any)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.tablView.reloadData()
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.arr_mut_add_new_product.removeAllObjects()
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! add_new_product_table_cell
        
        if textField == cell.txt_special_price {
            
            if (cell.txt_special_price.text!) >= cell.txt_regular_price.text! {
                
                print("in-valid price")
                cell.lbl_invalid_price_text.text = "Special price (should be less then regular price)"
                cell.lbl_invalid_price_text.textColor = .systemRed
                cell.txt_special_price.layer.borderColor = UIColor.systemRed.cgColor
                cell.txt_special_price.layer.borderWidth = 4
                
            } else {
                
                print("valid price")
                cell.lbl_invalid_price_text.text = "Special price"
                cell.lbl_invalid_price_text.textColor = .black
                cell.txt_special_price.layer.borderColor = button_dark.cgColor
                cell.txt_special_price.layer.borderWidth = 1
                
            }
            
        }
        
        // arr_mut_add_new_product
        
        /*let custom_dict = ["product_name"   : String(cell.txt_product_name.text!),
                           "regular_price"  : String(cell.txt_regular_price.text!),
                           "special_price"  : String(cell.txt_special_price.text!),
                           "color"          : String(cell.txt_color.text!),
                           "condition"      : String(cell.txt_condition.text!),
                           "category"       : String(cell.txt_category.text!),
                           "sub_category"   : String(cell.txt_sub_category.text!)
        ]
        
        self.arr_mut_add_new_product.add(custom_dict)
        
        print(self.arr_mut_add_new_product as Any)*/
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
                
        if scrollView == self.tablView {
            let isReachingEnd = scrollView.contentOffset.y >= 0
                && scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)
            if(isReachingEnd) {
                if(loadMore == 1) {
                    loadMore = 0
                    page += 1
                    print(page as Any)
                    
                    //self.list_of_all_category(pageNumber: page)
                    
                }
            }
        }
    }
    
    
    
    
    @objc func myTargetFunction() {
        print("myTargetFunction")
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "category_sub_category_id")
        self.navigationController?.pushViewController(push, animated: true)
        
    }
    
    @objc func sub_myTargetFunction() {
         let indexPath = IndexPath.init(row: 0, section: 0)
         let cell = self.tablView.cellForRow(at: indexPath) as! add_new_product_table_cell
        
        if cell.txt_category.text == "" {
            
            let alert = NewYorkAlertController(title: String("Alert"), message: String("Please select category first."), style: .alert)
            let cancel = NewYorkButton(title: "dismiss", style: .cancel)
            alert.addButtons([cancel])
            self.present(alert, animated: true)
            
        } else {
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "only_sub_category_id") as? only_sub_category
            push!.ar_get_sub_category_list = arr_sub_category
            self.navigationController?.pushViewController(push!, animated: true)
            
        }
        
        
    }
    
    // MARK: - OPEN CAMERA OR GALLERY -
    @objc func open_camera_gallery() {
        
        let actionSheet = NewYorkAlertController(title: "Upload product images", message: nil, style: .actionSheet)
        
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
        
        // let indexPath = IndexPath.init(row: 0, section: 0)
        // let cell = self.tablView.cellForRow(at: indexPath) as! edit_manage_product_co
        
        if let state = state,
           let image = cropper.originalImage.cropped(withCropperState: state) {
            
            // cell.img_profile.image = image
                
            let imageData:Data = image.pngData()!
            self.img_data_logo = imageData
                
                // self.upload_club_logo_to_server()
              
        } else {
            print("Something went wrong")
        }
        
        self.dismiss(animated: true, completion: nil)
        
        print("dismiss done <========")
        
        self.validation_before_upload()
    }
    
    @objc func validation_before_upload() {
        
        
        if self.img_data_logo == nil {
            print("without image")
        } else {
            self.edit_product_with_images()
        }
            
        
        
    }
    
    @objc func edit_product_with_images() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! edit_manage_product_table_cell
        
        if let person = UserDefaults.standard.value(forKey: key_user_default_value) as? [String:Any] {
            print(person as Any)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
            
            //Set Your URL
            let api_url = APPLICATION_BASE_URL
            guard let url = URL(string: api_url) else {
                return
            }
            
            // let x : Int = self.dict_fetch_album_holder_data["albumId"] as! Int
            // let myString = String(x)
            
            var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
            urlRequest.httpMethod = "POST"
            
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            urlRequest.addValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
            
            //Set Your Parameter
            
            let parameterDict = NSMutableDictionary()
            
            parameterDict.setValue("addproduct", forKey: "action")
            parameterDict.setValue(String(myString), forKey: "userId")
            
            parameterDict.setValue(String(self.str_product_id), forKey: "productId")
            parameterDict.setValue(String(cell.txt_product_name.text!), forKey: "productName")
            parameterDict.setValue(String(cell.txt_regular_price.text!), forKey: "price")
            parameterDict.setValue(String(cell.txt_special_price.text!), forKey: "salePrice")
            parameterDict.setValue(String(self.str_category_id), forKey: "categoryId")
            parameterDict.setValue(String(self.str_sub_category_id), forKey: "subcategoryId")
            parameterDict.setValue(String(cell.txt_condition.text!), forKey: "conditions")
            parameterDict.setValue(String(cell.txt_color.text!), forKey: "color")
            
            parameterDict.setValue(String(cell.txt_quantity.text!), forKey: "quantity")
            parameterDict.setValue(String(cell.txt_view.text!), forKey: "description")
            
            print(parameterDict as Any)
            
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
                
                // "multiImage[0]"
                
                // print(self.arrTest as Any)
                // print(self.arrTest.count as Any)
                
                 
                multiPart.append(self.img_data_logo, withName: "image_"+String(self.str_which_image_cell_select), fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/png")
                    
                
                
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
                            
                            self.product_details_WB(str_loader: "no")
                            
                            // self.arrTest.removeAllObjects()
                            // ERProgressHud.sharedInstance.hide()
                            
                            // self.show_image_wb(str_show_indicator: "no")
                            
                            
//                            var strSuccess2 : String!
//                            strSuccess2 = dictionary["msg"]as Any as? String
//
//
//                            let alert = NewYorkAlertController(title: dictionary["status"]as Any as? String, message: String(strSuccess2), style: .alert)
//
//                            let cancel = NewYorkButton(title: "Ok", style: .cancel) {
//                                _ in
//                                self.back_click_method()
//                            }
//                            alert.addButtons([cancel])
//
//                            self.present(alert, animated: true)
                            
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
                        
                        if let err = data.response {
                            print(err)
                            return
                        }
                        
                        break
                        
                    }
                })
        }
    }
    
    
    // MARK: - WEBSERVICE - ( PRODUCT DETAILS ) -
    @objc func product_details_WB(str_loader:String) {
        
        self.view.endEditing(true)
        
        if str_loader == "yes" {
            ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        }
         
        
        if let person = UserDefaults.standard.value(forKey: key_user_default_value) as? [String:Any] {
            // let str:String = person["role"] as! String
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let params = product_details(action: "productdetail",
                                         userId: String(myString),
                                         productId: String(self.str_product_id))
            
            
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
                        
                        self.get_full_product_details = dict as NSDictionary
                        
                        // image 1
                        if (dict["image_1"] as! String) != "" {
                            self.arr_mut_save_images.add(dict["image_1"] as! String)
                        }
                        
                        // image 2
                        if (dict["image_2"] as! String) != "" {
                            self.arr_mut_save_images.add(dict["image_2"] as! String)
                        }
                        
                        // image 3
                        if (dict["image_3"] as! String) != "" {
                            self.arr_mut_save_images.add(dict["image_3"] as! String)
                        }
                        
                        // image 4
                        if (dict["image_4"] as! String) != "" {
                            self.arr_mut_save_images.add(dict["image_4"] as! String)
                        }
                        
                        // image 5
                        if (dict["image_5"] as! String) != "" {
                            self.arr_mut_save_images.add(dict["image_5"] as! String)
                        }
                        
                        // print(self.arr_mut_save_images as Any)
                        
                        self.tablView.delegate = self
                        self.tablView.dataSource = self
                        self.tablView.reloadData()

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
    
    // MARK: - CATEGORY CLICK -
    @objc func category_click_method() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! edit_manage_product_table_cell
        
        let dummyList = ["New", "Open box", "Reconditioned"]
        RPicker.selectOption(title: "Select", cancelText: "Cancel", dataArray: dummyList, selectedIndex: 2) {[weak self] (selctedText, atIndex) in
            // TODO: Your implementation for selection
            // self?.outputLabel.text = selctedText + " selcted at \(atIndex)"
            cell.txt_condition.text = selctedText
        }
        
    }
    
}

//MARK:- COLLECTION VIEW -
extension edit_manage_product: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.arr_mut_save_images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "edit_manage_product_collection_cell", for: indexPath as IndexPath) as! edit_manage_product_collection_cell
        
        cell.img_product_image.backgroundColor = .clear
        
        cell.img_product_image.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
        cell.img_product_image.sd_setImage(with: URL(string: (self.arr_mut_save_images[indexPath.item] as! String)), placeholderImage: UIImage(named: "logo"))
        
        cell.backgroundColor  = .clear
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var sizes: CGSize
        let result = UIScreen.main.bounds.size
        NSLog("%f",result.height)
        sizes = CGSize(width: 98, height: 98)
        
        return sizes
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
                        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
        print(indexPath.item as Any)
        
        
        
        
        // image 1
        if (self.get_full_product_details["image_1"] as! String) == "" {
            
            self.str_which_image_cell_select = "\(indexPath.item+1)"
            
        } else if (self.get_full_product_details["image_2"] as! String) == "" {
            
            self.str_which_image_cell_select = "\(indexPath.item+2)"
            
        } else if (self.get_full_product_details["image_3"] as! String) == "" {
            
            self.str_which_image_cell_select = "\(indexPath.item+3)"
            
        } else if (self.get_full_product_details["image_4"] as! String) == "" {
            
            self.str_which_image_cell_select = "\(indexPath.item+4)"
            
        } else if (self.get_full_product_details["image_5"] as! String) == "" {
            
            self.str_which_image_cell_select = "\(indexPath.item+5)"
            
        } else {
            
            self.arr_mut_save_images.add("0")
            
        }
        
        print(String(self.str_which_image_cell_select))
        
        self.open_camera_gallery()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
}

//MARK:- TABLE VIEW -
extension edit_manage_product: UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:edit_manage_product_table_cell = tableView.dequeueReusableCell(withIdentifier: "edit_manage_product_table_cell") as! edit_manage_product_table_cell
        
        cell.backgroundColor = .clear
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        cell.accessoryType = .none
        
        
        
        cell.txt_product_name.delegate = self
        cell.txt_regular_price.delegate = self
        cell.txt_special_price.delegate = self
        cell.txt_color.delegate = self
        cell.txt_condition.delegate = self
        cell.txt_category.delegate = self
        cell.txt_sub_category.delegate = self
        cell.txt_quantity.delegate = self
        
        self.str_category_id = "\(self.get_full_product_details["categoryId"]!)"
        self.str_sub_category_id = "\(self.get_full_product_details["subcategoryId"]!)"
        self.str_product_id = "\(self.get_full_product_details["productId"]!)"
        
        cell.txt_product_name.text = (self.get_full_product_details["productName"] as! String)
        cell.txt_regular_price.text = "\(self.get_full_product_details["price"]!)"
        cell.txt_special_price.text = "\(self.get_full_product_details["salePrice"]!)"
        cell.txt_color.text = (self.get_full_product_details["color"] as! String)
        cell.txt_condition.text = (self.get_full_product_details["conditions"] as! String)
        cell.txt_category.text = (self.get_full_product_details["categoryName"] as! String)
        cell.txt_sub_category.text = (self.get_full_product_details["subCategoryName"] as! String)
        cell.txt_quantity.text = "\(self.get_full_product_details["quantity"]!)"
        cell.txt_view.text = (self.get_full_product_details["description"] as! String)
        
        // image 1
        if (self.get_full_product_details["image_1"] as! String) != "" {
            self.arr_mut_save_images.add(self.get_full_product_details["image_1"] as! String)
        } else {
            self.arr_mut_save_images.add("0")
        }
        
        // image 2
        if (self.get_full_product_details["image_2"] as! String) != "" {
            self.arr_mut_save_images.add(self.get_full_product_details["image_2"] as! String)
        } else {
            self.arr_mut_save_images.add("0")
        }
        
        // image 3
        if (self.get_full_product_details["image_3"] as! String) != "" {
            self.arr_mut_save_images.add(self.get_full_product_details["image_3"] as! String)
        } else {
            self.arr_mut_save_images.add("0")
        }
        
        // image 4
        if (self.get_full_product_details["image_4"] as! String) != "" {
            self.arr_mut_save_images.add(self.get_full_product_details["image_4"] as! String)
        } else {
            self.arr_mut_save_images.add("0")
        }
        
        // image 5
        if (self.get_full_product_details["image_5"] as! String) != "" {
            self.arr_mut_save_images.add(self.get_full_product_details["image_5"] as! String)
        } else {
            self.arr_mut_save_images.add("0")
        }
        
        print(self.arr_mut_save_images as Any)
        
        cell.collectionView.dataSource = self
        cell.collectionView.delegate = self
        
        if let person = UserDefaults.standard.value(forKey: "key_saved_category") as? [String:Any] {
            // print(person as Any)
            
            self.str_category_id = "\(person["id"]!)"
            cell.txt_category.text = (person["name"] as! String)
            
            self.arr_sub_category = (person["SubCat"] as! Array<Any>) as NSArray
            
            if let person_2 = UserDefaults.standard.value(forKey: "key_saved_sub_category") as? [String:Any] {
            
                cell.txt_sub_category.text = (person_2["name"] as! String)
                
                self.str_sub_category_id = "\(person_2["id"]!)"
                
                // print(str_category_id as Any)
                // print(str_sub_category_id as Any)
                
                let defaults = UserDefaults.standard
                defaults.setValue(nil, forKey: "key_saved_category")
                defaults.setValue(nil, forKey: "key_saved_sub_category")
            }
            
        }
        
        cell.btn_category_click.addTarget(self, action: #selector(myTargetFunction), for: .touchUpInside)
        cell.btn_sub_category_click.addTarget(self, action: #selector(sub_myTargetFunction), for: .touchUpInside)
        
        cell.txt_special_price.addTarget(self, action: #selector(add_new_product.textFieldDidChange(_:)), for: .editingChanged)
        
        // cell.btn_add_product_images.addTarget(self, action: #selector(open_camera_gallery), for: .touchUpInside)
        
        cell.btn_save_and_continue.addTarget(self, action: #selector(validation_before_upload), for: .touchUpInside)
        
        cell.btn_category.addTarget(self, action: #selector(category_click_method), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        /*let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "browse_product_category_id")
        self.navigationController?.pushViewController(push, animated: true)*/
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1400
    }
        
}

class edit_manage_product_table_cell:UITableViewCell {
    
    @IBOutlet weak var txt_product_name:UITextField! {
        didSet {
            Utils.text_field_UI(text_field: txt_product_name)
         }
    }
    
    @IBOutlet weak var txt_regular_price:UITextField! {
        didSet {
            Utils.text_field_UI(text_field: txt_regular_price)
         }
    }
    
    @IBOutlet weak var txt_special_price:UITextField! {
        didSet {
            Utils.text_field_UI(text_field: txt_special_price)
         }
    }
    
    @IBOutlet weak var txt_color:UITextField! {
        didSet {
            Utils.text_field_UI(text_field: txt_color)
         }
    }
    
    @IBOutlet weak var txt_condition:UITextField! {
        didSet {
            Utils.text_field_UI(text_field: txt_condition)
         }
    }
    
    @IBOutlet weak var txt_category:UITextField! {
        didSet {
            Utils.text_field_UI(text_field: txt_category)
         }
    }
    
    @IBOutlet weak var txt_sub_category:UITextField! {
        didSet {
            Utils.text_field_UI(text_field: txt_sub_category)
         }
    }
    
    @IBOutlet weak var txt_quantity:UITextField! {
        didSet {
            Utils.text_field_UI(text_field: txt_quantity)
            txt_quantity.keyboardType = .numberPad
         }
    }
    
    @IBOutlet weak var txt_view:UITextView! {
        didSet {
            txt_view.layer.cornerRadius = 8
            txt_view.clipsToBounds = true
            txt_view.layer.borderColor = UIColor.lightGray.cgColor
            txt_view.layer.borderWidth = 0.08
         }
    }
    
    @IBOutlet weak var lbl_invalid_price_text:UILabel! {
        didSet {
            lbl_invalid_price_text.textColor = .black
            lbl_invalid_price_text.text = "Special price"
        }
        
    }
    
    @IBOutlet weak var btn_edit:UIButton! {
        didSet {
            btn_edit.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            btn_edit.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            btn_edit.layer.shadowOpacity = 1.0
            btn_edit.layer.shadowRadius = 15.0
            btn_edit.layer.masksToBounds = false
            btn_edit.layer.cornerRadius = 15
            btn_edit.backgroundColor = .white
            btn_edit.tintColor = .black
        }
    }
    
    @IBOutlet weak var btn_category_click:UIButton! {
        didSet {
            btn_category_click.setTitle("", for: .normal)
        }
    }
    
    @IBOutlet weak var btn_sub_category_click:UIButton! {
        didSet {
            btn_sub_category_click.setTitle("", for: .normal)
        }
    }
    
    // collection view
    @IBOutlet weak var collectionView:UICollectionView! {
        didSet {
            collectionView.backgroundColor = .clear
            // collectionView.dataSource = self
            // collectionView.delegate = self
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
            btn_save_and_continue.setTitle("Add product", for: .normal)
        }
    }
    
    @IBOutlet weak var btn_add_product_images:UIButton! {
        didSet {
            btn_add_product_images.backgroundColor = button_light
            btn_add_product_images.setTitle(" Add product images (5)", for: .normal)
            btn_add_product_images.layer.cornerRadius = 22
            btn_add_product_images.clipsToBounds = true
            
            btn_add_product_images.layer.borderColor = button_dark.cgColor
            btn_add_product_images.layer.borderWidth = 1
            
            btn_add_product_images.setImage(UIImage(systemName: "plus"), for: .normal)
        }
    }
    
    @IBOutlet weak var btn_category:UIButton! {
        didSet {
            btn_category.setTitle("", for: .normal)
        }
    }
    
}


class edit_manage_product_collection_cell: UICollectionViewCell {
    
    @IBOutlet weak var img_product_image:UIImageView! {
        didSet {
            img_product_image.layer.cornerRadius = 25
            img_product_image.clipsToBounds = true
            img_product_image.layer.borderWidth = 5
            img_product_image.layer.borderColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1).cgColor
            img_product_image.backgroundColor = .clear
        }
    }
    
    
    
}

