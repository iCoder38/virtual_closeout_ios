//
//  browse_product_category.swift
//  Virtual Closeout
//
//  Created by Apple on 07/06/22.
//

import UIKit
import Alamofire
import SDWebImage

class browse_product_category: UIViewController , UITextFieldDelegate {
    
    var dict_get_clicked_user_product:NSDictionary!
    
    var page : Int! = 1
    var loadMore : Int! = 1
    
    var ar_get_sub_category_list : NSArray!
    
     var arr_mut_subcategory:NSMutableArray! = []
    
    var str_product_name:String!
    
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
            lblNavigationTitle.text = "Browse sub products"
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
        
        self.btnBack.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        
          // print(self.dict_get_clicked_user_product as Any)
        
        self.lblNavigationTitle.text = (self.dict_get_clicked_user_product["name"] as! String)
        
        self.txt_search.delegate = self
        
        self.btn_search_2.addTarget(self, action: #selector(list_of_all_sub_category_WB), for: .touchUpInside)
        
        self.list_of_all_category()
        
    }

    @objc func list_of_all_category() {
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        let params = sub_category_list(action: "subcategory",
                                       categoryId: "\(self.dict_get_clicked_user_product["id"]!)")
        
        
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
                    
                    self.arr_mut_subcategory.addObjects(from: ar as! [Any])
                    
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        self.arr_mut_subcategory.removeAllObjects()
        self.list_of_all_sub_category_WB()
        
        return true
    }
    
    @objc func list_of_all_sub_category_WB() {
        self.arr_mut_subcategory.removeAllObjects()
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        let params = sub_category_list_search_params(action: "subcategory",
                                                     categoryId: "\(self.dict_get_clicked_user_product["id"]!)",
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
                    
                    self.arr_mut_subcategory.addObjects(from: ar as! [Any])
                    
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

//MARK:- TABLE VIEW -
extension browse_product_category: UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arr_mut_subcategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:browse_product_category_table_cell = tableView.dequeueReusableCell(withIdentifier: "browse_product_category_table_cell") as! browse_product_category_table_cell
        
        cell.backgroundColor = .clear
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        cell.accessoryType = .disclosureIndicator
        
        let item = self.arr_mut_subcategory[indexPath.row] as? [String:Any]
        // print(item as Any)
        
        cell.lbl_title.text = (item!["name"] as! String)
        cell.lbl_description.text = (item!["description"] as! String)
        
        cell.img_product_image.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.img_product_image.sd_setImage(with: URL(string: (item!["image"] as! String)), placeholderImage: UIImage(named: "logo"))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = self.arr_mut_subcategory[indexPath.row] as? [String:Any]
         //print(item as Any)
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "browse_product_images_id") as? browse_product_images
        
        push!.get_category_id = "\(self.dict_get_clicked_user_product["id"]!)"
        push!.get_sub_category_id = "\(item!["id"]!)"
        push!.str_sub_product_name = (item!["name"] as! String)
        
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
        
}

class browse_product_category_table_cell:UITableViewCell {
    
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
