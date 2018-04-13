//
//  CSMenuCell.m
//  CSPP
//
//  Created by vivi wu on 2018/3/21.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import "CSMenuCell.h"

@implementation CSMenuCell

- (void)refreshData:(NSArray*)data
{
    _textLabel.text = data.firstObject;
    _imageView.image = [UIImage imageNamed:data.lastObject];
    
}

@end
