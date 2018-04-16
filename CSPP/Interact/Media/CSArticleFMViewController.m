//
//  CSArticleFMViewController.m
//  CSInvest
//
//  Created by vivi wu on 2018/3/20.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import "CSArticleFMViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVAudioSession.h>
#import <AudioToolbox/AudioSession.h>
#import "Definition.h"
#import "PopupView.h"
#import "AlertView.h"
#import "TTSConfig.h"

@interface CSArticleFMViewController ()

@end

@implementation CSArticleFMViewController


- (UITextView*)textView{
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    }
    return _textView;
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"FM文章";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.textView.backgroundColor=[UIColor whiteColor]; //设置背景色
    //    _textView.delegate = (id)self;       //设置代理方法的实现类
    self.textView.font=[UIFont fontWithName:@"Arial" size:18.0]; //设置字体名字和字体大小;
    self.textView.returnKeyType = UIReturnKeyDefault;//设置return键的类型
    self.textView.keyboardType = UIKeyboardTypeDefault;//设置键盘类型一般为默认
    self.textView.textAlignment = NSTextAlignmentLeft; //文本显示的位置默认为居左
    self.textView.dataDetectorTypes = UIDataDetectorTypeAll; //显示数据类型的连接模式（如电话号码、网址、地址等）
    self.textView.textColor = [UIColor blackColor];// 设置显示文字颜色
    self.textView.text = @"Xcode9 好坑爹" ; //设置显示的文本内容
    self.textView.scrollEnabled = YES;    //设置当文字超过视图的边框时是否允许滑动，默认为“YES”
    self.textView.editable = NO;        //设置是否允许编辑内容，默认为“YES”
    
    self.textView.layer.borderWidth = 0.5f;
    self.textView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [self.textView.layer setCornerRadius:7.0f];
    [self.view addSubview:self.textView];
    
    UIBarButtonItem *spaceBtnItem = [[ UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                     target:nil action:nil];
    
    UIBarButtonItem *hideBtnItem = [[UIBarButtonItem alloc]
                                    initWithTitle:@"Hide" style:UIBarButtonItemStylePlain
                                    target:self action:@selector(onKeyBoardDown:)];
    
    [hideBtnItem setTintColor:[UIColor whiteColor]];
    UIToolbar *toolbar = [[ UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    NSArray *array = [NSArray arrayWithObjects:spaceBtnItem,hideBtnItem, nil];
    [toolbar setItems:array];
    
    self.textView.inputAccessoryView = toolbar;
    
    CGFloat posY = self.textView.frame.origin.y+self.textView.frame.size.height/6;
    _popUpView = [[PopupView alloc] initWithFrame:CGRectMake(100, posY, 0, 0) withParentView:self.view];
    
    _inidicateView =  [[AlertView alloc]initWithFrame:CGRectMake(100, posY, 0, 0)];
    _inidicateView.ParentView = self.view;
    [self.view addSubview:_inidicateView];
    [_inidicateView hide];
    
#pragma mark - Setting For URI TTS
    
    //URI TTS: -(void)synthesize:(NSString *)text toUri:(NSString*)uri
    //If uri is nil, the audio file is saved in library/cache by defailt.
    NSString *prePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //Set the audio file name for URI TTS
    _uriPath = [NSString stringWithFormat:@"%@/%@",prePath,@"uri.pcm"];
    //Instantiate player for URI TTS
    _audioPlayer = [[PcmPlayer alloc] init];

#pragma mark - setToolbarItems
    UIBarButtonItem * start = [self plainBarItem:[UIImage imageNamed:@"play"] action:@selector(startSynBtnHandler:)];
    UIBarButtonItem * cancel = [self plainBarItem:[UIImage imageNamed:@"cancel"] action:@selector(cancelSynBtnHandler:)];
    UIBarButtonItem * pause = [self plainBarItem:[UIImage imageNamed:@"pause"] action:@selector(pauseSynBtnHandler:)];
    UIBarButtonItem * resume = [self plainBarItem:[UIImage imageNamed:@"resume"] action:@selector(resumeSynBtnHandler:)];
    
    [self setToolbarItems:@[[self spaceItem], start,[self spaceItem], cancel,[self spaceItem], pause,[self spaceItem], resume, [self spaceItem]] animated:YES];
    
}

- (UIBarButtonItem *)plainBarItem:(UIImage*)image action:(SEL)action
{
    return [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:action];
}

- (UIBarButtonItem *)spaceItem{
    return [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
}

- (BOOL)shouldAutorotate{
    return NO;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     self.navigationController.toolbarHidden = NO;
    [self initSynthesizer];
}

- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.toolbarHidden = YES;
    [super viewWillDisappear:animated];
    
    self.isViewDidDisappear = true;
    [_iFlySpeechSynthesizer stopSpeaking];
    [_audioPlayer stop];
    [_inidicateView hide];
    _iFlySpeechSynthesizer.delegate = nil;
    
}

#pragma mark - Button Handling

- (void)onKeyBoardDown:(id) sender{
    [_textView resignFirstResponder];
    
}

/**
 start normal TTS
 **/
 - (void)startSynBtnHandler:(id)sender {
    
    if ([self.textView.text isEqualToString:@""]) {
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
    
    NSString* str= self.textView.text;
     NSLog(@"textView.text==%@", self.textView.text);
    [_iFlySpeechSynthesizer startSpeaking:str];
    if (_iFlySpeechSynthesizer.isSpeaking) {
        _state = Playing;
    }
}

/**
 start URI TTS
 **/
 - (void):(id)sender {
    
    if ([self.textView.text isEqualToString:@""]) {
        [_popUpView showText: NSLocalizedString(@"T_TTS_InvTxt", nil)];
        return;
    }
    
    if (_audioPlayer != nil && _audioPlayer.isPlaying == YES) {
        [_audioPlayer stop];
    }
    
    _synType = UriType;
    
    self.hasError = NO;
    
    [NSThread sleepForTimeInterval:0.05];
    
    
    [_inidicateView setText: NSLocalizedString(@"T_TTS_Buff", nil)];
    [_inidicateView show];
    
    [_popUpView removeFromSuperview];
    
    self.isCanceled = NO;
    
    _iFlySpeechSynthesizer.delegate = self;
    
    [_iFlySpeechSynthesizer synthesize:self.textView.text toUri:_uriPath];
    if (_iFlySpeechSynthesizer.isSpeaking) {
        _state = Playing;
    }
}



/**
 cancel TTS
 Notice：
 1、cancel TTS and stop player for normal TTS；
 2、cancel TTS but storage the saved audio pcm data for URI TTS；
 **/
 - (void)cancelSynBtnHandler:(id)sender {
    [_inidicateView hide];
    [_iFlySpeechSynthesizer stopSpeaking];
    
}



/**
 pause player
 Notice：
 Only apply to normal TTS
 **/
 - (void)pauseSynBtnHandler:(id)sender {
    [_iFlySpeechSynthesizer pauseSpeaking];
}


/**
 resume palyer
 Notice：
 Only apply to normal TTS
 **/
 - (void)resumeSynBtnHandler:(id)sender {
    [_iFlySpeechSynthesizer resumeSpeaking];
}


 - (void)clearBtnHandler:(id)sender {
    [_textView setText:@""];
}



 - (void)onSetting:(id)sender {
    
    if ([[self.navigationController topViewController] isKindOfClass:[CSArticleFMViewController class]]){
        [self performSegueWithIdentifier:@"TTSSegue" sender:self];
    }
    
}


#pragma mark - IFlySpeechSynthesizerDelegate

/**
 callback of starting playing
 Notice：
 Only apply to normal TTS
 **/
- (void)onSpeakBegin
{
    [_inidicateView hide];
    self.isCanceled = NO;
    if (_state  != Playing) {
        [_popUpView showText: NSLocalizedString(@"T_TTS_Play", nil)];
    }
    _state = Playing;
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
- (void)onSpeakPaused
{
    [_inidicateView hide];
    [_popUpView showText: NSLocalizedString(@"T_TTS_Pause", nil)];
    
    _state = Paused;
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
    
    _state = NotStart;
    
    if (_synType == UriType) {//URI TTS
        
        NSFileManager *fm = [NSFileManager defaultManager];
        if ([fm fileExistsAtPath:_uriPath]) {
            [self playUriAudio];//play the audio file generated by URI TTS
        }
    }
}


#pragma mark - Initialization

- (void)initSynthesizer
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
    
    /*
    NSDictionary* languageDic=@{@"catherine":@"text_english",//English
                                @"XiaoYun":@"text_vietnam",//Vietnamese
                                @"Abha":@"text_hindi",//Hindi
                                @"Gabriela":@"text_spanish",//Spanish
                                @"Allabent":@"text_russian",//Russian
                                @"Mariane":@"text_french"};//French
    
    NSString* textNameKey=[languageDic valueForKey:instance.vcnName];
    NSString* textSample=nil;
    
    if(textNameKey && [textNameKey length]>0){
        textSample=NSLocalizedStringFromTable(textNameKey, @"tts/tts", nil);
    }else{
        textSample=NSLocalizedStringFromTable(@"text_chinese", @"iflyTTS/tts/tts", nil);
    }
    */
    [self.textView setText:textSample];
    
}


#pragma mark - Playing For URI TTS

- (void)playUriAudio
{
    TTSConfig *instance = [TTSConfig sharedInstance];
    [_popUpView showText: NSLocalizedString(@"M_TTS_URIPlay", nil)];
    NSError *error = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    _audioPlayer = [[PcmPlayer alloc] initWithFilePath:_uriPath sampleRate:[instance.sampleRate integerValue]];
    [_audioPlayer play];
    
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
