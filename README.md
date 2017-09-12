# DPKeyboardManager

Auto slide the view when keyboard appears

**HOW TO USE :**

```swift

import UIKit

class DPBaseViewController: UIViewController {

   let keyboardManager = DPKeyboardManager()
   
   override func viewDidAppear(_ animated: Bool) {
       super.viewDidAppear(animated)
       keyboardManager.enableKeybaordEvents(self.view)
   }

   override func viewWillDisappear(_ animated: Bool) {
       super.viewWillDisappear(animated)
       keyboardManager.disableKeyboardEvents()
   }
}

```

**that's all !!**
