//
//  MenuControllerVC.swift
//  SidebarMenu
//
//  Created by Apple  on 16/10/19.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class MenuControllerVC: UIViewController {
    
    
    
    let cellReuseIdentifier = "menuControllerVCTableCell"
    
    var bgImage: UIImageView?
    
    var roleIs:String!
    
    @IBOutlet weak var navigationBar:UIView!{
        didSet{
            navigationBar.backgroundColor = navigation_color
        }
    }
    
    @IBOutlet weak var viewUnderNavigation:UIView! {
        didSet {
            
            viewUnderNavigation.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "DASHBOARD"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var imgSidebarMenuImage:UIImageView! {
        didSet {
            
            //imgSidebarMenuImage.layer.borderWidth = 5.0
            //imgSidebarMenuImage.layer.borderColor = UIColor.white.cgColor
            imgSidebarMenuImage.image = UIImage(named: "logo")
            
            imgSidebarMenuImage.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            imgSidebarMenuImage.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            imgSidebarMenuImage.layer.shadowOpacity = 1.0
            imgSidebarMenuImage.layer.shadowRadius = 15.0
            imgSidebarMenuImage.layer.masksToBounds = false
            imgSidebarMenuImage.layer.cornerRadius = 15
            imgSidebarMenuImage.backgroundColor = .white
            imgSidebarMenuImage.clipsToBounds = false
            
        }
    }
    
    
    // customer
    var arrCustomerTitle = ["Browse product",
                            "Edit profile",
                            "Order history",
                            "Offered price",
                            "Wishlist",
                            "Shopping cart",
                            "Review & Rating",
//                            "Address",
                            "Change password",
                            "Help",
                            "Logout"]
    
    // customer_image
    var arrCustomerImage = ["house",
                            "pencil",
                            "newspaper",
                            "pencil",
                            "heart",
                            "cart",
                            "star",
                            "lock",
                            "info",
                            "iphone.and.arrow.right.outward"]
    
    // seller
    var seller_title = ["Dashboard",
                        "Edit Profile",
                        "Business profile",
                        "Payment information",
                         "Offered price",
                        "Add new product",
                        "Order history" ,
                        "Earnings",
                        "Cashout",
                         "Buy product",
                        "Wishlist",
                        "Review & Rating",
                        "Change Password",
                        "Help",
                        "Logout"]
    
    var seller_title_image = ["house" ,
                              "pencil" ,
                              "building" ,
                              "creditcard" ,
                              "pencil" ,
                              "plus" ,
                              "newspaper" ,
                              "house" ,
                              "house" ,
                              "house" ,
                              "heart" ,
                              "star" ,
                              "lock" ,
                              "info" ,
                              "iphone.and.arrow.right.outward" ,
                         ]
    
    @IBOutlet weak var lblUserName:UILabel! {
        didSet{
            lblUserName.text = "Dance Club"
            lblUserName.textColor = .black
            
        }
    }
    
    
    @IBOutlet weak var imgClub:UIImageView! {
        didSet {
            imgClub.clipsToBounds = true
            imgClub.layer.cornerRadius = 10.0
            imgClub.layer.borderWidth = 5
            imgClub.layer.borderColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1).cgColor
        }
        
    }
    
    
    @IBOutlet weak var lblPhoneNumber:UILabel! {
        didSet {
            lblPhoneNumber.textColor = .white
            //lblPhoneNumber.text = "1800-4267-3923"
            
            lblPhoneNumber.isHidden = true
        }
    }
    
    @IBOutlet var btnLocation:UIButton!{
        didSet{
            btnLocation.tintColor = .white
        }
        
    }
    
    @IBOutlet var menuButton:UIButton!
    
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            tbleView.delegate = self
            tbleView.dataSource = self
            tbleView.tableFooterView = UIView.init()
            tbleView.backgroundColor = navigation_color
            // tbleView.separatorInset = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 50)
            tbleView.separatorColor = .systemGray6
        }
    }
    
    @IBOutlet weak var lblMainTitle:UILabel!
    @IBOutlet weak var lblAddress:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideBarMenuClick()
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        self.tbleView.separatorColor = .lightGray
        
        self.view.backgroundColor = .white
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        if let person = UserDefaults.standard.value(forKey: key_user_default_value) as? [String:Any] {
            
            if person["role"] as! String == "Seller" {
                
                print(person as Any)
                
                self.lblUserName.text = (person["fullName"] as! String)
                
                self.imgSidebarMenuImage.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
                self.imgSidebarMenuImage.sd_setImage(with: URL(string: (person["image"] as! String)), placeholderImage: UIImage(named: "logo"))
                
            }
            
            else {
                
                print(person as Any)
                
                self.lblUserName.text = (person["fullName"] as! String)
                // self.lblAddress.text = (person["address"] as! String)
                // self.btnLocation.setTitle((person["address"] as! String), for: .normal)
                
                self.imgSidebarMenuImage.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
                self.imgSidebarMenuImage.sd_setImage(with: URL(string: (person["image"] as! String)), placeholderImage: UIImage(named: "logo"))
                
            }
            
        }
        
    }
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func sideBarMenuClick() {
        
        if revealViewController() != nil {
            menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

    @objc func logout_my_app_WB() {
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        if let person = UserDefaults.standard.value(forKey: key_user_default_value) as? [String:Any] {
            // let str:String = person["role"] as! String
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let params = Virtual_Closeout.logout_my_app(action: "logout",
                                       userId: String(myString))
            
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
                        
                        self.yesLogout()
                        
                    } else {
                        
                        print("no")
                        ERProgressHud.sharedInstance.hide()
                        
                        var strSuccess2 : String!
                        strSuccess2 = JSON["msg"]as Any as? String
                        
                        let alert = UIAlertController(title: String(strSuccess).uppercased(), message: String(strSuccess2), preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        
                        self.present(alert, animated: true)
                        
                    }
                    
                case let .failure(error):
                    print(error)
                    ERProgressHud.sharedInstance.hide()
                    
                    // Utils.showAlert(alerttitle: SERVER_ISSUE_TITLE, alertmessage: SERVER_ISSUE_MESSAGE, ButtonTitle: "Ok", viewController: self)
                }
            }
        }
    }
    
    @objc func yesLogout() {
        
        UserDefaults.standard.set("", forKey: key_user_default_value)
        UserDefaults.standard.set(nil, forKey: key_user_default_value)
        
        UserDefaults.standard.set("", forKey: "keySetToBackOrMenu")
        UserDefaults.standard.set(nil, forKey: "keySetToBackOrMenu")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
        self.view.window?.rootViewController = sw
        let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "select_profile_id")
        let navigationController = UINavigationController(rootViewController: destinationController!)
        sw.setFront(navigationController, animated: true)
        
    }
    
    
}

