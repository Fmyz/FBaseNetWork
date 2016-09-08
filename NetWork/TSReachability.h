//
//  TSReachability.h
//  YueZhai
//
//  Created by Fmyz on 16/8/12.
//  Copyright © 2016年 Fmyz. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TS_NetworkReachabilityStatus) {
    TS_NetworkReachabilityStatusUnknown          = -1,
    TS_NetworkReachabilityStatusNotReachable     = 0,
    TS_NetworkReachabilityStatusReachableViaWWAN = 1,
    TS_NetworkReachabilityStatusReachableViaWiFi = 2,
};

//封装一层，如果以后需要更换的话方便
@interface TSReachability : NSObject

/**
 The current network reachability status.
 */
@property (readonly, nonatomic, assign) TS_NetworkReachabilityStatus networkReachabilityStatus;

/**
 Whether or not the network is currently reachable.
 */
@property (readonly, nonatomic, assign, getter = isReachable) BOOL reachable;

/**
 Whether or not the network is currently reachable via WWAN.
 */
@property (readonly, nonatomic, assign, getter = isReachableViaWWAN) BOOL reachableViaWWAN;

/**
 Whether or not the network is currently reachable via WiFi.
 */
@property (readonly, nonatomic, assign, getter = isReachableViaWiFi) BOOL reachableViaWiFi;

+ (instancetype)share;

@property (assign, nonatomic) BOOL isStarting;
- (void)startReachabilityWithChangeBlock:(void (^)(TS_NetworkReachabilityStatus status))changeBlock;

- (void)stopReachability;

@end