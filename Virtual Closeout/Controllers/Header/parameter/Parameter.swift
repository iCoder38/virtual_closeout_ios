//
//  Parameter.swift
//  Bookit App
//
//  Created by Ranjan on 14/01/22.
//

import UIKit


//MARK: - REGISTRATION -
struct create_new_user: Encodable {
    
    //parameter
    let action: String
    let email: String
    let fullName: String
    let password: String
    let device: String
    let role: String
    let latitude: String
    let longitude: String
    let deviceToken:String

}

//MARK: - HELP -
struct help_wb_call: Encodable {
    
    let action: String
}

//MARK: - CHANGE PASSWORD -
struct change_my_password: Encodable {
    let action: String
    let userId:String
    let oldPassword:String
    let newPassword:String
    
}

//MARK: - LOGIN -
struct login_in_account: Encodable {
    
    let action: String
    let password:String
    let email: String
    
}

//MARK: - BANK INFORMATION -
struct add_edit_bank_info: Encodable {
    
    let action: String
    let userId:String
    let AccountNo: String
    let BankName: String
    let AccountHolderName: String
    let RoutingNo: String
    let PayPalAccount: String
    
}

//MARK: - PRODUCT LIST -
struct all_products_list: Encodable {
    
    let action: String
    let userId:String
    let pageNo:Int
    
}

//MARK: - PRODUCT LIST SEARCH -
struct all_products_list_search_params: Encodable {
    
    let action: String
    let userId:String
    let keyword:String
    
}

//MARK: - CATEGORY LIST -
struct category_list: Encodable {
    
    let action: String
    // let pageNo:Int
    
}

//MARK: - CATEGORY LIST -
struct category_list_search_params: Encodable {
    
    let action: String
    let keyword: String
    // let pageNo:Int
    
}

//MARK: - SUB - CATEGORY LIST -
struct sub_category_list: Encodable {
    
    let action: String
    let categoryId:String
    
}

//MARK: - SUB - CATEGORY LIST -
struct sub_category_list_search_params: Encodable {
    
    let action: String
    let categoryId:String
    let keyword:String
    
}

//MARK: - SUB - CATEGORY LIST -
struct product_list_with_images: Encodable {
    
    let action: String
    let categoryId:String
    let subcategoryId:String
    let pageNo:Int
}

//MARK: - SUB - CATEGORY LIST SEARCH -
struct product_search_list_params: Encodable {
    
    let action: String
    let categoryId:String
    let subcategoryId:String
    let pageNo:Int
    let keyword:String
}

//MARK: - SUB - CATEGORY LIST -
struct product_details: Encodable {
    
    let action: String
    let userId:String
    let productId:String
}

//MARK: - CART LIST -
struct get_cart_params: Encodable {
    
    let action: String
    let userId:String
}

//MARK: - CART LIST -
struct cart_list_params: Encodable {
    
    let action: String
    let userId:String
    let quantity:String
    let productId:String
}

//MARK: - ADDRESS LIST -
struct address_list_params: Encodable {
    
    let action: String
    let userId:String
}

//MARK: - ADD ADDRESS -
struct add_address_params: Encodable {
    
    let action: String
    let userId:String
    let firstName:String
    let lastName:String
    let mobile:String
    let address:String
    let City:String
    let state:String
    let Zipcode:String
    let company:String
    let country:String
}

//MARK: - EDIT ADDRESS -
struct edit_address_params: Encodable {
    
    let action: String
    let userId:String
    let addressId:String
    let firstName:String
    let lastName:String
    let mobile:String
    let address:String
    let City:String
    let state:String
    let Zipcode:String
    let company:String
    let country:String
}

//MARK: - ADD CARD -
struct add_new_card_params: Encodable {
    
    let action: String
    let userId:String
    let NameOnCard:String
    let cardNo:String
    let expMonth:String
    let expYear:String
    let nickName:String
    let cardType:String
}

//MARK: - CARD LIST -
struct card_list_params: Encodable {
    
    let action: String
    let userId:String
    let pageNo:String
}

//MARK: - CARD LIST -
struct delete_card_params: Encodable {
    
    let action: String
    let userId:String
    let cardId:String
}

//MARK: - DELETE CART -
struct delete_cart_item_params: Encodable {
    
    let action: String
    let userId:String
    let productId:String
}

//MARK: - DELETE ALL CART -
struct delete_all_cart_items_params: Encodable {
    
    let action: String
    let userId:String
}

//MARK: - ADD PURCHASE -
struct add_purchase_params: Encodable {
    
    let action: String
    let userId:String
    let productDetails:String
    let totalAmount:String
    let ShippingName:String
    let ShippingAddress:String
    let ShippingCity:String
    let ShippingState:String
    let ShippingZipcode:String
    let ShippingPhone:String
    let transactionId:String
    let latitude:String
    let longitude:String
}

