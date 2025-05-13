//
//  earnings.swift
//  Virtual Closeout
//
//  Created by Apple on 10/06/22.
//

import UIKit
import Alamofire
import SDWebImage

class earnings: UIViewController {
    
    var start_date:String!
    var end_date:String!
    
    var arr_mut_booking_history:NSMutableArray! = []
    
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
            lblNavigationTitle.text = "Earnings"
            lblNavigationTitle.textColor = .white
        }
    }

    // ***************************************************************** // nav
    
    @IBOutlet weak var lblTotalEarnig:UILabel! {
        didSet {
            lblTotalEarnig.text = ""
            lblTotalBooking.textColor = .white
        }
    }
    @IBOutlet weak var lblTotalBooking:UILabel! {
        didSet {
            lblTotalBooking.text = ""
            lblTotalBooking.textColor = .white
        }
    }
    
    @IBOutlet weak var view_payment_booking:UIView! {
        didSet {
            view_payment_booking.backgroundColor = navigation_color
            view_payment_booking.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_payment_booking.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            view_payment_booking.layer.shadowOpacity = 1.0
            view_payment_booking.layer.shadowRadius = 15.0
            view_payment_booking.layer.masksToBounds = false
            view_payment_booking.layer.cornerRadius = 8
            view_payment_booking.clipsToBounds = false
        }
    }
    
    @IBOutlet weak var txt_search:UITextField! {
        didSet {
            txt_search.keyboardType = .default
            
            txt_search.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            txt_search.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            txt_search.layer.shadowOpacity = 1.0
            txt_search.layer.shadowRadius = 15.0
            txt_search.layer.masksToBounds = false
            txt_search.layer.cornerRadius = 6
            txt_search.backgroundColor = .white
            txt_search.setLeftPaddingPoints(20)
            
            txt_search.attributedPlaceholder =
            NSAttributedString(string: "search seller here...", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
            
        }
    }
    
    @IBOutlet weak var btn_current_location:UIButton! {
        didSet {
            btn_current_location.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            btn_current_location.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            btn_current_location.layer.shadowOpacity = 1.0
            btn_current_location.layer.shadowRadius = 15.0
            btn_current_location.layer.masksToBounds = false
            btn_current_location.layer.cornerRadius = 6
            btn_current_location.backgroundColor = .white
            
        }
    }
    
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
        self.btnBack.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        
        // self.manage_profile(self.btnBack)
        
        self.my_club_earning_wb()
    }
    
    @objc func my_club_earning_wb() {
        
        self.view.endEditing(true)
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            print(person as Any)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let params = club_earning(action: "earning",
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
                        
                        // ERProgressHud.sharedInstance.hide()
                        
                        // total amount
                        var strSuccess2_total_amount : String!
                        strSuccess2_total_amount = "\(JSON["totalAmount"]!)"
                        
                        // total booking
                        var strSuccess2_booking : String!
                        strSuccess2_booking = "\(JSON["totalOrder"]!)"
                        
                        // print(strSuccess2_total_amount as Any)
                        // print(strSuccess2_booking as Any)
                        
                        let bigNumber = Double("\(String(strSuccess2_total_amount))")
                        let numberFormatter = NumberFormatter()
                        numberFormatter.numberStyle = .currency
                        let formattedNumber = numberFormatter.string(from: bigNumber! as NSNumber)
                        
                         self.lblTotalEarnig.text = "\(formattedNumber!)"
                         self.lblTotalBooking.text = String(strSuccess2_booking)
                        
                         self.filter_earning_wb()
                        
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
                    
                    self.please_check_your_internet_connection()
                }
            }
        }
    }
    
    @objc func filter_earning_wb() {
        
        self.view.endEditing(true)
        
        // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            print(person as Any)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let params = show_earnings_list(action: "bookinglistgroupby",
                                            userId: String(myString),
                                            completed: "Yes",
                                            startDate: String(self.start_date),
                                            endDate: String(self.end_date))
            
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
                        
                        self.arr_mut_booking_history.addObjects(from: ar as! [Any])
                        
                        // self.lbl_no_data_found.isHidden = true
                        self.tablView.isHidden = false
                        self.tablView.delegate = self
                        self.tablView.dataSource = self
                        self.tablView.reloadData()
                        
                        
                        
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


//MARK:- TABLE VIEW -
extension earnings: UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:earnings_table_cell = tableView.dequeueReusableCell(withIdentifier: "earnings_table_cell") as! earnings_table_cell
        
        cell.backgroundColor = .clear
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        cell.accessoryType = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        /*let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "browse_product_category_id")
        self.navigationController?.pushViewController(push, animated: true)*/
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
        
}

class earnings_table_cell:UITableViewCell {
    
    @IBOutlet weak var img_user_image:UIImageView! {
        didSet {
            img_user_image.layer.cornerRadius = 8
            img_user_image.clipsToBounds = true
            img_user_image.backgroundColor = .systemBrown
        }
    }
    
    @IBOutlet weak var lbl_product_name:UILabel! {
        didSet {
            lbl_product_name.textColor = .black
        }
    }
    
    @IBOutlet weak var lbl_color:UILabel! {
        didSet {
            lbl_color.textColor = .black
        }
    }
    
    @IBOutlet weak var lbl_price:UILabel! {
        didSet {
            lbl_price.textColor = .black
        }
    }
    
    @IBOutlet weak var btn_edit:UIButton! {
        didSet {
            btn_edit.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            btn_edit.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            btn_edit.layer.shadowOpacity = 1.0
            btn_edit.layer.shadowRadius = 15.0
            btn_edit.layer.masksToBounds = false
            btn_edit.layer.cornerRadius = 15
            btn_edit.backgroundColor = .white
            btn_edit.tintColor = .black
        }
    }
    
}
