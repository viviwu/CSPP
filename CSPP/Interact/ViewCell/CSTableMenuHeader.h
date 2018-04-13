//
//  CSTableMenuHeader.h
//  CSPP
//
//  Created by vivi wu on 2018/3/21.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DVVMovingTextView.h"

@interface CSTableMenuHeader : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UICollectionView *ccollectionView;
@property (weak, nonatomic) IBOutlet UIButton *dateBtn;
@property (weak, nonatomic) IBOutlet UIView *newsScroll;

- (void)setMovingText;

- (IBAction)datePickerAction:(UIButton *)sender;

@end
