import UIKit
import CoreLocation

// MARK:- BASE URL -
let APPLICATION_BASE_URL = "https://www.demo2.evirtualservices.co/virtual-closeout/site/services/index/"

// 64 112 216
let navigation_color = UIColor.init(red: 64.0/255.0, green: 112.0/255.0, blue: 216.0/255.0, alpha: 1)

let button_dark = UIColor.init(red: 64.0/255.0, green: 112.0/255.0, blue: 216.0/255.0, alpha: 1)
let button_light = UIColor.init(red: 200.0/255.0, green: 223.0/255.0, blue: 254.0/255.0, alpha: 1)

//
let key_user_default_value = "keyLoginFullData"
//

class Utils: NSObject {
    
    class func showAlert(alerttitle :String, alertmessage: String,ButtonTitle: String, viewController: UIViewController) {
        
        let alertController = UIAlertController(title: alerttitle, message: alertmessage, preferredStyle: .alert)
        let okButtonOnAlertAction = UIAlertAction(title: ButtonTitle, style: .default)
        { (action) -> Void in
            //what happens when "ok" is pressed
            
        }
        alertController.addAction(okButtonOnAlertAction)
        alertController.show(viewController, sender: self)
        
    }
    
    // text field
    class func text_field_UI(text_field:UITextField) {
        text_field.layer.cornerRadius = 22
        text_field.clipsToBounds = true
        text_field.backgroundColor = button_light
        text_field.setLeftPaddingPoints(20)
        text_field.textColor = .black
        text_field.layer.borderColor = button_dark.cgColor
        text_field.layer.borderWidth = 1
        
        /*text_field.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        text_field.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        text_field.layer.shadowOpacity = 1.0
        text_field.layer.shadowRadius = 15.0
        text_field.layer.masksToBounds = false*/
    }
    
    
    
    func isValidEmail(testStr:String) -> Bool {
        print("validate emilId: \(testStr)")
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    
    func validpassword(mypassword : String) -> Bool {
            // least one uppercase,
            // least one digit
            // least one lowercase
            // least one symbol
            //  min 8 characters total
            // let password = self.trimmingCharacters(in: CharacterSet.whitespaces)
            let passwordRegx = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{8,}$"
            let passwordCheck = NSPredicate(format: "SELF MATCHES %@",passwordRegx)
            return passwordCheck.evaluate(with: mypassword)

        
    }
    
}


extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?,_ country: String?, _ zipcode:  String?, _ localAddress:  String?, _ locality:  String?, _ subLocality:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality,$0?.first?.country, $0?.first?.postalCode,$0?.first?.subAdministrativeArea,$0?.first?.locality,$0?.first?.subLocality, $1) }
    }
    
    func countryCode(completion: @escaping (_ countryCodeIs:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.isoCountryCode, $1) }
    }
    
    func fullAddressFull(completion: @escaping (_ city: String?,_ country: String?, _ zipcode:  String?, _ localAddress:  String?, _ locality:  String?, _ subLocality:  String?,_ countryCodeIs:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality,$0?.first?.country, $0?.first?.postalCode,$0?.first?.administrativeArea,$0?.first?.locality,$0?.first?.subLocality,$0?.first?.isoCountryCode, $1) }
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
}

extension Date {
    
    func dateString(_ format: String = "MMM-dd-YYYY, hh:mm a") -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
    
    func dateByAddingYears(_ dYears: Int) -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.year = dYears
        
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
}

extension UIViewController {
    
    @objc func please_check_your_internet_connection() {
        
        let alert = NewYorkAlertController(title: String("Error").uppercased(), message: String("Please check your internet connection."), style: .alert)
        let cancel = NewYorkButton(title: "dismiss", style: .cancel)
        alert.addButtons([cancel])
        self.present(alert, animated: true)
        
    }
    
    @objc func validations_for_forms(str_title:String) {
        
        let alert = NewYorkAlertController(title: String("Alert").uppercased(), message: str_title+" should not be empty.", style: .alert)
        let cancel = NewYorkButton(title: "dismiss", style: .cancel)
        alert.addButtons([cancel])
        self.present(alert, animated: true)
        
    }
    
    // MARK: - BACK CLICK -
    @objc func back_click_method() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func manage_profile(_ sender:UIButton) {
        
        if let myLoadedString = UserDefaults.standard.string(forKey: "keySetToBackOrMenu") {
            print(myLoadedString)
            
            if myLoadedString == "backOrMenu" {
                // menu
                sender.setImage(UIImage(systemName: "list.dash"), for: .normal)
                self.sideBarMenuClick(sender)
            } else {
                // back
                sender.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
            }
        } else {
            // back
            sender.setImage(UIImage(systemName: "arrow.left"), for: .normal)
            sender.addTarget(self, action: #selector(back_click_method), for: .touchUpInside)
        }
        
    }
    
    // MARK: - SIDE BAR MENU -
    @objc func sideBarMenuClick(_ sender:UIButton) {
        
        let defaults = UserDefaults.standard
        defaults.setValue("", forKey: "keySetToBackOrMenu")
        defaults.setValue(nil, forKey: "keySetToBackOrMenu")
        
        self.view.endEditing(true)
        if revealViewController() != nil {
            sender.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            revealViewController().rearViewRevealWidth = 300
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
        
    }
    
    // MARK: - WHEN USER CLICK OUTSIDE -
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

extension UIView {
    
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
       
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
       
    }
    
}


extension UILabel {
    func setMargins(_ margin: CGFloat = 10) {
        if let textString = self.text {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.firstLineHeadIndent = margin
            paragraphStyle.headIndent = margin
            paragraphStyle.tailIndent = -margin
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
    }
}

extension Date {
    func today(format : String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
