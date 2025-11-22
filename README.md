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

## Support Development
If this project has been helpful to you, please consider making a small donation. Your support is crucial for funding new features, covering hosting costs, or simply buying me a coffee! Every contribution, big or small, is highly appreciated.

Scan the code below with your cryptocurrency wallet or copy the address.

|Donate with BTC (Bitcoin)
|:------------:|
|![](https://www.prioregroup.com/images/priore_btc_segwit_binance.jpg)
|`BTC Address (SegWit) : bc1q6rjOuuwu9k2fvs5n5elmqy9v4ljazhexejykjm`
