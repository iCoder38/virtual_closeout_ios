//
//  cart_list.swift
//  Virtual Closeout
//
//  Created by Apple on 08/06/22.
//

import UIKit
import Alamofire
import SDWebImage

class cart_list: UIViewController {

    var arr_mut_cart_list:NSMutableArray! = []
    
    var str_cart_sub_total:String = "0"
    var str_cart_total:String = "0"
    
    var arr_save_cart_product_list:NSMutableArray! = []
    
    var str_checkout_button_hide:String! = "0"
    
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
    
    @IBOutlet weak var buy_product_now:UIButton! {
        didSet {
            buy_product_now.backgroundColor = button_dark
            buy_product_now.setTitle("Buy product now", for: .normal)
            buy_product_now.setTitleColor(.white , for: .normal)
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "Cart"
            lblNavigationTitle.textColor = .white
        }
    }
    
    // ***************************************************************** // nav
    
    @IBOutlet weak var lblShippingPriceIs:UILabel!
    @IBOutlet weak var lblSubTotal:UILabel!
    
    @IBOutlet weak var lblFinalTotalPrice:UILabel!
    
    @IBOutlet weak var btnCheckOut:UIButton! {
        didSet {
            btnCheckOut.setTitleColor(.white, for: .normal)
            // btnCheckOut.layer.cornerRadius = 12
            // btnCheckOut.clipsToBounds = true
            
            btnCheckOut.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            btnCheckOut.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            btnCheckOut.layer.shadowOpacity = 1.0
            btnCheckOut.layer.shadowRadius = 15.0
            btnCheckOut.layer.masksToBounds = false
            btnCheckOut.layer.cornerRadius = 12
            btnCheckOut.backgroundColor = .white// navigation_color
        }
    }
    
    // MARK:- TABLE VIEW -
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            // self.tbleView.delegate = self
            // self.tbleView.dataSource = self
            self.tbleView.backgroundColor = .clear
            self.tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.init(red: 234.0/255.0, green: 234.0/255.0, blue: 238.0/255.0, alpha: 1)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.btnBack.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        
        self.my_Cart_list_WB(str_loader: "yes")
        
