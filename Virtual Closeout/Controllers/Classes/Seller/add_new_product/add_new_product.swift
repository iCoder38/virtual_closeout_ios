//
//  add_new_product.swift
//  Virtual Closeout
//
//  Created by Apple on 10/06/22.
//

import UIKit
import Alamofire
import SDWebImage

import OpalImagePicker
import BSImagePicker
import Photos

class add_new_product: UIViewController , UITextFieldDelegate , OpalImagePickerControllerDelegate , UINavigationControllerDelegate, UIImagePickerControllerDelegate , UITextViewDelegate {
    
    var arr_mut_add_new_product:NSMutableArray! = []
    var arr_sub_category:NSArray!
    
    var page : Int! = 1
    var loadMore : Int! = 1
    
    // var arr_mut_list_of_all_products:NSMutableArray! = []
    
    var str_category_id:String! = ""
    var str_sub_category_id:String! = ""
    
    var img_data : Data!
    var img_Str : String!
    
    var arrImages : NSMutableArray! = []
    
    var arrImagesThumbnail : NSMutableArray! = []
    var data:Data!
    var arrTest : NSMutableArray! = []
    
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
            tablView.delegate = self
            tablView.dataSource = self
            tablView.backgroundColor = .clear
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.btnBack.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        
        // self.list_of_all_category(pageNumber: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.tablView.reloadData()
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        /*self.arr_mut_add_new_product.removeAllObjects()
        
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
     */
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
        
        let imagePicker = OpalImagePickerController()
        imagePicker.imagePickerDelegate = self
        imagePicker.maximumSelectionsAllowed = 5
        imagePicker.allowedMediaTypes = Set([PHAssetMediaType.image])
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerDidCancel(_ picker: OpalImagePickerController) {
        //Cancel action?
    }
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingAssets assets: [PHAsset]) {
        
        // print("Selected: \(assets)")
        
        // self.imgProfile.image = self.getAssetThumbnail(asset: assets[0])
        
        // print(assets.count)
        
        // self.arrImagesThumbnail.add(self.getAssetThumbnail(asset: assets[0]))
        
        // for uiimage view
        // self.imgFeed.image = self.getAssetThumbnail(asset: assets[0])
        
        // for button
        // self.imgFeed.setImage(self.getAssetThumbnail(asset: assets[0]), for: .normal)
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! add_new_product_table_cell
        self.arrTest.removeAllObjects()
        
        for i in 0..<assets.count {
            
            self.arrImages.add(self.getAssetThumbnail(asset: assets[i]))
            print(self.arrImages as Any)
            
            let image = self.getAssetThumbnail(asset: assets[i])
            print(image as Any)
            
            self.data = image.jpegData(compressionQuality: 1.0)
            
            self.arrTest.add(self.data as Any) // show on collection
            
        }
        
        // print(self.arrTest as Any)
        // print(self.arrTest.count)
        
        //Dismiss Controller
        self.presentedViewController?.dismiss(animated: true, completion: nil)
        
        cell.collectionView.reloadData()
        
        
        // let indexPath_1 = IndexPath.init(row: self.arrTest.count, section: 0)
        // let cell_1 = cell.collectionView.cellForItem(at: indexPath_1) as! add_new_product_collection_cell

         // cell.img.image = self.getAssetThumbnail(asset: assets[0])
    }
    
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 500, height: 500), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
    
    @objc func validation_before_upload() {
        
        if self.arrTest.count == 0 {
            
            let alert = NewYorkAlertController(title: "Alert", message: String("Please select atleast one product image."), style: .alert)
            let cancel = NewYorkButton(title: "Ok", style: .cancel)
            alert.addButtons([cancel])
            self.present(alert, animated: true)
            
        } else {
            
            self.add_product_with_images()
        }
        
    }
    
    @objc func add_product_with_images() {
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! add_new_product_table_cell
          
            if (cell.txt_special_price.text!) >= cell.txt_regular_price.text! {
                
                print("in-valid price")
                cell.lbl_invalid_price_text.text = "Special price (should be less then regular price)"
                cell.lbl_invalid_price_text.textColor = .systemRed
                cell.txt_special_price.layer.borderColor = UIColor.systemRed.cgColor
                cell.txt_special_price.layer.borderWidth = 4
                
                let alert = NewYorkAlertController(title: "Alert", message: String("Special price (should be less then regular price)"), style: .alert)
                
                let cancel = NewYorkButton(title: "Ok", style: .cancel)
                alert.addButtons([cancel])
                
                self.present(alert, animated: true)
                
            } else {
                
                print("valid price")
                cell.lbl_invalid_price_text.text = "Special price"
                cell.lbl_invalid_price_text.textColor = .black
                cell.txt_special_price.layer.borderColor = button_dark.cgColor
                cell.txt_special_price.layer.borderWidth = 1
                
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
                
                for i in 0..<self.arrTest.count {
                    print("\("image_")"+"\(i+1)")
                    
                    let image : UIImage = UIImage(data: self.arrTest![i] as! Data)!
                    
                    multiPart.append((image ).jpegData(compressionQuality: 0.5)!, withName: "\("image_")"+"\(i+1)", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/png")
                    
                }
                
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
                            
                            self.arrTest.removeAllObjects()
                            ERProgressHud.sharedInstance.hide()
                            
                            // self.show_image_wb(str_show_indicator: "no")
                            
                            
                            var strSuccess2 : String!
                            strSuccess2 = dictionary["msg"]as Any as? String

                            
                            let alert = NewYorkAlertController(title: dictionary["status"]as Any as? String, message: String(strSuccess2), style: .alert)
                            
                            let cancel = NewYorkButton(title: "Ok", style: .cancel) {
                                _ in
                                self.back_click_method()
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
                        
                        if let err = data.response {
                            print(err)
                            return
                        }
                        
                        break
                        
                    }
           
                })
        }}
    }
    
    // MARK: - CATEGORY CLICK -
    @objc func category_click_method() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! add_new_product_table_cell
        
        let dummyList = ["New", "Open box", "Reconditioned"]
        RPicker.selectOption(title: "Select", cancelText: "Cancel", dataArray: dummyList, selectedIndex: 0) {[] (selctedText, atIndex) in
            // TODO: Your implementation for selection
            // self?.outputLabel.text = selctedText + " selcted at \(atIndex)"
            cell.txt_condition.text = selctedText
        }
        
    }
    
}

