//
//  DVVMovingTextView.h
//  DVVMovingTextView <https://github.com/devdawei/DVVMovingTextView.git>
//
//  Created by 大威 on 16/6/16.
//  Copyright © 2016年 devdawei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DVVMovingTextView : UIView

/** 设置显示的文本 */
@property (nonatomic, copy) NSString *movingText;
/** 这个标签用于滚动显示文字 */
@property (nonatomic, strong) UILabel *movingLabel;

@end
