#
#  Be sure to run `pod spec lint FBaseNetWork.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "FBaseNetWork"
  s.version      = "0.0.5"
  s.summary      = "简单封装 七牛及AFNetworking"

  s.homepage     = "https://github.com/Fmyz/FBaseNetWork.git"

  s.license      = "MIT"

  s.author    = "Fmyz"

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/Fmyz/FBaseNetWork.git", :tag => "#{s.version}" }
  s.requires_arc = true

  s.source_files  = "NetWork/*.{h,m}"

  s.dependency "Qiniu", "~> 7.1.0.1"
  s.dependency "AFNetworking", "~> 3.1.0"
end
