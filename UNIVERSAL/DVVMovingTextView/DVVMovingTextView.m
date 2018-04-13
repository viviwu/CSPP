//
//  DVVMovingTextView.m
//  DVVMovingTextView <https://github.com/devdawei/DVVMovingTextView.git>
//
//  Created by 大威 on 16/6/16.
//  Copyright © 2016年 devdawei. All rights reserved.
//

#import "DVVMovingTextView.h"

@interface DVVMovingTextView ()

/** dispatch source */
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, assign) BOOL isNeedLayout;

@end

@implementation DVVMovingTextView

#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        
        [self addSubview:self.movingLabel];
        
        // 获取全局队列
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        // 实例化 dispatch source
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        // 设置 dispatch source
        dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 0.01 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        __weak typeof(self) weakSelf = self;
        // 设置 dispatch source 事件处理
        dispatch_source_set_event_handler(_timer, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf moving];
            });
        });
        // 开启 dispatch source
        dispatch_resume(_timer);
        
//        _movingLabel.backgroundColor = [UIColor orangeColor];
    }
    return self;
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!_isNeedLayout) return;
    
    [self resetMovingLabelFrame];
}

#pragma mark - Setter getter

- (void)setMovingText:(NSString *)movingText
{
    _movingText = movingText;
    _movingLabel.text = movingText;
    
    CGSize size = self.bounds.size;
    if (0 != size.width &&
        0 != size.height)
    {
        [self resetMovingLabelFrame];
    }
    else
    {
        _isNeedLayout = YES;
    }
}

#pragma mark - UI

- (void)resetMovingLabelFrame
{
    CGSize size = self.bounds.size;
    CGFloat width = [DVVMovingTextView widthWithString:_movingLabel.text font:_movingLabel.font];
//    NSLog(@"widht = %f", width);
    _movingLabel.frame = CGRectMake(size.width, 0, width, size.height);
}

#pragma mark -
#pragma mark 一串字符在一行中正常显示所需要的宽度
+ (CGFloat)widthWithString:(NSString *)string
                      font:(UIFont *)font
{
    if (!string || !string.length || !font) return 0;
    
    CGSize size = CGSizeMake(MAXFLOAT, font.lineHeight);
    NSDictionary *dict = @{ NSFontAttributeName: font };
    CGFloat width = [string boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:dict context:nil].size.width;
    return width;
}

#pragma mark - Moving

- (void)moving
{
    if (!_movingText.length) return;
    CGRect frame = _movingLabel.frame;
//    NSLog(@"%f", fabsf((float)(frame.origin.x)));
    if (frame.origin.x < 0 &&
        fabsf((float)(frame.origin.x)) > frame.size.width)
    {
        frame.origin.x = self.bounds.size.width;
    }
    else
    {
        frame.origin.x -= 1;
    }
    _movingLabel.frame = frame;
}

#pragma mark - Lazy load

- (UILabel *)movingLabel
{
    if (!_movingLabel) {
        _movingLabel = [UILabel new];
        _movingLabel.font = [UIFont systemFontOfSize:14];
        _movingLabel.textColor = [UIColor redColor];
    }
    return _movingLabel;
}

#pragma mark - Dealloc

- (void)dealloc
{
    if (_timer) dispatch_source_cancel(_timer);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
