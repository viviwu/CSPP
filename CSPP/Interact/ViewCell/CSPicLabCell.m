//
//  CSPicLabCell.m
//  CSPP
//
//  Created by vivi wu on 2018/3/23.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import "CSPicLabCell.h"
#import "VideoModel.h"
#import "UIImageView+WebCache.h"

@interface CSPicLabCell()
@property (nonatomic, strong) VideoModel *videoModel;
@end

@implementation CSPicLabCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configeWithVideoModel:(VideoModel *)videoModel {
    self.videoModel = videoModel;
    NSLog(@"PlayURL = %@", videoModel.PlayURL.lastObject);
    self.titleLabel.text = videoModel.VideoTitle;
    //找到背景图片设置为空的地方
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:videoModel.CoverURL.lastObject] placeholderImage:[UIImage imageNamed:@"goldengate"]];
}

@end
