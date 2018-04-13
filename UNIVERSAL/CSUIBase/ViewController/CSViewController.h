//
//  CSViewController.h
//  CSFinance
//
//  Created by vivi wu on 2018/2/23.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "Constant.h"

@interface CSViewController : UIViewController



- (void)computeSafeArea;
 
- (CGFloat)safeTop;
- (CGFloat)safeBottom;

- (UIColor*)randomColor;

-(id)readJsonFile:(NSString*)fileName;

@end
