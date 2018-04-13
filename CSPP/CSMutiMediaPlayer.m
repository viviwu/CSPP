//
//  CSMutiMediaPlayer.m
//  CSPP
//
//  Created by csco on 2018/3/29.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import "CSMutiMediaPlayer.h"
#import "AppDelegate.h"

#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVAudioSession.h>
#import <AudioToolbox/AudioSession.h>

#import "IFlyMSC/IFlyMSC.h"
#import "PcmPlayer.h"
#import "TTSConfig.h"

#import "Definition.h"
#import "PopupView.h"
#import "AlertView.h"

static CSMutiMediaPlayer * instancePlayer = nil;

@interface CSMutiMediaPlayer()<IFlySpeechSynthesizerDelegate>

@property (nonatomic, strong) IFlySpeechSynthesizer * iFlySpeechSynthesizer;
@property (nonatomic, strong) PcmPlayer *audioPlayer;   //tts->AVAudioPlayer
@property (nonatomic, assign) BOOL isCanceled;
@property (nonatomic, assign) BOOL hasError;
@property (nonatomic, strong) NSString *uriPath;
 
@property (nonatomic, assign) SynthesizeType synType;

@property (nonatomic, strong) PopupView *popUpView;
@property (nonatomic, strong) AlertView *inidicateView;

@end

@implementation CSMutiMediaPlayer

+ (instancetype)instancePlayer
{
    @synchronized(instancePlayer){
        if (nil==instancePlayer) {
            instancePlayer = [[CSMutiMediaPlayer alloc]init];
        }
    }
    return instancePlayer;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setUpAudioSession];
        
        [self setUpInidicaters];
    }
    return self;
}

- (void)setUpAudioSession{
    //设置音频会话(静音状态也可播放声音)
    AVAudioSession *audionSession = [AVAudioSession sharedInstance];
    [audionSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audionSession setActive:YES error:nil];
}


#pragma mark-- ************************* TTS*************************
- (void)setUpInidicaters{
#pragma mark - InitializationTTS_UI
    // Do any additional setup after loading the view.
    UIView * appWindow = kAppDel.window;
    CGFloat posY = appWindow.frame.origin.y+ appWindow.frame.size.height/6;
    _popUpView = [[PopupView alloc] initWithFrame:CGRectMake(100, posY, 0, 0) withParentView:appWindow];
    _inidicateView =  [[AlertView alloc]initWithFrame:CGRectMake(100, posY, 0, 0)];
    _inidicateView.ParentView = appWindow;
    [appWindow addSubview:_inidicateView];
    [_inidicateView hide];
    
#pragma mark - Setting For URI TTS
    //URI TTS: -(void)synthesize:(NSString *)text toUri:(NSString*)uri
    //If uri is nil, the audio file is saved in library/cache by defailt.
    NSString *prePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //Set the audio file name for URI TTS
    _uriPath = [NSString stringWithFormat:@"%@/%@",prePath,@"uri.pcm"];
    //Instantiate player for URI TTS
    _audioPlayer = [[PcmPlayer alloc] init];
}

