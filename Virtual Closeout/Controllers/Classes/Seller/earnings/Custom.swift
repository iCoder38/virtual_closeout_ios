//
//  Custom.swift
//  E health App
//
//  Created by apple on 07/02/22.
//

import UIKit

class Custom: UIViewController {

    var custom_start_Date:String!
    var custom_end_Date:String!
    
    @IBOutlet weak var view_bg:UIView! {
        didSet {
            view_bg.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            view_bg.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            view_bg.layer.shadowOpacity = 1.0
            view_bg.layer.shadowRadius = 15.0
            view_bg.layer.masksToBounds = false
            view_bg.layer.cornerRadius = 15
            view_bg.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var viewNavigationbar:UIView! {
        didSet {
            viewNavigationbar.backgroundColor = navigation_color
        }
    }
    
    @IBOutlet weak var btnDashboardMenu: UIButton!
    @IBOutlet weak var lblNavationbar:UILabel! {
        didSet {
            lblNavationbar.text = "Custom"
        }
    }
    
    @IBOutlet weak var txt_start_Date:UITextField! {
        didSet {
            txt_start_Date.backgroundColor = .white
            txt_start_Date.textColor = .black
            txt_start_Date.layer.borderWidth = 0.8
            txt_start_Date.layer.borderColor = UIColor.systemGray4.cgColor
        }
    }
    
    @IBOutlet weak var txt_end_Date:UITextField! {
        didSet {
            txt_end_Date.backgroundColor = .white
            txt_end_Date.textColor = .black
            txt_end_Date.layer.borderWidth = 0.8
            txt_end_Date.layer.borderColor = UIColor.systemGray4.cgColor
        }
    }
    
    @IBOutlet weak var btn_submit:UIButton! {
        didSet {
            btn_submit.setTitle("Submit", for: .normal)
            btn_submit.layer.cornerRadius = 20.0
            btn_submit.clipsToBounds = true
            btn_submit.backgroundColor = button_dark
            btn_submit.tintColor = .white
         }
    }
    
    @IBOutlet weak var btn_start:UIButton!
    @IBOutlet weak var btn_end:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.btnDashboardMenu.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        self.btnDashboardMenu.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
        self.btn_submit.addTarget(self, action: #selector(validation_before_submit), for: .touchUpInside)
        
        
        self.btn_start.addTarget(self, action: #selector(start_Date_picker), for: .touchUpInside)
        self.btn_end.addTarget(self, action: #selector(end_Date_picker), for: .touchUpInside)
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func start_Date_picker() {
        
        RPicker.selectDate(title: "Select Start Date", didSelectDate: {[weak self] (selectedDate) in
            // TODO: Your implementation for date
            self!.txt_start_Date.text = selectedDate.dateString("yyyy-MM-dd")
        })
        
    }
    
    @objc func end_Date_picker() {
        
        RPicker.selectDate(title: "Select End Date", didSelectDate: {[weak self] (selectedDate) in
            // TODO: Your implementation for date
            self!.txt_end_Date.text = selectedDate.dateString("yyyy-MM-dd")
        })
        
    }
    
    @objc func validation_before_submit() {
        
        if self.txt_start_Date.text! == "" {
            
        } else if self.txt_end_Date.text! == "" {
            
        } else {
            self.btn_submit_click_method()
        }
        
        
    }
    
    @objc func btn_submit_click_method() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "earnings_id") as? earnings
        
        push!.start_date = String(self.txt_start_Date.text!)
        push!.end_date = String(self.txt_end_Date.text!)
        
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
}
