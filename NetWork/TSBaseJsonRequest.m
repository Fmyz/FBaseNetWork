//
//  TSBaseJsonRequest.m
//  YueZhai
//
//  Created by Fmyz on 16/8/12.
//  Copyright © 2016年 Fmyz. All rights reserved.
//

#import "TSBaseJsonRequest.h"
#import "TSReachability.h"
#import "AFNetworking.h"

@interface TSBaseJsonRequest ()

@property (nonatomic,strong) NSURLSessionDataTask *task;
@property (nonatomic,strong) AFHTTPSessionManager *sessionManager;

@end

@implementation TSBaseJsonRequest

+ (void)sendReuqestWithRequstURL:(NSString *)requstURL method:(NSString *)method params:(NSDictionary *)params showDebug:(BOOL)showDebug progress:(RequestProgress)progress complete:(RequestComplete)complete
{
    TSBaseJsonRequest *request = [[TSBaseJsonRequest alloc] initWithRequstURL:requstURL method:method params:params showDebug:showDebug];
    [request sendReuqestWithProgress:progress complete:complete];
}

- (instancetype)initWithRequstURL:(NSString *)requstURL method:(NSString *)method params:(NSDictionary *)params showDebug:(BOOL)showDebug
{
    if (self = [super init]) {
        self.requstURL = requstURL;
        self.method = method;
        [self.params addEntriesFromDictionary:params];
        self.showDebug = showDebug;
    }
    return self;
}

- (void)sendRequest
{
    [self sendReuqestWithProgress:self.progress complete:self.complete];
}

- (void)sendReuqestWithProgress:(RequestProgress)progress complete:(RequestComplete)complete
{
    if ([TSReachability share].isStarting) {
        if ([TSReachability share].networkReachabilityStatus != TS_NetworkReachabilityStatusUnknown && ![TSReachability share].isReachable) {
            if (complete) {
                NSError *error = [NSError errorWithDomain:@"TSBaseJsonRequest.NO.NetworkReachability" code:233 userInfo:nil];
                complete(nil, error);
            }
            return;
        }
    }
    
    self.progress = progress;
    self.complete = complete;
    
    //判读请求的方式,默认是POST方式
    if ([[_method uppercaseString] isEqualToString:@"POST"] || _method.length == 0) {
        //以post方式进行数据获取
        [self postJSON];
    }else{
        //以get方式进行数据获取
        [self getJSON];
    }
}

#pragma mark- 发送POST请求
- (void)postJSON{
    if (_showDebug) {
        //展示请求链接
        [self showRequestAndParams];
    }
    
    _task = [self.sessionManager POST:self.requstURL parameters:self.params progress:self.progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.complete) {
            self.complete(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.complete) {
            self.complete(nil, error);
        }
    }];
}

#pragma mark- 发送GET请求
-(void)getJSON{
    if (_showDebug) {
        //展示请求链接
        [self showRequestAndParams];
    }
    
    _task = [self.sessionManager GET:self.requstURL parameters:self.params progress:self.progress success:^(NSURLSessionTask * _Nonnull task, id _Nullable responseObject) {
        //请求成功
        if (self.complete) {
            self.complete(responseObject, nil);
        }
    } failure:^(NSURLSessionTask * _Nonnull operation, NSError * _Nonnull error) {
        //请求失败
        if (self.complete) {
            self.complete(nil, error);
        }
    }];
}


- (void)cancel
{
    if (_task) {
        [_task cancel];
    }
}

- (void)cancelAll
{
    if (_sessionManager) {
        [_sessionManager.operationQueue cancelAllOperations];
    }
}

#pragma mark- 展式请求的地址及其参数
- (void)showRequestAndParams
{
    NSLog(@"requestUrl: %@\nrequestParams: %@", self.requstURL, self.params);
}

- (AFHTTPSessionManager *)sessionManager
{
    if (!_sessionManager) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
       NSMutableSet<NSString *> *types = [NSMutableSet setWithSet:_sessionManager.responseSerializer.acceptableContentTypes];
        [types addObject:@"text/html"];
        _sessionManager.responseSerializer.acceptableContentTypes = types.copy;
    }
    return _sessionManager;
}

- (NSMutableDictionary *)params
{
    if (!_params) {
        _params = [[NSMutableDictionary alloc] init];
    }
    return _params;
}

@end
