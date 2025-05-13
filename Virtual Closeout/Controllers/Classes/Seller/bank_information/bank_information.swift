//
//  bank_information.swift
//  Virtual Closeout
//
//  Created by Apple on 09/06/22.
//

import UIKit
import Alamofire

class bank_information: UIViewController {
    
    var str_which_profile_bank_info:String!
    
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
            lblNavigationTitle.text = "Bank information"
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        // self.btnBack.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        
        print(self.str_which_profile_bank_info as Any)
        
        if String(self.str_which_profile_bank_info) == "edit_bank" {
            self.lblNavigationTitle.text = "Edit Bank information"
        }
        
        self.manage_profile(self.btnBack)
        
    }

    @objc func validation_before_upload_business_information() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! bank_information_table_cell
        
        if String(cell.txt_account_holder_name.text!) == "" {
            
            self.validations_for_forms(str_title: "Shop name")
            
        } else if String(cell.txt_Account_number.text!) == "" {
            
            self.validations_for_forms(str_title: "Phone number")
            
        } else if String(cell.txt_bank_name.text!) == "" {
            
            self.validations_for_forms(str_title: "Address")
            
        } else if String(cell.txt_routing_number.text!) == "" {
            
            self.validations_for_forms(str_title: "Country")
            
        } else if String(cell.txt_Account_number.text!) != String(cell.txt_confirm_account_number.text!) {
            
            let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: "Account number not matched. Please enter correct account number.", style: .alert)
            let cancel = NewYorkButton(title: "dismiss", style: .cancel)
            alert.addButtons([cancel])
            self.present(alert, animated: true)
            
        } else {
            self.add_edit_bank_info_WB()
        }
        
    }
    
    @objc func add_edit_bank_info_WB() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! bank_information_table_cell
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Updating...")
        
        if let person = UserDefaults.standard.value(forKey: key_user_default_value) as? [String:Any] {
            // let str:String = person["role"] as! String
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
        let params = add_edit_bank_info(action: "editprofile",
                                        userId: String(myString),
                                        AccountNo: String(cell.txt_Account_number.text!),
                                        BankName: String(cell.txt_bank_name.text!),
                                        AccountHolderName: String(cell.txt_account_holder_name.text!),
                                        RoutingNo: String(cell.txt_routing_number.text!),
                                        PayPalAccount: String(""))
        
        
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
                    
                    if String(self.str_which_profile_bank_info) == "edit_bank" {
                        
                        let alert = NewYorkAlertController(title: String("Success"), message: "Data edited successfully.", style: .alert)
                        let cancel = NewYorkButton(title: "Ok", style: .cancel)
                        alert.addButtons([cancel])
                        self.present(alert, animated: true)
                        
                    } else {
                        
                        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "dashboard_id") as? dashboard
                        self.navigationController?.pushViewController(settingsVCId!, animated: true)
                        
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
}

//MARK:- TABLE VIEW -
extension bank_information: UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:bank_information_table_cell = tableView.dequeueReusableCell(withIdentifier: "bank_information_table_cell") as! bank_information_table_cell
        
        cell.backgroundColor = .clear
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        cell.accessoryType = .none
        
        cell.btn_save_and_continue.addTarget(self, action: #selector(validation_before_upload_business_information), for: .touchUpInside)
        
        if let person = UserDefaults.standard.value(forKey: key_user_default_value) as? [String:Any] {
            
            if String(self.str_which_profile_bank_info) == "edit_bank" {
                
                cell.txt_account_holder_name.text   = (person["AccountHolderName"] as! String)
                cell.txt_Account_number.text        = (person["AccountNo"] as! String)
                cell.txt_confirm_account_number.text = (person["AccountNo"] as! String)
                cell.txt_bank_name.text             = (person["BankName"] as! String)
                cell.txt_routing_number.text        = (person["RoutingNo"] as! String)
                
            }
        }
    
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1200
    }
        
}

class bank_information_table_cell:UITableViewCell {
    
    @IBOutlet weak var txt_account_holder_name:UITextField! {
        didSet {
            Utils.text_field_UI(text_field: txt_account_holder_name)
         }
    }
    
    @IBOutlet weak var txt_Account_number:UITextField! {
        didSet {
            Utils.text_field_UI(text_field: txt_Account_number)
            txt_Account_number.isSecureTextEntry = true
         }
    }
    
    @IBOutlet weak var txt_confirm_account_number:UITextField! {
        didSet {
            Utils.text_field_UI(text_field: txt_confirm_account_number)
         }
    }
    
    @IBOutlet weak var txt_bank_name:UITextField! {
        didSet {
            Utils.text_field_UI(text_field: txt_bank_name)
         }
    }
    
    @IBOutlet weak var txt_routing_number:UITextField! {
        didSet {
            Utils.text_field_UI(text_field: txt_routing_number)
         }
    }
    
    @IBOutlet weak var btn_save_and_continue:UIButton! {
        didSet {
            btn_save_and_continue.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            btn_save_and_continue.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            btn_save_and_continue.layer.shadowOpacity = 1.0
            btn_save_and_continue.layer.shadowRadius = 15.0
            btn_save_and_continue.layer.masksToBounds = false
            btn_save_and_continue.layer.cornerRadius = 22
            btn_save_and_continue.backgroundColor = button_dark
            btn_save_and_continue.setTitleColor(.white, for: .normal)
            btn_save_and_continue.setTitle("Edit bank details", for: .normal)
        }
    }
    
}
