//
//  buy_now.swift
//  Virtual Closeout
//
//  Created by Apple on 14/06/22.
//

import UIKit
import SDWebImage

class buy_now: UIViewController {

    var productCategoryNamee:String!
    
    var productPhone:String!
    
    var productImage:String!
    var productDetails:String!
    var productQuantity:String!
    var productPrice:String!
    
    var productSubTotal:String!
    var productShipping:String!
    
    var productId:String!
    
    
    // save add to cart food
    var addInitialMutable:NSMutableArray = []
    
    var dict_get_product_data:NSDictionary!
    
    // NEW
    var quantity_user_select:String!
    
    var arr_mut_save_images:NSMutableArray! = []
    
    var str_user_clicked_on_which_image:String! = ""
    
    var str_save_sub_total:String! = ""
    var str_save_shipping_charge:String! = ""
    var str_save_delivery_charge:String! = ""
    var str_save_total_amount:String! = ""
    
    @IBOutlet weak var tble_view:UITableView! {
        didSet {
            tble_view.backgroundColor = .clear
        }
    }
    
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
            lblNavigationTitle.text = "Buy now"
            lblNavigationTitle.textColor = .white
        }
    }
    
    // ***************************************************************** // nav
    
    @IBOutlet weak var btnCheckOut:UIButton! {
        didSet {
            btnCheckOut.setTitle("CHECKOUT", for: .normal)
            btnCheckOut.setTitleColor(.white, for: .normal)
            btnCheckOut.backgroundColor = .systemGreen
            btnCheckOut.layer.cornerRadius = 6
            btnCheckOut.clipsToBounds = true
        }
    }
        
    @IBOutlet weak var imgProductImage:UIImageView! {
        didSet {
            imgProductImage.layer.cornerRadius = 6
            imgProductImage.clipsToBounds = true
            imgProductImage.backgroundColor = .brown
        }
    }
    
    @IBOutlet weak var lblProductDetails:UILabel!
    @IBOutlet weak var lblProductQuantityAndPrice:UILabel!
    @IBOutlet weak var lblShippingPriceIs:UILabel!
    @IBOutlet weak var lblSubTotal:UILabel!
    
    @IBOutlet weak var lblFinalTotalPrice:UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.init(red: 234.0/255.0, green: 234.0/255.0, blue: 238.0/255.0, alpha: 1)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.btnBack.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        
         self.show_saved_data()
    }
    
    @objc func show_saved_data() {
        
        print(self.dict_get_product_data as Any)
        
        // image 1
        if (self.dict_get_product_data["image_1"] as! String) != "" {
            self.arr_mut_save_images.add(self.dict_get_product_data["image_1"] as! String)
        }
        
        // image 2
        if (self.dict_get_product_data["image_2"] as! String) != "" {
            self.arr_mut_save_images.add(self.dict_get_product_data["image_2"] as! String)
        }
        
        // image 3
        if (self.dict_get_product_data["image_3"] as! String) != "" {
            self.arr_mut_save_images.add(self.dict_get_product_data["image_3"] as! String)
        }
        
        // image 4
        if (self.dict_get_product_data["image_4"] as! String) != "" {
            self.arr_mut_save_images.add(self.dict_get_product_data["image_4"] as! String)
        }
        
        // image 5
        if (self.dict_get_product_data["image_5"] as! String) != "" {
            self.arr_mut_save_images.add(self.dict_get_product_data["image_5"] as! String)
        }
        
        // print(self.arr_mut_save_images as Any)
        
        // calculation
        let multiply_quantity_with_price = Double(self.quantity_user_select)!*Double("\(self.dict_get_product_data["salePrice"]!)")!
        let formatted_multiply_quantity_with_price = String(format: "%.2f", multiply_quantity_with_price)
        self.str_save_sub_total = String(formatted_multiply_quantity_with_price)
        
        
        // calculate shipping charge
        let shipping_charge_is:String! = "0"
        self.str_save_shipping_charge = String(shipping_charge_is)
        
        // calculate delivery charge
        let delivery_charge_is:String! = "0"
        self.str_save_delivery_charge = String(delivery_charge_is)
        
        
        // calculate TOTAL
        let add_all_amounts = Double(formatted_multiply_quantity_with_price)!+Double(shipping_charge_is)!+Double(delivery_charge_is)!
        let formatted_add_all_amounts = String(format: "%.2f", add_all_amounts)
        self.str_save_total_amount = String(formatted_add_all_amounts)
        
        self.tble_view.delegate = self
        self.tble_view.dataSource = self
        self.tble_view.reloadData()
        
        
    }

    // MARK: - PUSH ( CHECK OUT ) -
    @objc func check_out_click_method() {
        
        if let person = UserDefaults.standard.value(forKey: key_user_default_value) as? [String:Any] {
            
            let arr_mut_save:NSMutableArray! = []
            
            // print(self.dict_get_product_data as Any)
            
            print(self.dict_get_product_data as Any)
            
            for _ in 0..<1 {
                // let item = self.arr_mut_cart_list[indexx] as? [String:Any]
                
                let create_custom_dict = ["ownerId"     : "\(self.dict_get_product_data!["sellerId"]!)",
                                          "productId"   : "\(self.dict_get_product_data!["productId"]!)",
                                          "price"       : String(self.str_save_total_amount),
                                          "Quantity"    : String(self.quantity_user_select)]
                
                arr_mut_save.add(create_custom_dict)
                                
            }
            
            print(arr_mut_save as Any)
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "address_id") as? address
            push!.str_i_am_from = "buy"
            
             // push!.arr_mut_get_product_details_address = arr_mut_save
            push!.str_final_amount = String(self.str_save_total_amount)
            
            // print(self.str_save_total_amount as Any)
            
            push!.arr_mut_get_product_details_address = arr_mut_save
            push!.str_final_amount = String(self.str_save_total_amount)
            
            self.navigationController?.pushViewController(push!, animated: true)
            
            
        }
        
    }
    
}

