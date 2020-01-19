//
//  ViewController.swift
//  GoJekContactsApp
//
//  Created by Chandra Rao on 16/01/20.
//  Copyright © 2020 Chandra Rao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableViewContacts: UITableView!
    var contacts: [ContactsResponse]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppPresenter.sharedInstance.conformToAppPresenterProtocol(withDelegate: self)
        AppPresenter.sharedInstance.rootVC = self
        AppPresenter.sharedInstance.fetchContacts()
    }
    
    func setUpTableView() {
        self.tableViewContacts.delegate = self
        self.tableViewContacts.dataSource = self
        
        self.tableViewContacts.estimatedRowHeight = 67
        self.tableViewContacts.rowHeight = UITableView.automaticDimension
    }
    
    @IBAction func rightBarButtonItemClicked(_ sender: Any) {
        let detailVC = UIStoryboard(name: .main).instantiateViewController(withIdentifier: ControllerNames.DetailVC) as! ContactDetailsViewController
        detailVC.contactDetailType = .new
        
        let navigationVC = UINavigationController(rootViewController: detailVC)
        self.navigationController?.present(navigationVC, animated: true, completion: {
            
        })
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let allContacts = self.contacts, let contact = allContacts[indexPath.row] as? ContactsResponse {
            AppPresenter.sharedInstance.fetchContactDetails(forContact: contact)
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let array = self.contacts {
            return array.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.tableViewContacts.dequeueReusableCell(withIdentifier: CellNames.HomeCell, for: indexPath) as? ContactsTableViewCell {
            if let array = self.contacts, let contact = array[indexPath.row] as? ContactsResponse {
                cell.configureContact(forContact: contact, andIndexPath: indexPath)
                return cell
            }
        }
        return UITableViewCell()
    }
}

extension ViewController: AppPresenterProtocol {
    func addDetailsDataReceived(withData data: ContactsResponse?, andError error: Error?) {
        
    }
    
    func updatedDetailsDataReceived(withData data: ContactsResponse?, andError error: Error?) {
        
    }
    
    func detailDataReceived(withData data: ContactsResponse?, andError error: Error?) {
        DispatchQueue.main.async {
            if let contactDetail = data {
                let detailVC = UIStoryboard(name: .main).instantiateViewController(withIdentifier: ControllerNames.DetailVC) as! ContactDetailsViewController
                detailVC.contactDetailType = .detail
                detailVC.contactDetail = contactDetail
                self.navigationController?.pushViewController(detailVC, animated: true)
            } else {
                AppPresenter.sharedInstance.showAlertOnController(onController: self, withMessage: AppConstants.NoRecordsMessage)
            }
        }
    }
    
    func dataReceived(withData data: [ContactsResponse]?, andError error: Error?) {
        DispatchQueue.main.async {
            if let arrData = data, arrData.count > 0 {
                self.contacts = arrData
                self.tableViewContacts.reloadData()
            } else {
                AppPresenter.sharedInstance.showAlertOnController(onController: self, withMessage: AppConstants.NoRecordsMessage)
            }
        }
    }
}
