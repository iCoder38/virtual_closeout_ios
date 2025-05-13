//
//  earnings_new.swift
//  Bookit
//
//  Created by Apple on 01/03/22.
//

import UIKit
import Alamofire
import SDWebImage

class earnings_new: UIViewController {

    var report_data = ["Today's earning" ,
                       "Weekly's earning" ,
                       "Monthly's earning" ,
                       "Yearly's earning" ,
                       "Custom earning"]
    
    @IBOutlet weak var viewNavigationbar:UIView! {
        didSet {
            viewNavigationbar.backgroundColor = navigation_color
            viewNavigationbar.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            viewNavigationbar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            viewNavigationbar.layer.shadowOpacity = 1.0
            viewNavigationbar.layer.shadowRadius = 15.0
            viewNavigationbar.layer.masksToBounds = false
        }
    }
    
    @IBOutlet weak var btnDashboardMenu: UIButton!
    @IBOutlet weak var lblNavationbar:UILabel! {
        didSet {
            lblNavationbar.text = "Filter earnings"
        }
    }
    
    @IBOutlet weak var tablView:UITableView! {
        didSet {
            tablView.delegate = self
            tablView.dataSource = self
            tablView.backgroundColor =  .clear
            tablView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
            tablView.separatorStyle = UITableViewCell.SeparatorStyle.none
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        self.view.backgroundColor = .white
        
        self.btnDashboardMenu.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        // self.btnDashboardMenu.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
        // self.manage_profile()
        self.manage_profile(self.btnDashboardMenu)
    }

    @objc func sideBarMenuClick() {
        
        let defaults = UserDefaults.standard
        defaults.setValue("", forKey: "keyBackOrSlide")
        defaults.setValue(nil, forKey: "keyBackOrSlide")
        
        if revealViewController() != nil {
            btnDashboardMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
}

extension earnings_new:UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return report_data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        
        let cell:earning_new_table_cell = tablView.dequeueReusableCell(withIdentifier: "earning_new_table_cell") as! earning_new_table_cell
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        cell.backgroundColor = .clear
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        cell.lbl_cell.textColor = .black
        cell.lbl_cell.text = (report_data[indexPath.row])
 
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let today_date = Date().today(format: "yyyy-MM-dd")
        
        
        if indexPath.row == 0 {
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "earnings_id") as? earnings
            
            push!.start_date = "\(today_date)"
            push!.end_date = "\(today_date)"
            
            self.navigationController?.pushViewController(push!, animated: true)
            
        } else if indexPath.row == 1 {
            
            let calendar = Calendar.current
            let addOneWeekToCurrentDate = calendar.date(byAdding: .weekOfYear, value: -1, to: Date())
 
             let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            let start_Date = df.string(from: addOneWeekToCurrentDate!)
 
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "earnings_id") as? earnings
            
            push!.start_date = "\(start_Date)"
            push!.end_date = "\(today_date)"
            
            self.navigationController?.pushViewController(push!, animated: true)
            
        } else if indexPath.row == 2 {
            
            let calendar = Calendar.current
            let addOneWeekToCurrentDate = calendar.date(byAdding: .month, value: -1, to: Date())
            // print(addOneWeekToCurrentDate as Any)
            
            // let earlyDate = Calendar.current.date( byAdding: .hour, value: -1, to: Date())
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            let start_Date = df.string(from: addOneWeekToCurrentDate!)
            print(start_Date as Any)
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "earnings_id") as? earnings
            
            push!.start_date = "\(start_Date)"
            push!.end_date = "\(today_date)"
            