- (void)initTTSSynthesizer
{
    TTSConfig *instance = [TTSConfig sharedInstance];
    instance.vcnName = @"xiaoyu";
    if (instance == nil) {
        return;
    }
    
    //TTS singleton
    if (_iFlySpeechSynthesizer == nil) {
        _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    }
    
    _iFlySpeechSynthesizer.delegate = self;
    
    //set speed,range from 1 to 100.
    [_iFlySpeechSynthesizer setParameter:instance.speed forKey:[IFlySpeechConstant SPEED]];
    
    //set volume,range from 1 to 100.
    [_iFlySpeechSynthesizer setParameter:instance.volume forKey:[IFlySpeechConstant VOLUME]];
    
    //set pitch,range from 1 to 100.
    [_iFlySpeechSynthesizer setParameter:instance.pitch forKey:[IFlySpeechConstant PITCH]];
    
    //set sample rate
    [_iFlySpeechSynthesizer setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
    
    //set TTS speaker
    [_iFlySpeechSynthesizer setParameter:instance.vcnName forKey:[IFlySpeechConstant VOICE_NAME]];
    
    //set text encoding mode
    [_iFlySpeechSynthesizer setParameter:@"unicode" forKey:[IFlySpeechConstant TEXT_ENCODING]];
    
    NSDictionary* languageDic=@{@"catherine":@"text_english",//English
                                @"XiaoYun":@"text_vietnam",//Vietnamese
                                @"Abha":@"text_hindi",//Hindi
                                @"Gabriela":@"text_spanish",//Spanish
                                @"Allabent":@"text_russian",//Russian
                                @"Mariane":@"text_french"};//French
    
    NSString* textNameKey=[languageDic valueForKey:instance.vcnName];
    NSString* textSample=nil;
    
    if(textNameKey && [textNameKey length]>0){
        textSample=NSLocalizedStringFromTable(textNameKey, @"ifly_tts_data/tts/tts", nil);
    }else{
        textSample=NSLocalizedStringFromTable(@"text_chinese", @"ifly_tts_data/tts/tts", nil);
    }
}

#pragma mark - TTS Action


/**
 start normal TTS
 **/
- (void)startSynTTS:(NSString * )str {
    
    if ([str isEqualToString:@""]) {
        [_popUpView showText: NSLocalizedString(@"T_TTS_InvTxt", nil)];
        return;
    }
    
    if (_audioPlayer != nil && _audioPlayer.isPlaying == YES) {
        [_audioPlayer stop];
    }
    
    _synType = NomalType;
    
    self.hasError = NO;
    [NSThread sleepForTimeInterval:0.05];
    
    [_inidicateView setText: NSLocalizedString(@"T_TTS_Buff", nil)];
    [_inidicateView show];
    
    [_popUpView removeFromSuperview];
    self.isCanceled = NO;
    
    _iFlySpeechSynthesizer.delegate = self;
    
    [_iFlySpeechSynthesizer startSpeaking:str];
    if (_iFlySpeechSynthesizer.isSpeaking) {
        _ttsStatus = TTSPlaying;
    }
}

/**
 start URI TTS
 **/


- (void)stopTTS{
    [_iFlySpeechSynthesizer stopSpeaking];
    [_audioPlayer stop];
    [_inidicateView hide];
    _iFlySpeechSynthesizer.delegate = nil;
}
/**
 cancel TTS
 Notice：
 1、cancel TTS and stop player for normal TTS；
 2、cancel TTS but storage the saved audio pcm data for URI TTS；
 **/
- (void)cancelSynTTS{
    [_inidicateView hide];
    [_iFlySpeechSynthesizer stopSpeaking];
    
}

/**
 pause player
 Notice：
 Only apply to normal TTS
 **/
- (void)pauseSynTTS {
    [_iFlySpeechSynthesizer pauseSpeaking];
}

/**
 resume palyer
 Notice：
 Only apply to normal TTS
 **/
- (void)resumeSynTTS {
    [_iFlySpeechSynthesizer resumeSpeaking];
}



#pragma mark - TTSPlaying For URI TTS
- (void)playUriAudio
{
    TTSConfig *instance = [TTSConfig sharedInstance];
    [_popUpView showText: NSLocalizedString(@"M_TTS_URIPlay", nil)];
    NSError *error = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    _audioPlayer = [[PcmPlayer alloc] initWithFilePath:_uriPath sampleRate:[instance.sampleRate integerValue]];
    [_audioPlayer play];
}

#pragma mark --IFlySpeechSynthesizerDelegate

/**
 callback of starting TTSPlaying
 Notice：
 Only apply to normal TTS
 **/
- (void)onSpeakBegin
{
    [_inidicateView hide];
    self.isCanceled = NO;
    if (_ttsStatus  != TTSPlaying) {
        [_popUpView showText: NSLocalizedString(@"T_TTS_Play", nil)];
    }
    _ttsStatus = TTSPlaying;
}

/**
 callback of buffer progress
 Notice：
 Only apply to normal TTS
 **/
- (void)onBufferProgress:(int) progress message:(NSString *)msg
{
    NSLog(@"buffer progress %2d%%. msg: %@.", progress, msg);
}


/**
 callback of playback progress
 Notice：
 Only apply to normal TTS
 **/
- (void) onSpeakProgress:(int) progress beginPos:(int)beginPos endPos:(int)endPos
{
    NSLog(@"speak progress %2d%%.", progress);
}


/**
 callback of pausing player
 Notice：
 Only apply to normal TTS
 **/
- (void)onSpeakTTSPaused
{
    [_inidicateView hide];
    [_popUpView showText: NSLocalizedString(@"T_TTS_Pause", nil)];
    
    _ttsStatus = TTSPaused;
}


/**
 callback of TTS completion
 **/
- (void)onCompleted:(IFlySpeechError *) error
{
    NSLog(@"%s,error=%d",__func__,error.errorCode);
    
    if (error.errorCode != 0) {
        [_inidicateView hide];
        [_popUpView showText:[NSString stringWithFormat:@"Error Code:%d",error.errorCode]];
        return;
    }
    NSString *text ;
    if (self.isCanceled) {
        text = NSLocalizedString(@"T_TTS_Cancel", nil);
    }else if (error.errorCode == 0) {
        text = NSLocalizedString(@"T_TTS_End", nil);
    }else {
        text = [NSString stringWithFormat:@"Error：%d %@",error.errorCode,error.errorDesc];
        self.hasError = YES;
        NSLog(@"%@",text);
    }
    
    [_inidicateView hide];
    [_popUpView showText:text];
    
    _ttsStatus = TTSNotStart;
    
    if (_synType == UriType) {//URI TTS
        
        NSFileManager *fm = [NSFileManager defaultManager];
        if ([fm fileExistsAtPath:_uriPath]) {
            [self playUriAudio];//play the audio file generated by URI TTS
        }
    }
}

- (TTSStatus)ttsStatus{
    return _ttsStatus;
}


@end
