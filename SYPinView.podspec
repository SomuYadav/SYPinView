

Pod::Spec.new do |spec|


  spec.name         = "SYPinView"
  spec.version      = "1.0.1"
  spec.summary      = "Simplest OTP View iOS"
  spec.description  = "OTP View with customisation and field validation, customisation using interface builder" 
  spec.homepage     = "https://github.com/Somendra-yadav/SYPinView"



 
  spec.license      = "MIT"


  spec.author             = { "Somendra Yadav" => "somendra.sy@gmail.com" }


    spec.platform     = :ios, "12.0"



  spec.source       = { :git => "https://github.com/Somendra-yadav/SYPinView.git", :tag => "#{spec.version}" }



  spec.source_files  = "SYPinView/*.swift"
   
  spec.swift_version = "5.0"
end
