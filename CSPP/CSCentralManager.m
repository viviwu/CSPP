//
//  CSCentralManager.m
//  CSPP
//
//  Created by vivi wu on 2018/3/26.
//  Copyright © 2018年 vivi wu. All rights reserved.
//

#import "CSCentralManager.h"


static CSCentralManager * instance = nil;
@implementation CSCentralManager

+ (instancetype)instance
{
    @synchronized(instance){
        if (nil==instance) {
            instance = [[CSCentralManager alloc]init];
        }
    }
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) { 
        
    }
    return self;
}



@end
