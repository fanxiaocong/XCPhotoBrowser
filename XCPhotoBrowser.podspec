Pod::Spec.new do |s|

  s.name         = "XCPhotoBrowser"
  s.version      = "1.0.0"
  s.summary      = "PhotoBrowser"

  s.description  = "PhotoBrowser封装自定义图片浏览器"

  s.homepage     = "https://github.com/fanxiaocong/XCPhotoBrowser"

  s.license      = "MIT"


  s.author       = { "樊小聪" => "1016697223@qq.com" }


  s.source       = { :git => "https://github.com/fanxiaocong/XCPhotoBrowser.git", :tag => s.version }


  s.source_files  = "XCPhotoBrowser"
  s.requires_arc  = true
  s.platform     = :ios, "8.0"
  s.frameworks   =  'UIKit'
 
  s.dependency 'SDWebImage', '~> 4.1.2' 

end