//MARK: - ORDER HISTORY -
struct order_history_params: Encodable {
    
    let action: String
    let userId:String
    let userType:String
    let status:String
    let pageNo:Int
}

//MARK: - ORDER HISTORY DETAILS -
struct order_history_details_params: Encodable {
    
    let action: String
    let purcheseId:String
}

//MARK: - DELETE ADDRESS -
struct delete_address_params: Encodable {
    
    let action: String
    let userId:String
    let addressId:String
}

//MARK: - EDIT ADDRESS -
struct edit_business_information_params: Encodable {
    
    let action: String
    let userId:String
    let businessName:String
    let contactNumber:String
    let address:String
    let city:String
    let state:String
    let zipCode:String
    let country:String
}

//MARK: - EARNINGS -
struct club_earning: Encodable {
    let action: String
    let userId:String
}

//MARK: - CASHOUT HISTORY -
struct cashout_history: Encodable {
    
    let action: String
    let userId:String
    let pageNo:String
    
}

//MARK: - FILTER PRODUCTS -
struct filter_pricelow_high_params: Encodable {
    
    let action: String
    let categoryId:String
    let subcategoryId:String
    let pageNo:Int
    let findby:String
}

//MARK: - FILTER PRODUCTS -
struct filter_min_max_price_params: Encodable {
    
    let action: String
    let categoryId:String
    let subcategoryId:String
    let pageNo:Int
    let maxPrice:String
    let minPrice:String
    let productConditions:String
}

//MARK: - CHANGE STATUS -
struct change_status_params: Encodable {
    
    let action: String
    let sellerId:String
    let purcheseId:String
}

/*
 [action] => productlist
     [userId] => 3
     [pageNo] => 1
 */

//MARK: - SELLER -
struct seller_profile_params: Encodable {
    
    let action: String
    let userId:String
    let pageNo:Int
}

// MARK: - CHECK USER'S FULL PROFILE -
struct check_profile_status: Encodable {
    
    let action: String
    let userId: String
}

// ************************************************************************************************
// ************************************************************************************************

struct customer_dashboard: Encodable {
    
    //parameter
    let action: String
    let userId: String
    let keyword: String
    let latitude: String
    let longitude: String
    let countryId: String
    let stateId: String
}

struct customer_table_listing: Encodable {
    
    /*
     action: tablelist
     userId:  // for Club
     clubId:  //for Customer
     pageNo:
     */
    //parameter
    let action: String
    // let action: String
    let clubId: String
    let pageNo: String
    
    // let clubId:String
    // let pageNo:String
}

struct customer_book_a_table: Encodable {
    
    let action: String
    let userId: String
    let clubId: String
    let clubTableId: String
    let bookingDate: String
    let arrvingTime: String
    let totalSeat: String
    let seatPrice: String
    let adminFee: String
    let totalAmount: String
    let advancePayment: String
    let fullPaymentStatus: String
}

struct customer_booking_history: Encodable {
    
    let action: String
    let userId: String
    let userType: String
    let pageNo: Int
}

struct customer_booking_history_for_club: Encodable {
    
    let action: String
    let userId: String
    let clubId: String
    let userType: String
    let pageNo: Int
}

struct customer_booking_history_earnings_for_club: Encodable {
    
    let action: String
    let userId: String
    let clubId: String
    let userType: String
    let pageNo: Int
    let completed: String
}

struct customer_booking_history_new: Encodable {
    
    let action: String
    let userId: String
    let clubId: String
    // let userType: String
    let pageNo: Int
}

struct club_reviews: Encodable {
    
    let action: String
    let userId: String
}





struct give_review_to_club: Encodable {
    
    let action: String
    let reviewTo: String
    let reviewFrom: String
    let star: String
    let message: String
}

struct like_to_club: Encodable {
    
    let action: String
    let userId: String
    let clubId: String
    let status: String
}

struct pay_pending_payment: Encodable {
    
    let action: String
    let userId: String
    let bookingId: String
    let fullPaymentStatus: String
    let remainPayment:String
    let remainTransactionID:String
}

struct update_payment_after_stripe_webservice: Encodable {
    
    let action: String
    let userId: String
    let bookingId: String
    let fullPaymentStatus: String
    let transactionId:String
}

struct add_table_from_club: Encodable {
    
    let action: String
    let userId: String
    let name: String
    let totalSeat: String
    let seatPrice:String
    let description:String
    let advancePercentage:String
}

struct edit_table_from_club: Encodable {
    
    let action: String
    let userId: String
    let clubTableId:String
    let name: String
    let totalSeat: String
    let seatPrice:String
    let description:String
    let advancePercentage:String
}




struct edit_club_profile: Encodable {
    
    let action: String
    let userId: String
    let address: String
    let countryId: String
    let stateId: String
    let openTime:String
    let closeTime:String
    let zipCode:String
    let city:String
    let about:String
}

