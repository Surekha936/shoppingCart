//
//  CustomLabel.swift
//  ShoppingCart
//
//  Created by Encoding on 06/11/17.
//  Copyright © 2017 surekha Ramchandra Shinde. All rights reserved.
//

import UIKit

class CustomLabel: UILabel
{
    override var bounds: CGRect
        {
        didSet {
            if (bounds.size.width != oldValue.size.width) {
                self.setNeedsUpdateConstraints();
            }
        }
    }
    
    override func updateConstraints()
    {
        if(self.preferredMaxLayoutWidth != self.bounds.size.width)
        {
            self.preferredMaxLayoutWidth = self.bounds.size.width
        }
        super.updateConstraints()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
