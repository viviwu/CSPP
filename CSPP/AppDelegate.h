//
//  AppDelegate.h
//  CSInvest
//
//  Created by vivi wu on 2018/3/8.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingModel.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, assign) BOOL allowRotation;
@property (nonatomic, strong) SettingModel *settingModel;

@end

