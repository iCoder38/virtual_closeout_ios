//
//  category_sub_category.swift
//  Virtual Closeout
//
//  Created by Apple on 13/06/22.
//

import UIKit
import Alamofire
import SDWebImage

class category_sub_category: UIViewController {
    
    var page : Int! = 1
    var loadMore : Int! = 1
    
    var ar_save : NSArray!
    
    var arr_mut_category_subcategory:NSMutableArray! = []
    
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
            lblNavigationTitle.text = "Category"
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
            NSAttributedString(string: "search category here...", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.btnBack.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        
        self.list_of_all_category()
    }
    
    /*func scrollViewDidScroll(_ scrollView: UIScrollView) {
                
        if scrollView == self.tablView {
            let isReachingEnd = scrollView.contentOffset.y >= 0
                && scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)
            if(isReachingEnd) {
                if(loadMore == 1) {
                    loadMore = 0
                    page += 1
                    print(page as Any)
                    
                    self.list_of_all_category(pageNumber: page)
                    
                }
            }
        }
    }*/
    
    @objc func list_of_all_category() {
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        let params = category_list(action: "category")
                                   // pageNo: "")
        
        
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
extension category_sub_category: UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arr_mut_category_subcategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:category_sub_category_table_cell = tableView.dequeueReusableCell(withIdentifier: "category_sub_category_table_cell") as! category_sub_category_table_cell
        
        cell.backgroundColor = .clear
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        let item = self.arr_mut_category_subcategory[indexPath.row] as? [String:Any]
        
        cell.lbl_product_name.text = (item!["name"] as! String)
        cell.lbl_description.text = (item!["description"] as! String)
        
        cell.img_product_image.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.img_product_image.sd_setImage(with: URL(string: (item!["image"] as! String)), placeholderImage: UIImage(named: "logo"))
        
        if (item!["status"] as! String) == "yes" {
            cell.btn_check_mark.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        } else {
            cell.btn_check_mark.setImage(UIImage(systemName: ""), for: .normal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let defaults = UserDefaults.standard
        defaults.setValue(nil, forKey: "key_saved_category")
        
        let item = self.arr_mut_category_subcategory[indexPath.row] as? [String:Any]
        let item_1 = self.ar_save[indexPath.row] as? [String:Any]
        // print(item_1 as Any)
        
        self.arr_mut_category_subcategory.removeAllObjects()
        
        for indexx in 0..<self.ar_save.count {
            
            let item = self.ar_save[indexx] as? [String:Any]
            
            let custom_dict = ["id"     : "\(item!["id"]!)",
                               "name"   : (item!["name"] as! String),
                               "description":(item!["description"] as! String),
                               "image"  : (item!["image"] as! String),
                               "status" : "no"]
            
            self.arr_mut_category_subcategory.add(custom_dict)
            
        }
        
        
        
        if (item!["status"] as! String) == "no" {
            
            self.arr_mut_category_subcategory.removeObject(at: indexPath.row)
            
            let custom_dict = ["id"     : "\(item!["id"]!)",
                               "name"   : (item!["name"] as! String),
                               "description":(item!["description"] as! String),
                               "image"  : (item!["image"] as! String),
                               "status" : "yes"]
            
            self.arr_mut_category_subcategory.insert(custom_dict, at: indexPath.row)
            
            let defaults = UserDefaults.standard
            defaults.setValue(item_1, forKey: "key_saved_category")
            
        }
        
        
        
        self.tablView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
        
}

class category_sub_category_table_cell:UITableViewCell {
    
    @IBOutlet weak var img_product_image:UIImageView!
    
    @IBOutlet weak var lbl_product_name:UILabel! {
        didSet {
            lbl_product_name.textColor = .black
        }
    }
    
    @IBOutlet weak var lbl_description:UILabel! {
        didSet {
            lbl_description.textColor = .black
        }
    }
    
    @IBOutlet weak var btn_check_mark:UIButton! {
        didSet {
            btn_check_mark.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        }
    }
    
}

