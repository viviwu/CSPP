//
//  CSMenuCell.h
//  CSPP
//
//  Created by vivi wu on 2018/3/21.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSMenuCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

- (void)refreshData:(id)data;

@end
