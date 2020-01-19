//
//  ContactDetailsViewController.swift
//  GoJekContactsApp
//
//  Created by Chandra Rao on 19/01/20.
//  Copyright © 2020 Chandra Rao. All rights reserved.
//

import UIKit
import SDWebImage

public enum ContactDetailType: Int {
    case edit = 0
    case new
    case detail
}

class ContactDetailsViewController: UIViewController {
    
    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    
    var contactDetailType: ContactDetailType?
    var userOptions: [[String: String]]?
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var detailView: UIView!
    
    @IBOutlet weak var userOptionsView: UIView!
    @IBOutlet weak var optionsHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionViewUserOptions: UICollectionView!
    var contactDetail: ContactsResponse?
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var userFName: UIView!
    @IBOutlet weak var fNameHeight: NSLayoutConstraint!
    @IBOutlet weak var txtFieldFirstName: UITextField!
    
    @IBOutlet weak var userLName: UIView!
    @IBOutlet weak var lNameHeight: NSLayoutConstraint!
    @IBOutlet weak var txtFieldLastName: UITextField!
    
    @IBOutlet weak var userMobile: UIView!
    @IBOutlet weak var txtFieldMobileNumber: UITextField!
    
    @IBOutlet weak var userEmail: UIView!
    @IBOutlet weak var txtFieldEmailId: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = UIColor(hexString: ThemeColor.ThemeColorString)
    }
    
    func setUpUI() {
        DispatchQueue.main.async {
            self.setGradientBackground()
            
            if let type = self.contactDetailType {
                switch type {
                case .new:
                    self.setUpUIForNewContact()
                case .edit:
                    self.setUpUIForUpdateContact()
                case .detail:
                    self.setUpUIForContactDetail()
                }
            }
        }
    }
    
    func setUpUIForNewContact() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: AppConstants.CancelString, style: .plain, target: self, action: #selector(cancelTapped(_:)))
        
        self.rightBarButton.title = AppConstants.DoneString
        
        self.userOptionsView.isHidden = true
        self.optionsHeight.constant = 0
        
    }
    
    func setUpUIForUpdateContact() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: AppConstants.CancelString, style: .plain, target: self, action: #selector(cancelTapped(_:)))
        
        self.rightBarButton.title = AppConstants.DoneString
        
        self.userOptionsView.isHidden = true
        self.optionsHeight.constant = 0
        
        if let contact = self.contactDetail {
            self.txtFieldFirstName.text = contact.first_name ?? ""
            self.txtFieldLastName.text = contact.last_name ?? ""
            self.txtFieldEmailId.text = contact.email ?? ""
            self.txtFieldMobileNumber.text = contact.phone_number ?? ""
            
            if let photoURL = contact.profile_pic {
                self.userImage.sd_setImage(with: URL(string: AppConstants.BASEURL + photoURL), placeholderImage: UIImage(named: ImageConstants.PlaceHolderImage), options: .refreshCached) { (image, error, cacheType, url) in
                    
                }
            } else {
                self.userImage.image = UIImage(named: ImageConstants.PlaceHolderImage)
            }
        }
    }
    
    func setUpUIForContactDetail() {
        self.rightBarButton.title = AppConstants.EditString
        
        self.userFName.isHidden = true
        self.fNameHeight.constant = 0
        
        self.txtFieldMobileNumber.isUserInteractionEnabled = false
        self.txtFieldEmailId.isUserInteractionEnabled = false
        
        self.userLName.isHidden = true
        self.lNameHeight.constant = 0
        
        self.userOptions = [
            [
                "imageName": ImageConstants.Message,
                "title": AppConstants.MessageText
            ],
            [
                "imageName": ImageConstants.Call,
                "title": AppConstants.CallText
            ],
            [
                "imageName": ImageConstants.Email,
                "title": AppConstants.EmailText
            ]
        ]
        
        if let contact = self.contactDetail {
            self.userName.text = contact.name() ?? ""
            
            self.txtFieldEmailId.text = contact.email ?? ""
            self.txtFieldMobileNumber.text = contact.phone_number ?? ""
            
            self.userOptions?.append([
                "imageName": (contact.favorite ?? false) ? ImageConstants.FavSelected : ImageConstants.FavUnSelected,
                "title": AppConstants.FavText,
                ])
            
            if let photoURL = contact.profile_pic {
                self.userImage.sd_setImage(with: URL(string: AppConstants.BASEURL + photoURL), placeholderImage: UIImage(named: ImageConstants.PlaceHolderImage), options: .refreshCached) { (image, error, cacheType, url) in
                    
                }
            } else {
                self.userImage.image = UIImage(named: ImageConstants.PlaceHolderImage)
            }
        }
        
        self.collectionViewUserOptions.delegate = self
        self.collectionViewUserOptions.dataSource = self
        
        self.collectionViewUserOptions.reloadData()
    }
    
    func setGradientBackground() {
        let colorTop =  UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 80.0/255.0, green: 227.0/255.0, blue: 194.0/255.0, alpha: 0.28).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.opacity = 0.55
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.detailView.bounds
        
        self.detailView.layer.insertSublayer(gradientLayer, at:0)
    }
    
    @IBAction func rightBarButtonItemClicked(_ sender: Any) {
        if let type = self.contactDetailType {
            switch type {
            case .new:
                print("Call Save API")
                CustomLoader.sharedInstance.addLoader(onView: self.view)
                let contactResponse = ContactsResponse(id: nil, first_name: self.txtFieldFirstName.text ?? "", last_name: self.txtFieldLastName.text ?? "", email: self.txtFieldEmailId.text ?? "", phone_number: self.txtFieldMobileNumber.text ?? "", created_at: nil, updated_at: nil, profile_pic: nil, favorite: false, url: nil)
                AppPresenter.sharedInstance.conformToAppPresenterProtocol(withDelegate: self)
                AppPresenter.sharedInstance.addContacts(forContact: contactResponse)
            case .edit:
                print("Call Save API")
                CustomLoader.sharedInstance.addLoader(onView: self.view)
                let contactResponse = ContactsResponse(id: self.contactDetail?.id ?? 0, first_name: self.txtFieldFirstName.text ?? "", last_name: self.txtFieldLastName.text ?? "", email: self.txtFieldEmailId.text ?? "", phone_number: self.txtFieldMobileNumber.text ?? "", created_at: nil, updated_at: nil, profile_pic: nil, favorite: self.contactDetail?.favorite ?? false, url: nil)
                AppPresenter.sharedInstance.conformToAppPresenterProtocol(withDelegate: self)
                AppPresenter.sharedInstance.updateContactDetails(forContact: contactResponse)
            case .detail:
                // Goto Edit
                let detailVC = UIStoryboard(name: .main).instantiateViewController(withIdentifier: ControllerNames.DetailVC) as! ContactDetailsViewController
                detailVC.contactDetailType = .edit
                detailVC.contactDetail = self.contactDetail
                
                let navigationVC = UINavigationController(rootViewController: detailVC)
                self.navigationController?.present(navigationVC, animated: true, completion: {
                    
                })
            }
        }
    }
    
    @objc func cancelTapped(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: {
            
        })
    }
}

