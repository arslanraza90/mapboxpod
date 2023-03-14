
Pod::Spec.new do |s|
  s.name             = 'mapboxpod'
  s.version          = '1.0.9'
  s.summary          = 'Mapbox frammework.' 
  s.homepage         = 'https://github.com/arslanraza90/mapboxpod'
  # s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Arslan Raza' => 'https://github.com/arslanraza90/' }
  s.source           = { :git => 'https://github.com/arslanraza90/mapboxpod.git', :tag => s.version.to_s }
 
  s.source_files = 'MapBoxFramework/**/*.{swift}'
  s.ios.deployment_target = '13.0'
  s.swift_versions = '5.0'
  s.static_framework = true

  s.dependency 'MapboxMaps', '10.10.1'
  s.dependency 'MapboxDirections', '~> 2.9'
  s.dependency 'MapboxCoreNavigation', '~> 2.9'
  s.dependency 'MapboxNavigation', '~> 2.9'
  s.dependency 'GooglePlaces', '7.3.0'

 
end