//
//  CustomLoader.swift
//  GoJekContactsApp
//
//  Created by Chandra Rao on 19/01/20.
//  Copyright © 2020 Chandra Rao. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents.MaterialActivityIndicator

class CustomLoader: NSObject {

    let activityIndicator = MDCActivityIndicator()

    // MARK: - Shared Instance

    static let sharedInstance: CustomLoader = {
        let instance = CustomLoader()
        // setup code
        return instance
    }()
    
    // MARK: - Initialization Method
    
    override init() {
        super.init()
    }
    
    func addLoader(onView sourceView: UIView?) {
        if let view = sourceView {
            DispatchQueue.main.async {
                self.activityIndicator.sizeToFit()
                self.activityIndicator.progress = 0.5
                self.activityIndicator.cycleColors = [.blue, .red, .green, .yellow]
                view.addSubview(self.activityIndicator)
                view.bringSubviewToFront(self.activityIndicator)
                self.activityIndicator.center = view.center
                self.startAnimatingLoader()
            }
        }
    }
    
    func removeLoader() {
        self.stopAnimatingLoader()
    }
    
    func startAnimatingLoader() {
        // To make the activity indicator appear:
        self.activityIndicator.startAnimating()
    }
    
    func stopAnimatingLoader() {
        // To make the activity indicator disappear:
        self.activityIndicator.stopAnimating()
    }
    
    
}
