//
//  OTPVerifyView.swift
//
//  Created by Krishna on 24/04/17.
//  Copyright © 2017 Konstant. All rights reserved.
//

import UIKit

public enum OTPError: Error {
    case inCompleteOTPEntry
    
    public var localizedDescription: String {
        switch self {
        case .inCompleteOTPEntry:  return "Incomplete OTP Entry"
        }
    }
}


@IBDesignable
public class PinView: UIStackView, UITextFieldDelegate, OTPTextFieldDelegate {
    
    @IBInspectable
    public var otpLength = 4
    
    @IBInspectable
    public var dotColor: UIColor = .black
    @IBInspectable
    public var lineColor: UIColor =  .clear
    public var viewMain: UIView = UIView()
    @IBInspectable
    public var isSecureTextEntry: Bool = true
    @IBInspectable
    public var placeHolderText: String = "*"
    @IBInspectable
    public var showPlaceHolder: Bool = true
    @IBInspectable
    public var filledColor: UIColor = UIColor.gray
    
    public var textFont: UIFont = UIFont.systemFont(ofSize: 18.0)
    
    
    override public func prepareForInterfaceBuilder() {
        setUpView()
    }
    
    private func setIB(){
        #if TARGET_INTERFACE_BUILDER
        setUpView()
        #endif
    }
    
    var textFields = [UITextField]()
    var viewLines  = [UIView]()
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override public func awakeFromNib() {
        setUpView()
    }
    
    public func setUpView() {
        self.axis           = .horizontal
        self.alignment      = .fill
        self.distribution   = .fillEqually
        
        for i in 0..<otpLength {
            let view = UIView()
            view.tag = i + 999
            view.backgroundColor = .clear
            addArrangedSubview(view)
        }
        
        self.layoutIfNeeded()
        self.textFields.removeAll()
        self.viewLines.removeAll()
        
        for i in stride(from: 0, to: otpLength, by:1) {
            let view = self.arrangedSubviews[i]
            let frameSize:CGSize = self.arrangedSubviews[i].frame.size
            let textField:PinTextField      = PinTextField()
            textField.delegateOTP           = self
            textField.tag                   = i+100
            textField.frame                 = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height - 1)
            textField.delegate              = self
            textField.isSecureTextEntry     = isSecureTextEntry
            textField.placeholder           = showPlaceHolder ? placeHolderText : ""
            textField.backgroundColor       = .white
            textField.textAlignment         = .center
            textField.borderStyle           = .none
            textField.keyboardType          = .numberPad
            textField.textColor             =  dotColor
            textField.font                  =  textFont
            textField.tintColor             =  self.tintColor
            textField.backgroundColor       = .clear
            textField.shouldShowClearButton(show: false)
            view.addSubview(textField)
            let viewLine                = UIView()
            viewLine.backgroundColor    = lineColor
            let viewLineFrame: CGRect
            
            viewLineFrame           = CGRect(x: 0, y: frameSize.height - 1, width: frameSize.width, height: 1)
            viewLine.frame = viewLineFrame
            viewLine.tag = i+200
            print(viewLine.tag,textField.tag)
            view.addSubview(viewLine)
            self.viewLines.append(viewLine)
            self.textFields.append(textField)
            if i == 0 {
                textField.becomeFirstResponder()
            }
        }
        self.layoutIfNeeded()
    }
    
    
    public func removeAllViews() {
        self.removeAllView()
    }
    
    public func removeAllView() {
        //view.subviews.forEach({ $0.removeFromSuperview() })
        
        for i in self.subviews {
            if let view = self.viewWithTag(i.tag),i.tag >= 999 {
                view.removeFromSuperview()
            }
        }
        
        for i in self.viewLines {
           i.removeFromSuperview()
        }
        for j in self.textFields {
            j.removeFromSuperview()
        }
    }
    
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == "" {
            if let view = self.viewWithTag(textField.tag+100) {
                view.backgroundColor = #colorLiteral(red: 0.8265652657, green: 0.8502194881, blue: 0.9000532627, alpha: 1)
            }
        } else {
            if let view = self.viewWithTag(textField.tag+100) {
                view.backgroundColor = filledColor
            }
        }
    
        if string.count == 0 {
            if textField.text?.count == 0 {
                if let previousTextField = self.viewWithTag(textField.tag-1) {
                    previousTextField.becomeFirstResponder()
                }
            }
        } else {
            if let currentTextField = self.viewWithTag(textField.tag+1) {
                currentTextField.becomeFirstResponder()
            } else {
                if !textField.text!.isEmpty {
                    return false
                }
            }
        }
        textField.text = string
        return false
    }
    
    func getOTP() throws -> String {
        var otpCode:String = ""
        for textField in textFields {
            if textField.text == "" {
                return ""
            }
                otpCode += textField.text!

        }
        if otpCode.count <= otpLength{
            return otpCode
        }else{
            throw OTPError.inCompleteOTPEntry
        }
    }
    
    func OTPTextFieldDidPressBackspace(textfield: PinTextField) {
        if let view = self.viewWithTag(textfield.tag+100-1) {
            view.backgroundColor = #colorLiteral(red: 0.8265652657, green: 0.8502194881, blue: 0.9000532627, alpha: 1)
        }
        if let previousTextField: PinTextField = self.viewWithTag(textfield.tag-1) as? PinTextField {
            previousTextField.text = ""
            previousTextField.becomeFirstResponder()
        }
    }
    
}
