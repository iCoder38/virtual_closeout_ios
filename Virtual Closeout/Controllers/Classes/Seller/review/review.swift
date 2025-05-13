//
//  review.swift
//  Virtual Closeout
//
//  Created by Apple on 10/06/22.
//

import UIKit

class review: UIViewController {
    
    var get_club_id:String!
    
    var str_check_review_online_Status:String!
    
    var arr_mut_review_list:NSMutableArray! = []
    
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
            }
        }
            
        @IBOutlet weak var lblNavigationTitle:UILabel! {
            didSet {
                lblNavigationTitle.text = "Review"
                lblNavigationTitle.textColor = .white
                lblNavigationTitle.backgroundColor = .clear
            }
        }
                    
    // ***************************************************************** // nav
   
    @IBOutlet weak var tablView:UITableView!{
        didSet {
             tablView.delegate = self
             tablView.dataSource = self
            tablView.backgroundColor =  .white
        }
    }
    
    @IBOutlet weak var viwLeft:UIView! {
        didSet {
            viwLeft.backgroundColor = .white
        }
    }
    

    @IBOutlet weak var viwBG:UIView!{
        
        didSet{
            viwBG.backgroundColor = .white
            // viwBG.addBottomBorder(with: .darkGray, andWidth: 0.3)
        
        }
    }
    
    @IBOutlet weak var lbl_one_star:UILabel! {
        didSet {
            lbl_one_star.textColor = .black
        }
    }
    
    @IBOutlet weak var lbl_two_star:UILabel! {
        didSet {
            lbl_two_star.textColor = .black
        }
    }
    
    @IBOutlet weak var lbl_three_star:UILabel! {
        didSet {
            lbl_three_star.textColor = .black
        }
    }
    
    @IBOutlet weak var lbl_four_star:UILabel! {
        didSet {
            lbl_four_star.textColor = .black
        }
    }
    
    @IBOutlet weak var lbl_five_star:UILabel! {
        didSet {
            lbl_five_star.textColor = .black
        }
    }
    
    @IBOutlet weak var lblAvgRating:UILabel!
    
    @IBOutlet weak var lblFiveRating:UILabel!
    @IBOutlet weak var lblFourRating:UILabel!
    @IBOutlet weak var lblThreeRating:UILabel!
    @IBOutlet weak var lblTwoRating:UILabel!
    @IBOutlet weak var lblOneRating:UILabel!
    
    @IBOutlet weak var progressBarFiveRating:UIProgressView! {
        didSet {
            progressBarFiveRating.setProgress(0.0, animated: true)
        }
    }
    
    @IBOutlet weak var progressBarFourRating:UIProgressView! {
        didSet {
            progressBarFourRating.setProgress(0.0, animated: true)
        }
    }
    
    @IBOutlet weak var progressBarThreeRating:UIProgressView! {
        didSet {
            progressBarThreeRating.setProgress(0.0, animated: true)
        }
    }
    
    @IBOutlet weak var progressBarTwoRating:UIProgressView! {
        didSet {
            progressBarTwoRating.setProgress(0.0, animated: true)
        }
    }
    
    @IBOutlet weak var progressBarOneRating:UIProgressView! {
        didSet {
            progressBarOneRating.setProgress(0.0, animated: true)
        }
    }
    
    
    @IBOutlet weak var btnBtnTotalReview:UIButton!
    
    @IBOutlet weak var btn_write_review:UIButton!
    
    @IBOutlet weak var btnStarRatingOne:UIButton!{
        didSet{
            //btnShare.layer.cornerRadius = 4.0
            //btnShare.clipsToBounds = true
        }
    }
    @IBOutlet weak var btnStarRatingTwo:UIButton!{
        didSet{
            //btnShare.layer.cornerRadius = 4.0
            //btnShare.clipsToBounds = true
        }
    }
    @IBOutlet weak var btnStarRatingThree:UIButton!{
        didSet{
            //btnShare.layer.cornerRadius = 4.0
            //btnShare.clipsToBounds = true
        }
    }
    @IBOutlet weak var btnStarRatingFour:UIButton!{
        didSet{
            //btnShare.layer.cornerRadius = 4.0
            //btnShare.clipsToBounds = true
        }
    }
    @IBOutlet weak var btnStarRatingFive:UIButton!{
        didSet{
            //btnShare.layer.cornerRadius = 4.0
            //btnShare.clipsToBounds = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .clear
        self.navigationController?.isNavigationBarHidden = true
        //self.tablView.separatorColor = .clear
        
        if let person = UserDefaults.standard.value(forKey: key_user_default_value) as? [String:Any] {
        // print(person as Any)
            
            if (person["role"] as! String) == "Customer" || (person["role"] as! String) == "Member" {
                self.btn_write_review.isHidden = false
            } else {
                self.btn_write_review.isHidden = true
            }
            
        } else {
            // guest
            self.btn_write_review.isHidden = true
        }
        
        // self.manage_profile(self.btnBack)
        
        self.btn_write_review.addTarget(self, action: #selector(btn_write_review_click_method), for: .touchUpInside)
        
         self.btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    
        
        if self.str_check_review_online_Status == "yes" {
            
            self.btn_write_review.isHidden = true
            // my_review_wb() // temp
        }
        else {
            
            // self.club_review_wb() // temp
            
        }
    }
    
    @objc func manage_profile() {
        
        if let myLoadedString = UserDefaults.standard.string(forKey: "keySetToBackOrMenu") {
            print(myLoadedString)
            
            if myLoadedString == "backOrMenu" {
                // menu
                self.btnBack.setImage(UIImage(systemName: "list.dash"), for: .normal)
                // self.sideBarMenuClick()
            } else {
                // back
                self.btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
            }
        } else {
            // back
            self.btnBack.setImage(UIImage(systemName: "arrow.left"), for: .normal)
            self.btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        }
        
    }
    
    /*@objc func sideBarMenuClick() {
        
        let defaults = UserDefaults.standard
        defaults.setValue("", forKey: "keySetToBackOrMenu")
        defaults.setValue(nil, forKey: "keySetToBackOrMenu")
        
        if revealViewController() != nil {
            btnBack.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }*/
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btn_write_review_click_method() {
        
        /*let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "GiveReviewId") as? GiveReview
        push!.str_club_id = self.get_club_id
        self.navigationController?.pushViewController(push!, animated: true)*/
        
    }
    
    /*@objc func my_review_wb() {
        
        self.arr_mut_review_list.removeAllObjects()
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
         if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
             print(person as Any)
            
             let x : Int = person["userId"] as! Int
             let myString = String(x)
            
            let params = club_reviews(action: "reviewlist",
                                      userId: String(myString))
            
            print(params as Any)
            
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
                    strSuccess = (JSON["status"]as Any as? String)?.lowercased()
                    print(strSuccess as Any)
                    if strSuccess == String("success") {
                        print("yes")
                        
                        ERProgressHud.sharedInstance.hide()
                        
                        var ar : NSArray!
                        ar = (JSON["response"] as! Array<Any>) as NSArray
                        self.arr_mut_review_list.addObjects(from: ar as! [Any])
                    
                        /*if self.arr_mut_review_list.count == 0 {
                            
                            let alert = NewYorkAlertController(title: String("Alert"), message: String("No reviews"), style: .alert)
                            
                            alert.addImage(UIImage.gif(name: "gif_alert"))
                            
                            let cancel = NewYorkButton(title: "Ok", style: .cancel) { _ in
                                
                                // SPConfetti.stopAnimating()
                                
                                 self.navigationController?.popViewController(animated: true)
                            }
                            alert.addButtons([cancel])
                            
                            self.present(alert, animated: true)
                            
                        } else {*/
                            
                            self.set_stars(get_dict: JSON)
                            
                            self.tablView.delegate = self
                            self.tablView.dataSource = self
                            self.tablView.reloadData()
                            
                        // }
                        
                        
                        
                    } else {
                        print("no")
                        //  ERProgressHud.sharedInstance.hide()
                        
                        var strSuccess2 : String!
                        strSuccess2 = JSON["msg"]as Any as? String
                        
                        if strSuccess2 == "Your Account is Inactive. Please contact admin.!!" ||
                            strSuccess2 == "Your Account is Inactive. Please contact admin.!" ||
                            strSuccess2 == "Your Account is Inactive. Please contact admin." {
                            
                            
                        } else {
                            
                            let alert = UIAlertController(title: String(strSuccess).uppercased(), message: String(strSuccess2), preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                            
                            self.present(alert, animated: true)
                            
                        }
                    }
                    
                case let .failure(error):
                    print(error)
                    ERProgressHud.sharedInstance.hide()
                    
                    // Utils.showAlert(alerttitle: SERVER_ISSUE_TITLE, alertmessage: SERVER_ISSUE_MESSAGE, ButtonTitle: "Ok", viewController: self)
                }
            }
        }
    }
    
    @objc func club_review_wb() {
        
        self.arr_mut_review_list.removeAllObjects()
        
        self.view.endEditing(true)
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        // if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // print(person as Any)
            
            // let x : Int = person["userId"] as! Int
            // let myString = String(x)
            
            let params = club_reviews(action: "reviewlist",
                                      userId: self.get_club_id)
            
            print(params as Any)
            
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
                    strSuccess = (JSON["status"]as Any as? String)?.lowercased()
                    print(strSuccess as Any)
                    if strSuccess == String("success") {
                        print("yes")
                        
                        ERProgressHud.sharedInstance.hide()
                        
                        var ar : NSArray!
                        ar = (JSON["response"] as! Array<Any>) as NSArray
                        self.arr_mut_review_list.addObjects(from: ar as! [Any])
                        
                        
                        
                         
                        
                        self.set_stars(get_dict: JSON)
                        
                        self.tablView.delegate = self
                        self.tablView.dataSource = self
                        self.tablView.reloadData()
                        
                    } else {
                        print("no")
                        //  ERProgressHud.sharedInstance.hide()
                        
                        var strSuccess2 : String!
                        strSuccess2 = JSON["msg"]as Any as? String
                        
                        if strSuccess2 == "Your Account is Inactive. Please contact admin.!!" ||
                            strSuccess2 == "Your Account is Inactive. Please contact admin.!" ||
                            strSuccess2 == "Your Account is Inactive. Please contact admin." {
                            
                            
                        } else {
                            
                            let alert = UIAlertController(title: String(strSuccess).uppercased(), message: String(strSuccess2), preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                            
                            self.present(alert, animated: true)
                            
                        }
                    }
                    
                case let .failure(error):
                    print(error)
                    ERProgressHud.sharedInstance.hide()
                    
                    // Utils.showAlert(alerttitle: SERVER_ISSUE_TITLE, alertmessage: SERVER_ISSUE_MESSAGE, ButtonTitle: "Ok", viewController: self)
                }
            }
        }*/
    // }
    
    
    @objc func set_stars(get_dict:NSDictionary) {
        
        print(get_dict as Any)
        
        var strSuccess_2 : String!
        strSuccess_2 = (get_dict["AVGRating"]as Any as? String)
        
       self.lblAvgRating.text = strSuccess_2
       
       self.btnBtnTotalReview.setTitle(String(arr_mut_review_list.count)+" total", for: .normal)
        
        let x_1 : Int = get_dict["ONESTAR"] as! Int
        let myString_1 = String(x_1)
        
        let x_2 : Int = get_dict["ONETWO"] as! Int
        let myString_2 = String(x_2)
        
        let x_3 : Int = get_dict["ONETHREE"] as! Int
        let myString_3 = String(x_3)
        
        let x_4 : Int = get_dict["ONEFOUR"] as! Int
        let myString_4 = String(x_4)
        
        let x_5 : Int = get_dict["ONEFIVE"] as! Int
        let myString_5 = String(x_5)
        
        self.lblOneRating.text      = myString_1
        self.lblTwoRating.text      = myString_2
        self.lblThreeRating.text    = myString_3
        self.lblFourRating.text     = myString_4
        self.lblFiveRating.text     = myString_5
        
        
        // average of one
        // let get_average_of_1:String!
        
        let caluculate_avg_1 = Double(myString_1)!/Double(self.arr_mut_review_list.count)
        print(caluculate_avg_1 as Any)
        self.progressBarOneRating.setProgress(Float(caluculate_avg_1), animated: true)
        
        // average of two
        // let get_average_of_2:String!
        
        let caluculate_avg_2 = Double(myString_2)!/Double(self.arr_mut_review_list.count)
        print(caluculate_avg_2 as Any)
        self.progressBarTwoRating.setProgress(Float(caluculate_avg_2), animated: true)
        
        // average of three
        // let get_average_of_3:String!
        
        let caluculate_avg_3 = Double(myString_3)!/Double(self.arr_mut_review_list.count)
        print(caluculate_avg_3 as Any)
        self.progressBarThreeRating.setProgress(Float(caluculate_avg_3), animated: true)
        
        // average of four
        // let get_average_of_4:String!
        
        let caluculate_avg_4 = Double(myString_4)!/Double(self.arr_mut_review_list.count)
        print(caluculate_avg_4 as Any)
        self.progressBarFourRating.setProgress(Float(caluculate_avg_4), animated: true)
        
        // average of five
        // let get_average_of_5:String!
        let caluculate_avg_5 = Double(myString_5)!/Double(self.arr_mut_review_list.count)
        print(caluculate_avg_5 as Any)
        self.progressBarFiveRating.setProgress(Float(caluculate_avg_5), animated: true)
        
        
        
        
    }

}

