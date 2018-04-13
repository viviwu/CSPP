//
//  XWBanner.h
//  XWScrollBanner
//
//  Created by vivi wu on 2014/11/4.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface XWBannerModel:NSObject

@property (nonatomic, copy) NSURL * imgURL;
@property (nonatomic, copy) NSString * imgName;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * link;
@end
 

@interface XWBanner : UICollectionViewCell

@property (nonatomic, strong) XWBannerModel * model;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)setModel:(XWBannerModel *)model;



@end
