//
//  XWTouchPunctureView.m
//  XWTouchPunctureView
//
//  Created by vivi wu on 2018/1/13.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import "XWTouchPunctureView.h"

@implementation XWTouchPunctureView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    if ([self pointInside:point withEvent:event]) {
        UIView *hitView = [super hitTest:point withEvent:event];
        if (self == hitView) {
            if (self.touchPuncture) {
                return nil;
            }else{
                UIView * responderView = (UIView*)[self nextResponder];
                NSLog(@"responderView==%@", responderView);
                return responderView;
            }
        }else{
            NSLog(@"hitView==%@", hitView);
            return hitView;
        }
    }
    return nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
