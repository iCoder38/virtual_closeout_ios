//
//  CashOutVC.swift
//  Bookit
//
//  Created by Ranjan on 21/12/21.
//

import UIKit
import Alamofire

class CashOutVC: UIViewController {
    
    
    var strSuccess2_total_amount : String!
    
    let paddingFromLeftIs:CGFloat = 0
    
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
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "Cashout"
            lblNavigationTitle.textColor = .white
            lblNavigationTitle.backgroundColor = .clear
        }
    }
    
    // ***************************************************************** // nav
    
    @IBOutlet weak var viwTop:UIView! {
        didSet {
            viwTop.backgroundColor = button_light
        }
    }
    
    @IBOutlet weak var viw:UIView! {
        didSet {
            viw.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var lblWithdrawableAmount:UILabel! {
        didSet {
            lblWithdrawableAmount.text = "Withdrawable balance : $200"
            lblWithdrawableAmount.textColor = .black
        }
    }
    
    @IBOutlet weak var lblTotalEarning:UILabel! {
        didSet {
            lblTotalEarning.text = "..."
            lblTotalEarning.textColor = .black
        }
    }
    
    @IBOutlet weak var txtAmount:UITextField! {
        didSet {
            Utils.text_field_UI(text_field: txtAmount)
            
            txtAmount.keyboardType = .numberPad
        }
    }
    
    @IBOutlet weak var btnSubmit:UIButton! {
        didSet {
            btnSubmit.layer.cornerRadius = 10.0
            btnSubmit.clipsToBounds = true
            btnSubmit.setTitle("Submit request", for: .normal)
            btnSubmit.backgroundColor =  button_dark
            btnSubmit.tintColor = .white
        }
    }
    
    @IBOutlet weak var btn_history:UIButton! {
        didSet {
            btn_history.backgroundColor = button_light
            btn_history.setTitle("History", for: .normal)
            btn_history.tintColor = .black
            btn_history.setImage(UIImage(systemName: "arrow.right"), for: .normal)
            btn_history.setTitleColor(.black, for: .normal)
            btn_history.layer.cornerRadius = 28
            btn_history.clipsToBounds = true
            
            btn_history.layer.borderColor = button_dark.cgColor
            btn_history.layer.borderWidth = 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        self.hideKeyboardWhenTappedAround()
        
        /*NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)*/
        
        self.btnSubmit.addTarget(self, action: #selector(validation_before_cashout), for: .touchUpInside)
        // self.manage_profile(self.btnBack)
        
        // self.btnBack.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        // self.btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
        self.btn_history.addTarget(self, action: #selector(history_click_method), for: .touchUpInside)
        
         self.my_club_earning_wb()
        
        self.manage_profile(self.btnBack)
    }
    
    @objc func history_click_method() {
        
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "cashout_list_id") as? cashout_list
        self.navigationController?.pushViewController(settingsVCId!, animated: true)
        
    }
    
    @objc func manage_profile() {
        
        if let myLoadedString = UserDefaults.standard.string(forKey: "keySetToBackOrMenu") {
            print(myLoadedString)
            
            if myLoadedString == "backOrMenu" {
                // menu
                self.btnBack.setImage(UIImage(systemName: "list.dash"), for: .normal)
                // self.sideBarMenuClick()
            } else {
                // back
                self.btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
            }
        } else {
            // back
            self.btnBack.setImage(UIImage(systemName: "arrow.left"), for: .normal)
            self.btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        }
        
        self.my_club_earning_wb()
        
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*@objc func sideBarMenuClick() {
        
        let defaults = UserDefaults.standard
        defaults.setValue("", forKey: "keyBackOrSlide")
        defaults.setValue(nil, forKey: "keyBackOrSlide")
        
        if revealViewController() != nil {
            btnBack.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    }*/
    
    // MARK: - VALIDATION BEFORE CASHOUT -
    @objc func validation_before_cashout() {
        
        if self.txtAmount.text! == "" {

            
            
        } else {
            
            if Double(self.strSuccess2_total_amount)! > Double(self.txtAmount.text!)! {
                
                self.cashout_request_wb()
                
            } else {
                
                let alert = NewYorkAlertController(title: String("Alert"), message: String("You amount should be lower than your total earnings."), style: .alert)
                
                // alert.addImage(UIImage.gif(name: "gif_alert"))
                
                let cancel = NewYorkButton(title: "Ok", style: .cancel)
                alert.addButtons([cancel])
                
                self.present(alert, animated: true)
                
            }
            
            //
        }
        
    }
    
    @objc func my_club_earning_wb() {
        
        self.view.endEditing(true)
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        if let person = UserDefaults.standard.value(forKey: key_user_default_value) as? [String:Any] {
            print(person as Any)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let params = club_earning(action: "profile",
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
                        
                        // total amount
                        
                        var dict: Dictionary<AnyHashable, Any>
                        dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                        
                        let defaults = UserDefaults.standard
                        defaults.setValue(dict, forKey: key_user_default_value)
                        
                        self.strSuccess2_total_amount = "\(dict["wallet"]!)"
                        
                        self.lblTotalEarning.text = "$"+String(self.strSuccess2_total_amount)
                        self.lblWithdrawableAmount.text = "Withdrawable balance : $\(dict["wallet"]!)"
                        
                        
                    } else {
                        print("no")
                        ERProgressHud.sharedInstance.hide()
                        
                        var strSuccess2 : String!
                        strSuccess2 = JSON["msg"]as Any as? String
                        
                        if strSuccess2 == "Your Account is Inactive. Please contact admin.!!" ||
                            strSuccess2 == "Your Account is Inactive. Please contact admin.!" ||
                            strSuccess2 == "Your Account is Inactive. Please contact admin." {
                            
                            
                        } else {
                            
                            let alert = UIAlertController(title: String(strSuccess).uppercased(), message: String(strSuccess2), preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                            
                            self.present(alert, animated: true)
                            
                        }
                    }
                    
                case let .failure(error):
                    print(error)
                    ERProgressHud.sharedInstance.hide()
                    
                    // Utils.showAlert(alerttitle: SERVER_ISSUE_TITLE, alertmessage: SERVER_ISSUE_MESSAGE, ButtonTitle: "Ok", viewController: self)
                }
            }
        }
    }
    
    // MARK: - CASHOUT REQUEST -
    @objc func cashout_request_wb() {
        
        self.view.endEditing(true)
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        if let person = UserDefaults.standard.value(forKey: key_user_default_value) as? [String:Any] {
            print(person as Any)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let params = cashout(action: "cashoutrequest",
                                 userId: String(myString),
                                 requestAmount: String(self.txtAmount.text!))
            
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
                        
                        var strSuccess2 : String!
                        strSuccess2 = JSON["msg"]as Any as? String
                        
                        let alert = NewYorkAlertController(title: "Success", message: String(strSuccess2), style: .alert)
                        
                        // alert.addImage(UIImage.gif(name: "success3"))
                        
                        let cancel = NewYorkButton(title: "Ok", style: .cancel) {
                            _ in
                            self.txtAmount.text = ""
                        }
                        alert.addButtons([cancel])
                        
                        self.present(alert, animated: true)
                        
                    } else {
                        
                        print("no")
                        ERProgressHud.sharedInstance.hide()
                        
                        var strSuccess2 : String!
                        strSuccess2 = JSON["msg"]as Any as? String
                        
                        if strSuccess2 == "Your Account is Inactive. Please contact admin.!!" ||
                            strSuccess2 == "Your Account is Inactive. Please contact admin.!" ||
                            strSuccess2 == "Your Account is Inactive. Please contact admin." {
                            
                            
                        } else {
                            
                            let alert = UIAlertController(title: String(strSuccess).uppercased(), message: String(strSuccess2), preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                            
                            self.present(alert, animated: true)
                            
                        }
                    }
                    
                case let .failure(error):
                    print(error)
                    ERProgressHud.sharedInstance.hide()
                    
                    // Utils.showAlert(alerttitle: SERVER_ISSUE_TITLE, alertmessage: SERVER_ISSUE_MESSAGE, ButtonTitle: "Ok", viewController: self)
                }
            }
        }
    }
    
}
