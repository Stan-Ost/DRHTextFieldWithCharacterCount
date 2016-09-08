//
//  DRHTextFieldWithCharacterCount.swift
//  DRHTextFieldWithCharacterCount
//
//  Created by Stanislav Ostrovskiy on 8/29/16.
//  Copyright © 2016 Stanislav Ostrovskiy. All rights reserved.
//

import UIKit

protocol DRHTextFieldWithCharacterCountDelegate: class {
    
    // some of UITextFieldDelegate methods you might need to use
    func didEndEditing()
    func didBeginEditing()
    
    // another handy method to use
    func didReachCharacterLimit(_ reach: Bool)
}

@IBDesignable class DRHTextFieldWithCharacterCount: UITextField {
    
    fileprivate let countLabel = UILabel()
    
    weak var drhDelegate: DRHTextFieldWithCharacterCountDelegate?
    
    @IBInspectable var lengthLimit: Int = 0
    @IBInspectable var countLabelTextColor: UIColor = UIColor.black
    
    weak var customDelegate: UITextFieldDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if lengthLimit > 0 {
            setCountLabel()
        }
        
        delegate = self
    }
    
    fileprivate func setCountLabel() {
        
        rightViewMode = .always
        countLabel.font = font?.withSize(10)
        countLabel.textColor = countLabelTextColor
        countLabel.textAlignment = .left
        rightView = countLabel
        
        countLabel.text = initialCounterValue(text)
        
        if let text = text {
            countLabel.text = "\(text.utf16.count)/\(lengthLimit)"
        } else {
            countLabel.text = "0/\(lengthLimit)"
        }
    }
    
    fileprivate func initialCounterValue(_ text: String?) -> String {
        if let text = text {
            return "\(text.utf16.count)/\(lengthLimit)"
        } else {
            return "0/\(lengthLimit)"
        }
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        
        if lengthLimit > 0 {
            return CGRect(x: frame.width - 35, y: 0, width: 30, height: 30)
        }
        return CGRect()
    }
}

extension DRHTextFieldWithCharacterCount: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text , lengthLimit != 0 else { return true }
                
        let newLength = text.utf16.count + string.utf16.count - range.length
        
        if newLength <= lengthLimit {
            countLabel.text = "\(newLength)/\(lengthLimit)"
            drhDelegate?.didReachCharacterLimit(false)
        } else {
            drhDelegate?.didReachCharacterLimit(true)
            UIView.animate(withDuration: 0.1, animations: {
                self.countLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                
                }, completion: { (finish) in
                    UIView.animate(withDuration: 0.1, animations: {
                        self.countLabel.transform = CGAffineTransform.identity
                    }) 
            })
        }
        
        
        
        return newLength <= lengthLimit
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        drhDelegate?.didEndEditing()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        drhDelegate?.didBeginEditing()
    }
}

