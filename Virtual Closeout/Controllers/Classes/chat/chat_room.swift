//
//  chat_room.swift
//  Virtual Closeout
//
//  Created by Apple on 14/06/22.
//

import UIKit

import Firebase
import FirebaseStorage

//import GrowingTextView

import SDWebImage

import QCropper

class chat_room: UIViewController , MessagingDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate , CropperViewControllerDelegate {
    
    // we get login user random custom id for chat
    var getLoginUserCustomId:String!
    
    var universalChatMessages:NSMutableArray = []
    
    var getPublicOrPrivateData:NSDictionary!
    
    var universalRoomId:String! = ""
    
    var strMatchSenderId:String! = ""
    
    var senderNameSaved:String!
    
    // for image
    var uploadImageForChatURL:String! = ""
    var imageStr1:String! = "0"
    var imgData1:Data!
    
    
    // NEW FOR VIRTUAL CLOSE-OUT
    var str_get_new_sender_id:String!
    var str_get_new_sender_name:String!
    var str_get_new_sender_image:String!
    
    var str_get_new_receiver_id:String!
    var str_get_new_receiver_name:String!
    var str_get_new_receiver_image:String!
    
    var new_room_id:String!
    
    var img_data_logo : Data!
    var img_Str_logo : String!
    
    var get_details_product_name:String!
    var get_details_price:String!
    var get_details_color:String!
    var get_details_category:String!
    var get_details_sub_category:String!
    
    @IBOutlet weak var btnNotification:UIButton! {
        didSet {
            btnNotification.setTitle("", for: .normal)
            btnNotification.tintColor = .black
            btnNotification.setTitleColor(.white, for: .normal)
            /*btnNotification.layer.cornerRadius = 20
             btnNotification.clipsToBounds = true
             btnNotification.layer.borderWidth = 1
             btnNotification.layer.borderColor = UIColor.lightGray.cgColor
             btnNotification.backgroundColor = .systemOrange
             btnNotification.setTitleColor(.white, for: .normal)*/
        }
    }
    
    @IBOutlet weak var uploadingImageView:UIView! {
        didSet {
            uploadingImageView.backgroundColor = button_light
            uploadingImageView.isHidden = true
        }
    }
    
    @IBOutlet weak var indicators:UIActivityIndicatorView! {
        didSet {
            indicators.color = .white
        }
    }
    
    @IBOutlet weak var lblProcessingImage:UILabel! {
        didSet {
            lblProcessingImage.textColor = .white
            lblProcessingImage.text = "processing..."
        }
    }
    
    @IBOutlet weak var inputToolbar: UIView! {
        didSet {
            inputToolbar.backgroundColor = button_dark
        }
    }
    
