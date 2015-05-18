#
# Be sure to run `pod lib lint YSMChineseSort.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "YSMChineseSort"
  s.version          = "0.1.0"
  s.summary          = "YSMChineseSort as Contacts array"
  s.description      = <<-DESC
                        1、chinese simple sort;
                        2、return titleArray for UITableView section title;
                        3、return rowArray for UITableViewCell info.
                       DESC
  s.homepage         = "https://github.com/Cain1127/YSMChineseSort"
  s.license          = 'MIT'
  s.author           = { "ysmeng" => "49427823@163.com" }
  s.source           = { :git => "https://github.com/Cain1127/YSMChineseSort.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.1'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'YSMChineseSort' => ['Pod/Assets/*.png']
  }

end
