//
//  CSMedia.h
//  CSInvest
//
//  Created by vivi wu on 2018/3/16.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CSMediaType) {
    CSMediaTypeVideo=0, //voidVideo
    CSMediaTypeAudio,   //audioText
    CSMediaTypeLive,    //liveVideo
    CSMediaTypeOthers
};

@interface CSMedia : NSObject

@property(nonatomic, copy)NSString * title;
@property(nonatomic, copy)NSString * theme_id;//节目主题类型
@property(nonatomic, copy)NSString * schema;
@property(nonatomic, copy)NSString * author;
@property(nonatomic, copy)NSString * imgUrl;
@property(nonatomic, copy)NSString * linkUrl;
@property(nonatomic, copy)NSString * resourceUrl;
@property(nonatomic, copy)NSDate * date;
@property(nonatomic, assign)NSInteger heat;
@property(nonatomic, assign)CSMediaType mediaType;
@property(nonatomic, assign)BOOL published;
@end