    @IBOutlet weak var textView: CustomGrowingTextView! {
        didSet {
            textView.backgroundColor = .white
            textView.textColor = .black
        }
    }
    
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "i am chat controller"
            lblNavigationTitle.textColor = .black
        }
    }
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet{
            btnBack.tintColor = .black
        }
    }
    
    @IBOutlet weak var btnRooms:UIButton! {
        didSet {
            btnRooms.setTitle("Rooms", for: .normal)
            btnRooms.backgroundColor = button_dark
            btnRooms.layer.cornerRadius = 18-1
            btnRooms.clipsToBounds = true
            btnRooms.isHidden = true
        }
    }
    
    // MARK:- TABLE VIEW -
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            self.tbleView.delegate = self
            self.tbleView.dataSource = self
            self.tbleView.backgroundColor = UIColor.init(red: 244.0/255.0, green: 246.0/255.0, blue: 248.0/255.0, alpha: 1)
            self.tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
        }
    }
    
    @IBOutlet weak var btnSendMessage:UIButton! {
        didSet {
            btnSendMessage.tintColor = .white
        }
    }
    
    @IBOutlet weak var btnAttachment:UIButton! {
        didSet {
            btnAttachment.tintColor = .white
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.view.backgroundColor = .white
        
        self.tbleView.separatorColor = .clear
        self.btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
        // send message
        self.btnSendMessage.addTarget(self, action: #selector(send_chat_without_attachment), for: .touchUpInside)
        
        // self.btnRooms.addTarget(self, action: #selector(createRoomClickMethod), for: .touchUpInside)
         self.btnNotification.addTarget(self, action: #selector(my_all_dialog_rooms), for: .touchUpInside)
        
        // *** Customize GrowingTextView ***
        textView.layer.cornerRadius = 4.0
        
        // *** Listen to keyboard show / hide ***
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        // *** Hide keyboard when tapping outside ***
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        view.addGestureRecognizer(tapGesture)
        
        // print(self.getLoginUserCustomId as Any)
        
        // sender's data
        if let person = UserDefaults.standard.value(forKey: key_user_default_value) as? [String:Any] {
            // print(person as Any)
            
            self.str_get_new_sender_id = "\(person["userId"]!)"
            self.str_get_new_sender_name = (person["fullName"] as! String)
            self.str_get_new_sender_image = (person["image"] as! String)
            
            print(self.str_get_new_sender_id as Any)
            print(self.str_get_new_sender_name as Any)
            print(self.str_get_new_sender_image as Any)
            
            print(self.str_get_new_receiver_id as Any)
            print(self.str_get_new_receiver_name as Any)
            print(self.str_get_new_receiver_image as Any)
            
            // lblNavigationTitle
            
            self.lblNavigationTitle.text = String(self.str_get_new_receiver_name)
            
        }
        
        /*// my saved name
         let defaults = UserDefaults.standard
         if let mySavedName = defaults.string(forKey: "KeyMyChatRoomName") {
         print("defaults savedString: \(mySavedName)")
         
         self.senderNameSaved = "\(mySavedName)"
         }*/
        
        self.btnAttachment.addTarget(self, action: #selector(cellTappedMethod1), for: .touchUpInside)
        
        
        // room name
        
        // self.strMatchSenderId = Auth.auth().currentUser!.uid
        
        // call fetch chats calls here
        self.get_all_chats_of_both_users()
    }
    
    @objc func backClickMethod() {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        if let endFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var keyboardHeight = UIScreen.main.bounds.height - endFrame.origin.y
            if #available(iOS 11, *) {
                if keyboardHeight > 0 {
                    keyboardHeight = keyboardHeight - view.safeAreaInsets.bottom
                }
            }
            textViewBottomConstraint.constant = keyboardHeight + 8
            view.layoutIfNeeded()
        }
    }
    
    @objc func tapGestureHandler() {
        view.endEditing(true)
    }
    
    func scrollToBottom() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.universalChatMessages.count-1, section: 0)
            self.tbleView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    // MARK:- FETCH ALL CHATS -
    @objc func get_all_chats_of_both_users() {
        
        print(self.str_get_new_sender_id+"+"+self.str_get_new_receiver_id)
        
        let ref = Database.database().reference()
        
            ref.child("one_to_one")
            .child(self.str_get_new_sender_id+"+"+self.str_get_new_receiver_id)
        
        
            // .queryLimited(toLast: 40)
        
            .observe(.value, with: { (snapshot) in
                if snapshot.exists() {
                    print("======> true rooms exist <========")
                    
                    self.new_room_id = self.str_get_new_sender_id+"+"+self.str_get_new_receiver_id
                    
                    self.universalChatMessages.removeAllObjects()
                    
                    for child in snapshot.children {
                        let snap = child as! DataSnapshot
                        let placeDict = snap.value as! [String: Any]
                        print(placeDict as Any)
                        
                        self.universalChatMessages.add(placeDict)
                        print(self.universalChatMessages as Any)
                        
                        self.tbleView.isHidden = false
                        
                        if self.universalChatMessages.count == 0 {
                            self.tbleView.isHidden = true
                        }
                        
                        if self.universalChatMessages.count > 2 {
                            self.scrollToBottom()
                        }
                        
                        self.tbleView.delegate = self
                        self.tbleView.dataSource = self
                        self.tbleView.reloadData()
                        
                        DispatchQueue.main.async {
                            
                        }
                        
                        
                    }
                    
                } else {
                    
                    print("======> false rooms not exist <========")
                    
                    self.check_another_id_if_room_not_exist()
                    
                }
            })
        
    }
    
    @objc func check_another_id_if_room_not_exist() {
        
        let ref = Database.database().reference()
        // ref.child(universalRoomId)
        
        //.queryOrdered(byChild: "Universal_Chat_CountryName")
        // .queryEqual(toValue: "\(myCountryName)")
        
        ref.child("one_to_one")
        .child(self.str_get_new_receiver_id+"+"+self.str_get_new_sender_id)
        
            .queryLimited(toLast: 40)
        
            .observe(.value, with: { (snapshot) in
                if snapshot.exists() {
                    print("======> true rooms exist <========")
                    
                    self.new_room_id = self.str_get_new_receiver_id+"+"+self.str_get_new_sender_id
                    
                    self.universalChatMessages.removeAllObjects()
                    
                    for child in snapshot.children {
                        let snap = child as! DataSnapshot
                        let placeDict = snap.value as! [String: Any]
                        print(placeDict as Any)
                        
                        self.universalChatMessages.add(placeDict)
                        print(self.universalChatMessages as Any)
                        
                        self.tbleView.isHidden = false
                        
                        if self.universalChatMessages.count == 0 {
                            self.tbleView.isHidden = true
                        }
                        
                        if self.universalChatMessages.count > 2 {
                            self.scrollToBottom()
                        }
                        
                        self.tbleView.delegate = self
                        self.tbleView.dataSource = self
                        self.tbleView.reloadData()
                        
                        DispatchQueue.main.async {
                            
                        }
                        
                        
                    }
                    
                } else {
                    
                    print("======> false rooms not exist again <========")
                    
                    // create room id here
                    self.new_room_id = self.str_get_new_sender_id+"+"+self.str_get_new_receiver_id
                    
                    print(String(self.new_room_id))
                    
                    
                }
            })
        
    }
    
    // MARK: - PUSH TO ALL MY DIALOGS ROOMS -
    @objc func my_all_dialog_rooms() {
        
        // print(self.get_details_product_name as Any)
        // print(self.get_details_price as Any)
        // print(self.get_details_color as Any)
        // print(self.get_details_category as Any)
        // print(self.get_details_sub_category as Any)
        
        let alert = NewYorkAlertController(title: String("Product details"), message: "Product name : "+String(self.get_details_product_name)+"\nPrice : $"+String(self.get_details_price)+"\nColor : "+String(self.get_details_color)+"\nCategory : "+String(self.get_details_category)+"\nSub-category : "+String(self.get_details_sub_category), style: .alert)
        let cancel = NewYorkButton(title: "dismiss", style: .cancel)
        alert.addButtons([cancel])
        self.present(alert, animated: true)
        
        /*let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "ChatRoomsId")
         self.navigationController?.pushViewController(push, animated: true)*/
        
    }
    // push
    @objc func createRoomClickMethod() {
        
        /*let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "ChatRoomsId")
         self.navigationController?.pushViewController(push, animated: true)*/
    }
    
    @objc func cellTappedMethod1() {
        
        let actionSheet = NewYorkAlertController(title: "Upload image", message: nil, style: .actionSheet)
        
        // actionSheet.addImage(UIImage(named: "camera"))
        
        let cameraa = NewYorkButton(title: "Camera", style: .default) { _ in
            print("camera clicked done")
            self.open_camera_or_gallery(str_type: "c")
        }
        
        let gallery = NewYorkButton(title: "Gallery", style: .default) { _ in
            print("gallery clicked done")
            self.open_camera_or_gallery(str_type: "g")
        }
        
        let cancel = NewYorkButton(title: "Cancel", style: .cancel)
        
        actionSheet.addButton(cameraa)
        actionSheet.addButton(gallery)
        
        actionSheet.addButton(cancel)
        
        present(actionSheet, animated: true)
        
    }
    
    // MARK: - OPEN CAMERA or GALLERY -
    @objc func open_camera_or_gallery(str_type:String) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if str_type == "c" {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image_data = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
            let cropper = CropperViewController(originalImage: image_data!)
            
            cropper.delegate = self
            
            picker.dismiss(animated: true) {
                self.present(cropper, animated: true, completion: nil)
                
            }

    }
    
    func cropperDidConfirm(_ cropper: CropperViewController, state: CropperState?) {
        cropper.dismiss(animated: true, completion: nil)
        
        self.uploadingImageView.isHidden = false
        self.indicators.startAnimating()
        
        if let state = state,
           let image = cropper.originalImage.cropped(withCropperState: state) {
            
            // cell.img_profile.image = image
                
            let imageData:Data = image.pngData()!
            self.img_data_logo = imageData
                
            var strURL = ""
            
            // Points to the root reference
            let store = Storage.storage()
            let storeRef = store.reference()
            
            // #2
            let removeBeforeThisDate = NSDate()
            let currentDateTimestamp = removeBeforeThisDate.timeIntervalSince1970
            
            let storeImage = storeRef.child("virtual_cashout_chat_images")
                .child(String(self.str_get_new_sender_id)+"&"+String(currentDateTimestamp)+".png")
            
            // if let uploadImageData = UIImagePNGRepresentation((img.image)!){
            storeImage.putData(self.img_data_logo, metadata: nil, completion: { (metaData, error) in
                storeImage.downloadURL(completion: { (url, error) in
                    if let urlText = url?.absoluteString {
                        
                        strURL = urlText
                        print("///////////tttttttt////////\(strURL)////////")
                        
                        self.uploadImageForChatURL = ("\(strURL)")
                        
                        // upload attachment image to firebase server
                        self.send_chat_with_attachment()
                        
                    }
                })
            })
            
            self.imageStr1 = "1"
            
        } else {
            print("Something went wrong")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK:- SEND MESSAGE WITHOUT ATTACHMENT -
    @objc func sendMessageWithoutAttachment() {
        
    }
    
    // MARK:- SEND MESSAGE WITHOUT ATTACHMENT -
    @objc func send_chat_without_attachment() {
        
        if self.textView.text == "" {
            
        } else {
            
            // chat random id
            // let create_chat_id = String.createChatId()
            
            // time stamp
            let someDate = Date()
            print(someDate)
            
            let myTimeStamp = someDate.timeIntervalSince1970
            
            let calendar = Calendar.current
            let time=calendar.dateComponents([.hour,.minute,.second], from: Date())
            print("\(time.hour!):\(time.minute!):\(time.second!)")
            
            // self.view.endEditing(true)
            let ref = Database.database().reference()
            
                .child("one_to_one")
                .child(String(self.new_room_id))
            
                .childByAutoId()
            
            
            let message = ["attachment_path"    : "",
                           "chatSenderId"       : String(self.str_get_new_sender_id),
                           "chat_date"          : String("...date..."),
                           "chat_message"       : String(self.textView.text),
                           "chat_receiver"      : String(self.str_get_new_receiver_name),
                           "chat_sender"        : String(self.str_get_new_sender_name),
                           "chat_sender_img"    : String(self.str_get_new_sender_image),
                           "chat_time"          : "\(time.hour!):\(time.minute!):\(time.second!)",
                           
                           "type"          : String("Text")] as [String : Any]
            
            ref.setValue(message)
            
            self.textView.text = ""
            
            
        }
        
        
    }
    
    // MARK:- SEND MESSAGE WITH ATTACHMENT -
    @objc func send_chat_with_attachment() {
        
        self.uploadingImageView.isHidden = true
        self.indicators.stopAnimating()
        
        let someDate = Date()
        print(someDate)
        
        let myTimeStamp = someDate.timeIntervalSince1970
        
        let calendar = Calendar.current
        let time=calendar.dateComponents([.hour,.minute,.second], from: Date())
        print("\(time.hour!):\(time.minute!):\(time.second!)")
        
        // self.view.endEditing(true)
        let ref = Database.database().reference()
        
            .child("one_to_one")
            .child(String(self.new_room_id))
        
            .childByAutoId()
        
        
        let message = ["attachment_path"    : String(self.uploadImageForChatURL),
                       "chatSenderId"       : String(self.str_get_new_sender_id),
                       "chat_date"          : String("...date..."),
                       "chat_message"       : String(self.textView.text),
                       "chat_receiver"      : String(self.str_get_new_receiver_name),
                       "chat_sender"        : String(self.str_get_new_sender_name),
                       "chat_sender_img"    : String(self.str_get_new_sender_image),
                       "chat_time"          : "\(time.hour!):\(time.minute!):\(time.second!)",
                       
                       "type"          : String("Image")] as [String : Any]
        
        ref.setValue(message)
        
        self.textView.text = ""
        
        
    }
        
    
    
    
    
}

extension chat_room: UITableViewDataSource , UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.universalChatMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = self.universalChatMessages[indexPath.row] as? [String:Any]
        
        print(item as Any)
        
        if (item!["chatSenderId"] as! String) == String(self.str_get_new_sender_id) {
            
            if item!["type"] as! String == "Text" {
                
                // text
                let cell1 = tableView.dequeueReusableCell(withIdentifier: "cellOne") as! chat_room_table_cell
                
                cell1.senderName.text = " "+(item!["chat_sender"] as! String)
                cell1.senderName.textColor = .white
                
                
                cell1.senderText.text = (item!["chat_message"] as! String)
                cell1.senderText.textColor = .white
                
                cell1.senderText.setMargins(10)
                
                cell1.backgroundColor = .clear
                
                cell1.lblTimeSender.text = (item!["chat_time"] as! String)
                cell1.lblTimeSender.textColor = .white
                
                cell1.imgSender.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                cell1.imgSender.sd_setImage(with: URL(string: (item!["chat_sender_img"] as! String)), placeholderImage: UIImage(named: "logo"))
                
                cell1.bubbleImageView.image = UIImage(named: "chat_bubble_sent")!
                    .resizableImage(withCapInsets:
                                        UIEdgeInsets(top: 17, left: 21, bottom: 17, right: 21),
                                    resizingMode: .stretch)
                    .withRenderingMode(.alwaysTemplate)
                
                cell1.viewRight.backgroundColor = .clear
                
                return cell1
                
            } else  {
                
                // image
                let cell3 = tableView.dequeueReusableCell(withIdentifier: "cellThree") as! chat_room_table_cell
                
                cell3.imgSenderAttachment.backgroundColor = button_light
                cell3.imgSenderAttachment.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                cell3.imgSenderAttachment.sd_setImage(with: URL(string: (item!["attachment_path"] as! String)), placeholderImage: UIImage(named: "logo"))
                cell3.backgroundColor = .clear
                
                cell3.lblTimeSenderForImage.text = (item!["chat_time"] as! String)                
                cell3.lblTimeSenderForImage.textColor = .white
                
                cell3.imgSenderAttachment2.backgroundColor = .white
                cell3.imgSenderAttachment2.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                cell3.imgSenderAttachment2.sd_setImage(with: URL(string: (item!["chat_sender_img"] as! String)), placeholderImage: UIImage(named: "logo"))
                
                return cell3
                
            }
            
            
        } else { // receiver
            
            if item!["type"] as! String == "Text" {
                
                let cell2 = tableView.dequeueReusableCell(withIdentifier: "cellTwo") as! chat_room_table_cell
                
                cell2.receiverName.text = (item!["chat_receiver"] as! String)
                cell2.receiverName.textColor = .white
                
                // chat message for reciver
                cell2.receiverText.text = (item!["chat_message"] as! String)
                cell2.receiverText.setMargins(10)
                
                
                
                cell2.receiverText.textColor = .white
                
                
                
                cell2.bubbleImageViewReceiver.image = UIImage(named: "chat_bubble_received")!
                    .resizableImage(withCapInsets:
                                        UIEdgeInsets(top: 17, left: 21, bottom: 17, right: 21),
                                    resizingMode: .stretch)
                    .withRenderingMode(.alwaysTemplate)
                
                cell2.backgroundColor = .clear

                cell2.lblTimeReceiver.text = (item!["chat_time"] as! String)
                cell2.lblTimeReceiver.textColor = .white
                
                cell2.imgReceiver.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                cell2.imgReceiver.sd_setImage(with: URL(string: (item!["chat_sender_img"] as! String)), placeholderImage: UIImage(named: "logo"))
                
                cell2.imgReceiver.tag = indexPath.row
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
                cell2.imgReceiver.isUserInteractionEnabled = true
                cell2.imgReceiver.addGestureRecognizer(tapGestureRecognizer)
                
                cell2.viewLeft.backgroundColor = .clear
                
                return cell2
                
            } else {
                
                let cell4 = tableView.dequeueReusableCell(withIdentifier: "cellFour") as! chat_room_table_cell
                
                cell4.imgReceiverAttachment.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                cell4.imgReceiverAttachment.sd_setImage(with: URL(string: (item!["attachment_path"] as! String)), placeholderImage: UIImage(named: "logo"))
                cell4.backgroundColor = .clear
                
                cell4.lblTimeReceiverForImage.text = (item!["chat_time"] as! String)
                cell4.lblTimeReceiverForImage.textColor = .black
                
                cell4.imgReceiverAttachment.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
                cell4.imgReceiverAttachment.sd_setImage(with: URL(string: (item!["chat_attachment"] as! String)), placeholderImage: UIImage(named: "anonymous"))
                cell4.imgReceiverAttachment.backgroundColor = .clear
                
                // receiver profile picture name : imgReceiverAttachment2
                cell4.imgReceiverAttachment2.sd_setImage(with: URL(string: (item!["chat_sender_img"] as! String)), placeholderImage: UIImage(named: "logo"))
                cell4.imgReceiverAttachment2.tag = indexPath.row
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
                cell4.imgReceiverAttachment2.isUserInteractionEnabled = true
                cell4.imgReceiverAttachment2.addGestureRecognizer(tapGestureRecognizer)
                
                return cell4
                
            }
            
            
        }
        
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        print(tappedImage.tag as Any)
        // Your action
        
        /*let item = self.universalChatMessages[tappedImage.tag] as? [String:Any]
         print(item as Any)
         
         let actionSheet = NewYorkAlertController(title: "Personal Chat", message: "Chat with "+(item!["chat_sender_name"] as! String)+"."+"\nYou can see all of your current chats in Rooms section.", style: .actionSheet)
         
         actionSheet.addImage(UIImage(named: "camera"))
         
         /*let buttons = (1...3).map { i -> NewYorkButton in
          let button = NewYorkButton(title: "Option \(i)", style: .default) { _ in
          print("Tapped option \(i)")
          }
          button.setDynamicColor(.pink)
          return button
          }
          actionSheet.addButtons(buttons)*/
         
         let cameraa = NewYorkButton(title: "Chat", style: .default) { _ in
         print("camera clicked done")
         
         /*let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "PersonalChatId") as? PersonalChat
          
          let ref = Database.database().reference()
          ref.child(APP_MODE+"Personal_Chats")
          .child(item!["chat_sender_id"] as! String)
          .child("Profile")
          
          .observeSingleEvent(of:.value, with: { (snapshot) in
          if snapshot.exists() {
          print("true rooms exist")
          
          for child in snapshot.children {
          let snap = child as! DataSnapshot
          let placeDict = snap.value as! [String: Any]
          // print(placeDict as Any)
          
          // self.chatMessages.add(placeDict)
          
          let item2 = (placeDict["User_Custom_Chat_Id"] as! String)
          print(item2 as Any)
          
          let item3 = (placeDict["User_Custom_Chat_Name"] as! String)
          print(item3 as Any)
          
          // self.addUsersToGetCustomChatId.add(item)
          
          ERProgressHud.sharedInstance.hide()
          
          // user 1 : custom name
          push!.getCustomIdOfUserOneForChat = self.getLoginUserCustomId
          
          
          
          push!.getCustomIdOfUserTwoForChat = item2
          
          
          
          
          
          push!.messageSenderFirebaseId = Auth.auth().currentUser!.uid
          
          // user 2 : firebase id
          push!.messageReceiverFirebaseId = (item!["chat_sender_id"] as! String)
          
          // user 2 : name on that chat box
          push!.receiverNameFromUniversalChat = item3
          
          self.navigationController?.pushViewController(push!, animated: true)
          
          }
          }
          
          })*/
         
         
         let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "PersonalChatId") as? PersonalChat
         
         // user 1
         push!.getCustomIdOfUserOneForChat = self.getLoginUserCustomId
         
         // user 1 : firebase id
         push!.messageSenderFirebaseId = Auth.auth().currentUser!.uid
         
         
         // user 2 : custom id for chat
         push!.getCustomIdOfUserTwoForChat = (item!["chat_custom_id"] as! String)
         
         // user 2 : firebase id
         push!.messageReceiverFirebaseId = (item!["chat_sender_id"] as! String)
         
         push!.get_dialog_id_from_dialog_rooms = (item!["chat_sender_id"] as! String)
         
         // user 2 : name on that chat box
         push!.receiverNameFromUniversalChat = (item!["chat_sender_name"] as! String)
         self.navigationController?.pushViewController(push!, animated: true)
         
         
         }
         
         let cancel = NewYorkButton(title: "Cancel", style: .cancel)
         
         actionSheet.addButton(cameraa)
         actionSheet.addButton(cancel)
         
         present(actionSheet, animated: true)*/
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let item = self.universalChatMessages[indexPath.row] as? [String:Any]
        
        if item!["type"] as! String == "Text" {
            
            return UITableView.automaticDimension
        } else {
            
            return 280
        }
        
    }
    
}

