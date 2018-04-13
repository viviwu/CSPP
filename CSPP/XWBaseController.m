//
//  XWBaseController.m
//  Touhu
//
//  Created by csco on 2018/4/12.
//  Copyright © 2018年 csco. All rights reserved.
//

#import "XWBaseController.h"

@implementation XWBaseController

@end

//@$$$$$$$$$$$$$$$$$$$$$$$$$$ $$$$$$$$$$$$$$$$$$$$$$$$$$

IB_DESIGNABLE
@implementation UIView(Base)
- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = cornerRadius > 0;
}
- (CGFloat)cornerRadius{
    return self.layer.cornerRadius;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)borderWidth{
    return self.layer.borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor{
    self.layer.borderColor = borderColor.CGColor;
}

- (UIColor *)borderColor{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

#pragma mark - hexRgbColor
- (void)setHexRgbColor:(NSString *)hexRgbColor{
    NSScanner *scanner = [NSScanner scannerWithString:hexRgbColor];
    unsigned hexNum;
    if (![scanner scanHexInt:&hexNum]) return;
    self.backgroundColor = [self colorWithRGBHex:hexNum];
}

- (UIColor *)colorWithRGBHex:(UInt32)hex {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}


- (NSString *)hexRgbColor{
    return @"0xffffff";
}

@end

//@$$$$$$$$$$$$$$$$$$$$$$$$$$ $$$$$$$$$$$$$$$$$$$$$$$$$$

@implementation UITableViewController(Base)

- (id)viewControllerFromStoryboard:(NSString*)stroyboardName{
    return [UIStoryboard storyboardWithName:stroyboardName bundle:nil].instantiateInitialViewController;
}

- (id)viewControllerFromStoryboard:(NSString*)stroyboardName identifier:(NSString*)identifier{
    return [[UIStoryboard storyboardWithName:stroyboardName bundle:nil] instantiateViewControllerWithIdentifier:identifier];
}

//- (id)consultStoryboardControllerWithID:(NSString*)stroyboardID{
//    return [[UIStoryboard storyboardWithName:@"PaidConsult" bundle:nil] instantiateViewControllerWithIdentifier:stroyboardID];
//}

@end

//@$$$$$$$$$$$$$$$$$$$$$$$$$$ $$$$$$$$$$$$$$$$$$$$$$$$$$

@implementation UIViewController(Base)
- (id)viewControllerFromStoryboard:(NSString*)stroyboardName{
    return [UIStoryboard storyboardWithName:stroyboardName bundle:nil].instantiateInitialViewController;
}

- (id)viewControllerFromStoryboard:(NSString*)stroyboardName identifier:(NSString*)identifier{
    return [[UIStoryboard storyboardWithName:stroyboardName bundle:nil] instantiateViewControllerWithIdentifier:identifier];
}

- (id)consultStoryboardControllerWithID:(NSString*)stroyboardID{
    return [[UIStoryboard storyboardWithName:@"PaidConsult" bundle:nil] instantiateViewControllerWithIdentifier:stroyboardID];
}

- (id)liveStoryboardControllerWithID:(NSString*)stroyboardID{
    return [[UIStoryboard storyboardWithName:@"LiveSpeech" bundle:nil] instantiateViewControllerWithIdentifier:stroyboardID];
}


@end



