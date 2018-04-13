//
//  UIView+CS.m
//  CSWealth
//
//  Created by vivi wu on 2018/2/7.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import "UIView+CS.h"

@implementation UIView (CS)

-(void)whiteBorder
{
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
}
-(void)highlightBorder{
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor yellowColor].CGColor;
}

@end
