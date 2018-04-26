//
//  XWBaseController.m
//  Touhu
//
//  Created by csco on 2018/4/12.
//  Copyright © 2018年 csco. All rights reserved.
//

#import "XWBaseController.h"

@implementation XWBaseController
- (void)computeSafeArea{
    
    UIEdgeInsets safeArea = UIEdgeInsetsZero;
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        safeArea = self.view.safeAreaInsets;
        _safeFrame = self.view.safeAreaLayoutGuide.layoutFrame;
        _safeTop = safeArea.top;
        _safeBottom = safeArea.bottom;
        _safeTop=64.0;
        if (kDevice_Is_iPhoneX) {
            _safeTop =88.0;
        }
    } else {
        // Fallback on earlier versions
    }
#endif
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.allowRotation = NO;
    
    //    self.view.backgroundColor = [UIColor lightGrayColor];
    // Do any additional setup after loading the view.
}

- (UIColor*)randomColor{
    int R = (arc4random() % 256) ;
    int G = (arc4random() % 256) ;
    int B = (arc4random() % 256) ;
    return KSYRGB(R, G, B);
}

-(id)readJsonFile:(NSString*)fileName{
    NSString * founds_path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    if (founds_path) {
        NSError * error = nil;
        NSData *data = [[NSData alloc] initWithContentsOfFile:founds_path];
        //        json = [jsonStr  stringByReplacingOccurrencesOfString:@":null" withString:@":\"\""];
        id jsonid = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (error) {
            NSLog(@"error==%@", error);
        }
        [NSDictionary changeType:jsonid];
        return jsonid;
    }else{
        NSLog(@"%@-->founds_path = %@", fileName, founds_path);
    }
    return nil;
}
@end

//@$$$$$$$$$$$$$$$$$$$$$$$$$$ $$$$$$$$$$$$$$$$$$$$$$$$$$

//IB_DESIGNABLE
@implementation UIView(Base)
/*
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
*/

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

- (id)salonStoryboardControllerWithID:(NSString*)stroyboardID{
    return [[UIStoryboard storyboardWithName:@"Salon" bundle:nil] instantiateViewControllerWithIdentifier:stroyboardID];
}


@end



