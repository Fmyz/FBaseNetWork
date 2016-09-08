//
//  TSReachability.m
//  YueZhai
//
//  Created by Fmyz on 16/8/12.
//  Copyright © 2016年 Fmyz. All rights reserved.
//

#import "TSReachability.h"

#import "AFNetworking.h"

@interface TSReachability ()

@property (readwrite, nonatomic, assign) TS_NetworkReachabilityStatus networkReachabilityStatus;

@end


@implementation TSReachability

+ (instancetype)share
{
    static TSReachability *reachability = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!reachability) {
            reachability = [[TSReachability alloc] init];
        }
    });
    return reachability;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.networkReachabilityStatus = TS_NetworkReachabilityStatusUnknown;
    }
    return self;
}

- (void)startReachabilityWithChangeBlock:(void (^)(TS_NetworkReachabilityStatus status))changeBlock
{
    self.isStarting = YES;
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        TS_NetworkReachabilityStatus TS_Status = (TS_NetworkReachabilityStatus)status;
        if (self.networkReachabilityStatus != TS_Status) {
            self.networkReachabilityStatus = TS_Status;
            if (changeBlock) {
                changeBlock(TS_Status);
            }
        }
    }];
}

- (void)stopReachability
{
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

- (BOOL)isReachable {
    return [self isReachableViaWWAN] || [self isReachableViaWiFi];
}

- (BOOL)isReachableViaWWAN {
    return self.networkReachabilityStatus == TS_NetworkReachabilityStatusReachableViaWWAN;
}

- (BOOL)isReachableViaWiFi {
    return self.networkReachabilityStatus == TS_NetworkReachabilityStatusReachableViaWiFi;
}

@end