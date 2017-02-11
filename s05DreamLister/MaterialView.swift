//
//  MaterialView.swift
//  s05DreamLister
//
//  Created by bernadette on 2/10/17.
//  Copyright © 2017 Bernadette P. All rights reserved.
//

import UIKit

//class MaterialView: UIView {
// change to "extension -- makes it so that anything that inherits from UIView will also have the ability to add they styling that we're about to make right now

// default option:  to not select the materialDesign
private var materialKey = false

extension UIView {

    // IBInspectable - toggling, or an option, or something that we can select inside the storyboard
    @IBInspectable var materialDesign: Bool {
        
        get {
            
            return materialKey
            
        } set {
            
            materialKey = newValue
            
            // "if materialKey" == "if materialKey = true" (shorthand)
            if materialKey {
                
                self.layer.masksToBounds = false
                self.layer.cornerRadius = 3.0
                self.layer.shadowOpacity = 0.8
                self.layer.shadowRadius = 3.0
                self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
                self.layer.shadowColor = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 1.0).cgColor
            } else {
                
                self.layer.cornerRadius = 0
                self.layer.shadowOpacity = 0
                self.layer.shadowRadius = 0
                self.layer.shadowColor = nil
            }
        }
        
    }

}