//MARK:- TABLE VIEW -
extension review: UITableViewDataSource , UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 // self.arr_mut_review_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:review_table_cell = tableView.dequeueReusableCell(withIdentifier: "review_table_cell") as! review_table_cell
        
        cell.backgroundColor = .white
      
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        /*let item = self.arr_mut_review_list[indexPath.row] as? [String:Any]
        
        // cell.imgProfile.image = UIImage(named: "dan")
        cell.lblName.text = (item!["userName"] as! String)
        
        cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
        cell.imgProfile.sd_setImage(with: URL(string: (item!["profile_picture"] as! String)), placeholderImage: UIImage(named: "bar"))
        
        
        
        let x : Int = item!["star"] as! Int
        let myString = String(x)
        
        if myString == "0" {
            
            cell.btnStarOne.setImage(UIImage(systemName: "star"), for: .normal)
            cell.btnStarTwo.setImage(UIImage(systemName: "star"), for: .normal)
            cell.btnStarThree.setImage(UIImage(systemName: "star"), for: .normal)
            cell.btnStarFour.setImage(UIImage(systemName: "star"), for: .normal)
            cell.btnStarFive.setImage(UIImage(systemName: "star"), for: .normal)
            
        } else if myString == "1" {
            
            cell.btnStarOne.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.btnStarTwo.setImage(UIImage(systemName: "star"), for: .normal)
            cell.btnStarThree.setImage(UIImage(systemName: "star"), for: .normal)
            cell.btnStarFour.setImage(UIImage(systemName: "star"), for: .normal)
            cell.btnStarFive.setImage(UIImage(systemName: "star"), for: .normal)
            
        } else if myString == "2" {
            
            cell.btnStarOne.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.btnStarTwo.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.btnStarThree.setImage(UIImage(systemName: "star"), for: .normal)
            cell.btnStarFour.setImage(UIImage(systemName: "star"), for: .normal)
            cell.btnStarFive.setImage(UIImage(systemName: "star"), for: .normal)
            
        } else if myString == "3" {
            
            cell.btnStarOne.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.btnStarTwo.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.btnStarThree.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.btnStarFour.setImage(UIImage(systemName: "star"), for: .normal)
            cell.btnStarFive.setImage(UIImage(systemName: "star"), for: .normal)
            
        } else if myString == "4" {
            
            cell.btnStarOne.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.btnStarTwo.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.btnStarThree.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.btnStarFour.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.btnStarFive.setImage(UIImage(systemName: "star"), for: .normal)
            
        } else {
            
            cell.btnStarOne.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.btnStarTwo.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.btnStarThree.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.btnStarFour.setImage(UIImage(systemName: "star.fill"), for: .normal)
            cell.btnStarFive.setImage(UIImage(systemName: "star.fill"), for: .normal)
            
        }
        
        cell.lblDate.text = (item!["created"] as! String)
        
        cell.lblReview.text = (item!["message"] as! String)
        */
        return cell
    }


    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}


