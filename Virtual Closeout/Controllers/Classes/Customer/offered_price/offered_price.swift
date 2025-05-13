//
//  offered_price.swift
//  Virtual Closeout
//
//  Created by Apple on 09/06/22.
//

import UIKit

class offered_price: UIViewController {

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
            lblNavigationTitle.text = "Offered price"
            lblNavigationTitle.textColor = .white
        }
    }
    
    
    // ***************************************************************** // nav
    
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
        
    }
}


//MARK:- TABLE VIEW -
extension offered_price: UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:offered_price_table_cell = tableView.dequeueReusableCell(withIdentifier: "offered_price_table_cell") as! offered_price_table_cell
        
        cell.backgroundColor = .clear
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        cell.accessoryType = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "browse_product_category_id")
        self.navigationController?.pushViewController(push, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
        
}

class offered_price_table_cell:UITableViewCell {
    
    @IBOutlet weak var img_user_image:UIImageView! {
        didSet {
            img_user_image.layer.cornerRadius = 8
            img_user_image.clipsToBounds = true
            img_user_image.backgroundColor = .systemBrown
        }
    }
    
    @IBOutlet weak var img_last_message:UIImageView! {
        didSet {
            img_last_message.layer.cornerRadius = 0
            img_last_message.clipsToBounds = true
            img_last_message.backgroundColor = .systemBrown
        }
    }
    
    @IBOutlet weak var lbl_user_name:UILabel! {
        didSet {
            lbl_user_name.textColor = .black
        }
    }
    
    @IBOutlet weak var lbl_user_last_message:UILabel! {
        didSet {
            lbl_user_last_message.textColor = .black
        }
    }
    
}
