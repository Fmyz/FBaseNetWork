//
//  TSBaseJsonRequest.h
//  YueZhai
//
//  Created by Fmyz on 16/8/12.
//  Copyright © 2016年 Fmyz. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^RequestComplete)(id responseObject, NSError *error);
typedef void(^RequestProgress)(NSProgress * progress);

@interface TSBaseJsonRequest : NSObject

@property (copy, nonatomic) NSString *requstURL;
@property (copy, nonatomic) NSString *method;
@property (strong, nonatomic) NSMutableDictionary *params;
@property (assign, nonatomic) BOOL showDebug;

@property (copy, nonatomic) RequestProgress progress;
@property (copy, nonatomic) RequestComplete complete;


+ (void)sendReuqestWithRequstURL:(NSString *)requstURL method:(NSString *)method params:(NSDictionary *)params showDebug:(BOOL)showDebug progress:(RequestProgress)progress complete:(RequestComplete)complete;

//构造方法
- (instancetype)initWithRequstURL:(NSString *)requstURL method:(NSString *)method params:(NSDictionary *)params showDebug:(BOOL)showDebug;
//发送请求
- (void)sendRequest;
- (void)sendReuqestWithProgress:(RequestProgress)progress complete:(RequestComplete)complete;

//取消请求
- (void)cancel;

//取消所有请求
- (void)cancelAll;

@end
