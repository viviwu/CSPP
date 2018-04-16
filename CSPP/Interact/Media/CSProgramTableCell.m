//
//  CSProgramTableCell.m
//  CSInvest
//
//  Created by vivi wu on 2018/3/19.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import "CSProgramTableCell.h"

#define kTimeW kSelfW*0.2
#define kTitleW (kSelfW-kTimeW-10.0)*1.0

@implementation CSProgramTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        if (!_timeLabel) {
            _timeLabel = [self instanceNewLabel];
        }
        if (!_stateLabel) {
            _stateLabel = [self instanceNewLabel];
        }
        self.imageView.image=[UIImage imageNamed:@"film_reel"];
        self.timeLabel.text = @"20:30";
        self.textLabel.numberOfLines = 0;
        self.textLabel.text = @"对话：CDR对中国股市的影响###";
        self.detailTextLabel.text = @"嘉宾：XXX";
        self.stateLabel.text = @"13625人关注";
        
        self.detailTextLabel.textColor = UIColor.darkGrayColor;
        self.timeLabel.textColor = UIColor.orangeColor;
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        self.stateLabel.textAlignment = NSTextAlignmentCenter;
        self.stateLabel.textColor = UIColor.orangeColor;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.timeLabel.frame = CGRectMake(5.0, 0, kTimeW, kSelfH*0.6);
    self.stateLabel.frame = CGRectMake(5.0, kSelfH*0.6, kTimeW, kSelfH*0.4);
    CGFloat imgX = 5.0 + kTimeW;
    if (CSMediaTypeVideo== _mediaType || CSMediaTypeLive==_mediaType) {
        self.timeLabel.font = [UIFont systemFontOfSize:24.0];
        self.textLabel.font = [UIFont systemFontOfSize:18.0];
        self.textLabel.textColor = UIColor.yellowColor;
        self.detailTextLabel.textColor = UIColor.yellowColor;
        
        self.textLabel.frame = CGRectMake(imgX, 0, kTitleW, kSelfH*0.3);
        self.detailTextLabel.frame = CGRectMake(imgX, kSelfH*0.7, kTitleW, kSelfH*0.25);
        self.imageView.frame = CGRectMake(imgX, 0, kTitleW, kSelfH-5.0);
    }else{
        self.timeLabel.font = [UIFont systemFontOfSize:18.0];
        self.textLabel.font = [UIFont systemFontOfSize:16.0];
        self.textLabel.textColor = UIColor.blackColor;
        self.detailTextLabel.textColor = UIColor.darkGrayColor;
        
        CGFloat imgW = 35.0, textW = kSelfW-kTimeW-imgW-5.0;
        self.textLabel.frame = CGRectMake(imgX, 0, textW, kSelfH*0.7);
        self.detailTextLabel.frame = CGRectMake(imgX, kSelfH*0.7, textW, kSelfH*0.3);
        self.imageView.frame = CGRectMake(kSelfW-imgW-2.5, (kSelfH-imgW)/2, imgW, imgW);
    }
}

- (void)refreshWithData:(CSMedia*)media
{
    _mediaType = media.mediaType;
    self.textLabel.text = media.title;
    self.detailTextLabel.text  =media.author;
    
    NSDate *date = media.date; //[NSDate date];
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
//            self.imageView.image = [UIImage imageNamed:@"film_reel"];//goldengate
            self.imageView.image = [UIImage imageNamed:@"goldengate"];
            break;
        case CSMediaTypeAudio:
            self.imageView.image = [UIImage imageNamed:@"headset"];
            break;
        case CSMediaTypeLive:
            self.imageView.image = [UIImage imageNamed:@"reading"];
            break;
        case CSMediaTypeOthers:
            self.imageView.image = [UIImage imageNamed:@"rules"];
            break;
            
        default:
            break;
    }
    
}

- (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
