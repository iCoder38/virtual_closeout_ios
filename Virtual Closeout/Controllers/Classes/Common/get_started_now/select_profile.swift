//
//  select_profile.swift
//  Virtual Closeout
//
//  Created by Apple on 07/06/22.
//

import UIKit
import CoreLocation

class select_profile: UIViewController , CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
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
            lblNavigationTitle.text = "Get started now"
            lblNavigationTitle.textColor = .white
        }
    }
    
    
    // ***************************************************************** // nav
    
    @IBOutlet weak var btn_customer:UIButton! {
        didSet {
            btn_customer.backgroundColor = button_dark
            btn_customer.setTitle("Customer", for: .normal)
            btn_customer.layer.cornerRadius = 28
            btn_customer.clipsToBounds = true
            
            btn_customer.layer.borderColor = button_light.cgColor
            btn_customer.layer.borderWidth = 1
        }
    }
    
    @IBOutlet weak var btn_seller:UIButton! {
        didSet {
            btn_seller.backgroundColor = button_light
            btn_seller.setTitle("Seller", for: .normal)
            btn_seller.setTitleColor(.black, for: .normal)
            btn_seller.layer.cornerRadius = 28
            btn_seller.clipsToBounds = true
            
            btn_seller.layer.borderColor = button_dark.cgColor
            btn_seller.layer.borderWidth = 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // UserDefaults.standard.set(nil, forKey: key_user_default_value)
        self.view.backgroundColor = .white
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.btn_customer.addTarget(self, action: #selector(customer_click_method), for: .touchUpInside)
        self.btn_seller.addTarget(self, action: #selector(seller_click_method), for: .touchUpInside)
        
        self.ask_for_location_permission()
        
        
        
        self.remember_me()
        
    }
    
    @objc func ask_for_location_permission() {
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations ===> \(locValue.latitude) \(locValue.longitude)")
    }
    
    @objc func remember_me() {
        
        if let person = UserDefaults.standard.value(forKey: key_user_default_value) as? [String:Any]  {

            print(person as Any)

            if (person["role"] as! String) == "Seller" {
                
                if (person["businessName"] as! String) == "" { // if your business information is empty
                    
                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "business_information_id") as? business_information
                    push!.str_which_profile = ""
                    self.navigationController?.pushViewController(push!, animated: false)
                    
                } else {
                
                    if (person["BankName"] as! String) == "" { // if bank name is empty
                        
                        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "bank_information_id") as? bank_information
                        push!.str_which_profile_bank_info = ""
                        self.navigationController?.pushViewController(push!, animated: false)
                        
                    } else {
                    
                        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "dashboard_id") as? dashboard
                        self.navigationController?.pushViewController(push!, animated: false)
                        
                    }
                }
                
            } else {
                
                /*let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "all_card_list_id")
                self.navigationController?.pushViewController(push, animated: false)*/
                
                // customer
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "browse_product_id")
                self.navigationController?.pushViewController(push, animated: false)
                
            }
            
        }
        
    }
          
    
    @objc func customer_click_method() {
        
        let defaults = UserDefaults.standard
        defaults.set("Member", forKey: "key_user_select_profile")
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "profile_id") as? profile
        self.navigationController?.pushViewController(push!, animated: true)
        
        /*let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "review_id")
        self.navigationController?.pushViewController(push, animated: true)*/
        
    }
    
    @objc func seller_click_method() {
        
        let defaults = UserDefaults.standard
        defaults.set("Seller", forKey: "key_user_select_profile")
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "profile_id") as? profile
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
}
