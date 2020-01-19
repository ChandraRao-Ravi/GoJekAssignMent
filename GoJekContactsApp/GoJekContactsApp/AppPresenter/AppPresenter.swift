//
//  AppPresenter.swift
//  GoJekContactsApp
//
//  Created by Chandra Rao on 19/01/20.
//  Copyright © 2020 Chandra Rao. All rights reserved.
//

import Foundation
import UIKit

protocol AppPresenterProtocol: class {
    func dataReceived(withData data: [ContactsResponse]?, andError error: Error?)
    func detailDataReceived(withData data: ContactsResponse?, andError error: Error?)
    func updatedDetailsDataReceived(withData data: ContactsResponse?, andError error: Error?)
    func addDetailsDataReceived(withData data: ContactsResponse?, andError error: Error?)
}

class AppPresenter: NSObject {
    
    var presenterProtocol: AppPresenterProtocol?
    var rootVC: UIViewController?
    
    // MARK: - Shared Instance
    
    static let sharedInstance: AppPresenter = {
        let instance = AppPresenter()
        // setup code
        return instance
    }()
    
    // MARK: - Initialization Method
    
    override init() {
        super.init()
    }
    
    func conformToAppPresenterProtocol(withDelegate classProtocol: AppPresenterProtocol?) {
        if let delegate = classProtocol {
            self.presenterProtocol = delegate
        }
    }
    
    func fetchContacts() {
        APIManager.sharedInstance.callGetContactsAPi(withDelegate: self)
    }
    
    func fetchContactDetails(forContact contact: ContactsResponse?) {
        if let detail = contact {
            APIManager.sharedInstance.callGetContactDetailsAPi(withDelegate: self, forContact: detail)
        }
    }
    
    func updateContactDetails(forContact contact: ContactsResponse?) {
        if let detail = contact {
            APIManager.sharedInstance.callUpdateContactDetailsAPi(withDelegate: self, forContact: detail)
        }
    }
    
    func addContacts(forContact contact: ContactsResponse?) {
        if let detail = contact {
            APIManager.sharedInstance.callAddContactDetailsAPi(withDelegate: self, forContact: detail)
        }
    }
    
    func showAlertOnController(onController sourceController: UIViewController?, withTitle title: String? = AppConstants.AppName, withMessage alertMessage: String?) {
        if let onController = sourceController, let message = alertMessage {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: AppConstants.OkString, style: .default, handler: { (action) in
                
            })
            alertController.addAction(okAction)
            onController.navigationController?.present(alertController, animated: true, completion: {
                
            })
        }
    }
}

extension AppPresenter: ContactsProtocol {
    func getAddContactDetailsData(withResponse response: ContactsResponse?, withError error: Error?) {
        if let contactData = response {
            if let delegate = presenterProtocol {
                delegate.addDetailsDataReceived(withData: contactData, andError: error)
            } else {
                fatalError("Please Conform to App Presenter")
            }
        } else {
            if let delegate = presenterProtocol {
                delegate.addDetailsDataReceived(withData: nil, andError: error)
            } else {
                fatalError("Please Conform to App Presenter")
            }
        }
    }
    
    func getUpdatedContactDetailsData(withResponse response: ContactsResponse?, withError error: Error?) {
        if let contactData = response {
            if let delegate = presenterProtocol {
                delegate.updatedDetailsDataReceived(withData: contactData, andError: error)
            } else {
                fatalError("Please Conform to App Presenter")
            }
        } else {
            if let delegate = presenterProtocol {
                delegate.updatedDetailsDataReceived(withData: nil, andError: error)
            } else {
                fatalError("Please Conform to App Presenter")
            }
        }
    }
    
    func getContactDetailsData(withResponse response: ContactsResponse?, withError error: Error?) {
        if let contactData = response {
            if let delegate = presenterProtocol {
                delegate.detailDataReceived(withData: contactData, andError: error)
            } else {
                fatalError("Please Conform to App Presenter")
            }
        } else {
            if let delegate = presenterProtocol {
                delegate.detailDataReceived(withData: nil, andError: error)
            } else {
                fatalError("Please Conform to App Presenter")
            }
        }
    }
    
    func getContactsData(withResponseArray array: [ContactsResponse]?, withError error: Error?) {
        if let arrData = array {
            if let delegate = presenterProtocol {
                let dataArray = arrData.sorted(by: { (contact1, contact2) -> Bool in
                    return (contact1.name() ?? "") < (contact2.name() ?? "")
                })
                delegate.dataReceived(withData: dataArray, andError: error)
            } else {
                fatalError("Please Conform to App Presenter")
            }
        } else {
            if let delegate = presenterProtocol {
                delegate.dataReceived(withData: nil, andError: error)
            } else {
                fatalError("Please Conform to App Presenter")
            }
        }
    }
}
