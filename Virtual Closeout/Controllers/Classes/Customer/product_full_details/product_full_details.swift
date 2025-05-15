//
//  product_full_details.swift
//  Virtual Closeout
//
//  Created by Apple on 07/06/22.
//

import UIKit
//import PaddingLabel
import MapKit
import Alamofire
import SDWebImage

class product_full_details: UIViewController {
    
    var get_product_id:String!
    
    var arr_mut_save_images:NSMutableArray! = []
    var dict_save_full_data:NSDictionary!
    
    var str_user_clicked_on_which_image:String! = ""
    
    var set_quantity:String! = "0"
    
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
    
    @IBOutlet weak var btn_cart:UIButton! {
        didSet {
            btn_cart.tintColor = .white
            btn_cart.isHidden = true
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
            lblNavigationTitle.text = "Product details"
            lblNavigationTitle.textColor = .white
        }
    }
    
    
    // ***************************************************************** // nav
    
    @IBOutlet weak var tablView:UITableView! {
        didSet {
            
            tablView.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var lbl_cart_count:UILabel! {
        didSet {
            lbl_cart_count.textColor = .black
            lbl_cart_count.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.btnBack.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        self.buy_product_now.addTarget(self, action: #selector(buy_product_click_method), for: .touchUpInside)
        
        self.btn_cart.addTarget(self, action: #selector(cart_click_method), for: .touchUpInside)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.product_details_WB()
        
    }
    
    @objc func cart_click_method() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "cart_list_id")
        self.navigationController?.pushViewController(push, animated: true)
        
    }
    
    @objc func buy_product_click_method() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "cart_list_id")
        self.navigationController?.pushViewController(push, animated: true)
        
    }
    
    // MARK: - WEBSERVICE - ( PRODUCT DETAILS ) -
    @objc func product_details_WB() {
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        if let person = UserDefaults.standard.value(forKey: key_user_default_value) as? [String:Any] {
            // let str:String = person["role"] as! String
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let params = product_details(action: "productdetail",
                                         userId: String(myString),
                                         productId: String(self.get_product_id))
            
            
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
                        
                        var dict: Dictionary<AnyHashable, Any>
                        dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                        
                        self.dict_save_full_data = dict as NSDictionary
                        
                        // image 1
                        if (dict["image_1"] as! String) != "" {
                            self.arr_mut_save_images.add(dict["image_1"] as! String)
                        }
                        
                        // image 2
                        if (dict["image_2"] as! String) != "" {
                            self.arr_mut_save_images.add(dict["image_2"] as! String)
                        }
                        
                        // image 3
                        if (dict["image_3"] as! String) != "" {
                            self.arr_mut_save_images.add(dict["image_3"] as! String)
                        }
                        
                        // image 4
                        if (dict["image_4"] as! String) != "" {
                            self.arr_mut_save_images.add(dict["image_4"] as! String)
                        }
                        
                        // image 5
                        if (dict["image_5"] as! String) != "" {
                            self.arr_mut_save_images.add(dict["image_5"] as! String)
                        }
                        
                        print(self.arr_mut_save_images as Any)
                        
                        self.my_Cart_list_WB()

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
    
    // MARK: - PUSH ( CHAT ROOM ) -
    @objc func go_to_chat_room_click_method() {
        
        /*
         var get_details_product_name:String!
         var get_details_price:String!
         var get_details_color:String!
         var get_details_category:String!
         var get_details_sub_category:String!
         
         
         */
        //
        
         // print(self.dict_save_full_data as Any)
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "chat_room_id") as? chat_room
        
        push!.str_get_new_receiver_id = "\(self.dict_save_full_data["sellerId"]!)"
        push!.str_get_new_receiver_name = (self.dict_save_full_data["sellerName"] as! String)
        push!.str_get_new_receiver_image = (self.dict_save_full_data["sellerImage"] as! String)
        
        push!.get_details_product_name = (self.dict_save_full_data["productName"] as! String)
        push!.get_details_price = "\(self.dict_save_full_data["salePrice"]!)"
        push!.get_details_color = (self.dict_save_full_data["color"] as! String)
        push!.get_details_category = (self.dict_save_full_data["categoryName"] as! String)
        push!.get_details_sub_category = (self.dict_save_full_data["subCategoryName"] as! String)
        
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    
    
    // MARK: - ADD -
    @objc func add_item_click_method(_ sender:UIButton) {
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! product_full_details_table_cell
        
        
        if "\(self.dict_save_full_data["quantity"]!)" != String(self.set_quantity) {
            
            // add one
            let minus_one_with_total_quantity = String(self.set_quantity)
            let myInt1 = Int(minus_one_with_total_quantity)!+1
            print(myInt1 as Any)
            
            self.set_quantity = "\(myInt1)"
            
            cell.lbl_item_count.text = String(self.set_quantity)
            
            self.tablView.reloadData()
            
        }
           
    }
    
    // MARK: - MINUS -
    @objc func minus_item_click_method(_ sender:UIButton) {
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tablView.cellForRow(at: indexPath) as! product_full_details_table_cell
        
        if "\(self.dict_save_full_data["quantity"]!)" != "" || "\(self.dict_save_full_data["quantity"]!)" != "0" {
         
            if String(self.set_quantity) != "0" {
                
                // minus one
                let minus_one_with_total_quantity = String(self.set_quantity)
                let myInt1 = Int(minus_one_with_total_quantity)!-1
                // print(myInt1 as Any)
                
                self.set_quantity = "\(myInt1)"
                
                cell.lbl_item_count.text = String(self.set_quantity)
                
                self.tablView.reloadData()
                
            }
            
            
        }
        
    }
    
    
    
    @objc func buy_now_click_method() {
        // let indexPath = IndexPath.init(row: 0, section: 0)
        // let cell = self.tablView.cellForRow(at: indexPath) as! product_full_details_table_cell
        
        // print(self.set_quantity as Any)
        
        if String(self.set_quantity) == "0" {
            
            let alert = NewYorkAlertController(title: String("Alert"), message: String("Quantity should be greater then 0"), style: .alert)
            let dismiss = NewYorkButton(title: "dismiss", style: .default)
            alert.addButtons([dismiss])
            self.present(alert, animated: true)
            
        } else {
            
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "buy_now_id") as? buy_now
            
            push!.quantity_user_select = String(self.set_quantity)
            push!.dict_get_product_data = self.dict_save_full_data
            
            /*print(self.dict_save_full_data as Any)
            
            /*// price
            if dictGetProductDetails!["price"] is String {
                print("Yes, it's a String")

                push!.productPrice = (dictGetProductDetails!["price"] as! String)

            } else if dictGetProductDetails!["price"] is Int {
                print("It is Integer")
                            
                let x2 : Int = (dictGetProductDetails!["price"] as! Int)
                let myString2 = String(x2)
                push!.productPrice = myString2
                
            } else {
                print("i am number")
                            
                let temp:NSNumber = dictGetProductDetails!["price"] as! NSNumber
                let tempString = temp.stringValue
                push!.productPrice = tempString
                
             }*/
            
            
            
            
            // product name
            push!.productDetails = (dict_save_full_data!["productName"] as! String)
            // +"\n"+(dictGetProductDetails!["cateroryName"] as! String)
            
            // product image
            push!.productImage = (dict_save_full_data!["image"] as! String)
            
            // shipping charge
            push!.productShipping = "0" // (dictGetProductDetails!["image"] as! String)
            
            // product id
            /*let x233 : Int = (dictGetProductDetails!["productId"] as! Int)
            let myString233 = String(x233)
            push!.productId = myString233*/
            
            // quantity
            push!.productQuantity = String(self.set_quantity)
            
            // phone number
            
            
            /*// sub total
            if dictGetProductDetails!["price"] is String {
                print("Yes, it's a String")

                push!.productSubTotal = (dictGetProductDetails!["price"] as! String)

            } else if dictGetProductDetails!["price"] is Int {
                print("It is Integer")
                            
                let x2 : Int = (dictGetProductDetails!["price"] as! Int)
                let myString2 = String(x2)
                push!.productSubTotal = myString2
                
            } else {
                print("i am number")
                            
                let temp:NSNumber = dictGetProductDetails!["price"] as! NSNumber
                let tempString = temp.stringValue
                push!.productSubTotal = tempString
                
             }*/
            
            push!.productCategoryNamee = (self.dict_save_full_data["productName"] as! String)
            */
            
            self.navigationController?.pushViewController(push!, animated: true)
            
        }
        
    }
    
    @objc func add_to_cart_click_method() {
        // let indexPath = IndexPath.init(row: 0, section: 0)
        // let cell = self.tablView.cellForRow(at: indexPath) as! product_full_details_table_cell
        
        // print(self.set_quantity as Any)
        
        if String(self.set_quantity) == "0" {
            
            let alert = NewYorkAlertController(title: String("Alert"), message: String("Quantity should be greater then 0"), style: .alert)
            let dismiss = NewYorkButton(title: "dismiss", style: .default)
            alert.addButtons([dismiss])
            self.present(alert, animated: true)
            
        } else {
            
            self.add_to_cart_WB()
            
        }
        
    }
    
    // MARK: - MY CART LIST -
    @objc func my_Cart_list_WB() {
        
        self.view.endEditing(true)
        // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
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
                        
                        if "\(JSON["TotalCartItem"]!)" == "0" || "\(JSON["TotalCartItem"]!)" == "" {
                            
                            self.lbl_cart_count.isHidden = true
                            self.btn_cart.isHidden = true
                            
                        } else {
                            
                            self.lbl_cart_count.textColor = .white
                            self.lbl_cart_count.text = "\(JSON["TotalCartItem"]!)"
                            self.lbl_cart_count.isHidden = false
                            self.btn_cart.isHidden = false
                            
                        }
                        
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
    
    // MARK: - ADD TO CART -
    @objc func add_to_cart_WB() {
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        if let person = UserDefaults.standard.value(forKey: key_user_default_value) as? [String:Any] {
            // let str:String = person["role"] as! String
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let params = cart_list_params(action: "addcart",
                                          userId: String(myString),
                                          quantity: String(self.set_quantity),
                                          productId: "\(self.dict_save_full_data["productId"]!)")
            
            
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
                        
                        if "\(JSON["totalCartItem"]!)" == "0" || "\(JSON["totalCartItem"]!)" == "" {
                            
                            self.lbl_cart_count.isHidden = true
                            self.btn_cart.isHidden = true
                            
                        } else {
                            
                            self.lbl_cart_count.textColor = .white
                            self.lbl_cart_count.text = "\(JSON["totalCartItem"]!)"
                            self.lbl_cart_count.isHidden = false
                            self.btn_cart.isHidden = false
                            
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
extension product_full_details: UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:product_full_details_table_cell = tableView.dequeueReusableCell(withIdentifier: "product_full_details_table_cell") as! product_full_details_table_cell
        
        cell.backgroundColor = .clear
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        cell.img_full_view.backgroundColor = button_light
        
        if self.str_user_clicked_on_which_image == "" {
            cell.collectionView.dataSource = self
            cell.collectionView.delegate = self
            
            cell.img_full_view.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            cell.img_full_view.sd_setImage(with: URL(string: self.arr_mut_save_images[0] as! String), placeholderImage: UIImage(named: "logo"))
            
        } else {
            
            cell.img_full_view.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            cell.img_full_view.sd_setImage(with: URL(string: self.str_user_clicked_on_which_image), placeholderImage: UIImage(named: "logo"))
            
        }
        
        if ("\(self.dict_save_full_data["wishlist"]!)" == "0"){
            cell.btnHeart.setImage(UIImage(systemName: "heart"), for: .normal)
            cell.btnHeart.tintColor = .systemRed
        } else {
            cell.btnHeart.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            cell.btnHeart.tintColor = .systemRed
        }
        
        // product name
        cell.lbl_title.text = (self.dict_save_full_data["productName"] as! String)
        self.lblNavigationTitle.text = (self.dict_save_full_data["productName"] as! String)
        
        // product price
        let bigNumber = Double("\(self.dict_save_full_data["salePrice"]!)")
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        let formattedNumber = numberFormatter.string(from: bigNumber! as NSNumber)
        cell.lbl_price.text = "\(formattedNumber!)"
        
        // product new
        cell.lbl_new.text = (self.dict_save_full_data["categoryName"] as! String)
        
        // product automatic
        cell.lbl_automatic.text = (self.dict_save_full_data["subCategoryName"] as! String)
        
        // product regular
        cell.lbl_regular.text = (self.dict_save_full_data["conditions"] as! String)
        
        // posted
        cell.lbl_posted.text = "Posted on "+(self.dict_save_full_data["sellerRegistered"] as! String)
        
        // condition
        cell.lbl_condition.text = (self.dict_save_full_data["conditions"] as! String)
        
        // condition
        cell.lbl_condition.text = (self.dict_save_full_data["conditions"] as! String)
        
        // category
        cell.lbl_category.text = (self.dict_save_full_data["categoryName"] as! String)
        
        // seller profile image
        cell.img_profile.backgroundColor = button_light
        cell.img_profile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        cell.img_profile.sd_setImage(with: URL(string: (self.dict_save_full_data["sellerImage"] as! String)), placeholderImage: UIImage(named: "logo"))
        
        // seller name
        cell.lbl_profile_name.text = (self.dict_save_full_data["sellerName"] as! String)
        
        // seller rating
        if "\(self.dict_save_full_data["sellerRating"]!)" == "1" {
            
            cell.btn_star_one.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.btn_star_two.setImage(UIImage(systemName: "star"), for: .normal)
            cell.btn_star_three.setImage(UIImage(systemName: "star"), for: .normal)
            cell.btn_star_four.setImage(UIImage(systemName: "star"), for: .normal)
            cell.btn_star_five.setImage(UIImage(systemName: "star"), for: .normal)
            
        } else if "\(self.dict_save_full_data["sellerRating"]!)" == "2" {
            
            cell.btn_star_one.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.btn_star_two.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.btn_star_three.setImage(UIImage(systemName: "star"), for: .normal)
            cell.btn_star_four.setImage(UIImage(systemName: "star"), for: .normal)
            cell.btn_star_five.setImage(UIImage(systemName: "star"), for: .normal)
            
        } else if "\(self.dict_save_full_data["sellerRating"]!)" == "3" {
            
            cell.btn_star_one.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.btn_star_two.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.btn_star_three.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.btn_star_four.setImage(UIImage(systemName: "star"), for: .normal)
            cell.btn_star_five.setImage(UIImage(systemName: "star"), for: .normal)
            
        } else if "\(self.dict_save_full_data["sellerRating"]!)" == "4" {
            
            cell.btn_star_one.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.btn_star_two.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.btn_star_three.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.btn_star_four.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.btn_star_five.setImage(UIImage(systemName: "star"), for: .normal)
            
        } else if "\(self.dict_save_full_data["sellerRating"]!)" == "5" {
            
            cell.btn_star_one.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.btn_star_two.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.btn_star_three.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.btn_star_four.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.btn_star_five.setImage(UIImage(systemName: "star.fill"), for: .normal)
            
        } else {
            
            cell.btn_star_one.setImage(UIImage(systemName: "star"), for: .normal)
            cell.btn_star_two.setImage(UIImage(systemName: "star"), for: .normal)
            cell.btn_star_three.setImage(UIImage(systemName: "star"), for: .normal)
            cell.btn_star_four.setImage(UIImage(systemName: "star"), for: .normal)
            cell.btn_star_five.setImage(UIImage(systemName: "star"), for: .normal)
            
        }
        
        // lbl since
        cell.lbl_since.text = "Member since "+(self.dict_save_full_data["sellerRegistered"] as! String)
        
        // description
        cell.lbl_description.text = (self.dict_save_full_data["description"] as! String)
        
        // quantity
        cell.lbl_item_count.text = String(self.set_quantity)
        
        
        cell.btn_add_item.addTarget(self, action: #selector(add_item_click_method), for: .touchUpInside)
        
        cell.btn_minus_item.addTarget(self, action: #selector(minus_item_click_method), for: .touchUpInside)
        
        cell.btn_buy_now.addTarget(self, action: #selector(buy_now_click_method), for: .touchUpInside)
        cell.btn_add_to_cart.addTarget(self, action: #selector(add_to_cart_click_method), for: .touchUpInside)
        
        cell.btn_chat_text.addTarget(self, action: #selector(go_to_chat_room_click_method), for: .touchUpInside)
        cell.btn_ask.addTarget(self, action: #selector(go_to_chat_room_click_method), for: .touchUpInside)
        cell.btn_make_offer.addTarget(self, action: #selector(go_to_chat_room_click_method), for: .touchUpInside)
        
        
        // print(self.dict_save_full_data as Any)
        
        if let person = UserDefaults.standard.value(forKey: key_user_default_value) as? [String:Any] {
            
            if (person["role"] as! String) == "Seller" {
                
                if "\(self.dict_save_full_data["sellerId"]!)" == "\(person["userId"]!)" {
                    
                    print("=====> yes, i am the owner of this product <========")
                    
                    cell.btn_add_item.isHidden = true
                    cell.btn_minus_item.isHidden = true
                    cell.lbl_item_count.isHidden = true
                    cell.btn_buy_now.isHidden = true
                    cell.btn_add_to_cart.isHidden = true
                    
                } else {
                    
                    cell.btn_add_item.isHidden = false
                    cell.btn_minus_item.isHidden = false
                    cell.lbl_item_count.isHidden = false
                    cell.btn_buy_now.isHidden = false
                    cell.btn_add_to_cart.isHidden = false
                    
                }
                
                
            } else {
                
                
                
            }
            
        }
        
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
        
}

//MARK:- COLLECTION VIEW -
extension product_full_details: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.arr_mut_save_images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "product_full_details_collection_cell", for: indexPath as IndexPath) as! product_full_details_collection_cell
        
        // let item = self.arr_mut_save_images[indexPath.row] as? [String:Any]
        
        cell.img_product_image.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        cell.img_product_image.sd_setImage(with: URL(string: self.arr_mut_save_images[indexPath.row] as! String), placeholderImage: UIImage(named: "logo"))
        
        // cell.img_product_image.backgroundColor = .brown
        
        cell.backgroundColor  = .clear
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var sizes: CGSize
        let result = UIScreen.main.bounds.size
        NSLog("%f",result.height)
        sizes = CGSize(width: 98, height: 98)
        
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
        
        /*let result = UIScreen.main.bounds.size
         if result.height == 667.000000 { // 8
         return 2
         } else if result.height == 812.000000 { // 11 pro
         return 4
         } else {
         return 10
         }*/
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.str_user_clicked_on_which_image = (self.arr_mut_save_images[indexPath.row] as! String)

        print(self.str_user_clicked_on_which_image as Any)
        
        self.tablView.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
}

class product_full_details_table_cell:UITableViewCell {
    
    @IBOutlet weak var img_full_view:UIImageView! {
        didSet {
            img_full_view.backgroundColor = .brown
        }
    }
    
    // collection view
    @IBOutlet weak var collectionView:UICollectionView! {
        didSet {
            collectionView.backgroundColor = .clear
            // collectionView.dataSource = self
            // collectionView.delegate = self
        }
    }
    
    @IBOutlet weak var lbl_title:UILabel! {
        didSet {
            lbl_title.textColor = .black
        }
    }
    
    @IBOutlet weak var lbl_price:UILabel! {
        didSet {
            lbl_price.textColor = button_dark
        }
    }
    
    @IBOutlet weak var lbl_new:UILabel! {
        didSet {
            lbl_new.textColor = .black
            lbl_new.backgroundColor = .systemGray4
            lbl_new.layer.cornerRadius = 10
            lbl_new.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var lbl_automatic:UILabel! {
        didSet {
            lbl_automatic.textColor = .black
            lbl_automatic.backgroundColor = .systemGray4
            lbl_automatic.layer.cornerRadius = 10
            lbl_automatic.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var lbl_regular:UILabel! {
        didSet {
            lbl_regular.textColor = .black
            lbl_regular.backgroundColor = .systemGray4
            lbl_regular.layer.cornerRadius = 10
            lbl_regular.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var lbl_posted:UILabel! {
        didSet {
            lbl_posted.textColor = .black
        }
    }
    
    @IBOutlet weak var lbl_condition:UILabel! {
        didSet {
            lbl_condition.textColor = .black
        }
    }
    
    @IBOutlet weak var lbl_category:UILabel! {
        didSet {
            lbl_category.textColor = .black
        }
    }
    
    @IBOutlet weak var view_profile:UIView! {
        didSet {
            view_profile.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_profile.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            view_profile.layer.shadowOpacity = 1.0
            view_profile.layer.shadowRadius = 15.0
            view_profile.layer.masksToBounds = false
            view_profile.layer.cornerRadius = 15
            view_profile.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var img_profile:UIImageView! {
        didSet {
            img_profile.backgroundColor = .brown
            img_profile.layer.cornerRadius = 40
            img_profile.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var lbl_profile_name:UILabel! {
        didSet {
            lbl_profile_name.textColor = .black
        }
    }
    
    @IBOutlet weak var lbl_description:UILabel! {
        didSet {
            lbl_description.textColor = .black
        }
    }
    
    @IBOutlet weak var lbl_since:UILabel! {
        didSet {
            lbl_since.textColor = .black
        }
    }
    
    @IBOutlet weak var btn_save:UIButton! {
        didSet {
            btn_save.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            btn_save.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            btn_save.layer.shadowOpacity = 1.0
            btn_save.layer.shadowRadius = 15.0
            btn_save.layer.masksToBounds = false
            btn_save.layer.cornerRadius = 8
            btn_save.backgroundColor = .white
            btn_save.setTitle("Save", for: .normal)
        }
    }
    
    @IBOutlet weak var btn_report:UIButton! {
        didSet {
            btn_report.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            btn_report.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            btn_report.layer.shadowOpacity = 1.0
            btn_report.layer.shadowRadius = 15.0
            btn_report.layer.masksToBounds = false
            btn_report.layer.cornerRadius = 8
            btn_report.backgroundColor = .white
            btn_report.setTitle("Report", for: .normal)
        }
    }
    
    @IBOutlet weak var btn_share:UIButton! {
        didSet {
            btn_share.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            btn_share.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            btn_share.layer.shadowOpacity = 1.0
            btn_share.layer.shadowRadius = 15.0
            btn_share.layer.masksToBounds = false
            btn_share.layer.cornerRadius = 8
            btn_share.backgroundColor = .white
            btn_share.setTitle("Share", for: .normal)
        }
    }
    
    @IBOutlet weak var map_view:MKMapView! {
        didSet {
            map_view.layer.cornerRadius = 8
            map_view.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var btn_ask:UIButton! {
        didSet {
            btn_ask.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            btn_ask.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            btn_ask.layer.shadowOpacity = 1.0
            btn_ask.layer.shadowRadius = 15.0
            btn_ask.layer.masksToBounds = false
            btn_ask.layer.cornerRadius = 8
            btn_ask.backgroundColor = .white
            btn_ask.setTitle("Ask", for: .normal)
        }
    }
    
    @IBOutlet weak var btn_make_offer:UIButton! {
        didSet {
            btn_make_offer.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            btn_make_offer.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            btn_make_offer.layer.shadowOpacity = 1.0
            btn_make_offer.layer.shadowRadius = 15.0
            btn_make_offer.layer.masksToBounds = false
            btn_make_offer.layer.cornerRadius = 8
            btn_make_offer.backgroundColor = .white
            btn_make_offer.setTitle("Make offer", for: .normal)
        }
    }
    
    @IBOutlet weak var btn_star_one:UIButton! {
        didSet {
            btn_star_one.setTitle("", for: .normal)
        }
    }
    
    @IBOutlet weak var btn_star_two:UIButton! {
        didSet {
            btn_star_two.setTitle("", for: .normal)
        }
    }
    
    @IBOutlet weak var btn_star_three:UIButton! {
        didSet {
            btn_star_three.setTitle("", for: .normal)
        }
    }
    
    @IBOutlet weak var btn_star_four:UIButton! {
        didSet {
            btn_star_four.setTitle("", for: .normal)
        }
    }
    
    @IBOutlet weak var btn_star_five:UIButton! {
        didSet {
            btn_star_five.setTitle("", for: .normal)
        }
    }
    
    @IBOutlet weak var btn_chat_text:UIButton! {
        didSet {
            btn_chat_text.setTitle("Text me message for any question", for: .normal)
        }
    }
    
    @IBOutlet weak var lbl_item_count:UILabel! {
        didSet {
            lbl_item_count.textColor = .black
            lbl_item_count.backgroundColor = .clear
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
    
    @IBOutlet weak var btnHeart:UIButton!
    @IBOutlet weak var btnShare:UIButton!
    
    @IBOutlet weak var btn_buy_now:UIButton! {
        didSet {
            btn_buy_now.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            btn_buy_now.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            btn_buy_now.layer.shadowOpacity = 1.0
            btn_buy_now.layer.shadowRadius = 10
            btn_buy_now.layer.masksToBounds = false
            btn_buy_now.layer.cornerRadius = 17
            btn_buy_now.clipsToBounds = false
            btn_buy_now.backgroundColor = button_light
        }
    }
    
    @IBOutlet weak var btn_add_to_cart:UIButton! {
        didSet {
            btn_add_to_cart.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            btn_add_to_cart.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            btn_add_to_cart.layer.shadowOpacity = 1.0
            btn_add_to_cart.layer.shadowRadius = 10
            btn_add_to_cart.layer.masksToBounds = false
            btn_add_to_cart.layer.cornerRadius = 17
            btn_add_to_cart.clipsToBounds = false
            btn_add_to_cart.backgroundColor = button_light
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
    
}

class product_full_details_collection_cell: UICollectionViewCell {
    
    @IBOutlet weak var img_product_image:UIImageView! {
        didSet {
            img_product_image.layer.cornerRadius = 25
            img_product_image.clipsToBounds = true
            img_product_image.layer.borderWidth = 5
            img_product_image.layer.borderColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1).cgColor
        }
    }
    
    
    
}
