//
//  UIViewController+CS.h
//  CSWealth
//
//  Created by vivi wu on 2018/2/6.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (CS)

+ (void) toastAlert:(NSString*)message time:(double)duration;

-(UIStatusBarStyle)preferredStatusBarStyle;

-(void)setTabBarItemTitle:(NSString*)title Image:(UIImage*)image;
//-(void)setTabBarItemImage:(UIImage*)image;

@end
