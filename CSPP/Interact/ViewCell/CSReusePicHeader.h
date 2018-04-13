//
//  CSReusePicHeader.h
//  CSPP
//
//  Created by vivi wu on 2018/3/23.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoModel;

@interface CSReusePicHeader : UICollectionReusableView

@property (nonatomic, copy) void(^tapBlock)(void);

- (void)configeVideoModel:(VideoModel *)videoModel;

@end
