//
//  filter.swift
//  Virtual Closeout
//
//  Created by Apple on 23/06/22.
//

import UIKit

class filter: UIViewController {

    var str_product_condition:String! = ""
    
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
            lblNavigationTitle.text = "Filter"
            lblNavigationTitle.textColor = .white
        }
    }
    
    // ***************************************************************** // nav

    @IBOutlet weak var btn_done:UIButton! {
        didSet {
            btn_done.tintColor = .white
            btn_done.isHidden = false
            btn_done.setTitle("Done", for: .normal)
        }
    }
    
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
        
        self.btn_done.addTarget(self, action: #selector(done_filter_click_method), for: .touchUpInside)
    }
    
    @objc func done_filter_click_method() {
        let indexPath = IndexPath.init(row: 1, section: 0)
        let cell = self.tble_view.cellForRow(at: indexPath) as! filter_table_cell
        
        let custom_dict = ["min_price":String(cell.txt_minimum_price.text!),
                           "max_price":String(cell.txt_maximum_price.text!),
                           "product_condition":String(self.str_product_condition),
        ]
        
        let defaults = UserDefaults.standard
        defaults.setValue(custom_dict, forKey: "key_filter_price")
        
        self.navigationController?.popViewController(animated: true)
    }

    /*
     var str_new_get:String! = ""
     var str_open_box:String! = ""
     var str_recondition:String! = ""
     */
    
    // MARK: - NEW CLICK -
    @objc func new_click_method() {
        let indexPath = IndexPath.init(row: 3, section: 0)
        let cell = self.tble_view.cellForRow(at: indexPath) as! filter_table_cell
        
        if cell.btn_new.tag == 0 {
            
            self.str_product_condition = "New"
            cell.btn_new.setImage(UIImage(named: "check_mark"), for: .normal)
            
            cell.btn_recondition.setImage(UIImage(named: "un_check_mark"), for: .normal)
            cell.btn_open_box.setImage(UIImage(named: "un_check_mark"), for: .normal)
            
            cell.btn_open_box.tag = 0
            cell.btn_recondition.tag = 0
            
            cell.btn_new.tag = 1
            
        } else {
            
            self.str_product_condition = ""
            cell.btn_new.tag = 0
            cell.btn_new.setImage(UIImage(named: "un_check_mark"), for: .normal)
            
        }
        
    }
    
    // MARK: - RECONDITION -
    @objc func recondition_click_method() {
        let indexPath = IndexPath.init(row: 3, section: 0)
        let cell = self.tble_view.cellForRow(at: indexPath) as! filter_table_cell
        
        
        if cell.btn_recondition.tag == 0 {
            
            self.str_product_condition = "Reconditioned"
            cell.btn_recondition.setImage(UIImage(named: "check_mark"), for: .normal)
            
            cell.btn_new.setImage(UIImage(named: "un_check_mark"), for: .normal)
            cell.btn_open_box.setImage(UIImage(named: "un_check_mark"), for: .normal)
            
            cell.btn_new.tag = 0
            cell.btn_open_box.tag = 0
            
            cell.btn_recondition.tag = 1
            
        } else {
            
            self.str_product_condition = ""
            cell.btn_recondition.tag = 0
            cell.btn_recondition.setImage(UIImage(named: "un_check_mark"), for: .normal)
            
        }
        
    }
    
    // MARK: - OPEN BOX -
    @objc func open_box_click_method() {
        let indexPath = IndexPath.init(row: 3, section: 0)
        let cell = self.tble_view.cellForRow(at: indexPath) as! filter_table_cell
        
        if cell.btn_open_box.tag == 0 {
            
            self.str_product_condition = "Open box"
            cell.btn_open_box.setImage(UIImage(named: "check_mark"), for: .normal)
            
            cell.btn_new.setImage(UIImage(named: "un_check_mark"), for: .normal)
            cell.btn_recondition.setImage(UIImage(named: "un_check_mark"), for: .normal)
            
            cell.btn_new.tag = 0
            cell.btn_recondition.tag = 0
            
            cell.btn_open_box.tag = 1
            
        } else {
            
            self.str_product_condition = ""
            cell.btn_open_box.tag = 0
            cell.btn_open_box.setImage(UIImage(named: "un_check_mark"), for: .normal)
            
        }
        
    }
    
    
    @objc func textFieldDidChange_min(_ textField: UITextField) {
        let indexPath = IndexPath.init(row: 1, section: 0)
        let cell = self.tble_view.cellForRow(at: indexPath) as! filter_table_cell
        cell.txt_maximum_price.text = ""
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let indexPath = IndexPath.init(row: 1, section: 0)
        let cell = self.tble_view.cellForRow(at: indexPath) as! filter_table_cell
        cell.txt_minimum_price.text = ""
        
    }
    
}


