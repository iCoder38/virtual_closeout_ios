//
//  manage_products.swift
//  Virtual Closeout
//
//  Created by Apple on 09/06/22.

import UIKit
import Alamofire
import SDWebImage

class manage_products: UIViewController {
    
    var page : Int! = 1
    var loadMore : Int! = 1
    
    var arr_mut_list_of_all_products:NSMutableArray! = []
    
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
            lblNavigationTitle.text = "Manage products"
            lblNavigationTitle.textColor = .white
        }
    }
    
    // ***************************************************************** // nav
    
    @IBOutlet weak var btn_add:UIButton! {
        didSet {
            btn_add.tintColor = .white
            btn_add.isHidden = false
            btn_add.setImage(UIImage(systemName: "plus"), for: .normal)
        }
    }
    
    @IBOutlet weak var btn_search:UIButton! {
        didSet {
            
        }
    }
    
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
            NSAttributedString(string: "search seller here...", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
            
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
        
        self.manage_profile(btnBack)
        
        self.btn_add.addTarget(self, action: #selector(add_product_click_method), for: .touchUpInside)
        self.btn_search.addTarget(self, action: #selector(all_products_list_search_wb), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.arr_mut_list_of_all_products.removeAllObjects()
        self.list_of_all_products_WB(pageNumber: 1)
    }
    
    @objc func add_product_click_method() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "add_new_product_id")
        self.navigationController?.pushViewController(push, animated: true)
        
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
                    
                    self.list_of_all_products_WB(pageNumber: page)
                    
                }
            }
        }
    }
    
    @objc func list_of_all_products_WB(pageNumber:Int) {
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        if let person = UserDefaults.standard.value(forKey: key_user_default_value) as? [String:Any] {
            // let str:String = person["role"] as! String
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let params = all_products_list(action: "productlist",
                                           userId: String(myString),
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
                        
                        if ar.count == 0 {
                            
                            /*let alert = NewYorkAlertController(title: String("Alert"), message: String("No product found. Please add products."), style: .alert)
                             
                             let add_products = NewYorkButton(title: "add, product", style: .default) {
                             _ in
                             
                             let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "add_new_product_id")
                             self.navigationController?.pushViewController(push, animated: true)
                             
                             }
                             
                             let cancel = NewYorkButton(title: "dismiss", style: .cancel) {
                             _ in
                             
                             // self.back_click_method()
                             }
                             
                             add_products.setDynamicColor(.pink)
                             
                             alert.addButtons([add_products , cancel])
                             self.present(alert, animated: true)*/
                            
                        } else {
                            
                            self.arr_mut_list_of_all_products.addObjects(from: ar as! [Any])
                            
                            self.tablView.isHidden = false
                            self.tablView.delegate = self
                            self.tablView.dataSource = self
                            self.tablView.reloadData()
                            self.loadMore = 1
                            
                        }
                        
                        
                        
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
    
    @objc func all_products_list_search_wb() {
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        if let person = UserDefaults.standard.value(forKey: key_user_default_value) as? [String:Any] {
            // let str:String = person["role"] as! String
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let params = all_products_list_search_params(action: "productlist",
                                           userId: String(myString),
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
                        
                        if ar.count == 0 {
                            
                            /*let alert = NewYorkAlertController(title: String("Alert"), message: String("No product found. Please add products."), style: .alert)
                             
                             let add_products = NewYorkButton(title: "add, product", style: .default) {
                             _ in
                             
                             let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "add_new_product_id")
                             self.navigationController?.pushViewController(push, animated: true)
                             
                             }
                             
                             let cancel = NewYorkButton(title: "dismiss", style: .cancel) {
                             _ in
                             
                             // self.back_click_method()
                             }
                             
                             add_products.setDynamicColor(.pink)
                             
                             alert.addButtons([add_products , cancel])
                             self.present(alert, animated: true)*/
                            
                        } else {
                            
                            self.arr_mut_list_of_all_products.addObjects(from: ar as! [Any])
                            
                            self.tablView.isHidden = false
                            self.tablView.delegate = self
                            self.tablView.dataSource = self
                            self.tablView.reloadData()
                            self.loadMore = 1
                            
                        }
                        
                        
                        
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
    
    
    // MARK: - EDIT PRODUCT -
    @objc func edit_product_click_method(_ sender:UIButton) {
        let item = self.arr_mut_list_of_all_products[sender.tag] as? [String:Any]
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "edit_manage_product_id") as? edit_manage_product
        
        push!.get_full_product_details = item as NSDictionary?
        
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
}


//MARK:- TABLE VIEW -
extension manage_products: UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arr_mut_list_of_all_products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:manage_products_table_cell = tableView.dequeueReusableCell(withIdentifier: "manage_products_table_cell") as! manage_products_table_cell
        
        cell.backgroundColor = .clear
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        cell.accessoryType = .none
        
        let item = self.arr_mut_list_of_all_products[indexPath.row] as? [String:Any]
        
        cell.lbl_product_name.text = (item!["productName"] as! String)
        cell.lbl_color.text = (item!["color"] as! String)
        cell.lbl_price.text = "$\(item!["salePrice"]!)"
        
        cell.img_user_image.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
        cell.img_user_image.sd_setImage(with: URL(string: (item!["image_1"] as! String)), placeholderImage: UIImage(named: "logo"))
        
        cell.btn_edit.tag = indexPath.row
        cell.btn_edit.addTarget(self, action: #selector(edit_product_click_method), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        /*let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "browse_product_category_id")
        self.navigationController?.pushViewController(push, animated: true)*/
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
        
}

class manage_products_table_cell:UITableViewCell {
    
    @IBOutlet weak var img_user_image:UIImageView! {
        didSet {
            img_user_image.layer.cornerRadius = 8
            img_user_image.clipsToBounds = true
            img_user_image.backgroundColor = .systemBrown
        }
    }
    
    @IBOutlet weak var lbl_product_name:UILabel! {
        didSet {
            lbl_product_name.textColor = .black
        }
    }
    
    @IBOutlet weak var lbl_color:UILabel! {
        didSet {
            lbl_color.textColor = .black
        }
    }
    
    @IBOutlet weak var lbl_price:UILabel! {
        didSet {
            lbl_price.textColor = .black
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
    
}
