//
//  COrderHistoryProductDetailsTableCell.swift
//  Alien Broccoli
//
//  Created by Apple on 07/10/20.
//

import UIKit

class COrderHistoryProductDetailsTableCell: UITableViewCell {

    @IBOutlet weak var viewbg:UIView! {
        didSet {
            viewbg.backgroundColor = .white
            viewbg.layer.cornerRadius = 6
            viewbg.clipsToBounds = true
            viewbg.layer.borderColor = UIColor.darkGray.cgColor
            viewbg.layer.borderWidth = 0.08
        }
    }
    
    @IBOutlet weak var imgProfile:UIImageView! {
        didSet {
            imgProfile.image = UIImage(named: "logo")
        }
    }
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblCreatedAt:UILabel!
    @IBOutlet weak var lblQuantity:UILabel!
    @IBOutlet weak var lblPrice:UILabel! {
        didSet {
            lblPrice.textColor = button_dark
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
