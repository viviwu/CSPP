//
//  UIViewController+CS.m
//  CSWealth
//
//  Created by vivi wu on 2018/2/6.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import "UIViewController+CS.h"

@implementation UIViewController (CS)

+ (void) toastAlert:(NSString*)message time:(double)duration
{
    UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [toast show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [toast dismissWithClickedButtonIndex:0 animated:YES];
    });
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    NSLog(@"%s", __func__);
    return UIStatusBarStyleLightContent;
}

-(void)setTabBarItemTitle:(NSString*)title Image:(UIImage*)image
//-(void)setTabBarItemImage:(UIImage*)image
{
    self.title = title;
    self.tabBarItem.image = [image imageWithRenderingMode:UIImageRenderingModeAutomatic];
    self.tabBarItem.selectedImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

@end
