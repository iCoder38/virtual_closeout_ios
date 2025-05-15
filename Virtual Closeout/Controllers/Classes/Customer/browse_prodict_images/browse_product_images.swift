//
//  browse_product_images.swift
//  Virtual Closeout
//
//  Created by Apple on 07/06/22.
//

import UIKit
import Alamofire
import SDWebImage

class browse_product_images: UIViewController , UITextFieldDelegate {
    
    var page : Int! = 1
    var loadMore : Int! = 1
    
    var arr_sub_cat:NSArray!
    
    var get_category_id:String!
    var get_sub_category_id:String!
    
    var str_sub_product_name:String!
    var arr_mut_list_of_product_images:NSMutableArray! = []
    
    var str_seller_id_for_product:String!
    var str_which_product_details:String!
    
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
            lblNavigationTitle.text = "Image details"
            lblNavigationTitle.textColor = .white
        }
    }
    
    // ***************************************************************** // nav
    
    @IBOutlet weak var txt_search:UITextField! {
        didSet {
            txt_search.keyboardType = .default
            
            txt_search.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            txt_search.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            txt_search.layer.shadowOpacity = 1.0
            txt_search.layer.shadowRadius = 15.0
            txt_search.layer.masksToBounds = false
            txt_search.layer.cornerRadius = 6
            txt_search.backgroundColor = .white
            txt_search.setLeftPaddingPoints(20)
            
            txt_search.attributedPlaceholder =
            NSAttributedString(string: "search product here...", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
            
        }
    }
    
    @IBOutlet weak var btn_current_location:UIButton! {
        didSet {
            btn_current_location.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            btn_current_location.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            btn_current_location.layer.shadowOpacity = 1.0
            btn_current_location.layer.shadowRadius = 15.0
            btn_current_location.layer.masksToBounds = false
            btn_current_location.layer.cornerRadius = 6
            btn_current_location.backgroundColor = .white
            
        }
    }
    
    @IBOutlet weak var btn_refresh:UIButton! {
        didSet {
            btn_refresh.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var collectionView:UICollectionView! {
        didSet {
            // collectionView.dataSource = self
            // collectionView.delegate = self
        }
    }
    
    @IBOutlet weak var view_filter:UIView! {
        didSet {
            view_filter.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_filter.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            view_filter.layer.shadowOpacity = 1.0
            view_filter.layer.shadowRadius = 15.0
            view_filter.layer.masksToBounds = false
            view_filter.layer.cornerRadius = 15
            view_filter.backgroundColor = UIColor(red: 55.0/255.0, green: 96.0/255.0, blue: 180.0/255.0, alpha: 1)
        }
    }
    
    @IBOutlet weak var btn_price_low_to_high:UIButton! {
        didSet {
            btn_price_low_to_high.setTitle("", for: .normal)
            btn_price_low_to_high.backgroundColor = .white
            btn_price_low_to_high.layer.cornerRadius = 8
            btn_price_low_to_high.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var btn_filter_all:UIButton! {
        didSet {
            btn_filter_all.setTitle("", for: .normal)
            btn_filter_all.backgroundColor = .white
            btn_filter_all.layer.cornerRadius = 8
            btn_filter_all.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var btn_search:UIButton! {
        didSet {
            btn_search.tintColor = .lightGray
            btn_search.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.btnBack.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        self.btn_price_low_to_high.addTarget(self, action: #selector(price_low_high_click_method), for: .touchUpInside)
        self.btn_filter_all.addTarget(self, action: #selector(filter_click_method), for: .touchUpInside)
        
        self.btn_refresh.addTarget(self, action: #selector(refresh_click_method), for: .touchUpInside)
        
        if self.str_which_product_details == "yes_seller" {
            self.btn_search.addTarget(self, action: #selector(search_click_method_seller), for: .touchUpInside)
        } else {
            self.btn_search.addTarget(self, action: #selector(search_click_method), for: .touchUpInside)
        }
        
        
        // print(self.str_which_product_details as Any)
        
        if self.str_which_product_details == "yes_seller" {
            
            self.lblNavigationTitle.text = "Seller's products"
            self.get_seller_full_profile(page_number: 1)
            
        } else {
            
            self.lblNavigationTitle.text = String(self.str_sub_product_name)
            
            self.product_list_with_image(pageNumber: 1)
            
        }
        
        
    }
    
    @objc func refresh_click_method() {
        
        self.txt_search.text = ""
        self.arr_mut_list_of_product_images.removeAllObjects()
        
        if self.str_which_product_details == "yes_seller" {
            self.product_list_with_image_seller(pageNumber: 1)
        } else {
            self.product_list_with_image(pageNumber: 1)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let person = UserDefaults.standard.value(forKey: "key_filter_price") as? [String:Any] {
            
            print(person as Any)
            
            let defaults = UserDefaults.standard
            defaults.setValue(nil, forKey: "key_filter_price")
            
            if self.str_which_product_details == "yes_seller" {
                
                self.filter_max_min_price_seller_WB (pageNumber: 1,
                                             str_max_price: (person["min_price"] as! String),
                                             str_min_price: (person["max_price"] as! String),
                                             str_product_condition:(person["product_condition"] as! String))
                
            } else {
                self.filter_max_min_price_WB(pageNumber: 1,
                                             str_max_price: (person["min_price"] as! String),
                                             str_min_price: (person["max_price"] as! String),
                                             str_product_condition:(person["product_condition"] as! String))
            }
            
            
            
            
            
        }
        
        
        
    }
    
    
    
    @objc func search_click_method() {
        self.arr_mut_list_of_product_images.removeAllObjects()
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        let params = product_search_list_params(action: "productlist",
                                              categoryId: String(self.get_category_id),
                                              subcategoryId: String(self.get_sub_category_id),
                                              pageNo: 1,
                                                keyword: String(self.txt_search.text!))
        
        
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
                    
                    var ar : NSArray!
                    ar = (JSON["data"] as! Array<Any>) as NSArray
                    
                    self.arr_mut_list_of_product_images.addObjects(from: ar as! [Any])
                    
                    self.collectionView.delegate = self
                    self.collectionView.dataSource = self
                    self.collectionView.reloadData()
                    
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
    
    @objc func search_click_method_seller() {
        self.arr_mut_list_of_product_images.removeAllObjects()
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        let params = product_search_list_params(action: "productlist",
                                              categoryId: "",
                                              subcategoryId: "",
                                              pageNo: 1,
                                                keyword: String(self.txt_search.text!))
        
        
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
                    
                    var ar : NSArray!
                    ar = (JSON["data"] as! Array<Any>) as NSArray
                    
                    self.arr_mut_list_of_product_images.addObjects(from: ar as! [Any])
                    
                    self.collectionView.delegate = self
                    self.collectionView.dataSource = self
                    self.collectionView.reloadData()
                    
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
    
    
    @objc func product_list_with_image(pageNumber:Int) {
        
        //
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        let params = product_list_with_images(action: "productlist",
                                              categoryId: String(self.get_category_id),
                                              subcategoryId: String(self.get_sub_category_id),
                                              pageNo: pageNumber)
        
        
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
                    
                    var ar : NSArray!
                    ar = (JSON["data"] as! Array<Any>) as NSArray
                    
                    self.arr_mut_list_of_product_images.addObjects(from: ar as! [Any])
                    
                    self.collectionView.delegate = self
                    self.collectionView.dataSource = self
                    self.collectionView.reloadData()
                    
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
    
    @objc func product_list_with_image_seller(pageNumber:Int) {
        
        //
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        let params = product_list_with_images(action: "productlist",
                                              categoryId: "",
                                              subcategoryId: "",
                                              pageNo: pageNumber)
        
        
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
                    
                    var ar : NSArray!
                    ar = (JSON["data"] as! Array<Any>) as NSArray
                    
                    self.arr_mut_list_of_product_images.addObjects(from: ar as! [Any])
                    
                    self.collectionView.delegate = self
                    self.collectionView.dataSource = self
                    self.collectionView.reloadData()
                    
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
    
    
    
    @objc func filter_click_method() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "filter_id")
        self.navigationController?.pushViewController(push, animated: true)
        
    }
    
    @objc func price_low_high_click_method() {
        
        if self.str_which_product_details == "yes_seller" {
            
            let actionSheet = NewYorkAlertController(title: "Filter", message: nil, style: .actionSheet)
            
            let recent_first = NewYorkButton(title: "Recent first", style: .default) { _ in
                print("=====> RECENT FIRST")
                
                self.filter_product_price_high_low_seller_WB(pageNumber: 1,
                                                      str_filter_find_by: "Recent")
            }
            
            let closest_first = NewYorkButton(title: "Closest first", style: .default) { _ in
                print("=====> CLOSEST FIRST")
                
                self.filter_product_price_high_low_seller_WB(pageNumber: 1,
                                                      str_filter_find_by: "Closet")
                
            }
            
            let price_low_to_high = NewYorkButton(title: "Price: Low to High", style: .default) { _ in
                print("=====> LOW TO HIGH")
                
                self.filter_product_price_high_low_seller_WB(pageNumber: 1,
                                                      str_filter_find_by: "LH")
                
            }
            
            let price_high_to_low = NewYorkButton(title: "Price: High to Low", style: .default) { _ in
                print("=====> HIGH TO LOW")
                
                self.filter_product_price_high_low_seller_WB(pageNumber: 1,
                                                      str_filter_find_by: "HL")
                
            }
            
            let reset = NewYorkButton(title: "Reset", style: .destructive) { _ in
                print("gallery clicked done")
                
                self.arr_mut_list_of_product_images.removeAllObjects()
                self.product_list_with_image(pageNumber: 1)
                
            }
            
            let cancel = NewYorkButton(title: "Cancel", style: .cancel)
            
            actionSheet.addButtons([recent_first,
                                    closest_first,
                                    price_low_to_high,
                                    price_high_to_low,
                                    reset,
                                    cancel])
            
            present(actionSheet, animated: true)
            
        } else {
        
            let actionSheet = NewYorkAlertController(title: "Filter", message: nil, style: .actionSheet)
            
            let recent_first = NewYorkButton(title: "Recent first", style: .default) { _ in
                print("=====> RECENT FIRST")
                
                self.filter_product_price_high_low_WB(pageNumber: 1,
                                                      str_filter_find_by: "Recent")
            }
            
            let closest_first = NewYorkButton(title: "Closest first", style: .default) { _ in
                print("=====> CLOSEST FIRST")
                
                self.filter_product_price_high_low_WB(pageNumber: 1,
                                                      str_filter_find_by: "Closet")
                
            }
            
            let price_low_to_high = NewYorkButton(title: "Price: Low to High", style: .default) { _ in
                print("=====> LOW TO HIGH")
                
                self.filter_product_price_high_low_WB(pageNumber: 1,
                                                      str_filter_find_by: "LH")
                
            }
            
            let price_high_to_low = NewYorkButton(title: "Price: High to Low", style: .default) { _ in
                print("=====> HIGH TO LOW")
                
                self.filter_product_price_high_low_WB(pageNumber: 1,
                                                      str_filter_find_by: "HL")
                
            }
            
            let reset = NewYorkButton(title: "Reset", style: .destructive) { _ in
                print("gallery clicked done")
                
                self.arr_mut_list_of_product_images.removeAllObjects()
                self.product_list_with_image(pageNumber: 1)
                
            }
            
            let cancel = NewYorkButton(title: "Cancel", style: .cancel)
            
            actionSheet.addButtons([recent_first,
                                    closest_first,
                                    price_low_to_high,
                                    price_high_to_low,
                                    reset,
                                    cancel])
            
            present(actionSheet, animated: true)
            
        }
        
        
        
    }
    
    @objc func filter_product_price_high_low_WB(pageNumber:Int,
                                                str_filter_find_by:String) {
        
        self.arr_mut_list_of_product_images.removeAllObjects()
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        let params = filter_pricelow_high_params(action: "productlist",
                                                 categoryId: String(self.get_category_id),
                                                 subcategoryId: String(self.get_sub_category_id),
                                                 pageNo: pageNumber,
                                                 findby:String(str_filter_find_by))
        
        
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
                    
                    var ar : NSArray!
                    ar = (JSON["data"] as! Array<Any>) as NSArray
                    
                    self.arr_mut_list_of_product_images.addObjects(from: ar as! [Any])
                    
                    self.collectionView.delegate = self
                    self.collectionView.dataSource = self
                    self.collectionView.reloadData()
                    
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
    
    @objc func filter_product_price_high_low_seller_WB(pageNumber:Int,
                                                str_filter_find_by:String) {
        
        self.arr_mut_list_of_product_images.removeAllObjects()
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        let params = filter_pricelow_high_params(action: "productlist",
                                                 categoryId: "",
                                                 subcategoryId: "",
                                                 pageNo: pageNumber,
                                                 findby:String(str_filter_find_by))
        
        
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
                    
                    var ar : NSArray!
                    ar = (JSON["data"] as! Array<Any>) as NSArray
                    
                    self.arr_mut_list_of_product_images.addObjects(from: ar as! [Any])
                    
                    self.collectionView.delegate = self
                    self.collectionView.dataSource = self
                    self.collectionView.reloadData()
                    
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
    
    @objc func filter_max_min_price_WB(pageNumber:Int,
                                       str_max_price:String,
                                       str_min_price:String,
                                       str_product_condition:String) {
        
        self.arr_mut_list_of_product_images.removeAllObjects()
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        let params = filter_min_max_price_params(action: "productlist",
                                                 categoryId: String(self.get_category_id),
                                                 subcategoryId: String(self.get_sub_category_id),
                                                 pageNo: pageNumber,
                                                 maxPrice:String(str_max_price),
                                                 minPrice:String(str_min_price),
                                                 productConditions:String(str_product_condition))
        
        
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
                    
                    var ar : NSArray!
                    ar = (JSON["data"] as! Array<Any>) as NSArray
                    
                    self.arr_mut_list_of_product_images.addObjects(from: ar as! [Any])
                    
                    self.collectionView.delegate = self
                    self.collectionView.dataSource = self
                    self.collectionView.reloadData()
                    
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
    
    @objc func filter_max_min_price_seller_WB(pageNumber:Int,
                                       str_max_price:String,
                                       str_min_price:String,
                                       str_product_condition:String) {
        
        self.arr_mut_list_of_product_images.removeAllObjects()
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        let params = filter_min_max_price_params(action: "productlist",
                                                 categoryId: "",
                                                 subcategoryId: "",
                                                 pageNo: pageNumber,
                                                 maxPrice:String(str_max_price),
                                                 minPrice:String(str_min_price),
                                                 productConditions:String(str_product_condition))
        
        
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
                    
                    var ar : NSArray!
                    ar = (JSON["data"] as! Array<Any>) as NSArray
                    
                    self.arr_mut_list_of_product_images.addObjects(from: ar as! [Any])
                    
                    self.collectionView.delegate = self
                    self.collectionView.dataSource = self
                    self.collectionView.reloadData()
                    
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
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == self.collectionView {
            let isReachingEnd = scrollView.contentOffset.y >= 0
            && scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)
            if(isReachingEnd) {
                if(loadMore == 1) {
                    loadMore = 0
                    page += 1
                    print(page as Any)
                    
                    if self.str_which_product_details == "yes_seller" {
                        
                        self.get_seller_full_profile(page_number: page)
                        
                    } else {
                        
                        self.product_list_with_image(pageNumber: page)
                        
                    }
                    
                    
                }
            }
        }
    }
    
    @objc func get_seller_full_profile(page_number:Int) {
        // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "please wait...")
            
        self.view.endEditing(true)
             
            let params = seller_profile_params(action: "productlist",
                                               userId: String(self.str_seller_id_for_product),
                                               pageNo: page_number)
            
            print(params)
            
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
                            strSuccess = JSON["status"]as Any as? String
                            
                            // var strSuccess2 : String!
                            // strSuccess2 = JSON["msg"]as Any as? String
                            
                            if strSuccess == String("success") {
                                print("yes")
                                 ERProgressHud.sharedInstance.hide()
                               
                                
                                var ar : NSArray!
                                ar = (JSON["data"] as! Array<Any>) as NSArray
                                self.arr_mut_list_of_product_images.addObjects(from: ar as! [Any])
//
                                self.collectionView.delegate = self
                                self.collectionView.dataSource = self
                                self.collectionView.reloadData()
                                self.loadMore = 1
                                
                            } else {
                                print("no")
                                ERProgressHud.sharedInstance.hide()
                                
                                var strSuccess2 : String!
                                strSuccess2 = JSON["msg"]as Any as? String
                                
                                Utils.showAlert(alerttitle: String(strSuccess), alertmessage: String(strSuccess2), ButtonTitle: "Ok", viewController: self)
                                
                            }
                            
                        case let .failure(error):
                            print(error)
                            ERProgressHud.sharedInstance.hide()
                            
                            // Utils.showAlert(alerttitle: SERVER_ISSUE_TITLE, alertmessage: SERVER_ISSUE_MESSAGE, ButtonTitle: "Ok", viewController: self)
                        }
                }
            
            
    }
    
}

//MARK:- COLLECTION VIEW -
extension browse_product_images: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.arr_mut_list_of_product_images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "browse_product_images_collection_cell", for: indexPath as IndexPath) as! browse_product_images_collection_cell
        
        let item = self.arr_mut_list_of_product_images[indexPath.row] as? [String:Any]
        cell.img_product_image.backgroundColor = .white
        
        cell.lbl_product_name.text = (item!["productName"] as! String)
        cell.lbl_product_price.text = "$\(item!["salePrice"]!)"
        
        /*let fv = (item!["salePrice"]!)
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
         cell.lbl_product_price.text = formatter.string(from: fv as! NSNumber)*/
        // resultFV.text = formatter.stringFromNumber(fv)
        
        /*let bigNumber = Double("\(item!["salePrice"]!)")
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        let formattedNumber = numberFormatter.string(from: bigNumber! as NSNumber)
        // print(formattedNumber)
        cell.lbl_product_price.text = "\(formattedNumber!)"*/
        
        cell.img_product_image.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        cell.img_product_image.sd_setImage(with: URL(string: (item!["image_1"] as! String)), placeholderImage: UIImage(named: "logo"))
        
        cell.backgroundColor  = .clear
        
        self.txt_search.delegate = self
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var sizes: CGSize
        let result = UIScreen.main.bounds.size
        NSLog("%f",result.height)
        
        sizes = CGSize(width: 120, height: 180)
        
        return sizes
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        let result = UIScreen.main.bounds.size
        if result.height == 812 {
            return 4
        } else {
            return 10
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
                        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        let result = UIScreen.main.bounds.size
        if result.height == 812 {
            return 4
        } else {
            return 10
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item = self.arr_mut_list_of_product_images[indexPath.row] as? [String:Any]
        print(item as Any)
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "product_full_details_id") as? product_full_details
        
        push!.get_product_id = "\(item!["productId"]!)"
        
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        
        
        let result = UIScreen.main.bounds.size
        if result.height == 844 {
            return UIEdgeInsets(top: 10, left: 4, bottom: 10, right: 4)
        } else if result.height == 812 {
            return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        } else {
            return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
        
        
        
    }
    
}

class browse_product_images_collection_cell: UICollectionViewCell {
    
    @IBOutlet weak var img_product_image:UIImageView! {
        didSet {
            img_product_image.layer.cornerRadius = 25
            img_product_image.clipsToBounds = true
            img_product_image.layer.borderWidth = 5
            img_product_image.layer.borderColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1).cgColor
        }
    }
    
    @IBOutlet weak var lbl_product_name:UILabel! {
        didSet {
            lbl_product_name.textColor = .black
        }
    }
    
    @IBOutlet weak var lbl_product_price:UILabel! {
        didSet {
            lbl_product_price.textColor = .black
        }
    }
    
}
