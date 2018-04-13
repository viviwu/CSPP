//
//  UIView+XW.m
//  ideaPod
//
//  Created by viviwu on 2017/2/21.
//  Copyright © 2017年 viviwu. All rights reserved.
//

#import "UIView+XW.h"


@implementation UIView (XW)

@dynamic borderWidth, borderColor, cornerRadius;

/**
 * 设置边框宽度
 *
 */
- (void)setBorderWidth:(CGFloat)borderWidth
{
  if(borderWidth <0) return;
  self.layer.borderWidth = borderWidth;
}

/**
 * 设置边框颜色
 */
- (void)setBorderColor:(UIColor *)borderColor
{
  self.layer.borderColor = borderColor.CGColor;
}

/**
 *  设置圆角
 */
- (void)setCornerRadius:(CGFloat)cornerRadius
{
  self.layer.cornerRadius = cornerRadius;
  self.layer.masksToBounds = cornerRadius >0;
}

@end
