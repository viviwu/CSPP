//
//  XWFilterView.h
//  XWScrollBanner
//
//  Created by csco on 2018/4/13.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWFilterCell.h"

typedef void(^XWSingleSelectHandle)(NSIndexPath *, NSString *);
typedef void(^XWMultiSelectHandle)(NSArray *);

@interface XWFilterView : UIView

@property (nonatomic, copy) NSArray* dataSource;
@property (nonatomic, copy) XWSingleSelectHandle selectHandle;
@property (nonatomic, copy) XWMultiSelectHandle multiResulter;

- (instancetype)initWithFrame:(CGRect)frame;

- (instancetype)initWithFrame:(CGRect)frame
                   dataSource:(NSArray*)dataSource;

@end
