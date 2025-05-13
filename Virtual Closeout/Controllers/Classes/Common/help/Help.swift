//
//  Help.swift
//  ExpressPlus
//
//  Created by Apple on 06/05/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import MessageUI

import Alamofire

class Help: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var imglogo:UIImageView! {
        didSet {
            imglogo.layer.cornerRadius = 60
            imglogo.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = navigation_color
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "Help"
        }
    }
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.tintColor = .white
            btnBack.isHidden = false
            btnBack.setImage(UIImage(systemName: "list.bullet.indent"), for: .normal)
        }
    }
    
    @IBOutlet weak var btnPhone:UIButton!
    @IBOutlet weak var btnEmil:UIButton!
    
    var strPhone:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = .white
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.btnBack.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        
        self.sideBarMenuClick(btnBack)
        
        //        self.sideBarMenuClick()
        //
                 self.helpWB()
    }
    
    //    @objc func sideBarMenuClick() {
    //        self.view.endEditing(true)
    //        if revealViewController() != nil {
    //            btnBack.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
    //            revealViewController().rearViewRevealWidth = 300
    //            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    //          }
    //    }
    
    
    
    @objc func helpWB() {
        
        self.view.endEditing(true)
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")

        let myProfileP = help_wb_call(action: "help")
        
        AF.request(APPLICATION_BASE_URL,
                   method: .post,
                   parameters: myProfileP,
                   encoder: JSONParameterEncoder.default).responseJSON { response in
            // debugPrint(response.result)
            
            switch response.result {
            case let .success(value):
                
                let JSON = value as! NSDictionary
                print(JSON as Any)
                
                var strSuccess : String!
                strSuccess = JSON["status"]as Any as? String
                
                if strSuccess == String("success") {
                    print("yes")
                    ERProgressHud.sharedInstance.hide()
                    
                    var dict: Dictionary<AnyHashable, Any>
                    dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                    // (dict["phone"] as! String)
                    self.btnPhone.setTitle((dict["phone"] as! String), for: .normal)
                    self.btnEmil.setTitle((dict["eamil"] as! String), for: .normal)
                    
                    self.strPhone = (dict["phone"] as! String)
                    
                    self.btnPhone.addTarget(self, action: #selector(self.callMethodClick), for: .touchUpInside)
                    self.btnEmil.addTarget(self, action: #selector(self.mailMethodClick), for: .touchUpInside)
                    
                    
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
                
                self.please_check_your_internet_connection()
            }
        }
        // }
        
    }
    
    
    @objc func callMethodClick() {
        if let url = URL(string: "tel://\(self.strPhone ?? "")"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc func mailMethodClick() {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["someone@somewhere.com"])
        mailComposerVC.setSubject("I AM SUBJECT")
        mailComposerVC.setMessageBody("I AM MESSAGE BODY", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let alert = UIAlertController(title: "Could Not Send Email", message: "You can always access your content by signing back in",         preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
            //Sign out action
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
