Pod::Spec.new do |s|
    s.name             = 'fb2book'
    s.version          = '1.0.1'
    s.summary          = 'FB2 parser for iOS'
    s.description      = 'Provides support for FB2Book for Swift'
    s.homepage         = 'https://github.com/awxkee/fb2book'
    s.license          = { :type => 'BSD-3', :file => 'LICENSE.md' }
    s.author           = { 'username' => 'radzivon.bartoshyk@proton.me' }
    s.source           = { :git => 'https://github.com/awxkee/fb2book.git', :tag => "#{s.version}" }
    s.ios.deployment_target = '11.0'
    s.source_files = 'Sources/fb2book/*.{swift,h,m,cpp,mm,hpp}'
    s.swift_version = ["5.3", "5.4", "5.5"]
    s.frameworks = "Foundation", "CoreGraphics", "Accelerate"
    s.libraries = 'c++'
    s.dependency 'XMLCoder'
    s.dependency 'ZIPFoundation'
    s.requires_arc = true
end