extension MenuControllerVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let person = UserDefaults.standard.value(forKey: key_user_default_value) as? [String:Any]  {
            
            if (person["role"] as! String) == "Customer" || (person["role"] as! String) == "Member" {
                
                return self.arrCustomerTitle.count
                
            } else if (person["role"] as! String) == "Seller" {
                
                return self.seller_title.count
                
            } else {
                return 0
            }
            
        }
        
        else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:MenuControllerVCTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! MenuControllerVCTableCell
        
        cell.backgroundColor = .clear
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        if let person = UserDefaults.standard.value(forKey: key_user_default_value) as? [String:Any] {
            
            if (person["role"] as! String) == "Customer" || (person["role"] as! String) == "Member" {
                cell.lblName.text = arrCustomerTitle[indexPath.row]
                cell.imgProfile.image = UIImage(systemName: arrCustomerImage[indexPath.row])
            } else if (person["role"] as! String) == "Seller" {
                cell.lblName.text = self.seller_title[indexPath.row]
                cell.imgProfile.image = UIImage(systemName: seller_title_image[indexPath.row])
            }
            
        }
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let person = UserDefaults.standard.value(forKey: key_user_default_value) as? [String:Any] {
            
            print(person as Any)
            /*
             ["Browse product",
                                     "Edit profile",
                                     "Order history",
                                     "Offered price",
                                     "Wishlist",
                                     "Shopping cart",
                                     "Review & Rating",
         //                            "Address",
                                     "Change Password",
                                     "Help",
                                     "Logout"]
             */
            if (person["role"] as! String) == "Customer" || (person["role"] as! String) == "Member" {
                
                if self.arrCustomerTitle[indexPath.row] == "Browse product" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "browse_product_id")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if self.arrCustomerTitle[indexPath.row] == "Help" {
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "Help_id")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if self.arrCustomerTitle[indexPath.row] == "Order history" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "order_history_id")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if self.arrCustomerTitle[indexPath.row] == "Shopping cart" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "cart_list_id")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if self.arrCustomerTitle[indexPath.row] == "Change password" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "change_password_id")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if self.arrCustomerTitle[indexPath.row] == "Edit profile" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "edit_profile_common_id")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if self.arrCustomerTitle[indexPath.row] == "Address" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "edit_address_id")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                }  else if self.arrCustomerTitle[indexPath.row] == "Offered price" {
                    
                    /*let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "offered_price_id")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)*/
                    
                }  else if self.arrCustomerTitle[indexPath.row] == "Wishlist" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "wishlist_id")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                }  else if self.arrCustomerTitle[indexPath.row] == "Review & Rating" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "rating_review_id")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                }   else if self.arrCustomerTitle[indexPath.row] == "Logout" {
                    
                    let alert = NewYorkAlertController(title: String("Logout"), message: String("Are you sure you want to logout ?"), style: .alert)
                    
                    let yes_logout = NewYorkButton(title: "yes, logout", style: .default) {
                        _ in
                        
                        self.logout_my_app_WB()
                    }
                    
                    yes_logout.setDynamicColor(.red)
                    
                    let cancel = NewYorkButton(title: "cancel", style: .cancel)
                    
                    alert.addButtons([yes_logout , cancel])
                    self.present(alert, animated: true)
                    
                }
            } else {
                
                /*
                 ["Dashboard",
                                     "Edit Profile",
                                     "Business profile",
                                     "Payment information",
                                      "Offered price",
                                     "Add new product",
                                     "Order history" ,
                                     "Earnings",
                                     "Cashout",
                                      "Buy product",
                                     "Wishlist",
                                     "Review & Rating",
                                     "Change Password",
                                     "Help",
                                     "Logout"]
                 */
                
                if self.seller_title[indexPath.row] == "Dashboard" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                        
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "dashboard_id")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if self.seller_title[indexPath.row] == "Edit Profile" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "edit_profile_common_id")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if self.seller_title[indexPath.row] == "My orders" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "my_orders_id")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if self.seller_title[indexPath.row] == "Help" {
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "Help_id")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if self.seller_title[indexPath.row] == "Change Password" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "change_password_id")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if self.seller_title[indexPath.row] == "Manage products" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                        
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "manage_products_id")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if self.seller_title[indexPath.row] == "Business profile" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                        
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "business_information_id") as? business_information
                    destinationController!.str_which_profile = "edit_business"
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                }  else if self.seller_title[indexPath.row] == "Order history" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                        
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "order_history_id")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if self.seller_title[indexPath.row] == "Payment information" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                        
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "bank_information_id") as? bank_information
                    destinationController!.str_which_profile_bank_info = "edit_bank"
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if self.seller_title[indexPath.row] == "Earnings" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                        
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "earnings_new_id")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if self.seller_title[indexPath.row] == "Cashout" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keySetToBackOrMenu")
                        
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "CashOutVC")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if self.seller_title[indexPath.row] == "Logout" {
                    
                    let alert = NewYorkAlertController(title: String("Logout"), message: String("Are you sure you want to logout ?"), style: .alert)
                    
                    let yes_logout = NewYorkButton(title: "yes, logout", style: .default) {
                        _ in
                        
                        self.logout_my_app_WB()
                    }
                    
                    yes_logout.setDynamicColor(.red)
                    
                    let cancel = NewYorkButton(title: "cancel", style: .cancel)
                    
                    alert.addButtons([yes_logout , cancel])
                    self.present(alert, animated: true)
                    
                }
                
            }
        }
        
    
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension MenuControllerVC: UITableViewDelegate {
    
}