//MARK:- COLLECTION VIEW -
extension add_new_product: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.arrTest.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "add_new_product_collection_cell", for: indexPath as IndexPath) as! add_new_product_collection_cell
        
        cell.img_product_image.backgroundColor = .clear
        
        let image : UIImage = UIImage(data: self.arrTest[indexPath.item] as! Data)!
        // print(image as Any)
        
        cell.img_product_image.image = image
        
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
        
        /*if result.height == 844 {
         
         print("i am iPhone 12")
         sizes = CGSize(width: 116, height: 130)
         } else if result.height == 812 {
         
         print("i am iPhone 12 mini")
         sizes = CGSize(width: 110, height: 130)
         } else {
         
         sizes = CGSize(width: 120, height: 130)
         }*/
        
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
        
        /*let result = UIScreen.main.bounds.size
         if result.height == 667.000000 { // 8
         return 2
         } else if result.height == 812.000000 { // 11 pro
         return 4
         } else {
         return 10
         }*/
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "product_full_details_id")
        self.navigationController?.pushViewController(push, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
}

//MARK:- TABLE VIEW -
extension add_new_product: UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:add_new_product_table_cell = tableView.dequeueReusableCell(withIdentifier: "add_new_product_table_cell") as! add_new_product_table_cell
        
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
        
        cell.btn_add_product_images.addTarget(self, action: #selector(open_camera_gallery), for: .touchUpInside)
        
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

class add_new_product_table_cell:UITableViewCell {
    
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
    
    @IBOutlet weak var btn_category:UIButton! {
        didSet {
            btn_category.setTitle("", for: .normal)
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
    
}


class add_new_product_collection_cell: UICollectionViewCell {
    
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