class chat_room_table_cell: UITableViewCell {
    
    @IBOutlet weak var bubbleImageView: UIImageView! {
        didSet {
            bubbleImageView.backgroundColor = .clear
        }
    }
    @IBOutlet weak var bubbleHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bubbleImageViewReceiver: UIImageView! {
        didSet {
            bubbleImageViewReceiver.backgroundColor = .clear
        }
    }
    @IBOutlet weak var bubbleHeightConstraintReceiver: NSLayoutConstraint!
    
    @IBOutlet weak var senderName:UILabel! {
        didSet {
            senderName.text = "Dishant Rajput"
            senderName.textColor = .black
        }
    }
    
    @IBOutlet weak var senderText:UILabel! {
        didSet {
            senderText.textColor = .black
            senderText.textAlignment = .right
        }
    }
    
    @IBOutlet weak var receiverName:UILabel! {
        didSet {
            receiverName.text = "Dishu Rajput"
        }
    }
    
    @IBOutlet weak var receiverText:UILabel! {
        didSet {
            receiverText.textColor = .black
            receiverText.text = "i am receiverText i am receiverText i am receiverText i am receiverText i am receiverText i am receiverText i am text i am receiverText i am text i am receiverText"
        }
    }
    
    @IBOutlet weak var viewRight:UIView! {
        didSet {
            viewRight.backgroundColor = button_dark
        }
    }
    
