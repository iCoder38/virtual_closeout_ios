//
//  login.swift
//  Virtual Closeout
//
//  Created by Apple on 07/06/22.
//

import UIKit
import Alamofire

class login: UIViewController , UITextFieldDelegate {
    
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
            lblNavigationTitle.text = "Sign in"
            lblNavigationTitle.textColor = .white
        }
    }
    
    // ***************************************************************** // nav
    
    @IBOutlet weak var view_login:UIView! {
        didSet {
            view_login.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_login.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            view_login.layer.shadowOpacity = 1.0
            view_login.layer.shadowRadius = 15.0
            view_login.layer.masksToBounds = false
            view_login.layer.cornerRadius = 15
            view_login.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var txt_email:UITextField! {
        didSet {
            txt_email.keyboardType = .emailAddress
            txt_email.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var txt_password:UITextField! {
        didSet {
            txt_password.backgroundColor = .clear
            txt_password.isSecureTextEntry = true
        }
    }
    
    @IBOutlet weak var lbl_hello_text:UILabel! {
        didSet {
            lbl_hello_text.textColor = button_dark
        }
    }
    
    @IBOutlet weak var btn_sign_in:UIButton! {
        didSet {
            btn_sign_in.backgroundColor = button_dark
            btn_sign_in.setTitle("Sign In", for: .normal)
            btn_sign_in.layer.cornerRadius = 24
            btn_sign_in.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var lbl_remember_me:UILabel! {
        didSet {
            lbl_remember_me.textColor = button_dark
        }
    }
    
    @IBOutlet weak var btn_check_mark:UIButton! {
        didSet {
            btn_check_mark.backgroundColor = .clear
            btn_check_mark.setTitle("", for: .normal)
            btn_check_mark.layer.cornerRadius = 0
            btn_check_mark.clipsToBounds = true
            btn_check_mark.setImage(UIImage(named: "un_check_mark"), for: .normal)
        }
    }
    
    @IBOutlet weak var btn_forgot_password:UIButton! {
        didSet {
            btn_forgot_password.backgroundColor = .clear
            btn_forgot_password.setTitle("Forgot password", for: .normal)
            btn_forgot_password.setTitleColor(button_dark, for: .normal)
            btn_forgot_password.layer.cornerRadius = 28
            btn_forgot_password.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var btn_dnt_have_an_account:UIButton! {
        didSet {
            btn_dnt_have_an_account.backgroundColor = .clear
            btn_dnt_have_an_account.setTitle("Don't have an account - Sign up", for: .normal)
            btn_dnt_have_an_account.setTitleColor(button_dark, for: .normal)
            btn_dnt_have_an_account.layer.cornerRadius = 28
            btn_dnt_have_an_account.clipsToBounds = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.txt_email.delegate = self
        self.txt_password.delegate = self
        
        self.btnBack.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        self.btn_sign_in.addTarget(self, action: #selector(sign_in_click_method), for: .touchUpInside)
        
    }
    
    @objc func sign_in_click_method() {
        
        self.login_with_credentials_validations()
        
        /*let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "browse_product_id")
        self.navigationController?.pushViewController(push, animated: true)*/
        
    }
    
    // MARK: - VALIDATION ( LOGIN ) -
    @objc func login_with_credentials_validations() {
        
        if String(self.txt_email.text!) == "" {
            
            self.validations_for_forms(str_title: "Email")
        } else if String(self.txt_password.text!) == "" {
            
            self.validations_for_forms(str_title: "Password")
        } else {
            
            self.login_with_credentials()
        }
        
    }
    
    @objc func login_with_credentials() {
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        let params = login_in_account(action: "login",
                                      password: String(self.txt_password.text!),
                                      email: String(self.txt_email.text!))
        
        
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
                    
                    // var strSuccess2 : String!
                    // strSuccess2 = JSON["msg"]as Any as? String
                    
                    var dict: Dictionary<AnyHashable, Any>
                    dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                    
                    let defaults = UserDefaults.standard
                    defaults.setValue(dict, forKey: key_user_default_value)
                    
                    self.check_all_profiles()
                    
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
    
    
    @objc func check_all_profiles() {
        
        if let person = UserDefaults.standard.value(forKey: key_user_default_value) as? [String:Any]  {

            print(person as Any)

            if (person["role"] as! String) == "Seller" {
                
                if (person["businessName"] as! String) == "" { // if your business information is empty
                    
                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "business_information_id")
                    self.navigationController?.pushViewController(push, animated: false)
                    
                } else {
                
                    if (person["BankName"] as! String) == "" { // if bank name is empty
                        
                        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "bank_information_id") as? bank_information
                        push!.str_which_profile_bank_info = ""
                        self.navigationController?.pushViewController(push!, animated: true)
                        
                    } else {
                    
                        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "dashboard_id") as? dashboard
                        self.navigationController?.pushViewController(push!, animated: true)
                        
                    }
                    
                    
                }
                
                
            } else {
                
                // customer
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "browse_product_id")
                self.navigationController?.pushViewController(push, animated: true)
                
            }
            
        }
        
    }
    
}
