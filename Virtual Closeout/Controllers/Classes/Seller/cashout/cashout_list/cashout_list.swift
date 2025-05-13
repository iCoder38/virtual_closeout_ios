//
//  cashout_list.swift
//  Bookit
//
//  Created by Apple on 02/03/22.
//

import UIKit
import Alamofire

class cashout_list: UIViewController {
    
    var arr_mut_cashout_history:NSMutableArray! = []
    
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
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "Cashout list"
        }
    }
    
    // ***************************************************************** // nav
    
    @IBOutlet weak var tablView:UITableView! {
        didSet {
            // self.tablView.delegate = self
            // self.tablView.dataSource = self
            tablView.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var lbl_no_Data_found:UILabel! {
        didSet {
            lbl_no_Data_found.text = "No cashout history found."
            lbl_no_Data_found.textColor = .white
            lbl_no_Data_found.isHidden = true
            lbl_no_Data_found.numberOfLines = 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        // self.manage_profile(self.btnBack)
        
        self.btnBack.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        self.btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
        self.cashout_history()
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*@objc func sideBarMenuClick() {
        
        let defaults = UserDefaults.standard
        defaults.setValue("", forKey: "keyBackOrSlide")
        defaults.setValue(nil, forKey: "keyBackOrSlide")
        
        if revealViewController() != nil {
            btnBack.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }*/
    
    @objc func cashout_history() {
        
        self.view.endEditing(true)
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            print(person as Any)
            
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
            let params = Virtual_Closeout.cashout_history(action:"cashoutlist",
                                                userId:String(myString),
                                                pageNo:"")
            
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
                        
                        self.arr_mut_cashout_history.addObjects(from: ar as! [Any])
                        
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
extension cashout_list: UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arr_mut_cashout_history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:cashout_list_table_cell = tableView.dequeueReusableCell(withIdentifier: "cashout_list_table_cell") as! cashout_list_table_cell
        
        cell.backgroundColor = .clear
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        let item = self.arr_mut_cashout_history[indexPath.row] as? [String:Any]
        cell.lbl_request_money.text = "$\(item!["requestAmount"]!)"
        cell.lbl_created_date.text = "\(item!["created"]!)"
        
        // lbl_status
        
        if (item!["sendDate"] as! String) == "" {
            
            cell.lbl_status.text = "Status : pending..."
            cell.lbl_status.textColor = .systemOrange
            
        } else {
            
            cell.lbl_status.text = "Status : Done"
            cell.lbl_status.textColor = .systemGreen
            
        }
        
        return cell
    }
    
    @objc func btnSignUpTapped() {
        
        /*let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddTableVC") as? AddTableVC
        self.navigationController?.pushViewController(settingsVCId!, animated: true)*/
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    
}

class cashout_list_table_cell:UITableViewCell {
    
    @IBOutlet weak var view_bg:UIView! {
        didSet {
            view_bg.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_bg.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            view_bg.layer.shadowOpacity = 1.0
            view_bg.layer.shadowRadius = 15.0
            view_bg.layer.masksToBounds = false
            view_bg.layer.cornerRadius = 15
            view_bg.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var lbl_request_money:UILabel! {
        didSet {
            lbl_request_money.textColor = .black
        }
    }
    
    @IBOutlet weak var lbl_created_date:UILabel! {
        didSet {
            lbl_created_date.textColor = .darkGray
        }
    }
    
    @IBOutlet weak var lbl_status:UILabel! {
        didSet {
            lbl_status.textColor = .black
        }
    }
    
}
