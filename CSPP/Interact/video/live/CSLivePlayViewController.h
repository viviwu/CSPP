//
//  CSLivePlayViewController.h
//  CSPP
//
//  Created by csco on 2018/3/27.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayController.h"

@class PlayerViewModel;

@interface CSLivePlayViewController : PlayController

@property (nonatomic, strong) PlayerViewModel      *playerViewModel;

@property (nonatomic, assign) BOOL fullScreen;

/**
 *  点击视频列表内的其他item，player需要reload
 */
- (void)reloadPushFromSuspendHandler;

@end
