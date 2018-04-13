//
//  XWScrollBanner.h
//  XWScrollBanner
//
//  Created by vivi wu on 2014/11/4.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWBanner.h"

#define scrollRepeat 100

typedef void(^XWBannerClickHandle)(NSInteger, XWBannerModel *);

@interface XWScrollBanner : UIView

@property (nonatomic, assign) NSTimeInterval scrollInterval;//default is 2.0s
@property (nonatomic, copy) NSArray <XWBannerModel *>* dataSource;
@property (nonatomic, copy) XWBannerClickHandle bannerClickHandle;

- (instancetype)initWithFrame:(CGRect)frame;

- (instancetype)initWithFrame:(CGRect)frame
                   dataSource:(NSArray*)dataSource;

- (void)startTimer;
- (void)stopTimer;

@end


//这个东西实现方式有很多种，ScrollView、 TableView，CollectionView 都可以的；建议是TableView和CollectionView，毕竟复用了cell，比较方便，条目多了内存控制也好。
