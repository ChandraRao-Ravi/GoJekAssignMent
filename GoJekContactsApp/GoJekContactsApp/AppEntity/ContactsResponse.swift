//
//  ContactsResponse.swift
//  GoJekContactsApp
//
//  Created by Chandra Rao on 16/01/20.
//  Copyright © 2020 Chandra Rao. All rights reserved.
//

import Foundation

struct ContactsResponse : Codable {
    let id : Int?
    let first_name : String?
    let last_name : String?
    let email : String?
    let phone_number : String?
    let created_at : String?
    let updated_at : String?
    let profile_pic : String?
    let favorite : Bool?
    let url : String?
    
    func name() -> String? {
        return (first_name ?? "") + " " + (last_name ?? "")
    }
    
    func getDictData() -> [String: Any] {
        return [
            "first_name": self.first_name ?? "",
            "last_name": self.last_name ?? "",
            "email": self.email ?? "",
            "phone_number": self.phone_number ?? "",
            "favorite": (self.favorite ?? false) ? "true" : "false"
        ]
    }
}
