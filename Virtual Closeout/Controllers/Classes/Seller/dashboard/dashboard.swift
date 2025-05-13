//
//  dashboard.swift
//  Virtual Closeout
//
//  Created by Apple on 09/06/22.
//

import UIKit
import SDWebImage

class dashboard: UIViewController {

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
            lblNavigationTitle.text = "Dashboard"
            lblNavigationTitle.textColor = .white
        }
    }

    // ***************************************************************** // nav
    
    @IBOutlet weak var view_bottom:UIView! {
        didSet {
            
        }
    }
    
    @IBOutlet weak var btn_manage_orders:UIButton! {
        didSet {
            btn_manage_orders.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            btn_manage_orders.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            btn_manage_orders.layer.shadowOpacity = 1.0
            btn_manage_orders.layer.shadowRadius = 15.0
            btn_manage_orders.layer.masksToBounds = false
            btn_manage_orders.layer.cornerRadius = 8
            btn_manage_orders.setTitleColor(.black, for: .normal)
            btn_manage_orders.setTitle("All products", for: .normal)
            btn_manage_orders.backgroundColor = UIColor.init(red: 245.0/255.0, green: 214.0/255.0, blue: 50.0/255.0, alpha: 1)
        }
    }
    
    @IBOutlet weak var btn_manage_products:UIButton! {
        didSet {
            btn_manage_products.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            btn_manage_products.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            btn_manage_products.layer.shadowOpacity = 1.0
            btn_manage_products.layer.shadowRadius = 15.0
            btn_manage_products.layer.masksToBounds = false
            btn_manage_products.layer.cornerRadius = 8
            btn_manage_products.setTitleColor(.black, for: .normal)
            btn_manage_products.setTitle("Manage products", for: .normal)
            btn_manage_products.backgroundColor = UIColor.init(red: 245.0/255.0, green: 214.0/255.0, blue: 50.0/255.0, alpha: 1)
        }
    }
    
    @IBOutlet weak var img_profile_picture:UIImageView!
    
    @IBOutlet weak var lbl_user_name:UILabel! {
        didSet {
            lbl_user_name.textColor = .black
        }
    }
    
    @IBOutlet weak var lbl_address:UILabel! {
        didSet {
            lbl_address.textColor = .black
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.setNavigationBarHidden(true, animated: true)
 
        self.btn_manage_products.addTarget(self, action: #selector(manage_products_click_method), for: .touchUpInside)
        
        self.view_bottom.backgroundColor = UIColor.init(red: 64.0/255.0, green: 114.0/255.0, blue: 216.0/255.0, alpha: 1)
        self.view_bottom.roundCorners(corners: [.topLeft, .topRight], radius: 100)
        
        self.btn_manage_orders.addTarget(self, action: #selector(manage_order_click_method), for: .touchUpInside)
        
        // side bar menu
        // self.manage_profile(self.btnBack)
        
        self.get_login_user_data()
    }
    
    @objc func get_login_user_data() {
        
        if let person = UserDefaults.standard.value(forKey: key_user_default_value) as? [String:Any] {
            
            if (person["role"] as! String) == "Seller" {
                
                self.view.endEditing(true)
                if revealViewController() != nil {
                    self.btnBack.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
                    revealViewController().rearViewRevealWidth = 300
                    self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
                }
                
                self.img_profile_picture.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                self.img_profile_picture.sd_setImage(with: URL(string: (person["image"] as! String)), placeholderImage: UIImage(named: "logo"))
                
                self.lbl_user_name.text = (person["fullName"] as! String)
                self.lbl_user_name.textColor = .white
                
                self.lbl_address.text = (person["address"] as! String)+", "+(person["city"] as! String)+" - "+(person["state"] as! String)+" - "+(person["zipCode"] as! String)
                self.lbl_address.textColor = .white
                
            } else {
            
                self.img_profile_picture.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                self.img_profile_picture.sd_setImage(with: URL(string: (person["image"] as! String)), placeholderImage: UIImage(named: "logo"))
                
                self.lbl_user_name.text = (person["fullName"] as! String)
                self.lbl_user_name.textColor = .white
                
                self.lbl_address.text = (person["address"] as! String)+", "+(person["city"] as! String)+" - "+(person["state"] as! String)+" - "+(person["zipCode"] as! String)
                self.lbl_address.textColor = .white
                
            }
            
            
            
        }
        
    }

    @objc func manage_products_click_method() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "manage_products_id")
        self.navigationController?.pushViewController(push, animated: true)
        
    }
    
    @objc func manage_order_click_method() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "browse_product_id")
        self.navigationController?.pushViewController(push, animated: true)
        
    }
    
}