    @IBOutlet weak var viewLeft:UIView! {
        didSet {
            viewLeft.backgroundColor = UIColor.init(red: 222.0/255.0, green: 222.0/255.0, blue: 222.0/255.0, alpha: 1)
        }
    }
    
    @IBOutlet weak var viewBGImageSender:UIView! {
        didSet {
            viewBGImageSender.layer.cornerRadius = 4
            viewBGImageSender.clipsToBounds = true
            viewBGImageSender.backgroundColor = .systemBlue
        }
    }
    
    @IBOutlet weak var imgSenderAttachment:UIImageView!
    
    @IBOutlet weak var viewBGImageReceiver:UIView! {
        didSet {
            viewBGImageReceiver.layer.cornerRadius = 4
            viewBGImageReceiver.clipsToBounds = true
            viewBGImageReceiver.backgroundColor = UIColor.init(red: 222.0/255.0, green: 222.0/255.0, blue: 222.0/255.0, alpha: 1)
        }
    }
    
    @IBOutlet weak var imgReceiverAttachment:UIImageView!
    
    @IBOutlet weak var imgSender:UIImageView! {
        didSet {
            imgSender.layer.cornerRadius = 20
            imgSender.clipsToBounds = true
            imgSender.layer.borderColor = button_dark.cgColor
            imgSender.layer.borderWidth = 0.8
            imgSender.backgroundColor = .clear
            imgSender.image = UIImage(named: "anonymous")
        }
    }
    