struct show_club_images: Encodable {
    
    let action: String
    let userId: String
    // let clubTableId:String
    let pageNo: String
}

struct check_dates_availaibility:Encodable {
    
    // checkavailable
    let action: String
    let date: String
    let tableId: String
}



struct countryListWeb: Encodable {
    let action: String
}

struct state_list: Encodable {
    let action: String
    let countryId: String
}



struct edit_profile: Encodable {
    let action: String
    let userId:String
    let fullName:String
    let contactNumber:String
    let address:String
    let latitude:String
    let longitude:String
    
}

/*
 action: earning
 userId:
 */



struct club_earning_filter: Encodable {
    let action: String
    let userId:String
    let startDate:String
    let endDate:String
}

/*
 let action: String
 let userId: String
 let userType: String
 let pageNo: String
 */

struct show_booking_history_via_dates: Encodable {
    
    let action: String
    let clubId:String
    let userType:String
    let startDate:String
    let endDate:String
    
}

struct show_earnings_list: Encodable {
    
    let action: String
    let userId:String
    let completed:String
    let startDate:String
    let endDate:String
    
}


/*
 action: cashoutrequest
 userId:
 requestAmount:
 */

struct cashout: Encodable {
    
    let action: String
    let userId:String
    let requestAmount:String
    
}



/*
 action: addevent
 clubId:
 eventName:
 EventDate:
 EventTimeFrom:
 EventTimeTo:
 EventDescription:
 */
struct create_an_event: Encodable {
    
    let action: String
    let clubId:String
    let eventName:String
    let EventDate:String
    let EventTimeFrom:String
    let EventTimeTo:String
    let EventDescription:String
}

struct edit_an_event: Encodable {
    
    let action: String
    let eventId:String
    let clubId:String
    let eventName:String
    let EventDate:String
    let EventTimeFrom:String
    let EventTimeTo:String
    let EventDescription:String
}

/*
 action; deletetable
 clubId:
 clubTableId:
 */
struct club_delete_table: Encodable {
    
    let action: String
    let clubId:String
    let clubTableId:String
}

struct events_listing: Encodable {
    
    let action: String
    let userId:String
    let pageNo:Int
    let date:String
}

/*
 action: deleteevent
 clubId:
 eventId:
 */

struct delete_event: Encodable {
    
    let action: String
    let clubId:String
    let eventId:String
}

struct booking_list_for_upcoming_events: Encodable {
    
    let action: String
    // let userId: String
    let clubId: String
    let userType: String
    let pageNo: String
    let upcommimg: String
}

/*
 delete photo
 
 action: deleteclubphoto
 userId:
 tablephotoId:  //PHOTO ID
 
 */

struct delete_club_photo: Encodable {
    
    let action: String
    let userId: String
    let tablephotoId: String
}

struct forgot_password_webservice: Encodable {
    
    let action: String
    let email: String
}

struct cancel_booking: Encodable {
    
    let action: String
    let userId: String
    let bookingId: String
}

struct cancel_booking_request: Encodable {
    
    let action: String
    let userId: String
    let bookingId: String
    let cancelRequest:String
}

struct update_club_off_day: Encodable {
    
    let action: String
    let userId: String
    let Mon: String
    let Tue: String
    let Wed: String
    let Thu: String
    let Fri: String
    let Sat: String
    let Sun: String
}

struct update_token_for_club: Encodable {
    
    let action: String
    let userId: String
    let deviceToken: String
}

struct logout_my_app: Encodable {
    let action: String
    let userId: String
}

struct stripe_charger_amount: Encodable {
    let action: String
    let userId: String
    let amount: String
    let tokenID: String
}

struct check_stripe_registraiton: Encodable {
    
    let action: String
    let userId: String
    let email: String
}



struct check_stripe_status: Encodable {
    
    let action: String
    let userId: String
    let Account: String
}

struct edit_profile_for_stipe_payment_option: Encodable {
    
    let action: String
    let userId: String
    let currentPaymentOption: String
}

/*
 "action"        : "chargeramount",
 "userId"        : String(myString),
 "amount"        : strTotalAmount,//String("500"),
 "tokenID"       : String(strStripeTokenId),
 "DriverAmount"  : String(myInt3),
 "AccountNo"     : String(strAccountNumberIs)
 */

struct split_payment_via_stripe: Encodable {
    
    let action: String
    let userId: String
    let amount: String
    let tokenID: String
    let DriverAmount: String
    let AccountNo: String
}

struct edit_bank_details: Encodable {
    
    let action: String
    let userId: String
    let BankName: String
    let accountNo: String
    let RoutingNo: String
}

struct resend_email_verification: Encodable {
    
    let action: String
    let userId: String
}

class Parameter: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
}
