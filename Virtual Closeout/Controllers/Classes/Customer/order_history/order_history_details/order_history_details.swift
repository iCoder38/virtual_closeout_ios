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
        /*push!.str_seller_image = (self.dict["sellerId"] as! String)
        push!.str_seller_name = (self.dict["sellerId"] as! String)
        push!.str_seller_address = (self.dict["sellerId"] as! String)*/

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
        
        let alert = NewYorkAlertController(title: String("Alert"), message: String("Did you delivered this product?"), style: .alert)
        
        let yes_delivered = NewYorkButton(title: "yes, delivered", style: .default) {
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
                                              purcheseId: "\(self.dict["purcheseId"]!)")
            
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
}


extension order_history_details: UITableViewDataSource , UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4 // arrListOfAllMyOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        /*
         
         {
             data =     {
                 ShippingName = "Dishant Rajput";
                 ShippingPhone = 8287632340;
                 cardType = visa;
                 created = "2020-10-06 19:46:00";
                 deliveryDay = "3-4 days";
                 driverEmail = "ios@gmail.com";
                 driverImage = "";
                 driverName = "Mobile Gaming iPhone X";
                 driverPhone = 9865986434;
                 productDetails =         (
                                 {
                         Quantity = 1;
                         SKU = 878787;
                         description = "<p><strong><em>CBD content:&nbsp;</em></strong><em>about 25 mg, depending on your&nbsp;</em>Turmeric, agar agar, carrot juice, ginger, cayenne, and CBD, all in a sweet treat? Yes, it is possible! These healthy, satisfying treats require only about 10 minutes to make, and they stay fresh in the refrigerator for up to a week</p>
         \n";
                         image = "http://demo2.evirtualservices.com/HoneyBudz/site/img/uploads/products/1601895366_Elevem.jpg";
                         price = 90;
                         productId = 13;
                         productName = "Healthy CBD-Turmeric Sweets";
                     },
                                 {
                         Quantity = 5;
                         SKU = 44335;
                         description = "<p><strong><em>CBD content:&nbsp;</em></strong><em>varies, depending on the potency of your CBD oil&nbsp;</em>Healthy CBD granola will fill you up with goodness. This recipe calls for wholesome organic rolled oats, hemp seeds, CBD oil, and rich dark chocolate. The base granola provides plenty of benefits, and the addition of CBD oil elevates this snack to new heights.</p>
         \n";
                         image = "http://demo2.evirtualservices.com/HoneyBudz/site/img/uploads/products/1601895708_Tweve.jpg";
                         price = 30;
                         productId = 16;
                         productName = "CBD Granola";
                     },
                                 {
                         Quantity = 1;
                         SKU = 89809;
                         description = "<p><strong><em>CBD content:&nbsp;</em></strong><em>about 4 mg, depending on your ,</em>Toss freeze-dried raspberries, superfood seeds, CBD oil, and other wholesome ingredients into a food processor to quickly make satisfying and healthy bites that look like festive truffles and taste just as good.</p>
         \n";
                         image = "http://demo2.evirtualservices.com/HoneyBudz/site/img/uploads/products/1601895413_Eight.jpg";
                         price = 56;
                         productId = 14;
                         productName = "CBD Raspberry Energy Bites";
                     },
                                 {
                         Quantity = 2;
                         SKU = 23443;
                         description = "<p><strong><em>CBD content:&nbsp;</em></strong><em>varies, depending on the potency of your CBD oil or extract</em>&nbsp;Yes, even your green juice can be adapted into a CBD edible. This recipe combines a list of super-healthy and surprising ingredients, including amla berry powder and cilantro, to make a refreshing CBD snack you can drink on the go.</p>
         \n";
                         image = "http://demo2.evirtualservices.com/HoneyBudz/site/img/uploads/products/1601896824_Nine.jpg";
                         price = 34;
                         productId = 20;
                         productName = "Green Juice with CBD";
                     }
                 );
                 purcheseId = 48;
                 shippingAddress = "Unnamed Road, Sector 6, Sector 10 Dwarka, Dwarka, Delhi, 110075, IndiaOk";
                 shippingCity = Dwarka;
                 shippingCountry = "";
                 shippingState = Delhi;
                 shippingZipcode = 110075;
                 status = 0;
                 totalAmount = 364;
                 transactionId = "";
             };
             status = success;
         }
         (lldb)
         */
        // let item = self.arrListOfAllMyOrders[indexPath.row] as? [String:Any]
        
        // 0:
        // 1:
        // 2:
        // 3:
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellOne") as! order_history_details_table_cell
            
            // print(self.dict as Any)
            // let item = self.arrListOfAllMyOrders[indexPath.row] as? [String:Any]
            
            // total number of products
            
            ar = ((self.dict["productDetails"] as! Array<Any>) as NSArray)
            // print(ar as Any)
            
            let item = ar[0] as? [String:Any]
            // print(item as Any)
            
            if ar.count == 0 {
                
                cell.accessoryType = .none
            } else if ar.count == 1 {
                
                cell.accessoryType = .none
            } else {
                
                cell.accessoryType = .disclosureIndicator
            }
            
            cell.lblTitle.text    = (item!["productName"] as! String)
            cell.lblCreatedAt.text    = "SKU : "+(item!["SKU"] as! String)
            
            // price
            if item!["price"] is String {
                print("Yes, it's a String")

                cell.lblPrice.text = "Price : $ "+(item!["price"] as! String)

            } else if item!["price"] is Int {
                print("It is Integer")
                            
                let x2 : Int = (item!["price"] as! Int)
                let myString2 = String(x2)
                cell.lblPrice.text = "Price : $ "+myString2
                            
            } else {
                print("i am number")
                            
                let temp:NSNumber = item!["price"] as! NSNumber
                let tempString = temp.stringValue
                cell.lblPrice.text = "Price : $ "+tempString
            }
             
            // quantity
            if item!["Quantity"] is String {
                print("Yes, it's a String")

                cell.lblQuantity.text = "Quantity : "+(item!["Quantity"] as! String)

            } else if item!["Quantity"] is Int {
                print("It is Integer")
                            
                let x2 : Int = (item!["Quantity"] as! Int)
                let myString2 = String(x2)
                cell.lblQuantity.text = "Quantity : "+myString2
                            
            } else {
                print("i am number")
                            
                let temp:NSNumber = item!["Quantity"] as! NSNumber
                let tempString = temp.stringValue
                cell.lblQuantity.text = "Quantity : "+tempString
            }
            
            
            
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
            
            cell3.lblShippingCardType.text      = "Card Type - "+(self.dict["cardType"] as! String)
            cell3.lblShippingInvoiceDate.text   = (self.dict["created"] as! String)
            cell3.lblShippingRedId.text         = "Red Id : "+(self.dict["transactionId"] as! String)
            
            cell3.accessoryType = .none
            
            return cell3
            
        } else if indexPath.row == 3 {
            
            let cell4 = tableView.dequeueReusableCell(withIdentifier: "cellFour") as! order_history_details_table_cell
            
            
            
            if "\(self.dict["status"]!)" == "3" {
                
                cell4.lblShippingExpectedDelivery.text = "Expected Delivery : Done"
                cell4.lblShippingCurrentStatus.text = "Delivered"
                cell4.img_delivered.isHidden = false
                
            } else {
                
                cell4.lblShippingExpectedDelivery.text   = "Expected Delivery : "+(self.dict["deliveryDay"] as! String)
                cell4.lblShippingCurrentStatus.text = "In Transit"
                cell4.img_delivered.isHidden = true
                
            }
            
            cell4.accessoryType = .none
            
            cell4.btn_done_delivered.addTarget(self, action: #selector(change_status_WB), for: .touchUpInside)
            
            return cell4
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellFive") as! order_history_details_table_cell
            
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
                    
                    if "\(self.dict["status"]!)" == "0" {
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

        } else {
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
    

}
