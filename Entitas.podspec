Pod::Spec.new do |s|
  s.name         = "Entitas"
  s.version      = "0.0.19"
  s.summary      = "Entity-system for Objective-C."
  s.homepage     = "http://https://github.com/wooga/oc-entitas"
  s.license      = 'MIT'
  s.author       = { "devboy" => "dominic.graefen@gmail.com" }
  s.source       = { :git => "https://github.com/wooga/oc-entitas.git", :tag => "#{s.version}" }
  s.source_files = 'Entitas/*.{h,m}'
  s.requires_arc =  true
end