//MARK:- TABLE VIEW -
extension buy_now: UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell:buy_now_table_cell = tableView.dequeueReusableCell(withIdentifier: "buy_now_table_cell_one") as! buy_now_table_cell
            
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
            
            return cell
            
        } else if indexPath.row == 1 {
            
            let cell:buy_now_table_cell = tableView.dequeueReusableCell(withIdentifier: "buy_now_table_cell_two") as! buy_now_table_cell
            
            cell.backgroundColor = .clear
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            cell.lbl_product_name.text = (self.dict_get_product_data["productName"] as! String)
            
            return cell
            
        } else if indexPath.row == 2 {
            
            let cell:buy_now_table_cell = tableView.dequeueReusableCell(withIdentifier: "buy_now_table_cell_three") as! buy_now_table_cell
            
            cell.backgroundColor = .clear
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            cell.lbl_quantity.text = String(self.quantity_user_select)
            
            return cell
            
        } else if indexPath.row == 3 {
            
            let cell:buy_now_table_cell = tableView.dequeueReusableCell(withIdentifier: "buy_now_table_cell_four") as! buy_now_table_cell
            
            cell.backgroundColor = .clear
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            let bigNumber = Double("\(self.str_save_sub_total!)")
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .currency
            let formattedNumber = numberFormatter.string(from: bigNumber! as NSNumber)
            
            cell.lbl_sub_total.text = "\(formattedNumber!)"
            
            return cell
            
        } else if indexPath.row == 4 {
            
            let cell:buy_now_table_cell = tableView.dequeueReusableCell(withIdentifier: "buy_now_table_cell_five") as! buy_now_table_cell
            
            cell.backgroundColor = .clear
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            cell.lbl_shipping_charge.text = "$"+String(self.str_save_shipping_charge)
            
            return cell
            
        } else if indexPath.row == 5 {
            
            let cell:buy_now_table_cell = tableView.dequeueReusableCell(withIdentifier: "buy_now_table_cell_six") as! buy_now_table_cell
            
            cell.backgroundColor = .clear
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            cell.lbl_delivery_charge.text = "$"+String(self.str_save_delivery_charge)
            
            return cell
            
        } else if indexPath.row == 6 {
            
            let cell:buy_now_table_cell = tableView.dequeueReusableCell(withIdentifier: "buy_now_table_cell_seven") as! buy_now_table_cell
            
            cell.backgroundColor = .clear
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView

            let bigNumber = Double("\(self.str_save_total_amount!)")
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .currency
            let formattedNumber = numberFormatter.string(from: bigNumber! as NSNumber)
            cell.lbl_total_price.text = "\(formattedNumber!)"
            
            return cell
            
        } else if indexPath.row == 7 {
            
            let cell:buy_now_table_cell = tableView.dequeueReusableCell(withIdentifier: "buy_now_table_cell_eight") as! buy_now_table_cell
            
            cell.backgroundColor = .clear
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            cell.btn_check_out.addTarget(self, action: #selector(check_out_click_method), for: .touchUpInside)
            
            return cell
            
        } else {
            
            let cell:buy_now_table_cell = tableView.dequeueReusableCell(withIdentifier: "buy_now_table_cell_three") as! buy_now_table_cell
            
            cell.backgroundColor = .clear
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            cell.lbl_quantity.text = String(self.quantity_user_select)
            
            return cell
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "browse_product_images_id")
        self.navigationController?.pushViewController(push, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 450
        } else if indexPath.row == 7 {
            return 80
        } else {
            return 60
        }
    }
    
}

