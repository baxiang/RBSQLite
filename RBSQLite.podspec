
Pod::Spec.new do |s|
  s.name             = 'RBSQLite'
  s.version="1.2.3"
  s.summary          = 'A Cocoa / Objective-C wrapper around SQLite'
  s.homepage         = 'https://github.com/baxiang/RBSQLite'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'baxiang' => 'baxiang1989@163.com' }
  s.source           = { :git => 'https://github.com/baxiang/RBSQLite.git', :tag => s.version.to_s }
  s.ios.deployment_target = '7.0'
  s.source_files = 'RBSQLite/Classes/**/*'
  s.dependency 'FMDB'
end
