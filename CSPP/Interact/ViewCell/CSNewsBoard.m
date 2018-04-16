//
//  CSNewsBoard.m
//  CSPP
//
//  Created by vivi wu on 2018/3/22.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import "CSNewsBoard.h"

#import "JXTProgressLabel.h"
#import "XWTypewriterView.h"


@interface CSNewsBoard()

@property(nonatomic, strong)JXTProgressLabel * progressLabel;
@property(nonatomic, strong)XWTypewriterView * typewriterView;

@end

@implementation CSNewsBoard

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)setMedia:(CSMedia *)media
{
    _media = media;
    if (0 == media.mediaType) {
        
    }else if (1 == media.mediaType) {
        
    }else if (2 == media.mediaType) {
        
    }else if (3 == media.mediaType) {
        [self bringSubviewToFront:self.typewriterView];
        [self.typewriterView printMessage:kdemoMsg inDuration:30.0];
    }else{
        
    }
}

#pragma mark-- XWTypewriterView ##############################

- (XWTypewriterView *)typewriterView{
    if (!_typewriterView) {
        XWTypewriterView * imv = [[XWTypewriterView alloc] initWithFrame:self.bounds];
        [self addSubview:imv];
        _typewriterView = imv;
    }
    [_typewriterView cleanUpEverything];
    
    return _typewriterView;
}



- (void)preparePlay{
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(/*延迟执行时间*/1.0 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        //UI task
        NSTimeInterval period = 1.0; //设置时间间隔
        dispatch_queue_t queue = dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create( DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{    //在这里执行事件
            static BOOL flag;
            if (!flag) {
                _progressLabel.clipWidth ++;
                if (_progressLabel.clipWidth > _progressLabel.frame.size.width) {
                    flag = !flag;
                }
            }else {
                _progressLabel.clipWidth --;
                if (_progressLabel.clipWidth == 0) {
                    flag = !flag;
                }
            }
        });
        dispatch_resume(_timer);
    });
}

+ (CSMedia*)demoTextNews{
    CSMedia * media = [[CSMedia alloc]init];
    media.mediaType = CSMediaTypeLive;
    media.title =@"摘要: 小米上市在即，Pre-IPO股权“一份难求”，估值暴涨。兜售小米老股的二道贩子们击鼓传花，层层套利，也有人破坏行规，想要赚一把棺材本。";
    media.schema = @"小米IPO成为当下最热门的话题之一，它让外界对小米的关注和议论达到前所未有的高度，超越其成立八年来的任何时候。 尽管小米官方对上市一直闪烁其词，但这起备受瞩目的IPO似乎已经板上钉钉。 证监会和港交所也顺带因小米的上市传闻轮番占据媒体财经版面；各种各样的开曼基金和财富管理机构无论手里是否真的拿到了份额，都在疯狂兜售这家公司Pre-IPO的老股权，在他们的募资PPT里，小米估值也从450亿美元炒到1000亿美元甚至2000亿美元，每一次估值拉高都意味着新的赚钱机会。";
    return media;
}

/*
- (JXTProgressLabel * )progressLabel{
    if (!_progressLabel) {
        _progressLabel = [[JXTProgressLabel alloc] initWithFrame:self.frame];
        _progressLabel.backgroundColor = [UIColor blackColor];
        _progressLabel.backgroundTextColor = [UIColor whiteColor];
        _progressLabel.foregroundTextColor = [UIColor yellowColor];
        _progressLabel.text = kdemoMsg;
        _progressLabel.textAlignment = NSTextAlignmentLeft;
        _progressLabel.font = [UIFont systemFontOfSize:20];
        _progressLabel.clipWidth = kSelfW-20.0;
    }
    [self addSubview:_progressLabel];
    return _progressLabel;
}
*/

@end
