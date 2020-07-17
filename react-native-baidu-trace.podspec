require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "react-native-baidu-trace"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.description  = <<-DESC
                  react-native-baidu-trace
                   DESC
  s.homepage     = "https://github.com/Koppel-Zhou/react-native-baidu-trace"
  # brief license entry:
  s.license      = "MIT"
  # optional - use expanded license entry instead:
  # s.license    = { :type => "MIT", :file => "LICENSE" }
  s.authors      = { "Koppel" => "koppel.zhou@email.com" }
  s.platforms    = { :ios => "9.0" }
  s.source       = { :git => "https://github.com/Koppel-Zhou/react-native-baidu-trace.git", :tag => "#{s.version}" }
  s.vendored_frameworks = 'ios/Frameworks/BaiduTraceSDK.framework'
  s.source_files = "ios/**/*.{h,c,m,swift}"
  s.requires_arc = true

  s.dependency "React"
  # s.dependency "BaiduTraceKit"
end

