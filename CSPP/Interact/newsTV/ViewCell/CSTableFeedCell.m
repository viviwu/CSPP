//
//  CSTableFeedCell.m
//  CSPP
//
//  Created by vivi wu on 2018/3/21.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import "CSTableFeedCell.h"


#define timeLab_W 55.0
#define imgSize 40.0
#define kStartX (timeLab_W + imgSize +5.0)*1.0
#define titleLab_W (kSelfW - kStartX)*1.0

@interface CSTableFeedCell()
@property(nonatomic, assign) NAKPlaybackIndicatorViewState state;
@end

@implementation CSTableFeedCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if(self){
        [self setUpSubviews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUpSubviews];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUpSubviews];
    // Initialization code
}

- (void)setUpSubviews{
    if (!_timeLabel) {
        _timeLabel = [self instanceNewLabel];
    }
    if (!_stateLabel) {
        _stateLabel = [self instanceNewLabel];
    }
    if (!_playbackIndicatorView) {
        _playbackIndicatorView = [[NAKPlaybackIndicatorView alloc] initWithStyle:[NAKPlaybackIndicatorViewStyle iOS10Style]];
        [self.contentView addSubview:_playbackIndicatorView];
    }
    self.imageView.image=[UIImage imageNamed:@"film_reel"];
    self.timeLabel.text = @"20:30";
    self.textLabel.text = @"对话：CDR对中国股市的影响###";
    self.textLabel.numberOfLines = 0;
    self.detailTextLabel.text = @"嘉宾：XXX";
    self.stateLabel.text = @"13625人关注";
    
    self.detailTextLabel.textColor = UIColor.darkGrayColor;
    self.timeLabel.textColor = UIColor.orangeColor;
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.stateLabel.textAlignment = NSTextAlignmentCenter;
    self.stateLabel.textColor = UIColor.orangeColor;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.state = NAKPlaybackIndicatorViewStateStopped;
}
- (NAKPlaybackIndicatorViewState)state
{
    return self.playbackIndicatorView.state;
}
- (void)setState:(NAKPlaybackIndicatorViewState)state
{
    self.playbackIndicatorView.state = state;
    self.imageView.hidden = (state != NAKPlaybackIndicatorViewStateStopped);
    self.playbackIndicatorView.hidden = !self.imageView.hidden;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.timeLabel.frame = CGRectMake(0, 0, timeLab_W, kSelfH);
    CGFloat imgTop = (kSelfH - imgSize)*0.5;
    self.imageView.frame = CGRectMake(timeLab_W, imgTop, imgSize, imgSize);
    self.textLabel.frame = CGRectMake(kStartX, 0, titleLab_W, kSelfH*0.6);
    self.detailTextLabel.frame = CGRectMake(kStartX, kSelfH*0.6, titleLab_W*0.5, kSelfH*0.4);
    self.stateLabel.frame = CGRectMake(kStartX+titleLab_W*0.5, kSelfH*0.6, titleLab_W*0.5, kSelfH*0.4);
    self.playbackIndicatorView.frame = self.imageView.frame;
}

- (void)refreshWithData:(CSMedia*)media
{
    self.textLabel.text = media.title?:@"textLabel";
    self.detailTextLabel.text  =media.author?:@"detailTextLabel";
    
    NSDate *date = media.date?:[NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    self.timeLabel.text = [self stringFromDate:localeDate];
    
    if (media.published) {
        self.stateLabel.textColor = [UIColor orangeColor];
        self.timeLabel.textColor = [UIColor orangeColor];
        self.stateLabel.text= [NSString stringWithFormat:@"%ld关注", (long)media.heat];
    }else{
        self.stateLabel.textColor = [UIColor greenColor];
        self.timeLabel.textColor = [UIColor greenColor];
        self.stateLabel.text= @"敬请期待";
    }
    switch (media.mediaType) {
        case CSMediaTypeVideo:
            self.imageView.image = [UIImage imageNamed:@"film_reel"];
            break;
        case CSMediaTypeAudio:
            self.imageView.image = [UIImage imageNamed:@"headset"];
            break;
        case CSMediaTypeLive:
            self.imageView.image = [UIImage imageNamed:@"webcam"];
            break;
        case CSMediaTypeOthers:
            self.imageView.image = [UIImage imageNamed:@"rules"];
            break;
            
        default:
            break;
    }
    
}

- (void)drawRect:(CGRect)rect
{
    UIColor *color = [UIColor lightGrayColor];
    [color set]; //设置线条颜色
    
    UIBezierPath* aPath = [UIBezierPath bezierPath];
    aPath.lineWidth = 1.0;
    aPath.lineCapStyle = kCGLineCapRound; //线条拐角
    aPath.lineJoinStyle = kCGLineCapRound; //终点处理
    
    CGFloat R = 8.0;
    // Set the starting point of the shape.
    [aPath moveToPoint:CGPointMake(timeLab_W, 0.0)];
    [aPath addLineToPoint:CGPointMake(timeLab_W, kSelfH/2-R)];
    [aPath addQuadCurveToPoint:CGPointMake(timeLab_W, kSelfH/2+R) controlPoint:CGPointMake(timeLab_W-R, kSelfH/2)];
//    [aPath moveToPoint:CGPointMake(timeLab_W, kSelfH/2+R)];
    [aPath addLineToPoint:CGPointMake(timeLab_W, kSelfH)];
    
    [aPath moveToPoint:CGPointMake(kStartX, 0.0)];
    [aPath addLineToPoint:CGPointMake(kSelfW, 0.0)];
    
    [aPath moveToPoint:CGPointMake(kStartX, kSelfH)];
    [aPath addLineToPoint:CGPointMake(kSelfW, kSelfH)];
    
    //    [aPath closePath];
    [aPath stroke];//Draws line
    
    [super drawRect:rect];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.state = !self.state;
    // Configure the view for the selected state
}


- (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
    
}


-(UILabel*)instanceNewLabel{
    
    UILabel * la = UILabel.new;
    la.textColor = UIColor.blackColor;
    la.text = @"*^*";
    la.font =  [UIFont systemFontOfSize:14.0];
    la.textAlignment = NSTextAlignmentLeft;
    la.numberOfLines = 0;
    la.lineBreakMode = NSLineBreakByCharWrapping;
    [self.contentView addSubview: la];
    return la;
}


@end
