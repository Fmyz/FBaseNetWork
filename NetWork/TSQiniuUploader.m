//
//  TSQiniuUploader.m
//  YueZhai
//
//  Created by Fmyz on 16/8/12.
//  Copyright © 2016年 Fmyz. All rights reserved.
//

#import "TSQiniuUploader.h"
#import "AFNetworking.h"
#import "QiniuSDK.h"
#import "TSReachability.h"

@implementation TSQiniuUploader

+ (QNUploadManager*)qnUploadManager
{
    static QNUploadManager *s_upManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_upManager = [[QNUploadManager alloc] init];
    });
    return s_upManager;
}

+ (void)uploadData:(NSData *)imageData tokenURL:(NSString *)tokenURL tokenParameters:(NSDictionary *)tokenParameters progress:(void (^)(double))progressBlock completion:(void (^)(TSQiniuUploaderInfo *info, NSError *error))completion
{
    if ([TSReachability share].isStarting) {
        if ([TSReachability share].networkReachabilityStatus != TS_NetworkReachabilityStatusUnknown && ![TSReachability share].isReachable) {
            if (completion) {
                NSError *error = [NSError errorWithDomain:@"TSQiniuUploader.NO.NetworkReachability" code:233 userInfo:nil];
                completion(nil, error);
            }
            return;
        }
    }
    
    [self tokenURL:tokenURL tokenParameters:tokenParameters complete:^(NSArray *tokenArr, NSError *error) {
        if (error) {
            if (completion) {
                completion(nil, error);
            }
        }else{
            for (NSDictionary *eachDic in tokenArr) {
                NSString *key = [eachDic objectForKey:@"key"];
                NSString *uploadToken = [eachDic objectForKey:@"token"];
                
                NSString *url= [eachDic objectForKey:@"url"];
                NSString *tbUrl= [eachDic objectForKey:@"url_t"];
                
                QNUploadOption *opt = [[QNUploadOption alloc] initWithProgressHandler:^(NSString *key, float percent) {
                    if(progressBlock)
                    {
                        progressBlock(percent);
                    }
                }];
                [[TSQiniuUploader qnUploadManager] putData:imageData key:key token:uploadToken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                    
                    if (info.error && info.statusCode != 200){
                        if (completion) {
                            completion(nil, info.error);
                        }
                    }else{
                        TSQiniuUploaderInfo *tsInfo = [[TSQiniuUploaderInfo alloc] init];
                        tsInfo.key = key;
                        tsInfo.token = uploadToken;
                        
                        if (url && url.length) {
                            tsInfo.url = url;
                        }
                        if (tbUrl && tbUrl.length) {
                            tsInfo.tbUrl = tbUrl;
                        }
                        
                        UIImage *image = [UIImage imageWithData:imageData];
                        if (image) {
                            tsInfo.width = image.size.width;
                            tsInfo.height = image.size.height;
                        }
                        
                        if (completion) {
                            completion(tsInfo, nil);
                        }
                    }
                } option:opt];
            }
        }
    }];
}

+ (void)tokenURL:(NSString*)tokenURL tokenParameters:(NSDictionary *)tokenParameters complete:(void(^)(NSArray *tokenArr, NSError *error))complete
{
    //第一步，获取上传token
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Accept"];
    session.requestSerializer = requestSerializer;
    
    [session POST:tokenURL parameters:tokenParameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *resultDic = (NSDictionary *)responseObject;
            NSInteger result = [resultDic[@"result"] integerValue];
            if (result == 0) {
                NSDictionary *dataDic = [resultDic objectForKey:@"data"];
                NSArray *tokenArr = [dataDic objectForKey:@"token"];
                if (tokenArr && [tokenArr count]) {
                    if (complete) {
                        complete(tokenArr, nil);
                    }
                }else{
                    if (complete) {
                        NSError *error = [NSError errorWithDomain:@"TS.QINIU.GETTOKEN.ERROR" code:TSTokenArrayError userInfo:nil];
                        complete(nil, error);
                    }
                }
                
            }else{
                if (complete) {
                    NSError *error = [NSError errorWithDomain:@"TS.QINIU.GETTOKEN.ERROR" code:TSTokenResultError userInfo:nil];
                    complete(nil, error);
                }
            }
            
        }else{
            if (complete) {
                NSError *error = [NSError errorWithDomain:@"TS.QINIU.GETTOKEN.ERROR" code:TSTokenClassError userInfo:nil];
                complete(nil, error);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败
        if (complete) {
            complete(nil, error);
        }
    }];
    
}

@end

@implementation TSQiniuUploaderInfo

@end

