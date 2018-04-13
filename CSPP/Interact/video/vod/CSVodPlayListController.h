//
//  CSVodPlayListController.h
//  KSYPlayerDemo
//
//  Created by devcdl on 2017/9/11.
//  Copyright © 2017年 kingsoft. All rights reserved.
//

#import "CSViewController.h"

@class PlayerViewModel, CSVodPlayController;

@interface CSVodPlayListController : CSViewController

@property (nonatomic, strong) CSVodPlayController   *playVC;

@property (nonatomic, strong) PlayerViewModel       *playerViewModel;

@end
