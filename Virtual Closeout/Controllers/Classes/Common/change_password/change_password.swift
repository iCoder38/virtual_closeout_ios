//
//  change_password.swift
//  Virtual Closeout
//
//  Created by Apple on 09/06/22.
//

import UIKit
import Alamofire

class change_password: UIViewController {
    
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
            lblNavigationTitle.text = "Change password"
            lblNavigationTitle.textColor = .white
        }
    }
    
    // ***************************************************************** // nav
    
    @IBOutlet weak var txtCurrentPassword:UITextField! {
        didSet {
            txtCurrentPassword.layer.cornerRadius = 6
            txtCurrentPassword.clipsToBounds = true
            txtCurrentPassword.setLeftPaddingPoints(40)
            txtCurrentPassword.layer.borderColor = UIColor.clear.cgColor
            txtCurrentPassword.layer.borderWidth = 0.8
        }
    }
    
    @IBOutlet weak var txtNewPassword:UITextField! {
        didSet {
            txtNewPassword.layer.cornerRadius = 6
            txtNewPassword.clipsToBounds = true
            txtNewPassword.setLeftPaddingPoints(40)
            txtNewPassword.layer.borderColor = UIColor.clear.cgColor
            txtNewPassword.layer.borderWidth = 0.8
        }
    }
    
    @IBOutlet weak var txtConfirmPassword:UITextField! {
        didSet {
            txtConfirmPassword.layer.cornerRadius = 6
            txtConfirmPassword.clipsToBounds = true
            txtConfirmPassword.setLeftPaddingPoints(40)
            txtConfirmPassword.layer.borderColor = UIColor.clear.cgColor
            txtConfirmPassword.layer.borderWidth = 0.8
        }
    }
    
    @IBOutlet weak var btnUpdatePassword:UIButton! {
        didSet {
            btnUpdatePassword.layer.cornerRadius = 12
            btnUpdatePassword.clipsToBounds = true
            btnUpdatePassword.backgroundColor = button_dark
            btnUpdatePassword.setTitleColor(.white, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        // self.btnBack.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        
        // MARK:- VIEW UP WHEN CLICK ON TEXT FIELD -
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.manage_profile(self.btnBack)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        self.btnUpdatePassword.addTarget(self, action: #selector(validationBeforeChangePassword), for: .touchUpInside)
    }
    
    @objc override func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @objc func validationBeforeChangePassword() {
        
        if self.txtCurrentPassword.text == "" {
            
            let alert = UIAlertController(title: String("Error!"), message: String("Current Password should not be Empty."), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else if self.txtNewPassword.text == "" {
            
            let alert = UIAlertController(title: String("Error!"), message: String("New Password should not be Empty."), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            self.changePasswordWB()
        }
        
        
    }
    
   @objc func changePasswordWB() {
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        self.view.endEditing(true)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // let str:String = person["role"] as! String
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let params = change_my_password(action: "changePassword",
                                         userId: String(myString),
                                         oldPassword: String(txtCurrentPassword.text!),
                                         newPassword: String(txtNewPassword.text!))
            
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
                    
                    var strSuccess2 : String!
                    strSuccess2 = JSON["msg"]as Any as? String
                    
                    if strSuccess == String("success") {
                        print("yes")
                        ERProgressHud.sharedInstance.hide()
                        
                        let alert = UIAlertController(title: String(strSuccess), message: String(strSuccess2), preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                            
                            self.txtCurrentPassword.text = ""
                            self.txtNewPassword.text = ""
                            self.txtConfirmPassword.text = ""
                            
                        }))
                        self.present(alert, animated: true, completion: nil)
                        
                        
                        
                        
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
                    
                    self.please_check_your_internet_connection()
                }
            }
        }
    }
    
}

