//
//  my_orders.swift
//  Virtual Closeout
//
//  Created by Apple on 27/06/22.
//

import UIKit
import Alamofire
import SDWebImage

class my_orders: UIViewController {
    
    var page : Int! = 1
    var loadMore : Int! = 1
    
    var arr_mut_order_history:NSMutableArray! = []
    
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
            lblNavigationTitle.text = "My history"
            lblNavigationTitle.textColor = .white
        }
    }
    
    
    // ***************************************************************** // nav
    
    // MARK:- TABLE VIEW -
    @IBOutlet weak var tble_view: UITableView! {
        didSet {
            tble_view.delegate = self
            tble_view.dataSource = self
            self.tble_view.backgroundColor = .white
            self.tble_view.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.btnBack.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        self.tble_view.separatorColor = .clear
        
        self.manage_profile(self.btnBack)
        
        self.order_history_WB(page_number: 1)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == self.tble_view {
            let isReachingEnd = scrollView.contentOffset.y >= 0
            && scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)
            if(isReachingEnd) {
                if(loadMore == 1) {
                    loadMore = 0
                    page += 1
                    print(page as Any)
                    
                    self.order_history_WB(page_number: page)
                    
                }
            }
        }
    }
    
     // MARK:- WEBSERVICE ( ORDER HISTORY DETAILS ) -
    @objc func order_history_WB(page_number:Int) {
         ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "please wait...")
             
         self.view.endEditing(true)
             
         if let person = UserDefaults.standard.value(forKey: key_user_default_value) as? [String:Any] {
             let x : Int = (person["userId"] as! Int)
             let myString = String(x)
                 
             let params = order_history_params(action: "purcheslist",
                                               userId: String(myString),
                                               userType: "Customer",
                                               status: "",
                                               pageNo: page_number)
             
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
                                  ERProgressHud.sharedInstance.hide()
                                
                                 
                                 var ar : NSArray!
                                 ar = (JSON["data"] as! Array<Any>) as NSArray
                                 self.arr_mut_order_history.addObjects(from: ar as! [Any])
                                 
                                 self.tble_view.delegate = self
                                 self.tble_view.dataSource = self
                                 self.tble_view.reloadData()
                                 self.loadMore = 1
                                 
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


extension my_orders: UITableViewDataSource , UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr_mut_order_history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell:my_orders_table_cell = tableView.dequeueReusableCell(withIdentifier: "my_orders_table_cell") as! my_orders_table_cell
          
        /*
         ShippingName = "Dishant Rajput";
         ShippingPhone = 8287632340;
         created = "2020-10-06 17:13:00";
         productDetails =             (
                             {
                 Quantity = 1;
                 price = 90;
                 productId = 13;
             },
                             {
                 Quantity = 5;
                 price = 30;
                 productId = 16;
             },
                             {
                 Quantity = 1;
                 price = 56;
                 productId = 14;
             },
                             {
                 Quantity = 2;
                 price = 34;
                 productId = 20;
             }
         );
         purcheseId = 47;
         shippingAddress = "Unnamed Road, Sector 6, Sector 10 Dwarka, Dwarka, Delhi, 110075, IndiaOk";
         shippingCity = Dwarka;
         shippingCountry = "";
         shippingState = Delhi;
         shippingZipcode = 110075;
         status = "";
         totalAmount = 364;
         transactionId = "";
         */
        
         let item = self.arr_mut_order_history[indexPath.row] as? [String:Any]
        // print(item as Any)
        
        let x222 : Int = (item!["purcheseId"] as! Int)
        let myString222 = String(x222)
        
        cell.lblTitle.text    = "Item "+"#"+myString222//(item!["ShippingName"] as! String)
        cell.lblCreatedAt.text    = (item!["created"] as! String)
        
        // total number of products
        var ar : NSArray!
        ar = (item!["productDetails"] as! Array<Any>) as NSArray
        
        let x22 : Int = (item!["totalAmount"] as! Int)
        let myString22 = String(x22)
        
        cell.lblQuantity.text = "Products : "+String(ar.count)
        cell.lblPrice.text = "Price : $ "+myString22
        cell.lblPrice.textColor = button_dark
        
        cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
        cell.imgProfile.sd_setImage(with: URL(string: (item!["productImage1"] as! String)), placeholderImage: UIImage(named: "logo"))
        
        // cell.accessoryType = .disclosureIndicator
        
        return cell
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
        let item = self.arr_mut_order_history[indexPath.row] as? [String:Any]
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "order_history_details_id") as? order_history_details
        
        push!.productId = "\(item!["purcheseId"]!)"
        
        self.navigationController?.pushViewController(push!, animated: true)
        
        /*let item = self.arrListOfAllMyOrders[indexPath.row] as? [String:Any]
        let x : Int = (item!["purcheseId"] as! Int)
        let myString = String(x)
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "order_history_details_id") as? order_history_details
        push!.productId = String(myString)
        self.navigationController?.pushViewController(push!, animated: true)*/
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        return 116
    }
    
}

class my_orders_table_cell: UITableViewCell {

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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
