//
//  CSReusePicHeader.m
//  CSPP
//
//  Created by vivi wu on 2018/3/23.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import "CSReusePicHeader.h"
#import "VideoModel.h"
#import "UIImageView+WebCache.h"

@interface CSReusePicHeader()
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLab;
@end

@implementation CSReusePicHeader
- (IBAction)tapAction:(id)sender {
    if (self.tapBlock) {
        self.tapBlock();
    }
}

- (void)configeVideoModel:(VideoModel *)videoModel {
    self.descriptionLab.text = videoModel.VideoTitle;
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:videoModel.CoverURL.firstObject] placeholderImage:[UIImage imageNamed:@"goldengate"]];
}

@end
