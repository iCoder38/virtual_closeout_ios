//
//  order_history_details.swift
//  Virtual Closeout
//
//  Created by Apple on 08/06/22.
//

import UIKit
import Alamofire
import SDWebImage

class order_history_details: UIViewController {

    var ar : NSArray!
    
    var productId:String!
    var dict: Dictionary<AnyHashable, Any> = [:]
    
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
            lblNavigationTitle.text = "Details"
            lblNavigationTitle.textColor = .white
        }
    }
    
    
    // ***************************************************************** // nav
    
    // MARK:- TABLE VIEW -
    @IBOutlet weak var tble_view: UITableView! {
        didSet {
            // tble_view.delegate = self
            // tble_view.dataSource = self
            self.tble_view.backgroundColor = .white
            self.tble_view.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
        }
    }
    
    @IBOutlet weak var btn_seller_profile:UIButton! {
        didSet {
            btn_seller_profile.tintColor = .white
            btn_seller_profile.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.btnBack.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        
        
        
        self.btn_seller_profile.addTarget(self, action: #selector(seller_profile_click_method), for: .touchUpInside)
        
        self.order_details_WB(str_loader: "yes")
    }
    
    @objc func seller_profile_click_method() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "seller_profile_id") as? seller_profile
        push!.str_seller_profile_id = "\(self.dict["sellerId"]!)"
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    @objc func order_details_WB(str_loader:String) {
        
        if str_loader == "yes"{
            ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "please wait...")
        }
        
            
        self.view.endEditing(true)
             
        let params = order_history_details_params(action: "purchedetail",
                                                  purcheseId: String(self.productId))
            
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
                            
                            // var strSuccess2 : String!
                            // strSuccess2 = JSON["msg"]as Any as? String
                            
                            if strSuccess == String("success") {
                                print("yes")
                                ERProgressHud.sharedInstance.hide()
                               
                                
                                self.dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                                
                                if let person = UserDefaults.standard.value(forKey: key_user_default_value) as? [String:Any] {
                                    let x : Int = (person["userId"] as! Int)
                                    let myString = String(x)
                                    
                                    if "\(self.dict["sellerId"]!)" == String(myString) {
                                        
                                        self.btn_seller_profile.isHidden = true
                                        
                                    } else {
                                        
                                        self.btn_seller_profile.isHidden = false
                                        
                                    }
                                    
                                }
                                
                                self.tble_view.delegate = self
                                self.tble_view.dataSource = self
                                self.tble_view.reloadData()
                                
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
                            
                            //Utils.showAlert(alerttitle: SERVER_ISSUE_TITLE, alertmessage: SERVER_ISSUE_MESSAGE, ButtonTitle: "Ok", viewController: self)
                        }
                }
            
            }
    
    
    // MARK:- WEBSERVICE ( ORDER HISTORY DETAILS ) -
    @objc func change_status_WB() {
        
        let alert = NewYorkAlertController(title: String("Delivered ?"), message: String("Did you delivered this product?"), style: .alert)
        
        let yes_delivered = NewYorkButton(title: "Yes, delivered", style: .default) {
            _ in
            
            self.mark_as_delivered()
        }

        let cancel = NewYorkButton(title: "cancel", style: .cancel)
        
        alert.addButtons([yes_delivered , cancel])
        self.present(alert, animated: true)
        
        
        
    }
    
    @objc func mark_as_delivered() {
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "please wait...")
            
        self.view.endEditing(true)
            
        // print(self.dict as Any)
        
        if let person = UserDefaults.standard.value(forKey: key_user_default_value) as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
                
            let params = change_status_params(action: "changestatus",
                                              sellerId: String(myString),
                                              purcheseId: "\(self.dict["purchaseId"]!)")
            
            print(params)
            
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
                            
                            // var strSuccess2 : String!
                            // strSuccess2 = JSON["msg"]as Any as? String
                            
                            if strSuccess == String("success") {
                                print("yes")
                                
                                // ERProgressHud.sharedInstance.hide()
                               
                                self.order_details_WB(str_loader: "no")
                                
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
                            
                            // Utils.showAlert(alerttitle: SERVER_ISSUE_TITLE, alertmessage: SERVER_ISSUE_MESSAGE, ButtonTitle: "Ok", viewController: self)
                        }
                }
            
            }
        
    }
    
    
    @objc func ratingClickMethod() {
        showRatingAlert { rating, description in
            print("Rating: \(rating), Description: \(description)")
            self.sendReviewWBSeller(star: "\(rating)", message: "\(description)")
        }
    }
    
    @objc func ratingClickMethod2() {
        showRatingAlert { rating, description in
            print("Rating: \(rating), Description: \(description)")
            self.sendReviewWB(star: "\(rating)", message: "\(description)")
        }
    }
    
    
    @objc func sendReviewWBSeller(star:String,message:String) {
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "please wait...")
            
        self.view.endEditing(true)
            
        // print(self.dict as Any)
        
        if let person = UserDefaults.standard.value(forKey: key_user_default_value) as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
                
            let params = sendReviewParam(action: "submitreview", orderId: "\(self.dict["purchaseId"]!)", reviewTo:"\(self.dict["userId"]!)" , reviewFrom: "\(self.dict["ownerId"]!)", star: String(star), message: String(message))
            
            print(params)
            
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
                            
                            // var strSuccess2 : String!
                            // strSuccess2 = JSON["msg"]as Any as? String
                            
                            if strSuccess == String("success") {
                                print("yes")
                                
                                self.order_details_WB(str_loader: "no")
                                
                            } else if strSuccess == String("Success") {
                                print("yes")
                                
                                self.order_details_WB(str_loader: "no")
                                
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
                            
                            // Utils.showAlert(alerttitle: SERVER_ISSUE_TITLE, alertmessage: SERVER_ISSUE_MESSAGE, ButtonTitle: "Ok", viewController: self)
                        }
                }
            
            }
        
    }
    
    @objc func sendReviewWB(star:String,message:String) {
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "please wait...")
            
        self.view.endEditing(true)
            
        // print(self.dict as Any)
        
        if let person = UserDefaults.standard.value(forKey: key_user_default_value) as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
                
            let params = sendReviewParam(action: "submitreview", orderId: "\(self.dict["purchaseId"]!)", reviewTo: "\(self.dict["ownerId"]!)", reviewFrom: String(myString), star: String(star), message: String(message))
            
            print(params)
            
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
                            
                            // var strSuccess2 : String!
                            // strSuccess2 = JSON["msg"]as Any as? String
                            
                            if strSuccess == String("success") {
                                print("yes")
                                
                                self.order_details_WB(str_loader: "no")
                                
                            } else if strSuccess == String("Success") {
                                print("yes")
                                
                                self.order_details_WB(str_loader: "no")
                                
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
                            
                            // Utils.showAlert(alerttitle: SERVER_ISSUE_TITLE, alertmessage: SERVER_ISSUE_MESSAGE, ButtonTitle: "Ok", viewController: self)
                        }
                }
            
            }
        
    }
}


