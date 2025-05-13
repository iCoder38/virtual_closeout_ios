//
//  COrderHistoryProductDetails.swift
//  Alien Broccoli
//
//  Created by Apple on 07/10/20.
//

import UIKit

class COrderHistoryProductDetails: UIViewController {

    let cellReuseIdentifier = "cOrderHistoryProductDetailsTableCell"
    
    // MARK:- ARRAY -
    var arrListOfAllProductDetails: NSArray!
    
    // MARK:- CUSTOM NAVIGATION BAR -
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = navigation_color
        }
    }

    // MARK:- CUSTOM NAVIGATION TITLE -
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "Products"
            lblNavigationTitle.textColor = .white
        }
    }
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.tintColor = .white
            btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        }
    }
    
    // MARK:- TABLE VIEW -
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
              // self.tbleView.delegate = self
              // self.tbleView.dataSource = self
            self.tbleView.backgroundColor = .white
            self.tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.tbleView.separatorColor = .clear
        
        self.tbleView.delegate = self
        self.tbleView.dataSource = self
        self.tbleView.reloadData()
        
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension COrderHistoryProductDetails: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrListOfAllProductDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell:COrderHistoryProductDetailsTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! COrderHistoryProductDetailsTableCell
          
        let item = self.arrListOfAllProductDetails[indexPath.row] as? [String:Any]
        
        cell.lblTitle.text    = (item!["productName"] as! String)
        cell.lblCreatedAt.text    = "SKU : "+(item!["SKU"] as! String)
        
        // quantity
        if item!["Quantity"] is String {
            print("Yes, it's a String")

            cell.lblQuantity.text = "Quantity : "+(item!["Quantity"] as! String)
            
        } else if item!["Quantity"] is Int {
            print("It is Integer")
                        
            let x2 : Int = (item!["Quantity"] as! Int)
            let myString2 = String(x2)
            // cell1.btnQuantity.setTitle("Quantity ("+myString2+")", for: .normal)
            
            cell.lblQuantity.text = "Quantity : "+String(myString2)
            
        } else {
            print("i am number")
                        
            let temp:NSNumber = item!["Quantity"] as! NSNumber
            let tempString = temp.stringValue
            
            cell.lblQuantity.text = "Quantity : "+String(tempString)
            
        }
        
        
        // price
        if item!["price"] is String {
            print("Yes, it's a String")

            cell.lblPrice.text = "Price $ : "+(item!["price"] as! String)
            
        } else if item!["price"] is Int {
            print("It is Integer")
                        
            let x2 : Int = (item!["price"] as! Int)
            let myString2 = String(x2)
            // cell1.btnQuantity.setTitle("Quantity ("+myString2+")", for: .normal)
            
            cell.lblPrice.text = "Price $ : "+String(myString2)
            
        } else {
            print("i am number")
                        
            let temp:NSNumber = item!["price"] as! NSNumber
            let tempString = temp.stringValue
            
            cell.lblPrice.text = "Price $ : "+String(tempString)
            
        }
        
        
        
        
        
        // let x22 : Int = (item!["price"] as! Int);
        // let myString22 = String(x22)
        
        
        // cell.lblPrice.text = "Price : $ "+myString22
        
        cell.imgProfile.sd_setImage(with: URL(string: (item!["image"] as! String)), placeholderImage: UIImage(named: "logo"))
        
        /*
         Quantity = 1;
             SKU = 878787;
             description = "<p><strong><em>CBD content:&nbsp;</em></strong><em>about 25 mg, depending on your&nbsp;</em>Turmeric, agar agar, carrot juice, ginger, cayenne, and CBD, all in a sweet treat? Yes, it is possible! These healthy, satisfying treats require only about 10 minutes to make, and they stay fresh in the refrigerator for up to a week</p>
         \n";
             image = "http://demo2.evirtualservices.com/HoneyBudz/site/img/uploads/products/1601895366_Elevem.jpg";
             price = 90;
             productId = 13;
             productName = "Healthy CBD-Turmeric Sweets";
         */
       
        return cell
        
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        return 116 // UITableView.automaticDimension
    }
    
}

extension COrderHistoryProductDetails: UITableViewDelegate {
    
}