    @IBOutlet weak var imgReceiver:UIImageView! {
        didSet {
            imgReceiver.layer.cornerRadius = 20
            imgReceiver.clipsToBounds = true
            imgReceiver.layer.borderColor = button_dark.cgColor
            imgReceiver.layer.borderWidth = 0.8
            imgReceiver.backgroundColor = .clear
            imgReceiver.image = UIImage(named: "anonymous")
        }
    }
    
    @IBOutlet weak var imgSenderAttachment2:UIImageView! {
        didSet {
            imgSenderAttachment2.layer.cornerRadius = 20
            imgSenderAttachment2.clipsToBounds = true
            imgSenderAttachment2.layer.borderColor = UIColor.white.cgColor
            imgSenderAttachment2.layer.borderWidth = 0.8
        }
    }
    
    @IBOutlet weak var imgReceiverAttachment2:UIImageView! {
        didSet {
            imgReceiverAttachment2.layer.cornerRadius = 20
            imgReceiverAttachment2.clipsToBounds = true
            imgReceiverAttachment2.layer.borderColor = UIColor.white.cgColor
            imgReceiverAttachment2.layer.borderWidth = 0.8
        }
    }
    
    @IBOutlet weak var lblTimeSender:UILabel! {
        didSet {
            lblTimeSender.textColor = .black
        }
    }
    