        self.manage_profile(self.btnBack)
    }
    
    // MARK: - PUSH ( CHECK OUT ) -
    @objc func check_out_click_method() {
        
        print(self.arr_mut_cart_list as Any)
        
        /*
         if let person = UserDefaults.standard.value(forKey: key_user_default_value) as? [String:Any] {
             let x : Int = (person["userId"] as! Int)
             let myString = String(x)
         */
        /* seller
         productId = 44;
         productImage = "https://demo2.evirtualservices.co/virtual-closeout/site/img/uploads/product/16563201301656320128.400356.jpeg";
         productName = "Tiger Biscuit";
         productPrice = 20;
         productSKU = "";
         productTotalQuatiity = 40;
         productsalePrice = 19;
         quantity = 1;
         userId = 6;
         */
        
        if let person = UserDefaults.standard.value(forKey: key_user_default_value) as? [String:Any] {
            
            let arr_mut_save:NSMutableArray! = []
            
            for indexx in 0..<self.arr_mut_cart_list.count {
                let item = self.arr_mut_cart_list[indexx] as? [String:Any]
                
                let create_custom_dict = ["ownerId"     : "\(item!["sellerId"]!)",
                                          "productId"   : "\(item!["productId"]!)",
                                          "price"       : "\(item!["productsalePrice"]!)",
                                          "Quantity"    : "\(item!["quantity"]!)"]
                
                arr_mut_save.add(create_custom_dict)
                                
            }

            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "address_id") as? address
            push!.str_i_am_from = "cart"
            
            push!.arr_mut_get_product_details_address = arr_mut_save
            push!.str_final_amount = String(self.str_cart_total)
            
            self.navigationController?.pushViewController(push!, animated: true)
        }
    }
    
    // MARK: - ADD ONE ITEM -
    @objc func add_item_click_method(_ sender:UIButton) {
        
        let btn_add:UIButton = sender

        let item = self.arr_mut_cart_list[btn_add.tag-1] as? [String:Any]
        
        // compare quantity
        var product_total_quantity:String! = "0"
        
        // productTotalQuatiity
        if "\(item!["productTotalQuatiity"]!)" == "" {
            product_total_quantity = "1"
        } else {
            product_total_quantity = "\(item!["productTotalQuatiity"]!)"
        }
        
        // user quantity
        var product_user_quantity:String!
        
        product_user_quantity = "\(item!["quantity"]!)"
        
        print("total ======>",String(product_total_quantity))
        print("user ======>",String(product_user_quantity))
        
        //if String(product_total_quantity)>String(product_user_quantity) {
            print("===========> EXIST <===========")
            
            let myInt1 = Int(product_user_quantity)!+1
            print(myInt1 as Any)
            
            self.add_to_cart_WB(str_quantity: "\(myInt1)",
                                str_product_id: "\(item!["productId"]!)")
            
        /*} else {
            print("===========> INVALID <===========")

        }*/
    }
    
    // MARK: - MINUS ONE ITEM -
    @objc func minus_item_click_method(_ sender:UIButton) {
        
        let btn_add:UIButton = sender
        
        let item = self.arr_mut_cart_list[btn_add.tag-1] as? [String:Any]
        
        // user quantity
        var product_user_quantity:String!
        
        product_user_quantity = "\(item!["quantity"]!)"
        
        let myInt1 = Int(product_user_quantity)!-1
            
        if "\(myInt1)" == "0" {
            
            self.delete_cart_WB(str_product_id: "\(item!["productId"]!)")
            
        } else {
            
            self.add_to_cart_WB(str_quantity: "\(myInt1)",
                                str_product_id: "\(item!["productId"]!)")
        }
        
    }
    
    // MARK: - ADD TO CART -
    @objc func add_to_cart_WB(str_quantity:String , str_product_id:String) {
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        if let person = UserDefaults.standard.value(forKey: key_user_default_value) as? [String:Any] {
            // let str:String = person["role"] as! String
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let params = cart_list_params(action: "addcart",
                                          userId: String(myString),
                                          quantity: String(str_quantity),
                                          productId: String(str_product_id))
            
            
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
                        
                        self.my_Cart_list_WB(str_loader: "no")
                        
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
    
    // MARK: - MY CART LIST -
    @objc func my_Cart_list_WB(str_loader:String) {
        
        self.arr_mut_cart_list.removeAllObjects()
        
        self.view.endEditing(true)
        
        if str_loader == "yes" {
            ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        }
        
        
        
        if let person = UserDefaults.standard.value(forKey: key_user_default_value) as? [String:Any] {
            // let str:String = person["role"] as! String
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let params = get_cart_params(action: "getcarts",
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
                        
                        var ar : NSArray!
                        ar = (JSON["data"] as! Array<Any>) as NSArray
                        
                        if ar.count == 0 {
                            
                            self.tbleView.isHidden = true
                            self.str_checkout_button_hide = "0"
                            
                        } else {
                         
                            self.tbleView.isHidden = false
                            self.str_checkout_button_hide = "1"
                            
                            self.arr_mut_cart_list.addObjects(from: ar as! [Any])
                            
                            var product_total_quantity :String!
                            var total_sum = Double(0.0)
                            
                            for indexx in 0..<self.arr_mut_cart_list.count {
                                
                                let item = self.arr_mut_cart_list[indexx] as? [String:Any]
                                 print(item as Any)

                                if "\(item!["productTotalQuatiity"]!)" == "" {
                                    product_total_quantity = "1"
                                } else {
                                    product_total_quantity = "\(item!["quantity"]!)"
                                }
                                
                                print("\(item!["productsalePrice"]!)")
                                print(product_total_quantity as Any)
                                
                                let add_total_with_quantity = Double("\(item!["productsalePrice"]!)")!*Double(product_total_quantity)!
                                let formatted_add_total_with_quantity = String(format: "%.2f", add_total_with_quantity)
                                
                                
                                print("PP with q =======>",formatted_add_total_with_quantity as Any)
                                
                                
                                total_sum = total_sum+Double(formatted_add_total_with_quantity)!
                                let formatted_total_sum = String(format: "%.2f", total_sum)
                                print("final after add ======>",formatted_total_sum as Any)
                                
                                self.str_cart_sub_total = String(formatted_total_sum)
                            }
                            
                            // print(self.str_cart_sub_total as Any)
                            
                            
                            // shipping
                            let shipping_charge:String! = "0"
                            
                            // delivery
                            let delivery_charge:String! = "0"
                            
                            // add all to get total
                            let add_all_values_for_total = Double(self.str_cart_sub_total)!+Double(shipping_charge)!+Double(delivery_charge)!
                            let formatted_add_all_values_for_total = String(format: "%.2f", add_all_values_for_total)
                            self.str_cart_total = String(formatted_add_all_values_for_total)
                            
                            self.tbleView.delegate = self
                            self.tbleView.dataSource = self
                            self.tbleView.reloadData()
                            
                            
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
    
    // MARK: - DELETE CART -
    @objc func delete_cart_WB(str_product_id:String) {
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        if let person = UserDefaults.standard.value(forKey: key_user_default_value) as? [String:Any] {
            // let str:String = person["role"] as! String
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let params = delete_cart_item_params(action: "deletecarts",
                                             userId: String(myString),
                                                 productId: String(str_product_id))
            
            
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
                        
                        self.my_Cart_list_WB(str_loader: "no")
                        
                        // ERProgressHud.sharedInstance.hide()
                        
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
    
    // MARK: - CART CALCULATION -
    @objc func cart_calculation() {
        
        
        
    }
    
    
}


extension cart_list: UITableViewDataSource , UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr_mut_cart_list.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if indexPath.row == 0 {
            
            let cell:cart_list_table_cell = tableView.dequeueReusableCell(withIdentifier: "cart_list_table_cell_two") as! cart_list_table_cell
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            cell.backgroundColor = .clear
            
            if self.arr_mut_cart_list.count == 0 {
                cell.lbl_item_count.text = "Item"
            } else if self.arr_mut_cart_list.count == 1 {
                cell.lbl_item_count.text = "Item"
            } else {
                cell.lbl_item_count.text = "Items"
            }
            
            if self.str_checkout_button_hide ==  "0" {
            
                cell.btn_check_out.isHidden = true
                
            } else {
                
                cell.btn_check_out.isHidden = false
                cell.btn_check_out.addTarget(self, action: #selector(check_out_click_method), for: .touchUpInside)
            }
            
            // cell.lbl_sub_total.text = "$"+String(self.str_cart_sub_total)
            let bigNumber = Double("\(self.str_cart_sub_total)")
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .currency
            let formattedNumber = numberFormatter.string(from: bigNumber! as NSNumber)
            cell.lbl_sub_total.text = "\(formattedNumber!)"
            
            // cell.lbl_total.text = "$"+String(self.str_cart_total)
            let bigNumber_2 = Double("\(self.str_cart_total)")
            let numberFormatter_2 = NumberFormatter()
            numberFormatter_2.numberStyle = .currency
            let formattedNumber_2 = numberFormatter_2.string(from: bigNumber_2! as NSNumber)
            cell.lbl_total.text = "\(formattedNumber_2!)"
            
            return cell
            
        } else {
            
            let cell:cart_list_table_cell = tableView.dequeueReusableCell(withIdentifier: "cart_list_table_cell") as! cart_list_table_cell
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            cell.backgroundColor = .clear
            
            let item = self.arr_mut_cart_list[indexPath.row-1] as? [String:Any]
            print(item as Any)
            
            cell.lbl_product_name.text = (item!["productName"] as! String)
            
            // cell.lbl_price.text = "$\(item!["productsalePrice"]!)"
            let bigNumber_2 = Double("\(item!["productsalePrice"]!)")
            let numberFormatter_2 = NumberFormatter()
            numberFormatter_2.numberStyle = .currency
            let formattedNumber_2 = numberFormatter_2.string(from: bigNumber_2! as NSNumber)
            cell.lbl_price.text = "\(formattedNumber_2!)"
            
            cell.lbl_cart_count.text = "\(item!["quantity"]!)"
            
            if "\(item!["quantity"]!)" == "\(item!["productTotalQuatiity"]!)" {
                
                cell.btn_add_item.isHidden = true
            } else {
                
                cell.btn_add_item.isHidden = false
            }
            
            
            
            
            
            cell.img_product.backgroundColor = button_light
            cell.img_product.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            cell.img_product.sd_setImage(with: URL(string: (item!["productImage"] as! String)), placeholderImage: UIImage(named: "logo"))
            
            cell.btn_add_item.tag = indexPath.row
            cell.btn_add_item.addTarget(self, action: #selector(add_item_click_method), for: .touchUpInside)
            
            cell.btn_minus_item.tag = indexPath.row
            cell.btn_minus_item.addTarget(self, action: #selector(minus_item_click_method), for: .touchUpInside)
            
            return cell
            
        }
        
    }

    /*@objc func deleteCartFromItems(_ sender:UIButton) {
        
        let item = self.arrListOfAllMyOrders[sender.tag] as? [String:Any]
        // print(item as Any)
        
        let alert = UIAlertController(title: String("Delete Item"), message: String("Are you sure you want to delete.")+"' "+(item!["productName"] as! String)+" '"+" from your cart ?",
                                      
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes, Delete", style: .default, handler: { action in
             
            let x : Int = (item!["productId"] as! Int)
            let myString = String(x)
            
            self.deleteItemFromCart(strinproductId: myString)
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: { action in
             
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK:- DELETE ITEM FROM CART -
    @objc func deleteItemFromCart(strinproductId:String) {
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "deleting...")
            
        self.view.endEditing(true)
            
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
                
            let params = DeleteCart(action: "deletecarts",
                                    userId: String(myString),
                                    productId: String(strinproductId))
            
            AF.request(BASE_URL_LABOUR_DISPATCH,
                       method: .post,
                       parameters: params,
                       encoder: JSONParameterEncoder.default).responseJSON { response in
                        // debugPrint(response.result)
                        
                        switch response.result {
                        case let .success(value):
                            
                            let JSON = value as! NSDictionary
                            // print(JSON as Any)
                            
                            var strSuccess : String!
                            strSuccess = JSON["status"]as Any as? String
                            
                            // var strSuccess2 : String!
                            // strSuccess2 = JSON["msg"]as Any as? String
                            
                            if strSuccess == String("success") {
                                print("yes")
                                // ERProgressHud.sharedInstance.hide()
                               
                                let x : Int = JSON["totalCartItem"] as! Int
                                let myString = String(x)
                                
                                if myString == "0" {
                                    self.lblNavigationTitle.isHidden = true
                                } else if myString == "" {
                                    self.lblNavigationTitle.isHidden = true
                                } else {
                                    self.lblNavigationTitle.isHidden = false
                                    self.lblNavigationTitle.text = "My Cart ("+String(myString)+")"
                                }
                                 
                                
                                self.totalItemsInCart()
                                
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
                            
                            Utils.showAlert(alerttitle: SERVER_ISSUE_TITLE, alertmessage: SERVER_ISSUE_MESSAGE, ButtonTitle: "Ok", viewController: self)
                        }
                }
            
            }
    }*/
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        if indexPath.row == 0 {
            return 224
        } else {
            return 134
        }
        
    }
    
}

class cart_list_table_cell: UITableViewCell {

    @IBOutlet weak var img_product:UIImageView! {
        didSet {
            /*img_product.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            img_product.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            img_product.layer.shadowOpacity = 1.0
            img_product.layer.shadowRadius = 15.0
            img_product.layer.masksToBounds = false
            img_product.layer.cornerRadius = 12*/
            img_product.layer.cornerRadius = 8
            img_product.clipsToBounds = true
            img_product.backgroundColor = .brown
            img_product.layer.borderColor = button_dark.cgColor
            img_product.layer.borderWidth = 1
        }
    }
    
    @IBOutlet weak var view_cell_bg:UIView! {
        didSet {
            /*view_cell_bg.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_cell_bg.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            view_cell_bg.layer.shadowOpacity = 1.0
            view_cell_bg.layer.shadowRadius = 15.0
            view_cell_bg.layer.masksToBounds = false*/
            view_cell_bg.layer.cornerRadius = 4
            view_cell_bg.clipsToBounds = true
            view_cell_bg.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var lbl_product_name:UILabel! {
        didSet {
            lbl_product_name.textColor = .black
            lbl_product_name.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var lbl_price:UILabel! {
        didSet {
            lbl_price.textColor = .black
            lbl_price.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var lbl_cart_count:UILabel! {
        didSet {
            lbl_cart_count.textColor = .black
            lbl_cart_count.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var lbl_item_count:UILabel! {
        didSet {
            lbl_item_count.textColor = .black
            lbl_item_count.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var btn_delete:UIButton! {
        didSet {
            btn_delete.setTitleColor(.black, for: .normal)
            btn_delete.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var btn_add_item:UIButton! {
        didSet {
            btn_add_item.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            btn_add_item.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            btn_add_item.layer.shadowOpacity = 1.0
            btn_add_item.layer.shadowRadius = 10
            btn_add_item.layer.masksToBounds = false
            btn_add_item.layer.cornerRadius = 17
            btn_add_item.clipsToBounds = false
            btn_add_item.backgroundColor = .black
        }
    }
    
    @IBOutlet weak var btn_minus_item:UIButton! {
        didSet {
            btn_minus_item.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            btn_minus_item.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            btn_minus_item.layer.shadowOpacity = 1.0
            btn_minus_item.layer.shadowRadius = 15.0
            btn_minus_item.layer.masksToBounds = false
            btn_minus_item.layer.cornerRadius = 17
            btn_minus_item.clipsToBounds = false
            btn_minus_item.backgroundColor = .clear
            btn_minus_item.layer.borderColor = UIColor.black.cgColor
            btn_minus_item.layer.borderWidth = 1
            btn_minus_item.setTitleColor(.black, for: .normal)
        }
    }
    
    @IBOutlet weak var lbl_sub_total:UILabel! {
        didSet {
            lbl_sub_total.textColor = .black
            lbl_sub_total.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var lbl_shipping:UILabel! {
        didSet {
            lbl_shipping.textColor = .black
            lbl_shipping.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var lbl_delivery_charge:UILabel! {
        didSet {
            lbl_delivery_charge.textColor = .black
            lbl_delivery_charge.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var lbl_total:UILabel! {
        didSet {
            lbl_total.textColor = .black
            lbl_total.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var btn_check_out:UIButton! {
        didSet {
            btn_check_out.backgroundColor = button_light
            btn_check_out.setTitle("Checkout", for: .normal)
            btn_check_out.tintColor = .black
            btn_check_out.setImage(UIImage(systemName: "arrow.right"), for: .normal)
            btn_check_out.setTitleColor(.black, for: .normal)
            btn_check_out.layer.cornerRadius = 23
            btn_check_out.clipsToBounds = true
            
            btn_check_out.layer.borderColor = button_dark.cgColor
            btn_check_out.layer.borderWidth = 1
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
