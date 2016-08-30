//
//  DRHTextFieldWithCharacterCount.swift
//  DRHTextFieldWithCharacterCount
//
//  Created by Stanislav Ostrovskiy on 8/29/16.
//  Copyright © 2016 Stanislav Ostrovskiy. All rights reserved.
//

import UIKit

@IBDesignable class DRHTextFieldWithCharacterCount: UITextField {
    
    private let countLabel = UILabel()
    
    @IBInspectable var lengthLimit: Int = 0
    @IBInspectable var countLabelTextColor: UIColor = UIColor.blackColor()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        delegate = self
        
        if lengthLimit > 0 {
            setCountLabel()
        }
    }
    
    private func setCountLabel() {
        
        rightViewMode = .Always
        countLabel.font = font?.fontWithSize(10)
        countLabel.textColor = countLabelTextColor
        countLabel.textAlignment = .Left
        rightView = countLabel
        
        countLabel.text = initialCounterValue(text)
        
        if let text = text {
            countLabel.text = "\(text.utf16.count)/\(lengthLimit)"
        } else {
            countLabel.text = "0/\(lengthLimit)"
        }
    }
    
    private func initialCounterValue(text: String?) -> String {
        if let text = text {
            return "\(text.utf16.count)/\(lengthLimit)"
        } else {
            return "0/\(lengthLimit)"
        }
    }
    
    override func rightViewRectForBounds(bounds: CGRect) -> CGRect {
        
        if lengthLimit > 0 {
            return CGRect(x: frame.width - 35, y: 0, width: 30, height: 30)
        }
        return CGRect()
    }
}

extension DRHTextFieldWithCharacterCount: UITextFieldDelegate {
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text where lengthLimit != 0 else { return true }
        
        let newLength = text.utf16.count + string.utf16.count - range.length
        
        if newLength <= lengthLimit {
            countLabel.text = "\(newLength)/\(lengthLimit)"
        } else {
            UIView.animateWithDuration(0.1, animations: {
                self.countLabel.transform = CGAffineTransformMakeScale(1.1, 1.1)
                
                }, completion: { (finish) in
                    UIView.animateWithDuration(0.1) {
                        self.countLabel.transform = CGAffineTransformIdentity
                    }
            })
        }
        return newLength <= lengthLimit
    }
}