    @IBOutlet weak var lblTimeSenderForImage:UILabel! {
        didSet {
            lblTimeSenderForImage.textColor = .black
        }
    }
    
    @IBOutlet weak var lblTimeReceiver:UILabel! {
        didSet {
            lblTimeReceiver.textColor = .black
        }
    }
    
    @IBOutlet weak var lblTimeReceiverForImage:UILabel! {
        didSet {
            lblTimeReceiverForImage.textColor = .white
        }
    }
    
    @IBOutlet weak var btnSenderPremiumIcon:UIButton! {
        didSet {
            btnSenderPremiumIcon.backgroundColor = .clear // UIColor.init(red: 212.0/255.0, green: 175.0/255.0, blue: 55.0/255.0, alpha: 1)
            btnSenderPremiumIcon.setTitle("", for: .normal)
            btnSenderPremiumIcon.tintColor = .systemYellow// setTitleColor(.black, for: .normal)
            btnSenderPremiumIcon.isHidden = true
        }
    }
    
    @IBOutlet weak var btnReceiverPremiumIcon:UIButton! {
        didSet {
            btnReceiverPremiumIcon.backgroundColor = .clear // UIColor.init(red: 212.0/255.0, green: 175.0/255.0, blue: 55.0/255.0, alpha: 1)
            btnReceiverPremiumIcon.setTitle("", for: .normal)
            btnReceiverPremiumIcon.tintColor = .systemYellow// setTitleColor(.black, for: .normal)
            btnReceiverPremiumIcon.isHidden = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


import UIKit

@IBDesignable
class CustomGrowingTextView: UITextView {

    /// Max height limit for the text view
    @IBInspectable var maxHeight: CGFloat = 120.0

    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        let fittingSize = sizeThatFits(CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude))
        let height = min(fittingSize.height, maxHeight)
        return CGSize(width: UIView.noIntrinsicMetric, height: height)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // Prevent scrolling so it grows instead
        isScrollEnabled = false
    }

    override var text: String! {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var attributedText: NSAttributedString! {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
}
