# DPKeyboardManager

Auto slide the view when keyboard appears

**HOW TO USE :**

```swift

import UIKit

class DPBaseViewController: UIViewController {

   let keyboardManager = DPKeyboardManager()
   
   override func viewDidLoad() {
       super.viewDidLoad()
        
	   keyboardManager.loadKeyboardEvents(self)
   }
   
   override func viewDidAppear(_ animated: Bool) {
       super.viewDidAppear(animated)
       keyboardManager.enableKeybaordEvents()
   }

   override func viewWillDisappear(_ animated: Bool) {
       super.viewWillDisappear(animated)
       keyboardManager.disableKeyboardEvents()
   }
   
   override var shouldAutomaticallyForwardAppearanceMethods: Bool {
       return !keyboardManager.isEmbeddedViewController
   }
   
}

```

**that's all !!**
