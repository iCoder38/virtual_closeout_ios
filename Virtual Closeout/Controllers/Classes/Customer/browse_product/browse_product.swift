//
//  browse_product.swift
//  Virtual Closeout
//
//  Created by Apple on 07/06/22.
//

import UIKit
import Alamofire
import SDWebImage

class browse_product: UIViewController , UITextFieldDelegate {

    var page : Int! = 1
    var loadMore : Int! = 1
    
    var ar_save : NSArray!
    
    var arr_mut_category_subcategory:NSMutableArray! = []
    
    var filteredData: [String]!
    
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
            btnBack.setImage(UIImage(systemName: "list.dash"), for: .normal)
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "Products"
            lblNavigationTitle.textColor = .white
        }
    }

    // ***************************************************************** // nav
    
    @IBOutlet weak var btn_search_2:UIButton! {
        didSet {
            btn_search_2.tintColor = .lightGray
            btn_search_2.isHidden = false
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
            NSAttributedString(string: "search product here...", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
            
        }
    }
    
    @IBOutlet weak var btn_current_location:UIButton! {
        didSet {
            // btn_current_location.backgroundColor = .white
            // btn_current_location.layer.cornerRadius = 6
            // btn_current_location.clipsToBounds = true
            
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
        
        // self.btnBack.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        
        self.txt_search.delegate = self
        
        // self.manage_profile(self.btnBack)
        
        if let person = UserDefaults.standard.value(forKey: key_user_default_value) as? [String:Any] {
         
            if (person["role"] as! String) == "Seller" {
                
                self.btnBack.setImage(UIImage(systemName: "arrow.left"), for: .normal)
                self.btnBack.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
                
            } else {
                
                self.btnBack.setImage(UIImage(systemName: "list.dash"), for: .normal)
                
                let defaults = UserDefaults.standard
                defaults.setValue("", forKey: "keySetToBackOrMenu")
                defaults.setValue(nil, forKey: "keySetToBackOrMenu")
                
                self.view.endEditing(true)
                if revealViewController() != nil {
                    self.btnBack.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
                    revealViewController().rearViewRevealWidth = 300
                    self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
                }
                
            }
            
        }
        
        self.btn_search_2.addTarget(self, action: #selector(list_of_all_category_WB), for: .touchUpInside)
        
        self.list_of_all_category() 
        
    }
    
    // MARK: - LIST OF ALL CATEGORY -
    @objc func list_of_all_category() {
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        let params = category_list(action: "category")
                                   // pageNo: "")
        
        
        print(params as Any)
        
        AF.request(APPLICATION_BASE_URL,
                   method: .post,
                   parameters: params,
                   encoder: JSONParameterEncoder.default).responseJSON { [self] response in
            // debugPrint(response.result)
            
            switch response.result {
            case let .success(value):
                
                let JSON = value as! NSDictionary
                 // print(JSON as Any)
                
                var strSuccess : String!
                strSuccess = (JSON["status"]as Any as? String)?.lowercased()
                print(strSuccess as Any)
                if strSuccess == String("success") {
                    print("yes")
                    
                    ERProgressHud.sharedInstance.hide()
                    
                    self.ar_save = (JSON["data"] as! Array<Any>) as NSArray
                    
                    for indexx in 0..<self.ar_save.count {
                        
                        let item = self.ar_save[indexx] as? [String:Any]
                        
                        let custom_dict = ["id"     : "\(item!["id"]!)",
                                           "name"   : (item!["name"] as! String),
                                           "description": (item!["description"] as! String),
                                           "image"  : (item!["image"] as! String),
                                           "status" : "no"]
                        
                        self.arr_mut_category_subcategory.add(custom_dict)
                        
                    }
                    

                    let swiftArray: [String] = self.arr_mut_category_subcategory.compactMap { $0 as? String }
                    
                    self.filteredData = swiftArray
                    // print(filteredData as Any)
                    
                    let item = self.arr_mut_category_subcategory.mutableArrayValue(forKey: "name")
                    print(item)
                    
                    let filtered  = item.filter() {

                        return ($0 as AnyObject).contains("2.1")

                    }
                    print(filtered)
                    // let predicate = NSPredicate(format: "name BEGINSWITH [c] %@", "l")
                    // let filtered = NSArray(array:item).filtered(using: predicate)

                    print(filtered)
                    
                    self.tablView.isHidden = false
                    self.tablView.delegate = self
                    self.tablView.dataSource = self
                    self.tablView.reloadData()
                    self.loadMore = 1
                    
                    
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
        
        self.list_of_all_category_WB()
        
        return true
    }
    
    // MARK: - LIST OF CATEGORU SEARCH -
    @objc func list_of_all_category_WB() {
        
        self.arr_mut_category_subcategory.removeAllObjects()

        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        let params = category_list_search_params(action: "category",
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
                    
                    self.ar_save = (JSON["data"] as! Array<Any>) as NSArray
                    
                    for indexx in 0..<self.ar_save.count {
                        
                        let item = self.ar_save[indexx] as? [String:Any]
                        
                        let custom_dict = ["id"     : "\(item!["id"]!)",
                                           "name"   : (item!["name"] as! String),
                                           "description": (item!["description"] as! String),
                                           "image"  : (item!["image"] as! String),
                                           "status" : "no"]
                        
                        self.arr_mut_category_subcategory.add(custom_dict)
                        
                    }
                    
                    // self.arr_mut_category_subcategory.addObjects(from: ar as! [Any])
                    
                    self.tablView.isHidden = false
                    self.tablView.delegate = self
                    self.tablView.dataSource = self
                    self.tablView.reloadData()
                    self.loadMore = 1
                    
                    
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

//MARK:- TABLE VIEW -
extension browse_product: UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arr_mut_category_subcategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:browse_product_table_cell = tableView.dequeueReusableCell(withIdentifier: "browse_product_table_cell") as! browse_product_table_cell
        
        cell.backgroundColor = .clear
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        cell.accessoryType = .disclosureIndicator
        
        let item = self.arr_mut_category_subcategory[indexPath.row] as? [String:Any]
        
        cell.lbl_title.text = (item!["name"] as! String)
        cell.lbl_description.text = (item!["description"] as! String)
        
        cell.img_product_image.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.img_product_image.sd_setImage(with: URL(string: (item!["image"] as! String)), placeholderImage: UIImage(named: "logo"))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = self.ar_save[indexPath.row] as? [String:Any]
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "browse_product_category_id") as? browse_product_category
        push!.dict_get_clicked_user_product = item as NSDictionary?
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
        
}

class browse_product_table_cell:UITableViewCell {
    
    @IBOutlet weak var img_product_image:UIImageView!
    
    @IBOutlet weak var lbl_title:UILabel! {
        didSet {
            lbl_title.textColor = .black
        }
    }
    
    @IBOutlet weak var lbl_description:UILabel! {
        didSet {
            lbl_description.textColor = .black
        }
    }
    
}
