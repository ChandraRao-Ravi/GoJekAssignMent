//
//  ContactsTableViewCell.swift
//  GoJekContactsApp
//
//  Created by Chandra Rao on 19/01/20.
//  Copyright © 2020 Chandra Rao. All rights reserved.
//

import UIKit
import SDWebImage

class ContactsTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblUserImg: UIImageView!
    @IBOutlet weak var btnFav: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureContact(forContact contactDetail: ContactsResponse?, andIndexPath indexPath: IndexPath?) {
        if let contact = contactDetail {
            self.lblName.text = contact.name() ?? ""
            if let fav = contact.favorite, fav == true {
                self.btnFav.setImage(UIImage(named: ImageConstants.FavImage), for: .normal)
            } else{
                self.btnFav.setImage(UIImage(named: ImageConstants.EmptyImage), for: .normal)
            }
            if let photoURL = contactDetail?.profile_pic {
                self.lblUserImg.sd_setImage(with: URL(string: AppConstants.BASEURL + photoURL), placeholderImage: UIImage(named: ImageConstants.PlaceHolderImage), options: .refreshCached) { (image, error, cacheType, url) in
                    
                }
            } else {self.lblUserImg.image = UIImage(named: ImageConstants.PlaceHolderImage)
                
            }
        }
    }
}
