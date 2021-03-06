//
//  PlayerViewModel.h
//  KSYPlayerDemo
//
//  Created by devcdl on 2017/8/23.
//  Copyright © 2017年 kingsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "VideoListViewModel.h"

@class VodPlayOperationView, VideoContainerView, CSLivePlayViewController, CSVodPlayController;

@interface PlayerViewModel : NSObject

@property (nonatomic, strong) VideoModel         *playingVideoModel;

@property (nonatomic, strong) VideoListViewModel *videoListViewModel;

@property (nonatomic, weak) UIViewController *owner;

@property (nonatomic, assign) NSInteger currPlayingIndex;

- (instancetype)initWithPlayingVideoModel:(VideoModel *)playingVideoModel
                       videoListViewModel:(VideoListViewModel *)videoListViewModel
                            selectedIndex:(NSInteger)selectedIndex;

- (void)fullScreenButtonClickedHandlerForPlayController:(UIViewController *)playController
                    isFullScreen:(BOOL) isFullScreen;

- (void)fullScreenHandlerForLivePlayController:(CSLivePlayViewController *)playController
                              isFullScreen:(BOOL) isFullScreen;

- (void)fullScreenButtonClickedHandlerForCSVodPlayController:(CSVodPlayController *)vodPlayController isFullScreen:(BOOL)isFullScreen;

- (VideoModel *)nextVideoModel;

@end
