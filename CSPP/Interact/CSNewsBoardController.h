//
//  CSNewsBoardController.h
//  CSPP
//
//  Created by vivi wu on 2018/3/26.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSMedia.h"
#import "XWTypewriterView.h"

#import "TYVideoPlayer.h"


@interface CSNewsBoardController : UIViewController

@property(nonatomic, strong) CSMedia * media;

- (instancetype)initWithViewFrame:(CGRect)frame;

@property (nonatomic, strong) TYVideoPlayer *videoPlayer;

+ (CSMedia*)demoTextNews;


@end


#define kdemoMsg @"小米IPO成为当下最热门的话题之一，它让外界对小米的关注和议论达到前所未有的高度，超越其成立八年来的任何时候。 尽管小米官方对上市一直闪烁其词，但这起备受瞩目的IPO似乎已经板上钉钉。 证监会和港交所也顺带因小米的上市传闻轮番占据媒体财经版面；各种各样的开曼基金和财富管理机构无论手里是否真的拿到了份额，都在疯狂兜售这家公司Pre-IPO的老股权，在他们的募资PPT里，小米估值也从450亿美元炒到1000亿美元甚至2000亿美元，每一次估值拉高都意味着新的赚钱机会。"


/**
            使用环境                           优点              缺点
 MPMoviePlayerController    MediaPlayer      简单易用          不可定制
 AVPlayerViewController       AVKit          简单易用          不可定制
 AVPlayer                AVFoundation    可定制度高，功能强大    不支持流媒体
 IJKPlayer           IJKMediaFramework  定制度高，支持流媒体播放  使用稍复杂
 
 另外AVPlayer是一个可以播放任何格式的全功能影音播放器
 支持视频格式： WMV，AVI，MKV，RMVB，RM，XVID，MP4，3GP，MPG等。
 支持音频格式：MP3，WMA，RM，ACC，OGG，APE，FLAC，FLV等。
 所以不得不说苹果亲儿子还是很强大的，是做视频开发的首选。
 
 */
