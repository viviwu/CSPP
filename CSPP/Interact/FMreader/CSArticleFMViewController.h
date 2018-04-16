//
//  CSArticleFMViewController.h
//  CSInvest
//
//  Created by vivi wu on 2018/3/20.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "IFlyMSC/IFlyMSC.h"
#import "PcmPlayer.h"

@class AlertView;
@class PopupView;
@class IFlySpeechSynthesizer;

typedef NS_OPTIONS(NSInteger, SynthesizeType) {
    NomalType           = 5,    //Normal TTS
    UriType             = 6,    //URI TTS
};

//state of TTS
typedef NS_OPTIONS(NSInteger, Status) {
    NotStart            = 0,
    Playing             = 2,
    Paused              = 4,
};

/*
 demo of Text-to-Speech (TTS)
 
 Text-to-Speech has two work modes:
 1.Normal TTS: Playing While synthesizing;
 2.URI TTS   : Not Playing While synthesizing;
 */
@interface CSArticleFMViewController : UIViewController <IFlySpeechSynthesizerDelegate>

@property (nonatomic, strong) IFlySpeechSynthesizer * iFlySpeechSynthesizer;

@property (nonatomic, strong) PopupView *popUpView;
@property (nonatomic, strong) AlertView *inidicateView;

@property (nonatomic, assign) BOOL isCanceled;
@property (nonatomic, assign) BOOL hasError;
@property (nonatomic, assign) BOOL isViewDidDisappear;


@property (nonatomic, strong) NSString *uriPath;
@property (nonatomic, strong) PcmPlayer *audioPlayer;

@property (nonatomic, assign) Status state;
@property (nonatomic, assign) SynthesizeType synType;

@property (strong, nonatomic) UITextView *textView;
//@property (strong, nonatomic) UIButton *startSynthesizeBtn;
//@property (strong, nonatomic) UIButton *cancelSynthesizeBtn;
//@property (strong, nonatomic) UIButton *uriSynthesizeBtn;
//@property (strong, nonatomic) UIButton *clearTextBtn;
//@property (strong, nonatomic) UIButton *pauseSynthesizeBtn;
//@property (strong, nonatomic) UIButton *resumeSynthesizeBtn;


@end 

#define textSample @"世纪证券前身是江西证券，是在中国人民银行和中国证监会的直接领导下重组而成的一家全国性综合类证券公司，由北京首都旅游集团有限责任公司等12家颇具实力和社会影响力的大型企业出资成立。公司总部设在深圳，注册资金10.05亿元人民币，下辖北京、上海、深圳、成都、南昌5个业务总部，拥有21家营业部，经营网络遍布全国各大、中城市。简介  公司的经营范围包括：证券经纪；证券投资咨询；与证券交易、证券投资活动有关的财 务顾问；证券承销；证券投资基金代销；证券自营；证券资产管理；证券保荐；中国证监会批准的其他业务。公司以雄厚的资金实力、一流的人才队伍、丰富的专业经验、稳健的经营作风为广大投资者和机构客户提供全方位的专业证券服务。 历经多年的发展，公司培养和造就了一支高素质的骨干员工队伍，公司现有员工1600余人。 面对全球化背景下资本市场的机遇与挑战，公司坚持“合规经营、稳健发展”的经营思想，不断改革创新，努力提升公司的核心竞争力，为建设和谐社会、促进证券市场健康发展贡献新的力量。"
