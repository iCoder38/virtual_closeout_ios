//
//  seller_profile.swift
//  Virtual Closeout
//
//  Created by Apple on 28/06/22.
//

import UIKit
import Alamofire
import SDWebImage

class seller_profile: UIViewController {

    var str_seller_profile_id:String!
    var str_seller_image:String!
    var str_seller_name:String!
    var str_seller_address:String!
    
    var arr_mut_product_list:NSMutableArray! = []
    
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
            lblNavigationTitle.text = "Profile"
            lblNavigationTitle.textColor = .white
        }
    }
    
    // ***************************************************************** // nav
    
    @IBOutlet weak var img_profile:UIImageView! {
        didSet {
            img_profile.layer.cornerRadius = 12
            img_profile.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var lbl_seller_name:UILabel! {
        didSet {
            lbl_seller_name.textColor = .black
        }
    }
    
    @IBOutlet weak var lbl_seller_address:UILabel! {
        didSet {
            lbl_seller_address.textColor = .lightGray
        }
    }
    
    @IBOutlet weak var btn_view_all:UIButton! {
        didSet {
            btn_view_all.backgroundColor = .lightGray
            btn_view_all.layer.cornerRadius = 8
            btn_view_all.clipsToBounds = true
            btn_view_all.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            btn_view_all.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            btn_view_all.layer.shadowOpacity = 1.0
            btn_view_all.layer.shadowRadius = 15.0
            btn_view_all.layer.masksToBounds = false
            btn_view_all.layer.cornerRadius = 15
            btn_view_all.backgroundColor = .white
            btn_view_all.setTitle("view all", for: .normal)
            btn_view_all.setTitleColor(.black, for: .normal)
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
    
    @IBOutlet weak var starButton1: UIButton!
    @IBOutlet weak var starButton2: UIButton!
    @IBOutlet weak var starButton3: UIButton!
    @IBOutlet weak var starButton4: UIButton!
    @IBOutlet weak var starButton5: UIButton!
    
    @IBOutlet weak var lblShopName:UILabel!
    @IBOutlet weak var lblShopAddress:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.btnBack.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        
        self.btn_view_all.addTarget(self, action: #selector(view_all_click_method), for: .touchUpInside)
        
        self.get_seller_full_profile()
    }

    

    
    @objc func view_all_click_method() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "browse_product_images_id") as? browse_product_images
        
        push!.str_which_product_details = "yes_seller"
        push!.str_seller_id_for_product = String(self.str_seller_profile_id)
        
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    @objc func get_seller_full_profile() {
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "please wait...")
            
        self.view.endEditing(true)
             
            let params = check_profile_status(action: "profile",
                                              userId: String(self.str_seller_profile_id)
            )
            
            print(params)
            
            AF.request(APPLICATION_BASE_URL,
                       method: .post,
                       parameters: params,
                       encoder: JSONParameterEncoder.default).responseJSON { [self] response in
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
                                
                                var dict: Dictionary<AnyHashable, Any>
                                dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                                
                                self.img_profile.backgroundColor = .white
                                self.img_profile.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                                self.img_profile.sd_setImage(with: URL(string: (dict["image"] as! String)), placeholderImage: UIImage(named: "logo"))
                                
                                self.lbl_seller_name.text = (dict["fullName"] as! String)
                                self.lbl_seller_address.text = (dict["city"] as! String)+","+(dict["state"] as! String)+","+(dict["country"] as! String)
                                
                                // businessName = "New way electronics";
                                self.lblShopName.text = "\(dict["businessName"]!)"
                                self.lblShopAddress.text = (dict["city"] as! String)+","+(dict["state"] as! String)+","+(dict["country"] as! String)
                                
                                // stars
                                updateStars(ratingString: "\(dict["AVGRating"]!)")
                                
                                 self.seller_profile_WB()
                                
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
    
    func updateStars(ratingString: String) {
        guard let rating = Int(ratingString), rating >= 0 else {
            print("Invalid rating string")
            return
        }
        
        let starButtons = [starButton1, starButton2, starButton3, starButton4, starButton5]
        
        for (index, button) in starButtons.enumerated() {
            if index < rating {
                button?.setImage(UIImage(systemName: "star.fill"), for: .normal)
            } else {
                button?.setImage(UIImage(systemName: "star"), for: .normal)
            }
        }
    }

    
    @objc func seller_profile_WB() {
        // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "please wait...")
            
        self.view.endEditing(true)
             
            let params = seller_profile_params(action: "productlist",
                                               userId: String(self.str_seller_profile_id),
                                               pageNo: 1)
            
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
                                self.arr_mut_product_list.addObjects(from: ar as! [Any])
//
                                self.collectionView.delegate = self
                                self.collectionView.dataSource = self
                                self.collectionView.reloadData()
//                                self.loadMore = 1
                                
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

//MARK:- COLLECTION VIEW -
extension seller_profile: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.arr_mut_product_list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "seller_profile_collection_cell", for: indexPath as IndexPath) as! seller_profile_collection_cell
        
        cell.layer.cornerRadius = 25
        cell.clipsToBounds = true
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1).cgColor
        
         let item = self.arr_mut_product_list[indexPath.row] as? [String:Any]
        
         cell.img_product_image.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
         cell.img_product_image.sd_setImage(with: URL(string: (item!["image_1"] as! String)), placeholderImage: UIImage(named: "logo"))
        
        cell.lbl_project_name.text = (item!["productName"] as! String)
        
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
        sizes = CGSize(width: 194, height: 228)
        
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

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
}

class seller_profile_collection_cell: UICollectionViewCell {
    
    @IBOutlet weak var img_product_image:UIImageView! {
        didSet {
            img_product_image.layer.cornerRadius = 25
            img_product_image.clipsToBounds = true
            img_product_image.layer.borderWidth = 5
            img_product_image.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    @IBOutlet weak var lbl_project_name:UILabel! {
        didSet {
            lbl_project_name.textColor = .black
        }
    }
    
   

    
}
