//
//  only_sub_category.swift
//  Virtual Closeout
//
//  Created by Apple on 13/06/22.
//

import UIKit
import Alamofire
import SDWebImage

class only_sub_category: UIViewController {
    
    var page : Int! = 1
    var loadMore : Int! = 1
    
    var ar_get_sub_category_list : NSArray!
    
     var arr_mut_subcategory:NSMutableArray! = []
    
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
            lblNavigationTitle.text = "Sub-category"
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
        
        print(self.ar_get_sub_category_list as Any)
        
        // self.arr_mut_subcategory.addObjects(from: self.ar_get_sub_category_list as! [Any])
        // self.list_of_all_category()
        
        for indexx in 0..<self.ar_get_sub_category_list.count {
            
            let item = self.ar_get_sub_category_list[indexx] as? [String:Any]
            
            let custom_dict = ["id"     : "\(item!["id"]!)",
                               "name"   : (item!["name"] as! String),
                               "description": (item!["description"] as! String),
                               "image"  : (item!["image"] as! String),
                               "status" : "no"]
            
            self.arr_mut_subcategory.add(custom_dict)
            
        }
        
    }
    
}


//MARK:- TABLE VIEW -
extension only_sub_category: UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arr_mut_subcategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:only_sub_category_table_cell = tableView.dequeueReusableCell(withIdentifier: "only_sub_category_table_cell") as! only_sub_category_table_cell
        
        cell.backgroundColor = .clear
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        let item = self.arr_mut_subcategory[indexPath.row] as? [String:Any]
        
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
        
        let item = self.arr_mut_subcategory[indexPath.row] as? [String:Any]
        
        self.arr_mut_subcategory.removeAllObjects()
        
        for indexx in 0..<self.ar_get_sub_category_list.count {
            
            let item = self.ar_get_sub_category_list[indexx] as? [String:Any]
            
            let custom_dict = ["id"     : "\(item!["id"]!)",
                               "name"   : (item!["name"] as! String),
                               "description":(item!["description"] as! String),
                               "image"  : (item!["image"] as! String),
                               "status" : "no"]
            
            self.arr_mut_subcategory.add(custom_dict)
            
        }
        
        
        
        if (item!["status"] as! String) == "no" {
            
            self.arr_mut_subcategory.removeObject(at: indexPath.row)
            
            let custom_dict = ["id"     : "\(item!["id"]!)",
                               "name"   : (item!["name"] as! String),
                               "description":(item!["description"] as! String),
                               "image"  : (item!["image"] as! String),
                               "status" : "yes"]
            
            self.arr_mut_subcategory.insert(custom_dict, at: indexPath.row)
            
            let defaults = UserDefaults.standard
            defaults.setValue(item, forKey: "key_saved_sub_category")
            
        }
        
        self.tablView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
        
}

class only_sub_category_table_cell:UITableViewCell {
    
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

