//
//  success_payment.swift
//  Virtual Closeout
//
//  Created by Apple on 15/06/22.
//

import UIKit

class success_payment: UIViewController {

    @IBOutlet weak var btn_done:UIButton! {
        didSet {
            btn_done.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            btn_done.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            btn_done.layer.shadowOpacity = 1.0
            btn_done.layer.shadowRadius = 15.0
            btn_done.layer.masksToBounds = false
            btn_done.layer.cornerRadius = 6
            btn_done.backgroundColor = .white
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.btn_done.addTarget(self, action: #selector(done_click_method), for: .touchUpInside)
    }
    
    // MARK: - PUSH ( BROWSE PRODUCT ) -
    @objc func done_click_method() {
        
        if let person = UserDefaults.standard.value(forKey: key_user_default_value) as? [String:Any] {
            
            if (person["role"] as! String) == "Seller" {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "dashboard_id")
                self.navigationController?.pushViewController(push, animated: true)
                
            } else {
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "browse_product_id")
                self.navigationController?.pushViewController(push, animated: false)
            }
            
        }
        
        
    }

}
