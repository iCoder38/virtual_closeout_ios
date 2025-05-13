//
//  all_card_list.swift
//  Virtual Closeout
//
//  Created by Apple on 15/06/22.
//

import UIKit
import Alamofire
import SwiftyJSON

class all_card_list: UIViewController {

    var arr_mut_card_list:NSMutableArray! = []
    
    var arr_mut_get_product_list:NSMutableArray! = []
    
    var get_full_address:NSDictionary!
    
    var payment_type:String!
    var get_final_price_in_all_cards_screen:String!
    var get_products_list_in_all_cards_screen:NSMutableArray! = []
    
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
            lblNavigationTitle.text = "All cards"
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.btnBack.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        
        //
        
        print(self.get_full_address as Any)
        print(self.payment_type as Any)
        print(self.get_final_price_in_all_cards_screen as Any)
        print(self.get_products_list_in_all_cards_screen as Any)
        
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
                    print(JSON as Any)
                    
                    var strSuccess : String!
                    strSuccess = (JSON["status"]as Any as? String)?.lowercased()
                    print(strSuccess as Any)
                    if strSuccess == String("success") {
                        print("yes")
                        
                        ERProgressHud.sharedInstance.hide()
                        
                        var ar : NSArray!
                        ar = (JSON["data"] as! Array<Any>) as NSArray
                        
                        self.arr_mut_card_list.addObjects(from: ar as! [Any])
                        
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
    
    // MARK: - DELETE CARD -
    @objc func delete_card_click_method() {
        
        let alert = NewYorkAlertController(title: String("Delete card"), message: String("Are you sure you want to delete this card?"), style: .alert)
        
        let yes_delete = NewYorkButton(title: "yes, delete", style: .destructive) {
            _ in
        }
        
        let dismiss = NewYorkButton(title: "dismiss", style: .cancel)
        
        yes_delete.setDynamicColor(.red)
        
        alert.addButtons([yes_delete , dismiss])
        self.present(alert, animated: true)
        
    }
    
    @objc func add_purchase_WB() {
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        if let person = UserDefaults.standard.value(forKey: key_user_default_value) as? [String:Any] {
            // let str:String = person["role"] as! String
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let paramsArray = self.get_products_list_in_all_cards_screen
            let paramsJSON = JSON(paramsArray!)
            let paramsString = paramsJSON.rawString(String.Encoding.utf8, options: JSONSerialization.WritingOptions.prettyPrinted)!
            
            let params = add_purchase_params(action: "addpurchese",
                                             userId: String(myString),
                                             productDetails: paramsString,
                                             totalAmount: String(self.get_final_price_in_all_cards_screen),
                                             ShippingName: (self.get_full_address["firstName"] as! String)+" "+(self.get_full_address["lastName"] as! String),
                                             ShippingAddress: (self.get_full_address["address"] as! String),
                                             ShippingCity: (self.get_full_address["City"] as! String),
                                             ShippingState: (self.get_full_address["state"] as! String),
                                             ShippingZipcode: (self.get_full_address["Zipcode"] as! String),
                                             ShippingPhone: (self.get_full_address["mobile"] as! String),
                                             transactionId: "tok_dummy_transaction_id",
                                             latitude: "",
                                             longitude: "")
            
            
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
                        
                        if self.payment_type == "buy" {
                            ERProgressHud.sharedInstance.hide()
                            
                            // push to success after payment
                            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "success_payment_id")
                            self.navigationController?.pushViewController(push, animated: true)
                            
                        } else {
                            self.delete_all_carts_WB()
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
    
    // MARK: - DELETE ALL CARTS -
    @objc func delete_all_carts_WB() {
        
        self.view.endEditing(true)
        // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        if let person = UserDefaults.standard.value(forKey: key_user_default_value) as? [String:Any] {
            // let str:String = person["role"] as! String
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let params = delete_all_cart_items_params(action: "deleteallcarts",
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
                        
                        // push to success after payment
                        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "success_payment_id")
                        self.navigationController?.pushViewController(push, animated: true)
                        
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
extension all_card_list: UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arr_mut_card_list.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell:all_card_list_table_cell = tableView.dequeueReusableCell(withIdentifier: "all_card_list_table_cell_one") as! all_card_list_table_cell
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            cell.backgroundColor = .clear
            
            cell.accessoryType = .disclosureIndicator
            
            return cell
            
        } else {
          
            let cell:all_card_list_table_cell = tableView.dequeueReusableCell(withIdentifier: "all_card_list_table_cell") as! all_card_list_table_cell
            
            cell.backgroundColor = .clear
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            cell.accessoryType = .disclosureIndicator
            
            let item = self.arr_mut_card_list[indexPath.row-1] as? [String:Any]
            
            let last4 = (item!["cardNo"] as! String).suffix(4)
            cell.lbl_card_number.text = "- "+String(last4)
            
            // card type
            if (item!["cardType"] as! String) == "" {
                
                cell.lbl_card_type.text = "N.A."
            } else {
                
                cell.lbl_card_type.text = (item!["cardType"] as! String)
            }
            
            // nick name
            if (item!["nickName"] as! String) == "" {
                cell.lbl_nick_name.text = (item!["NameOnCard"] as! String)
            } else {
                cell.lbl_nick_name.text = (item!["nickName"] as! String)
            }
            
            cell.lbl_card_year.text = (item!["expMonth"] as! String)+"/"+(item!["expYear"] as! String)
            
            cell.btn_delete.tag = indexPath.row
            cell.btn_delete.addTarget(self, action: #selector(delete_card_click_method), for: .touchUpInside)
            
            return cell
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        /*let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "payment_screen_id") as? payment_screen
        
        push!.get_total_price_for_payment = String(self.get_final_price_in_all_cards_screen)
        push!.get_products_details_for_payment = self.get_products_list_in_all_cards_screen
        
        self.navigationController?.pushViewController(push!, animated: true)*/
        
        if indexPath.row == 0 {
            
            /*
             print(self.get_full_address_for_payment as Any)
             print(self.payment_type_payment as Any)
             print(self.get_final_price_in_all_cards_screen_payment as Any)
             print(self.get_products_list_in_all_cards_screen_payment as Any)
             */
            
            /*
             var get_full_address:NSDictionary!
             
             var payment_type:String!
             var get_final_price_in_all_cards_screen:String!
             var get_products_list_in_all_cards_screen:NSMutableArray! = []
             */
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "payment_screen_id") as? payment_screen
            
            push!.get_full_address_for_payment = self.get_full_address
            push!.payment_type_payment = String(self.payment_type)
            push!.get_final_price_in_all_cards_screen_payment = self.get_final_price_in_all_cards_screen
            push!.get_products_list_in_all_cards_screen_payment = self.get_products_list_in_all_cards_screen
            
            self.navigationController?.pushViewController(push!, animated: true)
            
        } else {
            
        let alert = NewYorkAlertController.init(title: "CVV", message: "Please enter CVV of this card", style: .alert)

        // alert.addImage(UIImage(named: "Image"))
        
        alert.addTextField { tf in
            tf.placeholder = "cvv"
            tf.tag = 1
            tf.isSecureTextEntry = true
        }
        
        let ok = NewYorkButton(title: "Pay : $"+String(self.get_final_price_in_all_cards_screen), style: .default) { [unowned alert] _ in
            alert.textFields.forEach { tf in
                
                let text = tf.text ?? ""
                
                switch tf.tag {
                case 1:
                    print("cvv ====> \(text)")
                    
                    self.add_purchase_WB()
                    
                default:
                    break
                }
            }
        }
        let cancel = NewYorkButton(title: "Cancel", style: .cancel)
        
        alert.addButtons([ok, cancel])

        alert.isTapDismissalEnabled = false

        present(alert, animated: true)
    }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 60
        } else {
            return 70
        }
        
    }
    
}


class all_card_list_table_cell:UITableViewCell {
    
    @IBOutlet weak var lbl_nick_name:UILabel! {
        didSet {
            lbl_nick_name.textColor = .black
        }
    }
    
    @IBOutlet weak var lbl_card_type:UILabel! {
        didSet {
            lbl_card_type.textColor = .black
        }
    }
    
    @IBOutlet weak var lbl_card_number:UILabel! {
        didSet {
            lbl_card_number.textColor = .black
        }
    }
    
    @IBOutlet weak var lbl_card_year:UILabel! {
        didSet {
            lbl_card_year.textColor = .darkGray
        }
    }
    
    @IBOutlet weak var btn_delete:UIButton! {
        didSet {
            btn_delete.tintColor = .systemRed
        }
    }
    
    
    
}
