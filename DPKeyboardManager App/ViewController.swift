//
//  ViewController.swift
//  DPKeyboardManager App
//
//  Created by Danilo Priore on 26/03/2019.
//  Copyright © 2019 Danilo Priore. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let keyboardManager = DPKeyboardManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.keyboardManager.loadKeyboardEvents(self)
        
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.keyboardManager.enableKeybaordEvents()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.keyboardManager.disableKeyboardEvents()
    }
    
    override var shouldAutomaticallyForwardAppearanceMethods: Bool {
        return !self.keyboardManager.isEmbeddedViewController
    }

}

