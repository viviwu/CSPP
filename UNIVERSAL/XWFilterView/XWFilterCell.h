//
//  XWFilterCell.h
//  XWScrollBanner
//
//  Created by csco on 2018/4/13.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XWFilter:NSObject

@property (nonatomic, copy) NSString * title;
@property (nonatomic, assign) BOOL selected;

@property (nonatomic, copy) NSString * sectionTitle;

@end

@interface XWFilterCell : UICollectionViewCell
@property(nonatomic, strong) XWFilter * filter;

- (void)refreshModel:(id)model; 

@end

@interface XWFilterSectionHeader : UICollectionReusableView

@property(nonatomic, strong) XWFilter * filter;

- (void)refreshModel:(id)model;

@end

