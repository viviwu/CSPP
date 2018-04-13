//
//  CSTableFeedCell.h
//  CSPP
//
//  Created by vivi wu on 2018/3/21.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSMedia.h"
#import "NAKPlaybackIndicatorView.h"

@interface CSTableFeedCell : UITableViewCell

@property (strong, nonatomic) UILabel *timeLabel;
//@property (strong, nonatomic) UIImageView *typeIco;
@property (strong, nonatomic) UILabel *stateLabel;

@property (nonatomic, readonly) NAKPlaybackIndicatorView* playbackIndicatorView;

@property(nonatomic, assign) CSMediaType mediaType;

- (void)refreshWithData:(id)media;

@end
