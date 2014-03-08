Pod::Spec.new do |s|
  s.name         = "Entitas"
  s.version      = "0.1.0"
  s.summary      = "Entity-system for Objective-C."
  s.homepage     = "http://https://github.com/wooga/oc-entitas"
  s.license      = 'MIT'
  s.author       = { "devboy" => "dominic.graefen@gmail.com" }
  s.source       = { :git => "https://github.com/StephanPartzsch/oc-entitas.git" }
  s.source_files = 'Entitas/*.{h,m,mm}', 'Entitas/Internal/*.{h,m,mm}'
  s.requires_arc =  true
  s.libraries    = 'c++', 'stdc++'
  s.xcconfig = {
       'CLANG_CXX_LANGUAGE_STANDARD' => 'c++11',
       'CLANG_CXX_LIBRARY' => 'libc++'
  }
end
