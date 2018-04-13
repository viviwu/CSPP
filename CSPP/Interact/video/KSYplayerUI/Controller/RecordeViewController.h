//
//  RecordeViewController.h
//  KSYPlayerDemo
//
//  Created by devcdl on 2017/9/1.
//  Copyright © 2017年 kingsoft. All rights reserved.
//

#import "CSViewController.h"
#import <KSYMediaPlayer/KSYMoviePlayerController.h>

@class KSYMoviePlayerController;

@interface RecordeViewController : CSViewController

- (instancetype)initWithPlayer:(KSYMoviePlayerController *)player
    screenRecordeFinishedBlock:(void(^)(void))screenRecordeFinishedBlock;

- (void)startRecorde;

@end
