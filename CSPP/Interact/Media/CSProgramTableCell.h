//
//  CSProgramTableCell.h
//  CSInvest
//
//  Created by vivi wu on 2018/3/19.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSMedia.h"

@interface CSProgramTableCell : UITableViewCell

@property (strong, nonatomic) UILabel *timeLabel;
//@property (strong, nonatomic) UIImageView *typeIco;
@property (strong, nonatomic) UILabel *stateLabel;
@property(nonatomic, assign) CSMediaType mediaType;

- (void)refreshWithData:(id)media;

@end
