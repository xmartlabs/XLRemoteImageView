Pod::Spec.new do |s|
  s.name     = 'XLRemoteImageView'
  s.version  = '1.0.0'
  s.license  = 'MIT'
  s.summary  = 'UIImageView category that allow us to know the download progress of an image. It makes a good use of UIImageView+AFNetworking category, using its NSCache instance, NSOperationQueue instance and so on. Also it adds the ability to show a progress indicator while the image is being downloading from a server.'
  s.homepage = 'https://github.com/xmartlabs/XLRemoteImageView'
  s.authors  = { 'Martin Barreto' => 'martin@xmartlabs.com' }
  s.source   = { :git => 'https://github.com/xmartlabs/XLRemoteImageView.git', :tag => '1.0.0' }
  s.source_files = 'XLRemoteImageView/XL/*.{h,m}'
  s.requires_arc = true
  s.dependency 'AFNetworking', '~> 1.3.2'
  s.ios.deployment_target = '5.0'
  s.ios.frameworks = 'UIKit', 'Foundation'
end