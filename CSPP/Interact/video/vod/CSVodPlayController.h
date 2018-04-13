//
//  CSVodPlayController.h
//  CSPP
//
//  Created by csco on 2018/3/27.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayController.h"

@class PlayerViewModel, VodPlayOperationView;

@interface CSVodPlayController :  PlayController

@property (nonatomic, strong) PlayerViewModel      *playerViewModel;

@property (nonatomic, assign) BOOL fullScreen;

@property (nonatomic, strong) VodPlayOperationView      *playOperationView;

//- (void)suspendHandler;

//- (void)recoveryHandler;

- (void)stopSuspend;

@end
