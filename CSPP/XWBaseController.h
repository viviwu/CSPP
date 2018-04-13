//
//  XWBaseController.h
//  Touhu
//
//  Created by csco on 2018/4/12.
//  Copyright © 2018年 csco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XWBaseController : NSObject

@end

//@$$$$$$$$$$$$$$$$$$$$$$$$$$ $$$$$$$$$$$$$$$$$$$$$$$$$$

@interface UIView(Base)

/*
@property (assign,nonatomic) IBInspectable CGFloat cornerRadius;
@property (assign,nonatomic) IBInspectable CGFloat borderWidth;
@property (strong,nonatomic) IBInspectable UIColor  *borderColor;
// set background hex color
@property (assign,nonatomic) IBInspectable NSString *hexRgbColor; 
*/

@end

//@$$$$$$$$$$$$$$$$$$$$$$$$$$ $$$$$$$$$$$$$$$$$$$$$$$$$$

@interface UITableViewController(Base)

- (id)viewControllerFromStoryboard:(NSString*)stroyboardName;

- (id)viewControllerFromStoryboard:(NSString*)stroyboardName identifier:(NSString*)identifier;
//- (id)consultStoryboardControllerWithID:(NSString*)stroyboardID;

@end

//@$$$$$$$$$$$$$$$$$$$$$$$$$$ $$$$$$$$$$$$$$$$$$$$$$$$$$

@interface UIViewController(Base)

- (id)viewControllerFromStoryboard:(NSString*)stroyboardName;

- (id)viewControllerFromStoryboard:(NSString*)stroyboardName identifier:(NSString*)identifier;
- (id)consultStoryboardControllerWithID:(NSString*)stroyboardID;
- (id)liveStoryboardControllerWithID:(NSString*)stroyboardID;
- (id)salonStoryboardControllerWithID:(NSString*)stroyboardID;


@end
