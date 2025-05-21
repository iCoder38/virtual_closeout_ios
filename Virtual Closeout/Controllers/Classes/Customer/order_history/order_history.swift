//
//  order_history.swift
//  Virtual Closeout
//
//  Created by Apple on 08/06/22.
//

import UIKit
import Alamofire
import SDWebImage

class order_history: UIViewController {

    var page : Int! = 1
    var loadMore : Int! = 1
    
    var arr_mut_order_history:NSMutableArray! = []
    var strRole:String! = "Member"
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
            lblNavigationTitle.text = "Order history"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var btnFilter:UIButton! {
        didSet {
            btnFilter.isHidden = true
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
        
        self.btnFilter.addTarget(self, action: #selector(filter_click_method), for: .touchUpInside)
        
        self.tble_view.separatorColor = .clear
        
        self.manage_profile(self.btnBack)
        
        if let person = UserDefaults.standard.value(forKey: key_user_default_value) as? [String:Any] {
            print(person as Any)
             
            if (person["role"] as! String) == "Seller" {
                self.btnFilter.isHidden = false
                self.strRole = "Seller"
            } else {
                self.strRole = "Member"
            }
            
        }
        
        self.order_history_WB(page_number: 1)
    }

    @objc func filter_click_method() {
        
        let actionSheet = NewYorkAlertController(title: "Orders", message: nil, style: .actionSheet)
        
        // actionSheet.addImage(UIImage(named: "camera"))
        
        let cameraa = NewYorkButton(title: "Manage order", style: .default) { _ in
            print("Manage order")
            self.arr_mut_order_history.removeAllObjects()
            self.order_history_WB(page_number: 1)
            self.strRole = "Member"
        }
        
        let gallery = NewYorkButton(title: "My order", style: .default) { _ in
            print("My order")
            self.arr_mut_order_history.removeAllObjects()
            self.order_history_WB(page_number: 1)
            self.strRole = "Seller"
        }
        
        let cancel = NewYorkButton(title: "Cancel", style: .cancel)
        
        actionSheet.addButton(cameraa)
        actionSheet.addButton(gallery)
        actionSheet.addButton(cancel)
        
        present(actionSheet, animated: true)
        
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

        if let person = UserDefaults.standard.value(forKey: key_user_default_value) as? [String: Any],
           let userId = person["userId"] as? Int,
           let role = person["role"] as? String {

            let params = order_history_params(
                action: "purcheslist",
                userId: String(userId),
                userType: String(self.strRole),
                status: "",
                pageNo: page_number
            )

            print(params)

            AF.request(APPLICATION_BASE_URL,
                       method: .post,
                       parameters: params,
                       encoder: JSONParameterEncoder.default).responseJSON { response in
                switch response.result {
                case .success(let value):
                    guard let json = value as? [String: Any],
                          let status = json["status"] as? String else {
                        ERProgressHud.sharedInstance.hide()
                        return
                    }
                    print(response)
                    if status == "success" {
                        print("✅ Success response")
                        ERProgressHud.sharedInstance.hide()

                        print(json["response"])
                        
                        if let dataArray = json["response"] as? [AnyObject] {
                            self.arr_mut_order_history.addObjects(from: dataArray)

                            DispatchQueue.main.async {
                                self.tble_view.delegate = self
                                self.tble_view.dataSource = self
                                self.tble_view.reloadData()
                                self.loadMore = 1
                            }
                        } else {
                            print("⚠️ 'response' is not [AnyObject] or is missing.")
                        }


                    } else {
                        ERProgressHud.sharedInstance.hide()
                        let msg = json["msg"] as? String ?? "Unknown error"
                        Utils.showAlert(alerttitle: status, alertmessage: msg, ButtonTitle: "Ok", viewController: self)
                    }

                case .failure(let error):
                    print("❌ Error: \(error.localizedDescription)")
                    ERProgressHud.sharedInstance.hide()
                    // Optionally show alert here
                }
            }
        }

     }
}


extension order_history: UITableViewDataSource , UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr_mut_order_history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell:order_history_table_cell = tableView.dequeueReusableCell(withIdentifier: "order_history_table_cell") as! order_history_table_cell
          
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
        print(item as Any)
        
        let x222 : Int = (item!["purcheseId"] as! Int)
        let myString222 = String(x222)
        
        cell.lblTitle.text    = "\(item!["productName"]!)"
        cell.lblCreatedAt.text    = (item!["created"] as! String)
        
        // total number of products
        /*var ar : NSArray!
        ar = (item!["productDetails"] as! Array<Any>) as NSArray*/
        
        let x22 : Int = (item!["Amount"] as! Int)
        let myString22 = String(x22)
        
        cell.lblQuantity.text = "Quantity : \(item!["quantity"]!)"
        cell.lblPrice.text = "Price : $ "+myString22
        cell.lblPrice.textColor = button_dark
        
        if "\(item!["deliveryStatus"]!)" == "3" {
            cell.lblStatus.text = "Completed"
        } else {
            cell.lblStatus.text   = "In-Transit"
        }
        
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

class order_history_table_cell: UITableViewCell {

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
    @IBOutlet weak var lblStatus:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
