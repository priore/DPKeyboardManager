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
    
    static internal var disableTableViewAutoscoll: Bool = false
    
    private weak var containerView: UIView?
    private var keyboardAnimationDuration: Double = 0

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
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    @objc open func disableKeyboardEvents() {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Keyboard
    
    @objc private func keyboardWillShow(notification:NSNotification) {
        
        DPKeyboardManager.disableTableViewAutoscoll = true
        
        let userInfo = notification.userInfo!
        let keyboardFrame:NSValue = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
        let keyboardAnimation: NSNumber = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        self.keyboardRect = keyboardFrame.cgRectValue
        self.keyboardAnimationDuration = keyboardAnimation.doubleValue
        
        translateTextField()
    }
    
    @objc private func keyboardWillHide(notification:NSNotification) {

        DispatchQueue.main.async {
            UIView.animate(withDuration: self.keyboardAnimationDuration) {
                self.containerView?.transform = CGAffineTransform.identity
            }
        }
    }

    @objc private func keyboardDidHide(notification:NSNotification) {
        DPKeyboardManager.disableTableViewAutoscoll = false
    }
    
    // MARK: - UITextFiled
    
    @objc private func textDidBeginEditing(norification:NSNotification) {
        self.currentView = norification.object as? UIView
        translateTextField()
    }
    
    @objc private func translateTextField() {
        
        if let view = currentView, keyboardRect.height > 0 {
            let rect = view.superview?.convert(view.frame, to: nil)
            if let maxY = rect?.maxY, maxY > keyboardRect.minY {
                let delta = maxY - keyboardRect.minY + keyboardPadding
                DispatchQueue.main.async {
                    UIView.animate(withDuration: self.keyboardAnimationDuration) {
                        self.containerView?.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -delta)
                    }
                }
            }
        }
    }
}

extension UITableView {
    
    open override var contentOffset: CGPoint {
        get {
            return super.contentOffset
        }
        
        set {
            if !DPKeyboardManager.disableTableViewAutoscoll {
                super.contentOffset = newValue
            }
        }
    }
    
    
}
