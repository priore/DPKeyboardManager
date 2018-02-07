Pod::Spec.new do |s|

  s.name             = "DPKeyboardManager"
  s.version          = "1.1.3"
  s.summary          = "Auto slide the view when keyboard appears."
  
  s.homepage         = "https://github.com/priore/DPKeyboardManager"
  s.license          = 'MIT'
  s.authors 		 = { 'Danilo Priore' => 'support@prioregroup.com' }
  s.source           = { :git => "https://github.com/priore/DPKeyboardManager.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/danilopriore'

  s.platform     = :ios
  s.ios.deployment_target = '9.0'
  s.requires_arc = true
  s.framework    = 'UIKit'
  s.source_files = '*.swift'

end