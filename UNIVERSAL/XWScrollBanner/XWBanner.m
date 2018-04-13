//
//  XWBanner.m
//  XWScrollBanner
//
//  Created by vivi wu on 2014/11/4.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import "XWBanner.h"
#import <UIImageView+WebCache.h>

@implementation XWBannerModel

@end


@interface XWBanner ()

@property (nonatomic, strong)UIImageView * imgView;
@property (nonatomic, strong)UILabel * titlelabel;

@end

@implementation XWBanner

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imgView];
        [self addSubview:self.titlelabel];
    }
    return self;
}

- (UIImageView *)imgView{
    if (nil==_imgView) {
        _imgView =[[UIImageView alloc]initWithFrame:self.bounds];
    }
    return _imgView;
}

- (UILabel *)titlelabel{
    if (nil==_titlelabel) {
        _titlelabel = [[UILabel alloc]initWithFrame:self.bounds];
    }
    return _titlelabel;
}

- (void)setModel:(XWBannerModel *)model
{
    _model = model;
    UIImage *placeholderImage = [UIImage imageNamed:model.imgName];
    if (model.imgURL) {
        [self.imgView sd_setImageWithURL:model.imgURL placeholderImage:placeholderImage];
    }else if(model.imgName){
        self.imgView.image = placeholderImage;
    }
    self.titlelabel.text = model.title;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.imgView setFrame:self.bounds];
//    self.imgView.contentMode = UIViewContentModeScaleToFill;
}

@end
