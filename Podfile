
source 'git@github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
#inhibit_all_warnings!

def common
# Uncomment the next line if you're using Swift or would like to use dynamic frameworks
    # use_frameworks!

#    pod 'EDColor'
    pod 'Colours'
    pod 'PNChart'
    pod 'Masonry'
    pod 'AFNetworking'
    pod 'JSONModel'
    pod 'SDWebImage', '~> 4.0'
#    pod 'CocoaSecurity'
    pod 'MJRefresh', '~> 3.1.1'
    pod 'MJExtension', '~> 3.0.10'
    pod 'MBProgressHUD', '~> 0.9.2'
    pod 'BarrageRenderer', '~> 1.8.0'
#    pod 'GPUImage', '~> 0.1.7' 由于LFLiveKit里面已经集成了GPUImage
#    pod 'LFLiveKit', '~> 1.6'
    pod 'SSKeychain', '~> 1.2.2'
#    pod 'PYSearch'
    pod 'Toast'
    pod 'Bugly'
    
    #默认使用静态直播库
    #pod 'KSYMediaPlayer_iOS',                              :path => '../'
    
    #使用静态直播库
    pod 'KSYMediaPlayer_iOS/KSYMediaPlayer_live',         :path => '../'
    
    #使用动态直播库
    #pod 'KSYMediaPlayer_iOS/KSYMediaPlayer_live_dy',      :path => '../'
    
    #使用静态点播库
    #pod 'KSYMediaPlayer_iOS/KSYMediaPlayer_vod',          :path => '../'
    
    #使用动态点播库
    #pod 'KSYMediaPlayer_iOS/KSYMediaPlayer_vod_dy',       :path => '../'
end

#target 'CSPP' do
#	common
#end

target 'CSPP' do
    common
end
