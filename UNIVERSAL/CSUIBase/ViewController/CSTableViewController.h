//
//  CSTableViewController.h
//  CSFinance
//
//  Created by vivi wu on 2018/2/23.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSTableViewController : UITableViewController

@property (nonatomic, assign) CGRect safeFrame;
@property (nonatomic, assign) CGFloat safeTop;

- (void)computeSafeArea;

-(id)readJsonFile:(NSString*)fileName;

@end
