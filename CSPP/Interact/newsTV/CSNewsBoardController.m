//
//  CSNewsBoardController.m
//  CSPP
//
//  Created by vivi wu on 2018/3/26.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import "CSNewsBoardController.h"
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import "CSMutiMediaPlayer.h"

#import "JXTProgressLabel.h"
#import "XWTypewriterView.h"

#import "TYVideoPlayerView.h"

@interface CSNewsBoardController ()<TYVideoPlayerDelegate>

@property (nonatomic, weak) TYVideoPlayerView *playerView;
@property(nonatomic, strong) JXTProgressLabel * progressLabel;
@property(nonatomic, strong) XWTypewriterView * typewriterView;

@property (nonatomic, assign) TTSStatus playStatus;

@end

@implementation CSNewsBoardController

- (instancetype)initWithViewFrame:(CGRect)frame{
    self = [super init];
    if(self){
        [self.view setFrame:frame];
    }
    return self;
}

- (TTSStatus)playStatus
{
    _playStatus = [CSMutiMediaPlayer instancePlayer].ttsStatus;
    return _playStatus;
}

- (TYVideoPlayerView *)playerView{
    if (!_playerView) {
        TYVideoPlayerView *playerView = [[TYVideoPlayerView alloc]init];
        playerView.backgroundColor = [UIColor blackColor];
        playerView.frame = self.view.bounds;
        [self.view addSubview:playerView];
        _playerView = playerView;
    }
    return _playerView;
}

