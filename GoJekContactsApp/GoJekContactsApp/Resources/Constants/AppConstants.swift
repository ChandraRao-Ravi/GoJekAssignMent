//
//  AppConstants.swift
//  GoJekContactsApp
//
//  Created by Chandra Rao on 16/01/20.
//  Copyright © 2020 Chandra Rao. All rights reserved.
//

import Foundation
import UIKit

class AppConstants {
    static let BASEURL = "http://gojek-contacts-app.herokuapp.com/"
    static let HTTPMethodGet = "GET"
    static let HTTPMethodPOST = "POST"
    static let ContentType = "Content-Type"
    static let AuthorisationKey = "Authorization"
    static let AcceptKey = "Accept"
    static let ContentTypeURLEncoded = "application/x-www-form-urlencoded; charset=utf-8"
    static let ContentTypeJSON = "application/json"
    
    static let AppName = "GoJekContactsApp"
    static let OkString = "Ok"
    static let CancelString = "Cancel"
    static let DoneString = "Done"
    static let EditString = "Edit"
    
    static let NoRecordsMessage = "No Records Found"
    static let ErrorMessage = "Some Error Occured!!"
    
    static let EmailText = "email"
    static let CallText = "call"
    static let MessageText = "message"
    static let FavText = "favorite"
}

class ApiConstants {
    static let APIExtension = ".json"
    static var Contacts = "contacts"
}

class ImageConstants {
    static let FavImage = "home_favourite"
    static let EmptyImage = ""
    static let PlaceHolderImage = "placeholder_photo"
    
    static let FavSelected = "favourite_button_selected"
    static let FavUnSelected = "favourite_button"
    
    static let Message = "message_button"
    static let Call = "call_button"
    static let Email = "email_button"
}

class ControllerNames {
    static let ViewController = "ViewController"
    static let DetailVC = "ContactDetailsViewController"
}

class CellNames {
    static let HomeCell = "ContactsTableViewCell"
    static let DetailCell = "UserOptionsCollectionViewCell"
}

class ThemeColor {
    static let ThemeColorString = "#50E3C2"
}