extension ContactDetailsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let data = self.userOptions, let option = data[indexPath.row] as? [String: String], indexPath.row == 3, let con = self.contactDetail {
            let contactResponse = ContactsResponse(id: self.contactDetail?.id ?? 0, first_name: self.contactDetail?.first_name ?? "", last_name: self.contactDetail?.last_name ?? "", email: self.contactDetail?.email ?? "", phone_number: self.contactDetail?.phone_number ?? "", created_at: self.contactDetail?.created_at, updated_at: self.contactDetail?.updated_at, profile_pic: self.contactDetail?.profile_pic, favorite: (self.contactDetail?.favorite ?? false) ? false : true, url: self.contactDetail?.url)
            CustomLoader.sharedInstance.addLoader(onView: self.view)
            AppPresenter.sharedInstance.conformToAppPresenterProtocol(withDelegate: self)
            AppPresenter.sharedInstance.updateContactDetails(forContact: contactResponse)
        }
    }
}

extension ContactDetailsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let data = self.userOptions {
            return data.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = self.collectionViewUserOptions.dequeueReusableCell(withReuseIdentifier: CellNames.DetailCell, for: indexPath) as? UserOptionsCollectionViewCell {
            if let data = self.userOptions, let option = data[indexPath.row] as? [String: String] {
                cell.optionImage.image = UIImage(named: option["imageName"] ?? "")
                cell.optionLabel.text = option["title"] ?? ""
            }
            return cell
        }
        return UICollectionViewCell()
    }
}


extension ContactDetailsViewController: AppPresenterProtocol {
    func addDetailsDataReceived(withData data: ContactsResponse?, andError error: Error?) {
        DispatchQueue.main.async {
            CustomLoader.sharedInstance.removeLoader()
            if let contact = data {
                if let _ = contact.id {
                    self.navigationController?.dismiss(animated: true, completion: {
                        AppPresenter.sharedInstance.rootVC?.navigationController?.popToRootViewController(animated: true)
                    })
                }
            } else {
                AppPresenter.sharedInstance.showAlertOnController(onController: self, withMessage: AppConstants.ErrorMessage)
            }
        }
    }
    
    func dataReceived(withData data: [ContactsResponse]?, andError error: Error?) {
        
    }
    
    func detailDataReceived(withData data: ContactsResponse?, andError error: Error?) {
        
    }
    
    func updatedDetailsDataReceived(withData data: ContactsResponse?, andError error: Error?) {
        DispatchQueue.main.async {
            CustomLoader.sharedInstance.removeLoader()
            if let contact = data {
                if let type = self.contactDetailType {
                    switch type {
                    case .new:
                        print("New")
                    case .edit:
                        if let _ = contact.id {
                            self.navigationController?.dismiss(animated: true, completion: {
                                AppPresenter.sharedInstance.rootVC?.navigationController?.popToRootViewController(animated: true)
                            })
                        }
                    case .detail:
                        DispatchQueue.main.async {
                            self.contactDetail = data
                            self.setUpUIForContactDetail()
                        }
                    }
                }
            } else {
                AppPresenter.sharedInstance.showAlertOnController(onController: self, withMessage: AppConstants.ErrorMessage)
            }
        }
    }
}
