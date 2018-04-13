//
//  CSMutiMediaPlayer.h
//  CSPP
//
//  Created by csco on 2018/3/29.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import <Foundation/Foundation.h>


/**$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$*/
typedef NS_OPTIONS(NSInteger, SynthesizeType) {
    NomalType           = 5,    //Normal TTS
    UriType             = 6,    //URI TTS
};

//ttsStatus of TTS
typedef NS_OPTIONS(NSInteger, TTSStatus) {
    TTSNotStart            = 0,
    TTSPlaying             = 2,
    TTSPaused              = 4,
};

/**$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$*/

@interface CSMutiMediaPlayer : NSObject

+ (instancetype)instancePlayer;

#pragma mark - TTS
- (void)initTTSSynthesizer;
@property (nonatomic, assign) TTSStatus ttsStatus;

#pragma mark - TTS Action
/**
 start normal TTS
 **/
- (void)startSynTTS:(NSString * )str;
- (void)stopTTS;
/**
 cancel TTS
 Notice：
 1、cancel TTS and stop player for normal TTS；
 2、cancel TTS but storage the saved audio pcm data for URI TTS；
 **/
- (void)cancelSynTTS;
- (void)pauseSynTTS;
/**
 resume palyer
 Notice：
 Only apply to normal TTS
 **/
- (void)resumeSynTTS;


@end
