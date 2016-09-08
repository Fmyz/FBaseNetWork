//
//  TSQiniuUploader.h
//  YueZhai
//
//  Created by Fmyz on 16/8/12.
//  Copyright © 2016年 Fmyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TSUploadErrorCode)
{
    TSTokenClassError = 1000, //获取token返回类型错误
    TSTokenResultError,       //获取token返回resultCode错误
    TSTokenArrayError,        //获取token的数组错误
};

@class TSQiniuUploaderInfo;
@interface TSQiniuUploader : NSObject

+ (void)uploadData:(NSData *)imageData tokenURL:(NSString *)tokenURL tokenParameters:(NSDictionary *)tokenParameters progress:(void (^)(double))progressBlock completion:(void (^)(TSQiniuUploaderInfo *info, NSError *error))completion;

@end

@interface TSQiniuUploaderInfo : NSObject

@property (copy, nonatomic) NSString *key;
@property (copy, nonatomic) NSString *token;

@property (copy, nonatomic) NSString *url;
@property (copy, nonatomic) NSString *tbUrl;

@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat height;

@end
