require 'json'

package = JSON.parse(File.read(File.join(__dir__, '../package.json')))

Pod::Spec.new do |s|
  s.name         = package['name']
  s.version      = "1.0.0"
  s.summary      = package['description']
  s.description  = <<-DESC
                    Baidu Trace SDK modules for React Native
                   DESC
  s.homepage     = "https://github.com/Koppel-Zhou/react-native-baidu-trace"
  s.license      = package['license']
  s.author       = "Koppel"
  s.source       = { :git => "git@github.com:Koppel-Zhou/react-native-baidu-trace.git", :tag => "master" }
  s.requires_arc = true
  s.platform     = :ios, "7.0"
  s.preserve_paths = "Frameworks/*.framework"
  s.source_files  = "RNBaiduTrace/*.{h,m}"

  s.dependency "React"
  #s.dependency "others"

end

  