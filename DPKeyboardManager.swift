//
//  DPKeyboardManager.swift
//  DPKeyboardManager
//
//  Created by Danilo Priore on 28/08/17.
//  Copyright © 2017 D.Priore. All rights reserved.
//

import UIKit
import Foundation

open class DPKeyboardManager {
    
    private weak var containerView: UIView?
    
    @objc open var currentView: UIView?
    @objc open var keyboardRect: CGRect = CGRect.zero
    @objc open var keyboardPadding: CGFloat = 10.0
    
    @objc public init() {
        // NOP
    }
    
    @objc public init(_ view: UIView) {
        enableKeybaordEvents(view)
    }
    
    deinit {
        disableKeyboardEvents()
    }
    
    @objc open func enableKeybaordEvents(_ view: UIView) {
        
        containerView = view
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidBeginEditing), name: NSNotification.Name.UITextFieldTextDidBeginEditing, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidBeginEditing), name: NSNotification.Name.UITextViewTextDidBeginEditing, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc open func disableKeyboardEvents() {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Keyboard
    
    @objc private func keyboardWillShow(notification:NSNotification) {
        
        let userInfo = notification.userInfo!
        let keyboardFrame:NSValue = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
        self.keyboardRect = keyboardFrame.cgRectValue
        
        translateTextField()
    }
    
    @objc private func keyboardWillHide(notification:NSNotification) {
        
        UIView.animate(withDuration: 0.25) {
            DispatchQueue.main.async {
                self.containerView?.transform = CGAffineTransform.identity
            }
        }
    }
    
    // MARK: - UITextFiled
    
    @objc private func textDidBeginEditing(norification:NSNotification) {
        self.currentView = norification.object as? UIView
        translateTextField()
    }
    
    
    @objc private func textFieldDidBeginEditingAction(_ textField: UITextField) {
        self.currentView = textField
        translateTextField()
    }
    
    @objc private func translateTextField() {
        
        if let view = currentView, keyboardRect.height > 0 {
            let rect = view.superview?.convert(view.frame, to: nil)
            if let maxY = rect?.maxY, maxY > keyboardRect.minY {
                let delta = maxY - keyboardRect.minY + keyboardPadding
                UIView.animate(withDuration: 0.25) {
                    DispatchQueue.main.async {
                        self.containerView?.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -delta)
                    }
                }
            }
        }
        
    }
    
}