class review_table_cell: UITableViewCell {
    
    @IBOutlet weak var viw:UIView!{
        didSet{
            
            viw.backgroundColor = .clear
            
            viw.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            viw.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            viw.layer.shadowOpacity = 1.0
            viw.layer.shadowRadius = 15.0
            viw.layer.masksToBounds = false
        }
    }
    
    @IBOutlet weak var imgProfile:UIImageView!{
        didSet{
            
            imgProfile.layer.cornerRadius = 25.0
            imgProfile.clipsToBounds = true
            imgProfile.layer.borderWidth = 5
            imgProfile.layer.borderColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1).cgColor
            
        }
    }
    
    @IBOutlet weak var lblName:UILabel!
    
    @IBOutlet weak var lblDate:UILabel!
    
    @IBOutlet weak var btnStarOne:UIButton! {
        didSet {
            btnStarOne.tintColor = .systemYellow
            //btnShare.layer.cornerRadius = 4.0
            //btnShare.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var btnStarTwo:UIButton! {
        didSet {
            btnStarTwo.tintColor = .systemYellow
            //btnShare.layer.cornerRadius = 4.0
            //btnShare.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var btnStarThree:UIButton! {
        didSet {
            btnStarThree.tintColor = .systemYellow
            
            //btnShare.layer.cornerRadius = 4.0
            //btnShare.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var btnStarFour:UIButton! {
        didSet {
            btnStarFour.tintColor = .systemYellow
            
            //btnShare.layer.cornerRadius = 4.0
            //btnShare.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var btnStarFive:UIButton! {
        didSet {
            btnStarFive.tintColor = .systemYellow
            
            //btnShare.layer.cornerRadius = 4.0
            //btnShare.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var lblReview:UILabel!
   

}