//MARK:- COLLECTION VIEW -
extension buy_now: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.arr_mut_save_images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "buy_now_collection_cell", for: indexPath as IndexPath) as! buy_now_collection_cell
        
        // let item = self.arr_mut_save_images[indexPath.row] as? [String:Any]
        
        cell.img_product_image.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        cell.img_product_image.sd_setImage(with: URL(string: self.arr_mut_save_images[indexPath.row] as! String), placeholderImage: UIImage(named: "logo"))
        
        cell.backgroundColor  = .clear
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var sizes: CGSize
        // let result = UIScreen.main.bounds.size
        // NSLog("%f",result.height)
        sizes = CGSize(width: 98, height: 98)
        
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
        
        self.str_user_clicked_on_which_image = (self.arr_mut_save_images[indexPath.row] as! String)
        // print(self.str_user_clicked_on_which_image as Any)
        self.tble_view.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
}

class buy_now_table_cell:UITableViewCell {
    
    @IBOutlet weak var img_full_view:UIImageView! {
        didSet {
            img_full_view.backgroundColor = button_light
        }
    }
    
    // collection view
    @IBOutlet weak var collectionView:UICollectionView! {
        didSet {
            collectionView.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var lbl_product_name:UILabel! {
        didSet {
            lbl_product_name.textColor = .black
        }
    }
    
    @IBOutlet weak var lbl_quantity:UILabel! {
        didSet {
            lbl_quantity.textColor = .black
        }
    }
    
    @IBOutlet weak var lbl_sub_total:UILabel! {
        didSet {
            lbl_sub_total.textColor = .black
        }
    }
    
    @IBOutlet weak var lbl_shipping_charge:UILabel! {
        didSet {
            lbl_shipping_charge.textColor = .black
        }
    }
    
    @IBOutlet weak var lbl_delivery_charge:UILabel! {
        didSet {
            lbl_delivery_charge.textColor = .black
        }
    }
    
    @IBOutlet weak var lbl_total_price:UILabel! {
        didSet {
            lbl_total_price.textColor = .black
        }
    }
    
    @IBOutlet weak var btn_check_out:UIButton! {
        didSet {
            btn_check_out.backgroundColor = button_light
            btn_check_out.setTitle("Checkout", for: .normal)
            btn_check_out.tintColor = .black
            btn_check_out.setImage(UIImage(systemName: "arrow.right"), for: .normal)
            btn_check_out.setTitleColor(.black, for: .normal)
            btn_check_out.layer.cornerRadius = 28
            btn_check_out.clipsToBounds = true
            
            btn_check_out.layer.borderColor = button_dark.cgColor
            btn_check_out.layer.borderWidth = 1
        }
    }
    
}

class buy_now_collection_cell: UICollectionViewCell {
    
    @IBOutlet weak var img_product_image:UIImageView! {
        didSet {
            img_product_image.layer.cornerRadius = 25
            img_product_image.clipsToBounds = true
            img_product_image.layer.borderWidth = 5
            img_product_image.layer.borderColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1).cgColor
        }
    }
    
    
    
}
