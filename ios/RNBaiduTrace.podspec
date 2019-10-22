
Pod::Spec.new do |s|
  s.name         = "RNBaiduTrace"
  s.version      = "1.0.0"
  s.summary      = "RNBaiduTrace"
  s.description  = <<-DESC
                  RNBaiduTrace
                   DESC
  s.homepage     = ""
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "author" => "author@domain.cn" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/Koppel-Zhou/react-native-baidu-trace.git", :tag => "master" }
  s.source_files  = "RNBaiduTrace/**/*.{h,m}"
  s.requires_arc = true

  s.dependency "React"
  #s.dependency "others"

end

  