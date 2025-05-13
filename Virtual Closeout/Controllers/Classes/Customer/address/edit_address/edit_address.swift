//
//  edit_address.swift
//  Virtual Closeout
//
//  Created by Apple on 16/06/22.
//

import UIKit
import Alamofire
import BSImagePicker

class edit_address: UIViewController {
    
    var ar_data : NSArray!
    
    var arr_mut_added_address_list:NSMutableArray! = []
    
    var str_show_proceed:String! = "0"
    
    var str_i_am_from:String!
    
    var arr_mut_card_list:NSMutableArray! = []
    
    var str_final_amount:String!
    var arr_mut_get_product_details_address:NSMutableArray! = []
    
    var dict_get_clicked_address:NSDictionary!
    
    var str_address_id:String!
    
    var str_hide_add_address:String! = "0"
    
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
            lblNavigationTitle.text = "Address"
            lblNavigationTitle.textColor = .white
        }
    }
    
    // ***************************************************************** // nav
    
    @IBOutlet weak var btn_add:UIButton! {
        didSet {
            btn_add.tintColor = .white
            btn_add.isHidden = false
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
        
        self.btn_add.addTarget(self, action: #selector(add_new_address_click_method), for: .touchUpInside)
        
        self.manage_profile(self.btnBack)
        
        self.list_of_all_address_WB(str_loader: "yes")
    }
    
    // MARK:- VALIDATINO BEFORE SUBMIT -
    @objc func validationBeforeAddorEditNewAddress() {
        let indexPath = IndexPath.init(row: 2, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! edit_address_table_cell
        
        if cell.txtFirstName.text == "" {
            
            self.errorPopUp(strTitle: "First Name", strMessage: "First name field")
            
        } else if cell.txtLastName.text == "" {
            
            self.errorPopUp(strTitle: "Last Name", strMessage: "Last name field")
            
        } else if cell.txtMobileNumber.text == "" {
            
            self.errorPopUp(strTitle: "Mobile Number", strMessage: "Mobile Number field")
            
        } else if cell.txtaddressLine1.text == "" {
            
            self.errorPopUp(strTitle: "Address Line", strMessage: "Address Line field")
            
        } else if cell.txtCity.text == "" {
            
            self.errorPopUp(strTitle: "City", strMessage: "City field")
            
        } else if cell.txtPinCode.text == "" {
            
            self.errorPopUp(strTitle: "Pincode", strMessage: "Pincode field")
            
        } else if cell.txtCountry.text == "" {
            
            self.errorPopUp(strTitle: "Coutry", strMessage: "Country field")
            
        } else if cell.txtState.text == "" {
            
            self.errorPopUp(strTitle: "State", strMessage: "State field")
            
        } else if cell.txtCompany.text == "" {
            
            self.errorPopUp(strTitle: "Company", strMessage: "Company Name")
            
        } else {
            
            
            if cell.lbl_address_text.text == "Add address" {
                self.add_address_WB()
            } else {
                self.edit_address_WB(str_edit_address: String(self.str_address_id))
            }
            
            
        }
        
    }
    
    @objc func errorPopUp(strTitle:String,strMessage:String) {
        
        let alert = UIAlertController(title: String(strTitle), message: String(strMessage)+" should not be empty", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
            
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    // MARK: - WEBSERVICE ( LIST OF ALL ADDRESS ) -
    @objc func list_of_all_address_WB(str_loader:String) {
        self.arr_mut_added_address_list.removeAllObjects()
        
        self.view.endEditing(true)
        
        if str_loader == "yes" {
            ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        }
        
        if let person = UserDefaults.standard.value(forKey: key_user_default_value) as? [String:Any] {
            // let str:String = person["role"] as! String
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let params = address_list_params(action: "addresslist",
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
                        
                        self.str_hide_add_address = "0"
                        
                        self.ar_data = (JSON["data"] as! Array<Any>) as NSArray
                        
                        for indexx in 0..<self.ar_data.count {
                         
                            let item = self.ar_data[indexx] as? [String:Any]
                            
                            let custom_dict = ["City":(item!["City"] as! String),
                                               "Zipcode":(item!["Zipcode"] as! String),
                                               "address":(item!["address"] as! String),
                                               "addressId":"\(item!["addressId"]!)",
                                               "company":(item!["company"] as! String),
                                               "country":(item!["country"] as! String),
                                               "deliveryType":(item!["deliveryType"] as! String),
                                               "firstName":(item!["firstName"] as! String),
                                               "lastName":(item!["lastName"] as! String),
                                               "mobile":(item!["mobile"] as! String),
                                               "state":(item!["state"] as! String),
                                               "status":"no"]
                         
                         self.arr_mut_added_address_list.add(custom_dict)
                         
                         }
                        
                        // self.arr_mut_added_address_list.addObjects(from: ar as! [Any])
                        
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
    
    // MARK: - WEBSERVICE ( EDIT ADDRESS ) -
    @objc func edit_address_WB(str_edit_address:String) {
        let indexPath = IndexPath.init(row: 2, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! edit_address_table_cell
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        if let person = UserDefaults.standard.value(forKey: key_user_default_value) as? [String:Any] {
            // let str:String = person["role"] as! String
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let params = edit_address_params(action: "editaddress",
                                            userId: String(myString),
                                            addressId: String(str_edit_address),
                                            firstName: String(cell.txtFirstName.text!),
                                            lastName: String(cell.txtLastName.text!),
                                            mobile: String(cell.txtMobileNumber.text!),
                                            address: String(cell.txtaddressLine1.text!),
                                            City: String(cell.txtCity.text!),
                                            state: String(cell.txtState.text!),
                                            Zipcode: String(cell.txtPinCode.text!),
                                            company: String(cell.txtCompany.text!),
                                            country: String(cell.txtCountry.text!))
            
            
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
                        
                        self.after_add_address_success()
                        
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
    
    // MARK: - WEBSERVICE ( ADD ADDRESS ) -
    @objc func add_address_WB() {
        let indexPath = IndexPath.init(row: 2, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! edit_address_table_cell
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        if let person = UserDefaults.standard.value(forKey: key_user_default_value) as? [String:Any] {
            // let str:String = person["role"] as! String
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let params = add_address_params(action: "addaddress",
                                            userId: String(myString),
                                            firstName: String(cell.txtFirstName.text!),
                                            lastName: String(cell.txtLastName.text!),
                                            mobile: String(cell.txtMobileNumber.text!),
                                            address: String(cell.txtaddressLine1.text!),
                                            City: String(cell.txtCity.text!),
                                            state: String(cell.txtState.text!),
                                            Zipcode: String(cell.txtPinCode.text!),
                                            company: String(cell.txtCompany.text!),
                                            country: String(cell.txtCountry.text!))
            
            
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
                        
                        self.after_add_address_success()
                        
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
    
    @objc func after_add_address_success() {
        
        let indexPath = IndexPath.init(row: 2, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! edit_address_table_cell
        
        cell.txtFirstName.text      = ""
        cell.txtLastName.text       = ""
        cell.txtMobileNumber.text   = ""
        cell.txtaddressLine1.text   = ""
        cell.txtCity.text           = ""
        cell.txtPinCode.text        = ""
        cell.txtCompany.text        = ""
        cell.txtCountry.text        = ""
        cell.txtState.text          = ""
        cell.txtFirstName.text      = ""
        
        self.tablView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        
        // ERProgressHud.sharedInstance.hide()
        
        self.list_of_all_address_WB(str_loader: "no")
        
    }
    
    // MARK: - PUSH ( PROCEED ) -
    @objc func proceed_click_method() {
        
        // check if any card is already add
        self.card_list_WB()
    }
    
    // MARK: - WEBSERVICE ( CARD LIST ) -
    @objc func card_list_WB() {
        self.arr_mut_card_list.removeAllObjects()
        
        self.view.endEditing(true)
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        if let person = UserDefaults.standard.value(forKey: key_user_default_value) as? [String:Any] {
            // let str:String = person["role"] as! String
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let params = card_list_params(action: "cardlist",
                                          userId: String(myString),
                                          pageNo: "")
            
            
            print(params as Any)
            
            AF.request(APPLICATION_BASE_URL,
                       method: .post,
                       parameters: params,
                       encoder: JSONParameterEncoder.default).responseJSON { response in
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
                        
                        var ar : NSArray!
                        ar = (JSON["data"] as! Array<Any>) as NSArray
                        
                        if ar.count == 0 {
                            
                            // print(self.str_final_amount as Any)
                            // print(self.arr_mut_added_address_list as Any)
                            
                            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "payment_screen_id") as? payment_screen
                            
                            push!.str_you_are_from_which_profile = String(self.str_i_am_from)
                            
                            push!.get_total_price_for_payment = String(self.str_final_amount)
                            push!.get_products_details_for_payment = self.arr_mut_get_product_details_address
                            
                            self.navigationController?.pushViewController(push!, animated: true)
                            
                        } else {
                           
                            print(self.arr_mut_added_address_list as Any)
                            
                            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "all_card_list_id") as? all_card_list
                            
                            push!.get_full_address = self.dict_get_clicked_address
                            push!.get_final_price_in_all_cards_screen = String(self.str_final_amount)
                            push!.get_products_list_in_all_cards_screen = self.arr_mut_get_product_details_address
                            
                            self.navigationController?.pushViewController(push!, animated: true)
                            
                        }
                        
                        /*self.arr_mut_card_list.addObjects(from: ar as! [Any])
                        
                        self.tablView.delegate = self
                        self.tablView.dataSource = self
                        self.tablView.reloadData()*/
                        
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

    
    @objc func add_new_address_click_method() {
        
        self.str_hide_add_address = "1"
        
        let indexPath = IndexPath.init(row: 2, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! edit_address_table_cell
        
        cell.txtFirstName.text = ""
        cell.txtLastName.text = ""
        cell.txtMobileNumber.text = ""
        cell.txtaddressLine1.text = ""
        cell.txtCity.text = ""
        cell.txtPinCode.text = ""
        cell.txtCountry.text = ""
        cell.txtState.text = ""
        cell.txtCompany.text = ""
        
        cell.btnSaveAddress.setTitle("Add", for: .normal)
        
        cell.lbl_address_text.text = "Add address"
        
        self.tablView.reloadData()
        
    }
    
    
    @objc func delete_address_click_method(_ sender:UIButton) {
        
        let item = self.arr_mut_added_address_list[sender.tag] as? [String:Any]
        print(item)
        
        let alert = NewYorkAlertController(title: String("Delete"), message: String("Are you sure you want to delete this address?"), style: .alert)
        
        let yes_logout = NewYorkButton(title: "yes, delete", style: .default) {
            _ in
            
            self.delete_address_WB(str_address_id: "\(item!["addressId"]!)")
        }
        
        yes_logout.setDynamicColor(.red)
        
        let cancel = NewYorkButton(title: "cancel", style: .cancel)
        
        alert.addButtons([yes_logout , cancel])
        self.present(alert, animated: true)
        
    }
    
    @objc func delete_address_WB(str_address_id:String) {
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "deleting...")
        
        if let person = UserDefaults.standard.value(forKey: key_user_default_value) as? [String:Any] {
            // let str:String = person["role"] as! String
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let params = delete_address_params(action: "deleteaddress",
                                            userId: String(myString),
                                               addressId: String(str_address_id))
            
            
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
                        
                        // ERProgressHud.sharedInstance.hide()
                        
                        self.list_of_all_address_WB(str_loader: "no")
                        
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


//MARK: - TABLE VIEW -
extension edit_address: UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell:edit_address_table_cell = tableView.dequeueReusableCell(withIdentifier: "edit_address_table_cell_one") as! edit_address_table_cell
            
            cell.backgroundColor = .clear
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            
            cell.collectionView.dataSource = self
            cell.collectionView.delegate = self
            cell.collectionView.reloadData()
            
            
            
            return cell
            
        } else if indexPath.row == 1 {
            
            let cell:edit_address_table_cell = tableView.dequeueReusableCell(withIdentifier: "edit_address_table_cell_three") as! edit_address_table_cell
            
            cell.backgroundColor = .clear
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
                        
            cell.btn_proceed.addTarget(self, action: #selector(proceed_click_method), for: .touchUpInside)
            
            return cell
            
        } else {
            
            let cell:edit_address_table_cell = tableView.dequeueReusableCell(withIdentifier: "edit_address_table_cell_two") as! edit_address_table_cell
            
            cell.backgroundColor = .clear
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            cell.btnSaveAddress.addTarget(self, action: #selector(validationBeforeAddorEditNewAddress), for: .touchUpInside)
            
            return cell
            
            
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        /*let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "browse_product_images_id")
         self.navigationController?.pushViewController(push, animated: true)*/
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if self.str_hide_add_address == "0" {
        
            if self.arr_mut_added_address_list.count == 0 {
                
                if indexPath.row == 0 {
                    return 0
                } else if indexPath.row == 1 {
                    return 0
                } else {
                    return 0
                }
                
            } else {
                
                if self.str_show_proceed == "0" {
                    
                    if indexPath.row == 0 {
                        return 240
                    } else if indexPath.row == 1 {
                        return 0
                    } else {
                        return 0
                    }
                    
                } else {
                    
                    if indexPath.row == 0 {
                        return 240
                    } else if indexPath.row == 1 {
                        return 0
                    } else {
                        return 0
                    }
                    
                }
                
            }
            
        } else {
            
            if self.arr_mut_added_address_list.count == 0 {
                
                if indexPath.row == 0 {
                    return 0
                } else if indexPath.row == 1 {
                    return 0
                } else {
                    return 1400
                }
                
            } else {
                
                if self.str_show_proceed == "0" {
                    
                    if indexPath.row == 0 {
                        return 240
                    } else if indexPath.row == 1 {
                        return 0
                    } else {
                        return 1400
                    }
                    
                } else {
                    
                    if indexPath.row == 0 {
                        return 240
                    } else if indexPath.row == 1 {
                        return 0
                    } else {
                        return 1400
                    }
                    
                }
                
            }
            
        }
        
        
    }
    
}

//MARK:- COLLECTION VIEW -
extension edit_address: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.arr_mut_added_address_list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "edit_address_collection_cell", for: indexPath as IndexPath) as! edit_address_collection_cell
        
        cell.backgroundColor  = .clear
        
        cell.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        cell.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        cell.layer.shadowOpacity = 1.0
        cell.layer.shadowRadius = 15.0
        cell.layer.masksToBounds = false
        cell.layer.cornerRadius = 15
        cell.backgroundColor = .white
        
        let item = self.arr_mut_added_address_list[indexPath.row] as? [String:Any]
        cell.lbl_address_user_name.text = (item!["firstName"] as! String)+" "+(item!["lastName"] as! String)
        cell.lbl_full_address.text = (item!["address"] as! String)+", "+(item!["City"] as! String)+", "+(item!["state"] as! String)+", "+(item!["country"] as! String)+" - "+(item!["Zipcode"] as! String)
        
        
        
        cell.btn_bin.tag = indexPath.row
        cell.btn_bin.addTarget(self, action: #selector(delete_address_click_method), for: .touchUpInside)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var sizes: CGSize
        let result = UIScreen.main.bounds.size
        NSLog("%f",result.height)
        sizes = CGSize(width: 188, height: 160)
        
        /*if result.height == 844 {
         
         print("i am iPhone 12")
         sizes = CGSize(width: 116, height: 130)
         } else if result.height == 812 {
         
         print("i am iPhone 12 mini")
         sizes = CGSize(width: 110, height: 130)
         } else {
         
         sizes = CGSize(width: 120, height: 130)
         }*/
        
        return sizes
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
                        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        /*let item = self.arr_mut_added_address_list[indexPath.row] as? [String:Any]
        
        self.arr_mut_added_address_list.removeAllObjects()
        
        for indexx in 0..<self.ar_data.count {
            
            let item_e = self.ar_data[indexx] as? [String:Any]
            
            let custom_dict = ["City":(item_e!["City"] as! String),
                               "Zipcode":(item_e!["Zipcode"] as! String),
                               "address":(item_e!["address"] as! String),
                               "addressId":"\(item_e!["addressId"]!)",
                               "company":(item_e!["company"] as! String),
                               "country":(item_e!["country"] as! String),
                               "deliveryType":(item_e!["deliveryType"] as! String),
                               "firstName":(item_e!["firstName"] as! String),
                               "lastName":(item_e!["lastName"] as! String),
                               "mobile":(item_e!["mobile"] as! String),
                               "state":(item_e!["state"] as! String),
                               "status":"no"]
            
            self.arr_mut_added_address_list.add(custom_dict)
            
        }
        
        self.arr_mut_added_address_list.removeObject(at: indexPath.row)
        
        let custom_dict = ["City":(item!["City"] as! String),
                           "Zipcode":(item!["Zipcode"] as! String),
                           "address":(item!["address"] as! String),
                           "addressId":"\(item!["addressId"]!)",
                           "company":(item!["company"] as! String),
                           "country":(item!["country"] as! String),
                           "deliveryType":(item!["deliveryType"] as! String),
                           "firstName":(item!["firstName"] as! String),
                           "lastName":(item!["lastName"] as! String),
                           "mobile":(item!["mobile"] as! String),
                           "state":(item!["state"] as! String),
                           "status":"yes"]
        
        self.arr_mut_added_address_list.insert(custom_dict, at: indexPath.row)
        
        self.dict_get_clicked_address = item as NSDictionary?
        // print(self.dict_get_clicked_address as Any)
        
        self.str_show_proceed = "1"
        
        
        
        // self.tablView.reloadData()
        */
        
        let item = self.arr_mut_added_address_list[indexPath.row] as? [String:Any]
        // print(item as Any)
        
        let indexPath = IndexPath.init(row: 2, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! edit_address_table_cell
        
        self.str_address_id = "\(item!["addressId"]!)"
        
        cell.txtFirstName.text = (item!["firstName"] as! String)
        cell.txtLastName.text = (item!["lastName"] as! String)
        cell.txtMobileNumber.text = (item!["mobile"] as! String)
        cell.txtaddressLine1.text = (item!["address"] as! String)
        cell.txtCity.text = (item!["City"] as! String)
        cell.txtPinCode.text = (item!["Zipcode"] as! String)
        cell.txtCountry.text = (item!["country"] as! String)
        cell.txtState.text = (item!["state"] as! String)
        cell.txtCompany.text = (item!["company"] as! String)
        
        cell.btnSaveAddress.setTitle("Edit", for: .normal)
        
        cell.lbl_address_text.text = "Edit address"
        
        self.str_hide_add_address = "1"
        self.tablView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
}

class edit_address_table_cell:UITableViewCell {
    
    
    // collection view
    @IBOutlet weak var collectionView:UICollectionView! {
        didSet {
            collectionView.backgroundColor = .clear
            // collectionView.dataSource = self
            // collectionView.delegate = self
        }
    }
    
    
    
    @IBOutlet weak var txtFirstName:UITextField! {
        didSet {
            txtFirstName.placeholder = "first name..."
        }
    }
    @IBOutlet weak var txtLastName:UITextField! {
        didSet {
            txtLastName.placeholder = "last name..."
        }
    }
    @IBOutlet weak var txtMobileNumber:UITextField! {
        didSet {
            txtMobileNumber.placeholder = "mobile number..."
        }
    }
    @IBOutlet weak var txtaddressLine1:UITextField! {
        didSet {
            txtaddressLine1.placeholder = "address..."
        }
    }
    
    @IBOutlet weak var txtCity:UITextField! {
        didSet {
            txtCity.placeholder = "city..."
        }
    }
    @IBOutlet weak var txtPinCode:UITextField! {
        didSet {
            txtPinCode.placeholder = "pin code..."
        }
    }
    @IBOutlet weak var txtCountry:UITextField! {
        didSet {
            txtCountry.placeholder = "country..."
        }
    }
    @IBOutlet weak var txtState:UITextField! {
        didSet {
            txtState.placeholder = "state..."
        }
    }
    @IBOutlet weak var txtCompany:UITextField! {
        didSet {
            txtCompany.placeholder = "company..."
        }
    }
    
    @IBOutlet weak var lbl_address_text:UILabel! {
        didSet {
            lbl_address_text.textColor = .black
        }
    }
    
    @IBOutlet weak var btnSaveAddress:UIButton! {
        didSet {
            btnSaveAddress.layer.cornerRadius = 4
            btnSaveAddress.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var btn_proceed:UIButton! {
        didSet {
            btn_proceed.backgroundColor = button_light
            btn_proceed.setTitle("Proceed", for: .normal)
            btn_proceed.tintColor = .black
            btn_proceed.setImage(UIImage(systemName: "arrow.right"), for: .normal)
            btn_proceed.setTitleColor(.black, for: .normal)
            btn_proceed.layer.cornerRadius = 28
            btn_proceed.clipsToBounds = true
            
            btn_proceed.layer.borderColor = button_dark.cgColor
            btn_proceed.layer.borderWidth = 1
        }
    }
    
}

class edit_address_collection_cell: UICollectionViewCell {
    
    @IBOutlet weak var lbl_address_user_name:UILabel! {
        didSet {
            lbl_address_user_name.textColor = .black
        }
    }
    
    @IBOutlet weak var lbl_full_address:UILabel! {
        didSet {
            lbl_full_address.textColor = .black
        }
    }
    
    @IBOutlet weak var btn_bin:UIButton! {
        didSet {
            btn_bin.tintColor = .systemPink
        }
    }
    
}
