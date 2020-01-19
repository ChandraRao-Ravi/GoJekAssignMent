//
//  UIStoryboard+Extension.swift
//  GoJekContactsApp
//
//  Created by Chandra Rao on 19/01/20.
//  Copyright © 2020 Chandra Rao. All rights reserved.
//

import Foundation
import UIKit

enum StoryName: String {
    case main = "Main"
}

extension UIStoryboard{
    
    convenience init(name:StoryName, bundle:Bundle? = nil) {
        self.init(name:name.rawValue, bundle: bundle)
    }
}
