//
//  OTPTextField.swift
//
//  Created by Somendra Yadav on 23/02/20.
//  Copyright © 2020 Somendra. All rights reserved.
//

import UIKit

protocol OTPTextFieldDelegate {
    func OTPTextFieldDidPressBackspace(textfield: PinTextField)   
}
@IBDesignable
class PinTextField: UITextField {

    var delegateOTP:OTPTextFieldDelegate!
    
    override func deleteBackward() {
        super.deleteBackward()
        
        if delegateOTP != nil {
            delegateOTP.OTPTextFieldDidPressBackspace(textfield: self)
        }
    }
    
    func shouldShowClearButton(show : Bool){
        if show {
            if let clearButton = self.value(forKey: "_clearButton") as? UIButton {
                // Create a template copy of the original button image
                clearButton.setImage(UIImage(named: "input_close"), for: .normal)
                //clearButton.setImage(#imageLiteral(resourceName: "input_close"), for: .highlighted)
                self.clearButtonMode = .whileEditing
            }
        } else {
             self.clearButtonMode       = .never
        }
    }
    
}
