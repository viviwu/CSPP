//
//  CSTableMenuHeader.m
//  CSPP
//
//  Created by vivi wu on 2018/3/21.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import "CSTableMenuHeader.h"
@interface CSTableMenuHeader ()
@property (nonatomic, strong) DVVMovingTextView *movingTextView;
@end

@implementation CSTableMenuHeader

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (void)setMovingText
{
    if (!_movingTextView) {
        _movingTextView = [DVVMovingTextView new];
        [_movingTextView setFrame:self.newsScroll.bounds];
        [self.newsScroll addSubview:_movingTextView];
    }
    NSString * demo = @"摘要: 小米上市在即，Pre-IPO股权“一份难求”，估值暴涨。兜售小米老股的二道贩子们击鼓传花，层层套利，也有人破坏行规，想要赚一把棺材本。";
    _movingTextView.movingText = demo;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            _movingTextView.movingText = demo;
        });
    });
}

- (IBAction)datePickerAction:(UIButton *)sender {
    NSLog(@"A:%s", __func__);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

/*

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    <#code#>
}

+ (nonnull instancetype)appearance {
    <#code#>
}

+ (nonnull instancetype)appearanceForTraitCollection:(nonnull UITraitCollection *)trait {
    <#code#>
}

+ (nonnull instancetype)appearanceForTraitCollection:(nonnull UITraitCollection *)trait whenContainedIn:(nullable Class<UIAppearanceContainer>)ContainerClass, ... {
    <#code#>
}

+ (nonnull instancetype)appearanceForTraitCollection:(nonnull UITraitCollection *)trait whenContainedInInstancesOfClasses:(nonnull NSArray<Class<UIAppearanceContainer>> *)containerTypes {
    <#code#>
}

+ (nonnull instancetype)appearanceWhenContainedIn:(nullable Class<UIAppearanceContainer>)ContainerClass, ... {
    <#code#>
}

+ (nonnull instancetype)appearanceWhenContainedInInstancesOfClasses:(nonnull NSArray<Class<UIAppearanceContainer>> *)containerTypes {
    <#code#>
}

- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
    <#code#>
}

- (CGPoint)convertPoint:(CGPoint)point fromCoordinateSpace:(nonnull id<UICoordinateSpace>)coordinateSpace {
    <#code#>
}

- (CGPoint)convertPoint:(CGPoint)point toCoordinateSpace:(nonnull id<UICoordinateSpace>)coordinateSpace {
    <#code#>
}

- (CGRect)convertRect:(CGRect)rect fromCoordinateSpace:(nonnull id<UICoordinateSpace>)coordinateSpace {
    <#code#>
}

- (CGRect)convertRect:(CGRect)rect toCoordinateSpace:(nonnull id<UICoordinateSpace>)coordinateSpace {
    <#code#>
}

- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator {
    <#code#>
}

- (void)setNeedsFocusUpdate {
    <#code#>
}

- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context {
    <#code#>
}

- (void)updateFocusIfNeeded {
    <#code#>
}
*/



@end