extension order_history_details: UITableViewDataSource , UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5 // arrListOfAllMyOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellOne") as! order_history_details_table_cell
            
             print(self.dict as Any)
            
            cell.lblTitle.text    = (self.dict["productName"] as! String)
            cell.lblCreatedAt.text    = "Color : "+(self.dict["productColor"] as! String)
            cell.lblPrice.text = "Price: $\(self.dict["Amount"]!)"
            cell.lblQuantity.isHidden = false
            
            return cell
            
        } else if indexPath.row == 1 {
            
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "cellTwo") as! order_history_details_table_cell
            
            cell2.lblShippingAddressHolderName.text = (self.dict["ShippingName"] as! String)
            cell2.lblShippingAddress.text           = (self.dict["shippingAddress"] as! String)
            cell2.lblShippingPhoneNumber.text       = (self.dict["ShippingPhone"] as! String)
            
            cell2.accessoryType = .none
            
            return cell2
            
        } else if indexPath.row == 2 {
            
            let cell3 = tableView.dequeueReusableCell(withIdentifier: "cellThree") as! order_history_details_table_cell
            
            cell3.lblShippingCardType.text      = "\(self.dict["PaymentVia"]!)"
            cell3.lblShippingInvoiceDate.text   = (self.dict["created"] as! String)
            cell3.lblShippingRedId.text         = "Red Id : "+(self.dict["transactionId"] as! String)
            
            cell3.accessoryType = .none
            
            return cell3
            
        } else if indexPath.row == 3 {
            
            let cell4 = tableView.dequeueReusableCell(withIdentifier: "cellFour") as! order_history_details_table_cell
            
            
            
            if "\(self.dict["deliveryStatus"]!)" == "3" {
                
                cell4.lblShippingExpectedDelivery.text = "Expected Delivery : Done"
                cell4.lblShippingCurrentStatus.text = "Delivered"
                cell4.img_delivered.isHidden = false
                
            } else {
                
                cell4.lblShippingExpectedDelivery.text   = "Expected Delivery : "+(self.dict["deliveryDay"] as! String)
                cell4.lblShippingCurrentStatus.text = "In Transit"
                cell4.img_delivered.isHidden = true
                
            }
            
            cell4.accessoryType = .none
            
            if let person = UserDefaults.standard.value(forKey: key_user_default_value) as? [String:Any] {
                let x : Int = (person["userId"] as! Int)
                let myString = String(x)
                
                if "\(self.dict["sellerId"]!)" == String(myString) {
                    
                    print("I am seller")
                    if "\(self.dict["deliveryStatus"]!)" == "" {
                        // order complete button
                        cell4.btn_done_delivered.isHidden = false
                        cell4.btn_done_delivered.addTarget(self, action: #selector(change_status_WB), for: .touchUpInside)
                    } else {
                        // order complete button
                        cell4.btn_done_delivered.isHidden = true
                    }
                    
                }
                
            }
            
            
            
            return cell4
            
        } else if indexPath.row == 4 {
            
            let cell5 = tableView.dequeueReusableCell(withIdentifier: "cellFive") as! order_history_details_table_cell
            
            
            
            if let person = UserDefaults.standard.value(forKey: key_user_default_value) as? [String:Any] {
                let x : Int = (person["userId"] as! Int)
                let myString = String(x)
                
                if "\(self.dict["sellerId"]!)" == String(myString) {
                    
                    print("I am seller")
                    if "\(self.dict["revirewSeller"]!)" == "Yes" {
                        cell5.btnReview.isHidden = true
                    } else {
                        cell5.btnReview.isHidden = false
                        cell5.btnReview.setTitle("Rate customer", for: .normal)
                        cell5.btnReview.addTarget(self, action: #selector(ratingClickMethod2), for: .touchUpInside)
                    }
                    
                } else {
                    
                    print("I am customer")
                    if "\(self.dict["revirewUser"]!)" == "Yes" {
                        cell5.btnReview.isHidden = true
                    } else {
                        cell5.btnReview.isHidden = false
                        cell5.btnReview.setTitle("Rate seller", for: .normal)
                        cell5.btnReview.addTarget(self, action: #selector(ratingClickMethod), for: .touchUpInside)
                    }
                }
                
            }
           
            cell5.accessoryType = .none
            
            return cell5
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellSix") as! order_history_details_table_cell
            
            return cell
            
        }
        
        
        
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
     
        if indexPath.row == 0 {
            
            ar = ((self.dict["productDetails"] as! Array<Any>) as NSArray)
            
            if ar.count == 0 {
                
            } else if ar.count == 1 {
                
            } else {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "COrderHistoryProductDetailsId") as? COrderHistoryProductDetails
                push!.arrListOfAllProductDetails = ar
                self.navigationController?.pushViewController(push!, animated: true)
            }
            
            
        } else if indexPath.row == 3 {
            
            // (self.dict["ShippingPhone"] as! String)
            // (self.dict["ShippingName"] as! String)
            
            /*let nameAndPhone = "Name : "+(self.dict["driverName"] as! String)+"\n\nPhone : "+(self.dict["driverPhone"] as! String)
            
            let alert = UIAlertController(title: String("Detail"), message: String(nameAndPhone), preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Call Now", style: UIAlertAction.Style.default, handler: { action in
                
                
            }))
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: { action in
                
                
            }))
            
            self.present(alert, animated: true, completion: nil)*/
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        if indexPath.row == 3 {
            
            if let person = UserDefaults.standard.value(forKey: key_user_default_value) as? [String:Any] {
                let x : Int = (person["userId"] as! Int)
                let myString = String(x)
                
                if "\(self.dict["sellerId"]!)" == String(myString) {
                    
                    if "\(self.dict["deliveryStatus"]!)" == "" {
                        return 194
                    } else {
                        return 126
                    }
                    
                } else {
                
                    return 126
                }
                
            } else {
                return 0
            }

        }
        else if indexPath.row == 4 {
            
            if let person = UserDefaults.standard.value(forKey: key_user_default_value) as? [String:Any] {
                let x : Int = (person["userId"] as! Int)
                let myString = String(x)
                
                if "\(self.dict["sellerId"]!)" == String(myString) {
                    print("I am seller")
                    if "\(self.dict["deliveryStatus"]!)" == "3" { // delivered
                        if "\(self.dict["revirewSeller"]!)" == "Yes" { // review done from seller's end
                            return 0
                        } else {
                            return 80
                        }
                    } else {
                        // order not complete yet
                        return 0
                    }
                } else {
                    print("I am customer")
                    if "\(self.dict["deliveryStatus"]!)" == "3" { // delivered
                        if "\(self.dict["revirewUser"]!)" == "Yes" { // review done from user's end
                            return 0
                        } else {
                            return 80
                        }
                    } else {
                        return 0
                    }
                }
            }
            return 0
        }
        else {
            return UITableView.automaticDimension
        }
        
    }
    
}


class order_history_details_table_cell: UITableViewCell {

    // cell one
    @IBOutlet weak var viewbg:UIView! {
        didSet {
            viewbg.backgroundColor = .white
            viewbg.layer.cornerRadius = 6
            viewbg.clipsToBounds = true
            viewbg.layer.borderColor = UIColor.darkGray.cgColor
            viewbg.layer.borderWidth = 0.08
        }
    }
    
    @IBOutlet weak var imgProfile:UIImageView! {
        didSet {
            imgProfile.image = UIImage(named: "logo")
        }
    }
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblCreatedAt:UILabel!
    @IBOutlet weak var lblQuantity:UILabel!
    @IBOutlet weak var lblPrice:UILabel!
    
    // cell two
    @IBOutlet weak var viewbg2:UIView! {
        didSet {
            viewbg2.backgroundColor = .white
            viewbg2.layer.cornerRadius = 6
            viewbg2.clipsToBounds = true
            viewbg2.layer.borderColor = UIColor.darkGray.cgColor
            viewbg2.layer.borderWidth = 0.08
        }
    }
    @IBOutlet weak var lblShippingAddressHolderName:UILabel!
    @IBOutlet weak var lblShippingAddress:UILabel!
    @IBOutlet weak var lblShippingPhoneNumber:UILabel!
    
    // cell three
    @IBOutlet weak var lblShippingCardType:UILabel!
    @IBOutlet weak var lblShippingInvoiceDate:UILabel!
    
    @IBOutlet weak var btn_done_delivered:UIButton! {
        didSet {
            btn_done_delivered.backgroundColor = button_light
            btn_done_delivered.setTitle("Mark as delivered", for: .normal)
            btn_done_delivered.tintColor = .black
            btn_done_delivered.setImage(UIImage(systemName: ""), for: .normal)
            btn_done_delivered.setTitleColor(.black, for: .normal)
            btn_done_delivered.layer.cornerRadius = 28
            btn_done_delivered.clipsToBounds = true
            
            btn_done_delivered.layer.borderColor = button_dark.cgColor
            btn_done_delivered.layer.borderWidth = 1
        }
    }
    
    @IBOutlet weak var img_delivered:UIImageView! {
        didSet {
            img_delivered.image = UIImage(named: "delivered")
            img_delivered.isHidden = true
        }
    }
    
    @IBOutlet weak var lblShippingRedId:UILabel!
    @IBOutlet weak var viewbg3:UIView! {
        didSet {
            viewbg3.backgroundColor = .white
            viewbg3.layer.cornerRadius = 6
            viewbg3.clipsToBounds = true
            viewbg3.layer.borderColor = UIColor.darkGray.cgColor
            viewbg3.layer.borderWidth = 0.08
        }
    }
    
    // cell four
    @IBOutlet weak var lblShippingCurrentStatus:UILabel!
    @IBOutlet weak var lblShippingExpectedDelivery:UILabel!
    @IBOutlet weak var viewbg4:UIView! {
        didSet {
            viewbg4.backgroundColor = .systemGreen
            viewbg4.layer.cornerRadius = 6
            viewbg4.clipsToBounds = true
            viewbg4.layer.borderColor = UIColor.darkGray.cgColor
            viewbg4.layer.borderWidth = 0.08
        }
    }
    
    // cell 5
    @IBOutlet weak var btnReview:UIButton!
    

}