            self.navigationController?.pushViewController(push!, animated: true)
            
        } else if indexPath.row == 3 {
            
            let calendar = Calendar.current
            let addOneWeekToCurrentDate = calendar.date(byAdding: .year, value: -1, to: Date())
            // print(addOneWeekToCurrentDate as Any)
            
            // let earlyDate = Calendar.current.date( byAdding: .hour, value: -1, to: Date())
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            let start_Date = df.string(from: addOneWeekToCurrentDate!)
            print(start_Date as Any)
            
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "earnings_id") as? earnings
            
            push!.start_date = "\(start_Date)"
            push!.end_date = "\(today_date)"
            
            self.navigationController?.pushViewController(push!, animated: true)
            
        } else {
            
            // custom 
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Custom_id") as? Custom
            
            // push!.start_date = "\(today_date)"
            // push!.end_date = "\(today_date)"
            
            self.navigationController?.pushViewController(push!, animated: true)
            
        }
        
        /*if indexPath.row == 0 {
            
            
            
        } else if indexPath.row == 1 {
            
            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]  {
                
                if (person["role"] as! String) == "Hospital" || (person["role"] as! String) == "Lab" || (person["role"] as! String) == "Pharmacy" {
                    
                    if self.str_pharmacy_prescription_Status != nil {
                        
                        self.show_test_or_prescripption_images(str_action: "activeprescription",
                                                               str_start_Date: "\(today_date)",
                                                               str_end_date: "\(today_date)",
                                                               str_keyword: "")
                        
                    } else {
                        
                        if self.str_lab_test_Status != nil {
                            
                            self.show_test_or_prescripption_images(str_action: "activetest",
                                                                   str_start_Date: "\(today_date)",
                                                                   str_end_date: "\(today_date)",
                                                                   str_keyword: "")
                            
                        } else {
                            
                            if self.hospital_status_check == "yes" {
                                
                                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PPAppointmentsVC") as? PPAppointmentsVC
                                
                                push!.str_appointment_type = "Hospital"
                                push!.str_appointment_start_Date = "\(today_date)"
                                push!.str_appointment_end_date = "\(today_date)"
                                push!.str_appointment_keyword = ""
                                
                                self.navigationController?.pushViewController(push!, animated: true)
                                
                            } else {
                                
                                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HPDoctorsVC") as? HPDoctorsVC
                                push!.strMyProfileIs = "FromHospitalProfileToPatient"
                                push!.str_from_reports = "yes"
                                push!.str_report_role = "Patient"
                                push!.str_start_Date = "\(today_date)"
                                push!.str_end_Date = "\(today_date)"
                                push!.str_paid = String(self.str_payment_Status)
                                push!.str_keyword = ""
                                
                                self.navigationController?.pushViewController(push!, animated: true)
                                
                            }
                        }
                    }
                    
                    
                    
                } else if (person["role"] as! String) == "Doctor" {
                    // doctor
                    
                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PPAppointmentsVC") as? PPAppointmentsVC
                    
                    push!.str_appointment_type = "Doctor"
                    push!.str_appointment_start_Date = "\(today_date)"
                    push!.str_appointment_end_date = "\(today_date)"
                    push!.str_appointment_keyword = ""
                    
                    self.navigationController?.pushViewController(push!, animated: true)
                    
                } else if (person["role"] as! String) == "Supplier" {
                    
                    
                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "orderHistoryVC") as? orderHistoryVC
                    
                    push!.str_order_history_start_Date = "\(today_date)"
                    push!.str_order_history_end_Date = "\(today_date)"
                    push!.str_order_history_keyword = ""
                    
                    self.navigationController?.pushViewController(push!, animated: true)
                    
                }
                
            }
            
            
            
            // show_reports_Result
            
        } else if indexPath.row == 2 {
            
            
            let calendar = Calendar.current
            let addOneWeekToCurrentDate = calendar.date(byAdding: .weekOfYear, value: -1, to: Date())
            // print(addOneWeekToCurrentDate as Any)
            
            // let earlyDate = Calendar.current.date( byAdding: .hour, value: -1, to: Date())
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            let start_Date = df.string(from: addOneWeekToCurrentDate!)
            // print(start_Date as Any)
            
            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]  {
                
                if (person["role"] as! String) == "Hospital" || (person["role"] as! String) == "Lab" || (person["role"] as! String) == "Pharmacy" {
                    
                    if self.str_pharmacy_prescription_Status != nil {
                        
                        self.show_test_or_prescripption_images(str_action: "activeprescription",
                                                               str_start_Date: "\(start_Date)",
                                                               str_end_date: "\(today_date)",
                                                               str_keyword: "")
                        
                    } else {
                        
                        if self.str_lab_test_Status != nil {
                            
                            self.show_test_or_prescripption_images(str_action: "activetest",
                                                                   str_start_Date: "\(start_Date)",
                                                                   str_end_date: "\(today_date)",
                                                                   str_keyword: "")
                            
                        } else {
                            
                            if self.hospital_status_check == "yes" {
                                
                                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PPAppointmentsVC") as? PPAppointmentsVC
                                
                                push!.str_appointment_type = "Hospital"
                                push!.str_appointment_start_Date = "\(start_Date)"
                                push!.str_appointment_end_date = "\(today_date)"
                                push!.str_appointment_keyword = ""
                                
                                self.navigationController?.pushViewController(push!, animated: true)
                                
                            } else {
                                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HPDoctorsVC") as? HPDoctorsVC
                                
                                push!.strMyProfileIs = "FromHospitalProfileToPatient"
                                push!.str_from_reports = "yes"
                                push!.str_report_role = "Patient"
                                push!.str_start_Date = "\(start_Date)"
                                push!.str_end_Date = "\(today_date)"
                                push!.str_paid = String(self.str_payment_Status)
                                push!.str_keyword = ""
                                
                                self.navigationController?.pushViewController(push!, animated: true)
                            }
                        }
                    }
                    
                } else if (person["role"] as! String) == "Doctor" {
                    
                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PPAppointmentsVC") as? PPAppointmentsVC
                    
                    push!.str_appointment_type = "Doctor"
                    push!.str_appointment_start_Date = "\(start_Date)"
                    push!.str_appointment_end_date = "\(today_date)"
                    push!.str_appointment_keyword = ""
                    
                    self.navigationController?.pushViewController(push!, animated: true)
                    
                }  else if (person["role"] as! String) == "Supplier" {
                    
                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "orderHistoryVC") as? orderHistoryVC
                    
                    push!.str_order_history_start_Date = "\(start_Date)"
                    push!.str_order_history_end_Date = "\(today_date)"
                    push!.str_order_history_keyword = ""
                    
                    self.navigationController?.pushViewController(push!, animated: true)
                    
                }
                
            }
            
            
        } else if indexPath.row == 3 {
            
            
            let calendar = Calendar.current
            let addOneWeekToCurrentDate = calendar.date(byAdding: .month, value: -1, to: Date())
            // print(addOneWeekToCurrentDate as Any)
            
            // let earlyDate = Calendar.current.date( byAdding: .hour, value: -1, to: Date())
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            let start_Date = df.string(from: addOneWeekToCurrentDate!)
            print(start_Date as Any)
            
            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]  {
                
                if (person["role"] as! String) == "Hospital" || (person["role"] as! String) == "Lab" || (person["role"] as! String) == "Pharmacy" {
                    
                    if self.str_pharmacy_prescription_Status != nil {
                        
                        self.show_test_or_prescripption_images(str_action: "activeprescription",
                                                               str_start_Date: "\(start_Date)",
                                                               str_end_date: "\(today_date)",
                                                               str_keyword: "")
                        
                    } else {
                        
                        if self.str_lab_test_Status != nil {
                            
                            self.show_test_or_prescripption_images(str_action: "activetest",
                                                                   str_start_Date: "\(start_Date)",
                                                                   str_end_date: "\(today_date)",
                                                                   str_keyword: "")
                            
                        } else {
                            
                            if self.hospital_status_check == "yes" {
                                
                                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PPAppointmentsVC") as? PPAppointmentsVC
                                
                                push!.str_appointment_type = "Hospital"
                                push!.str_appointment_start_Date = "\(start_Date)"
                                push!.str_appointment_end_date = "\(today_date)"
                                push!.str_appointment_keyword = ""
                                
                                self.navigationController?.pushViewController(push!, animated: true)
                                
                            } else {
                                
                                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HPDoctorsVC") as? HPDoctorsVC
                                
                                push!.strMyProfileIs = "FromHospitalProfileToPatient"
                                push!.str_from_reports = "yes"
                                push!.str_report_role = "Patient"
                                push!.str_start_Date = "\(start_Date)"
                                push!.str_end_Date = "\(today_date)"
                                push!.str_paid = String(self.str_payment_Status)
                                push!.str_keyword = ""
                                
                                self.navigationController?.pushViewController(push!, animated: true)
                            }
                        }
                    }
                    
                } else if (person["role"] as! String) == "Doctor" {
                    
                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PPAppointmentsVC") as? PPAppointmentsVC
                    
                    push!.str_appointment_type = "Doctor"
                    push!.str_appointment_start_Date = "\(start_Date)"
                    push!.str_appointment_end_date = "\(today_date)"
                    push!.str_appointment_keyword = ""
                    
                    self.navigationController?.pushViewController(push!, animated: true)
                    
                } else if (person["role"] as! String) == "Supplier" {
                    
                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "orderHistoryVC") as? orderHistoryVC
                    
                    push!.str_order_history_start_Date = "\(start_Date)"
                    push!.str_order_history_end_Date = "\(today_date)"
                    push!.str_order_history_keyword = ""
                    
                    self.navigationController?.pushViewController(push!, animated: true)
                    
                }
                
            }
            
        } else if indexPath.row == 4 {
            
            
            let calendar = Calendar.current
            let addOneWeekToCurrentDate = calendar.date(byAdding: .year, value: -1, to: Date())
            // print(addOneWeekToCurrentDate as Any)
            
            // let earlyDate = Calendar.current.date( byAdding: .hour, value: -1, to: Date())
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            let start_Date = df.string(from: addOneWeekToCurrentDate!)
            print(start_Date as Any)
            
            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any]  {
                
                if (person["role"] as! String) == "Hospital" || (person["role"] as! String) == "Lab" || (person["role"] as! String) == "Pharmacy" {
                    
                    if self.str_pharmacy_prescription_Status != nil {
                        
                        self.show_test_or_prescripption_images(str_action: "activeprescription",
                                                               str_start_Date: "\(start_Date)",
                                                               str_end_date: "\(today_date)",
                                                               str_keyword: "")
                        
                    } else {
                        
                        if self.str_lab_test_Status != nil {
                            
                            self.show_test_or_prescripption_images(str_action: "activetest",
                                                                   str_start_Date: "\(start_Date)",
                                                                   str_end_date: "\(today_date)",
                                                                   str_keyword: "")
                            
                        } else {
                            
                            if self.hospital_status_check == "yes" {
                                
                                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PPAppointmentsVC") as? PPAppointmentsVC
                                
                                push!.str_appointment_type = "Hospital"
                                push!.str_appointment_start_Date = "\(start_Date)"
                                push!.str_appointment_end_date = "\(today_date)"
                                push!.str_appointment_keyword = ""
                                
                                self.navigationController?.pushViewController(push!, animated: true)
                                
                            } else {
                                
                                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HPDoctorsVC") as? HPDoctorsVC
                                
                                push!.strMyProfileIs = "FromHospitalProfileToPatient"
                                push!.str_from_reports = "yes"
                                push!.str_report_role = "Patient"
                                push!.str_start_Date = "\(start_Date)"
                                push!.str_end_Date = "\(today_date)"
                                push!.str_paid = String(self.str_payment_Status)
                                push!.str_keyword = ""
                                
                                self.navigationController?.pushViewController(push!, animated: true)
                            }
                        }
                    }
                    
                } else if (person["role"] as! String) == "Doctor" {
                    
                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PPAppointmentsVC") as? PPAppointmentsVC
                    
                    push!.str_appointment_type = "Doctor"
                    push!.str_appointment_start_Date = "\(start_Date)"
                    push!.str_appointment_end_date = "\(today_date)"
                    push!.str_appointment_keyword = ""
                    
                    self.navigationController?.pushViewController(push!, animated: true)
                    
                } else if (person["role"] as! String) == "Supplier" {
                    
                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "orderHistoryVC") as? orderHistoryVC
                    
                    push!.str_order_history_start_Date = "\(start_Date)"
                    push!.str_order_history_end_Date = "\(today_date)"
                    push!.str_order_history_keyword = ""
                    
                    self.navigationController?.pushViewController(push!, animated: true)
                    
                }
                
            }
            
        } else {
            
        }*/
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }
    
}

class earning_new_table_cell : UITableViewCell {
    
    @IBOutlet weak var lbl_cell:UILabel! {
        didSet {
            lbl_cell.textColor = . white
        }
    }
    
    
}