- (TYVideoPlayer *)videoPlayer{
    if (!_videoPlayer) {
        TYVideoPlayer *videoPlayer = [[TYVideoPlayer alloc]initWithPlayerLayerView:self.playerView];
        videoPlayer.delegate = self;
        _videoPlayer = videoPlayer;
    }
    return _videoPlayer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.playStatus = TTSNotStart;
    [[CSMutiMediaPlayer instancePlayer] initTTSSynthesizer];
    // Do any additional setup after loading the view.
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.playerView.frame = self.view.bounds;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (CSMediaTypeVideo == self.media.mediaType) {
        if (self.videoPlayer) {
            [self.videoPlayer play];
        }else{
            [self loadVodVideo];
        }
        [self.view bringSubviewToFront:_playerView];
        
    }else if (CSMediaTypeLive == self.media.mediaType) {
        if (self.videoPlayer) {
            [self.videoPlayer play];
        }else{
            [self loadLiveVideo];
        }
        [self.view bringSubviewToFront:_playerView];
        
    }else if (CSMediaTypeAudio == self.media.mediaType){
        if (TTSPlaying == self.playStatus) {
            [[CSMutiMediaPlayer instancePlayer] stopTTS];
        }
        [[CSMutiMediaPlayer instancePlayer] startSynTTS:self.media.schema];
        [self.typewriterView printMessage:kdemoMsg inDuration:30.0];
    }else{
        
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   
}

- (void)setMedia:(CSMedia *)media
{
    _media = media;
    if (self.videoPlayer != nil && TYVideoPlayerStateContentPlaying == self.videoPlayer.state) {
        [self.videoPlayer stop];
    }
    
    if (TTSPlaying == self.playStatus) {
        [[CSMutiMediaPlayer instancePlayer] stopTTS];
    }
    [self.typewriterView cleanUpEverything];
     
    if (CSMediaTypeVideo == media.mediaType) {
        [self.view bringSubviewToFront: self.playerView];
        [self loadVodVideo];
    }else if (CSMediaTypeAudio == media.mediaType) {
        if ( TTSPlaying == self.playStatus) {
            [[CSMutiMediaPlayer instancePlayer] stopTTS];
        }
        [[CSMutiMediaPlayer instancePlayer] startSynTTS:[CSNewsBoardController demoTextNews].schema];
        [self.view bringSubviewToFront:self.typewriterView];
        [self.typewriterView printMessage:kdemoMsg inDuration:30.0];
    }else if (CSMediaTypeLive == media.mediaType) {
        [self.view bringSubviewToFront: self.playerView];
        [self loadLiveVideo];
    }else{
        
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (CSMediaTypeVideo == self.media.mediaType) {
        if (self.videoPlayer) {
            [self.videoPlayer pause];
        }
    }else if (CSMediaTypeLive == self.media.mediaType) {
        if (self.videoPlayer) {
            [self.videoPlayer pause];
        }
    }else if (CSMediaTypeAudio == self.media.mediaType){
        if ( TTSPlaying == self.playStatus) {
            [[CSMutiMediaPlayer instancePlayer] stopTTS];
        }
    }else{
        
    }
}


#pragma mark-- ************************* *************************
#pragma mark - TYVideoPlayerDelegate

- (void)videoPlayer:(TYVideoPlayer*)videoPlayer track:(id<TYVideoPlayerTrack>)track didChangeToState:(TYVideoPlayerState)toState fromState:(TYVideoPlayerState)fromState
{
    switch (toState) {
        case TYVideoPlayerStateContentReadyToPlay:
            //[videoPlayer seekToLastWatchTime];
            [videoPlayer play];
            break;
            
        default:
            break;
    }
}


#pragma mark-- ************************* *************************
#pragma mark-- typewriterView

- (XWTypewriterView *)typewriterView{
    if (!_typewriterView) {
        XWTypewriterView * imv = [[XWTypewriterView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:imv];
        _typewriterView = imv;
    }
    [_typewriterView cleanUpEverything];
    
    return _typewriterView;
}


- (void)preparePlay{
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(/*延迟执行时间*/1.0 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        //UI task
        NSTimeInterval period = 1.0; //设置时间间隔
        dispatch_queue_t queue = dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create( DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{    //在这里执行事件
            static BOOL flag;
            if (!flag) {
                _progressLabel.clipWidth ++;
                if (_progressLabel.clipWidth > _progressLabel.frame.size.width) {
                    flag = !flag;
                }
            }else {
                _progressLabel.clipWidth --;
                if (_progressLabel.clipWidth == 0) {
                    flag = !flag;
                }
            }
        });
        dispatch_resume(_timer);
    });
}

+ (CSMedia*)demoTextNews{
    CSMedia * media = [[CSMedia alloc]init];
    media.mediaType = CSMediaTypeLive;
    media.title =@"摘要: 小米上市在即，Pre-IPO股权“一份难求”，估值暴涨。兜售小米老股的二道贩子们击鼓传花，层层套利，也有人破坏行规，想要赚一把棺材本。";
    media.schema = @"小米IPO成为当下最热门的话题之一，它让外界对小米的关注和议论达到前所未有的高度，超越其成立八年来的任何时候。 尽管小米官方对上市一直闪烁其词，但这起备受瞩目的IPO似乎已经板上钉钉。 证监会和港交所也顺带因小米的上市传闻轮番占据媒体财经版面；各种各样的开曼基金和财富管理机构无论手里是否真的拿到了份额，都在疯狂兜售这家公司Pre-IPO的老股权，在他们的募资PPT里，小米估值也从450亿美元炒到1000亿美元甚至2000亿美元，每一次估值拉高都意味着新的赚钱机会。";
    return media;
}

/*
 - (JXTProgressLabel * )progressLabel{
 if (!_progressLabel) {
 _progressLabel = [[JXTProgressLabel alloc] initWithFrame:self.frame];
 _progressLabel.backgroundColor = [UIColor blackColor];
 _progressLabel.backgroundTextColor = [UIColor whiteColor];
 _progressLabel.foregroundTextColor = [UIColor yellowColor];
 _progressLabel.text = kdemoMsg;
 _progressLabel.textAlignment = NSTextAlignmentLeft;
 _progressLabel.font = [UIFont systemFontOfSize:20];
 _progressLabel.clipWidth = kSelfW-20.0;
 }
 [self addSubview:_progressLabel];
 return _progressLabel;
 }
 */


#pragma mark-- *************************load Video *************************


- (void)loadVodVideo
{
    // 点播
    // http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8
    NSURL *streamURL = [NSURL URLWithString:@"http://mobile.ks3-cn-beijing.ksyun.com/mp4s/jaychou.mp4"];
    
    [_videoPlayer loadVideoWithStreamURL:streamURL];
//    _videoPlayer.track.continueLastWatchTime = YES;
}

- (void)loadLiveVideo
{
    // 直播
    NSURL *streamURL = [NSURL URLWithString:@"http://live.hkstv.hk.lxdns.com/live/hks/playlist.m3u8"]; 
    [_videoPlayer loadVideoWithStreamURL:streamURL];
}

- (void)loadLocalVideo
{
    // 本地播放
    NSString* path = [[NSBundle mainBundle] pathForResource:@"test_264" ofType:@"mp4"];
    if (!path) {
        UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"本地文件不存在！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alerView show];
        return;
    }
    NSURL* streamURL = [NSURL fileURLWithPath:path];
    [_videoPlayer loadVideoWithStreamURL:streamURL];
    _videoPlayer.track.continueLastWatchTime = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
