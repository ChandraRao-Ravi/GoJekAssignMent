//
//  APIManager.swift
//  GoJekContactsApp
//
//  Created by Chandra Rao on 16/01/20.
//  Copyright © 2020 Chandra Rao. All rights reserved.
//

import Foundation
import UIKit

protocol ContactsProtocol: class {
    func getContactsData(withResponseArray array: [ContactsResponse]?, withError error: Error?)
    func getContactDetailsData(withResponse response: ContactsResponse?, withError error: Error?)
    func getUpdatedContactDetailsData(withResponse response: ContactsResponse?, withError error: Error?)
    func getAddContactDetailsData(withResponse response: ContactsResponse?, withError error: Error?)
}

class APIManager: NSObject {
    
    //    var contactsDelegate: ContactsProtocol?
    
    // MARK: - Shared Instance
    static let sharedInstance: APIManager = {
        let instance = APIManager()
        // setup code
        return instance
    }()
    
    // MARK: - Initialization Method
    
    override init() {
        super.init()
    }
    
    func callGetContactsAPi(withDelegate classProtocol: ContactsProtocol?) {
        if let delegate = classProtocol {
            APIHelper.sharedInstance.makeGetApiCallWithMethod(withMethod: ApiConstants.Contacts + ApiConstants.APIExtension, successHandler: { (data, error) in
                if let responseData = data {
                    do {
                        let contacts = try JSONDecoder().decode([ContactsResponse].self, from: responseData)
                        if contacts.count > 0 {
                            delegate.getContactsData(withResponseArray: contacts, withError: error)
                        } else {
                            delegate.getContactsData(withResponseArray: nil, withError: error)
                        }
                    } catch {
                        // I find it handy to keep track of why the decoding has failed. E.g.:
                        print(error)
                        // Insert error handling here
                        delegate.getContactsData(withResponseArray: nil, withError: error)
                    }
                }
            }) { (strErrorMessage, error) in
                delegate.getContactsData(withResponseArray: nil, withError: error)
            }
        }
    }
    
    func callGetContactDetailsAPi(withDelegate classProtocol: ContactsProtocol?, forContact contact: ContactsResponse?) {
        if let delegate = classProtocol {
            APIHelper.sharedInstance.makeGetApiCallWithMethod(withMethod: ApiConstants.Contacts + "/" + "\((contact?.id ?? 0))", successHandler: { (data, error) in
                if let responseData = data {
                    do {
                        let contacts = try JSONDecoder().decode(ContactsResponse.self, from: responseData)
                        delegate.getContactDetailsData(withResponse: contacts, withError: error)
                    } catch {
                        // I find it handy to keep track of why the decoding has failed. E.g.:
                        print(error)
                        // Insert error handling here
                        delegate.getContactDetailsData(withResponse: nil, withError: error)
                    }
                }
            }) { (strErrorMessage, error) in
                delegate.getContactDetailsData(withResponse: nil, withError: error)
            }
        }
    }
    
    func callUpdateContactDetailsAPi(withDelegate classProtocol: ContactsProtocol?, forContact contact: ContactsResponse?) {
        if let delegate = classProtocol {
            APIHelper.sharedInstance.makePostAPICall(url: ApiConstants.Contacts + "/" + "\((contact?.id ?? 0))", params: contact?.getDictData(), method: .PUT, success: { (data, response, error) in
                if let responseData = data {
                    do {
                        let contacts = try JSONDecoder().decode(ContactsResponse.self, from: responseData)
                        delegate.getUpdatedContactDetailsData(withResponse: contacts, withError: error)
                    } catch {
                        // I find it handy to keep track of why the decoding has failed. E.g.:
                        print(error)
                        // Insert error handling here
                        delegate.getUpdatedContactDetailsData(withResponse: nil, withError: error)
                    }
                }
            }) { (data, response, error) in
                delegate.getUpdatedContactDetailsData(withResponse: nil, withError: error)
            }
        }
    }
    
    func callAddContactDetailsAPi(withDelegate classProtocol: ContactsProtocol?, forContact contact: ContactsResponse?) {
        if let delegate = classProtocol {
            APIHelper.sharedInstance.makePostAPICall(url: ApiConstants.Contacts, params: contact?.getDictData(), method: .POST, success: { (data, response, error) in
                if let responseData = data {
                    do {
                        let contacts = try JSONDecoder().decode(ContactsResponse.self, from: responseData)
                        delegate.getAddContactDetailsData(withResponse: contacts, withError: error)
                    } catch {
                        // I find it handy to keep track of why the decoding has failed. E.g.:
                        print(error)
                        // Insert error handling here
                        delegate.getAddContactDetailsData(withResponse: nil, withError: error)
                    }
                }
            }) { (data, response, error) in
                delegate.getAddContactDetailsData(withResponse: nil, withError: error)
            }
        }
    }
}
