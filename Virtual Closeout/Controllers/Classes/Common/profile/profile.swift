//
//  profile.swift
//  Virtual Closeout
//
//  Created by Apple on 07/06/22.
//

import UIKit

class profile: UIViewController {
    
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
            lblNavigationTitle.text = "Select"
            lblNavigationTitle.textColor = .white
        }
    }
    
    
    // ***************************************************************** // nav
    
    @IBOutlet weak var btn_sign_in:UIButton! {
        didSet {
            btn_sign_in.backgroundColor = button_dark
            btn_sign_in.setTitle("Sign In", for: .normal)
            btn_sign_in.layer.cornerRadius = 28
            btn_sign_in.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var btn_sign_up:UIButton! {
        didSet {
            btn_sign_up.backgroundColor = button_light
            btn_sign_up.setTitle("Create an account", for: .normal)
            btn_sign_up.setTitleColor(.black, for: .normal)
            btn_sign_up.layer.cornerRadius = 28
            btn_sign_up.clipsToBounds = true
            
            btn_sign_up.layer.borderColor = button_dark.cgColor
            btn_sign_up.layer.borderWidth = 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.btnBack.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        
        self.btn_sign_in.addTarget(self, action: #selector(sign_in_click_method), for: .touchUpInside)
        self.btn_sign_up.addTarget(self, action: #selector(create_an_account_click_method), for: .touchUpInside)
    }

    
    @objc func sign_in_click_method() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "login_id") as? login
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    @objc func create_an_account_click_method() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "registration_id") as? registration
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
}
