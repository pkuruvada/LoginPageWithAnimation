//
//  Constraints.swift
//  SimpleLogin
//
//  Created by VENKATA KURUVADA on 9/10/15.
//  Copyright © 2015 VENKATA KURUVADA. All rights reserved.
//

import UIKit;

class Constraints  {
    
    class func setHorizontalStretch(views: [String: AnyObject], metrics:[String: AnyObject], padding: String, view: String) -> [NSLayoutConstraint] {
        
        
        let formatString = "H:|-\(padding)-[\(view)]-\(padding)-|";
        return NSLayoutConstraint.constraintsWithVisualFormat(formatString, options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views);
        
    }
    
}