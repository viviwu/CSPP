//
//  XWFilterCell.m
//  XWScrollBanner
//
//  Created by csco on 2018/4/13.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import "XWFilterCell.h"

@implementation XWFilter

- (id)init{
    self= [super init];
    if (self) {
        _title = @"Ω≈ç√∫˜µ˜";
        _selected = NO;
        _sectionTitle = @"";
    }
    return self;
}

@end

@interface XWFilterCell ()

@property (nonatomic, strong) UILabel * titlelabel;

@end

@implementation XWFilterCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor  = [UIColor whiteColor];
        [self addSubview:self.titlelabel];
    }
    return self;
}
- (UILabel *)titlelabel{
    if (nil==_titlelabel) {
        _titlelabel = [[UILabel alloc]initWithFrame:self.bounds];
    }
    return _titlelabel;
}

- (void)refreshModel:(XWFilter*)model
{
    self.filter = model;
    _titlelabel.text = model.title;
    if (model.selected) {
        self.titlelabel.layer.borderColor = [UIColor redColor].CGColor;
        self.titlelabel.layer.borderWidth = 1.0;
        self.titlelabel.layer.cornerRadius = 8.0;
    }else{
        //        self.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor whiteColor]);
        self.titlelabel.layer.borderWidth = 0;
        //        self.layer.cornerRadius = 4.0;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _titlelabel.textAlignment = NSTextAlignmentCenter;
    
    [self setNeedsDisplay];
    //    self.imgView.contentMode = UIViewContentModeScaleToFill;
}

//- (void)drawRect:(CGRect)rect
//{
//    [super drawRect:rect];
//}

//- (void)setSelected:(BOOL)selected{
//
//}


@end

//ΩΩΩzΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩzΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩzΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩΩ

@interface XWFilterSectionHeader()

@property (nonatomic, strong) UILabel * titlelabel;

@end

@implementation XWFilterSectionHeader
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //        self.backgroundColor  = [UIColor whiteColor];
        [self addSubview:self.titlelabel];
    }
    return self;
}
- (UILabel *)titlelabel{
    if (nil==_titlelabel) {
        _titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(10.0, 0, self.bounds.size.width-20.0, self.bounds.size.height)];
    }
    return _titlelabel;
}

- (void)refreshModel:(XWFilter*)model
{
    self.filter = model;
    _titlelabel.text = model.sectionTitle;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _titlelabel.textAlignment = NSTextAlignmentLeft;
    //    self.imgView.contentMode = UIViewContentModeScaleToFill;
}



@end