extension filter: UITableViewDataSource , UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if indexPath.row == 0 {
            
            let cell:filter_table_cell = tableView.dequeueReusableCell(withIdentifier: "filter_table_cell_one") as! filter_table_cell

            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            return cell
            
        } else if indexPath.row == 1 {
            
            let cell:filter_table_cell = tableView.dequeueReusableCell(withIdentifier: "filter_table_cell_two") as! filter_table_cell
             
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            cell.txt_minimum_price.addTarget(self, action: #selector(filter.textFieldDidChange_min(_:)), for: .editingChanged)
            cell.txt_maximum_price.addTarget(self, action: #selector(filter.textFieldDidChange(_:)), for: .editingChanged)
            
            return cell
            
        } else if indexPath.row == 2 {
            
            let cell:filter_table_cell = tableView.dequeueReusableCell(withIdentifier: "filter_table_cell_three") as! filter_table_cell
             
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            cell.accessoryType = .disclosureIndicator
            
            return cell
            
        } else if indexPath.row == 3 {
            
            let cell:filter_table_cell = tableView.dequeueReusableCell(withIdentifier: "filter_table_cell_four") as! filter_table_cell
             
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            cell.btn_new.addTarget(self, action: #selector(new_click_method), for: .touchUpInside)
            cell.btn_open_box.addTarget(self, action: #selector(open_box_click_method), for: .touchUpInside)
            cell.btn_recondition.addTarget(self, action: #selector(recondition_click_method), for: .touchUpInside)
            
            return cell
            
        } else {
            
            let cell:filter_table_cell = tableView.dequeueReusableCell(withIdentifier: "filter_table_cell_three") as! filter_table_cell
             
            let backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = backgroundView
            
            return cell
            
        }

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
        // self.back_click_method()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        if indexPath.row == 0 {
            return 0
        } else if indexPath.row == 2 {
            return 0
        } else if indexPath.row == 3 {
            return 194
        } else {
            return 210
        }
        
    }
    
}

class filter_table_cell: UITableViewCell {

    @IBOutlet weak var lbl_location:UILabel!

    @IBOutlet weak var txt_minimum_price:UITextField!
    @IBOutlet weak var txt_maximum_price:UITextField!
    
    @IBOutlet weak var btn_open_box:UIButton! {
        didSet {
            btn_open_box.tag = 0
            btn_open_box.setImage(UIImage(named: "un_check_mark"), for: .normal)
        }
    }
    
    @IBOutlet weak var btn_new:UIButton! {
        didSet {
            btn_new.tag = 0
            btn_new.setImage(UIImage(named: "un_check_mark"), for: .normal)
        }
    }
    
    @IBOutlet weak var btn_recondition:UIButton! {
        didSet {
            btn_recondition.tag = 0
            btn_recondition.setImage(UIImage(named: "un_check_mark"), for: .normal)
        }
    }
    
    @IBOutlet weak var btn_see_listing:UIButton! {
        didSet {
            btn_see_listing.backgroundColor = button_light
            btn_see_listing.setTitle("See Listing", for: .normal)
            btn_see_listing.tintColor = .black
            // btn_see_listing.setImage(UIImage(systemName: "arrow.right"), for: .normal)
            btn_see_listing.setTitleColor(.black, for: .normal)
            btn_see_listing.layer.cornerRadius = 28
            btn_see_listing.clipsToBounds = true
            
            btn_see_listing.layer.borderColor = button_dark.cgColor
            btn_see_listing.layer.borderWidth = 1
        }
    }
    
}
