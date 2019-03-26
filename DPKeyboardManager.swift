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
    @objc open var isEmbeddedViewController: Bool = false
    
    @objc public init() {
        // NOP
    }
    
    @objc public init(_ viewController: UIViewController) {
        loadKeyboardEvents(viewController)
    }
    
    deinit {
        disableKeyboardEvents()
    }
    
    @objc open func loadKeyboardEvents(_ viewController: UIViewController) {

        containerView = viewController.view

        // check for embedded viewcontrollers
        if let parentVC = viewController.view.superview?.___parentViewController ?? viewController.parent?.view.superview?.___parentViewController {
            if !(parentVC is UITabBarController), !parentVC.children.contains(viewController) {
                isEmbeddedViewController = true
                
                viewController.willMove(toParent: parentVC)
                viewController.beginAppearanceTransition(true, animated: true)
                viewController.didMove(toParent: parentVC)
                viewController.endAppearanceTransition()
            }
        }
    }
    
    @objc open func enableKeybaordEvents() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidBeginEditing), name:
            UITextField.textDidBeginEditingNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidBeginEditing), name: UITextView.textDidBeginEditingNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc open func disableKeyboardEvents() {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Keyboard
    
    @objc private func keyboardWillShow(notification:NSNotification) {
        
        DPKeyboardManager.disableTableViewAutoscoll = ((currentView as? UITextField) ?? (currentView as? UITextView))?.inputView == nil
        
        let userInfo = notification.userInfo!
        let keyboardFrame:NSValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let keyboardAnimation: NSNumber = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber
        self.keyboardRect = keyboardFrame.cgRectValue
        self.keyboardAnimationDuration = keyboardAnimation.doubleValue
        
        translateTextField()
    }
    
    @objc private func keyboardDidShow(notification:NSNotification) {
        DPKeyboardManager.disableTableViewAutoscoll = false
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
    
     @objc open override var contentOffset: CGPoint {
        get {
            return super.contentOffset
        }
        
        set {
            let isPicker = NSStringFromClass(self.classForCoder).contains("Picker")
            if !DPKeyboardManager.disableTableViewAutoscoll || isPicker {
                super.contentOffset = newValue
            }
        }
    }
}

extension UITableViewController {
    
    @objc open override func viewWillAppear(_ animated: Bool) {
        if !DPKeyboardManager.disableTableViewAutoscoll {
            super.viewWillAppear(animated)
        }
    }
    
}

extension UIView {
    
    @objc open var ___parentViewController: UIViewController? {
        
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        
        return nil
    }
}

