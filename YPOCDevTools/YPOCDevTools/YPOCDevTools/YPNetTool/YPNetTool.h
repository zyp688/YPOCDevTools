//
//  YPNetTool.h
//  YPToolsUpdate
//
//  Created by Work_Zyp on 13/5/9.
//  Copyright © 2013年 Work_Zyp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"


@interface YPNetTool : NSObject

//----------------------安全取数据⬇️--------------------------
/**安全取字典,如果为非字典类型，则返回nil*/
+ (NSDictionary *)safeDictOfObject:(id)object withKey:(NSString *)key;
/**安全取数组，如果为非数组类型，则返回nil*/
+ (NSArray *)safeArrayOfObject:(id)object withKey:(NSString *)key;
/**安全取字符串，如果为非字符串类型，则返回长度为0的字符串*/
+ (NSString *)safeStringOfObject:(id)object withKey:(NSString *)key;
/**安全取 BOOL值*/
+ (BOOL)safeBoolOfObject:(id)object withKey:(NSString *)key;
/**安全取 NSInteger值*/
+ (NSInteger)safeIntegerOfObject:(id)object withKey:(NSString *)key;
//----------------------安全取数据⬆️--------------------------


//----------------------自定义请求相关方法⬇️--------------------------

/**  更新基础Url*/
+ (void)updateBaseUrlWithNewBaseUrl:(NSString *)newBaseUrl;
/**  允许得到直接返回未经判断处理的请求结果*/
+ (void)enableGetOriginaResponse:(BOOL)isOriginal;
/**  更新请求超时的时间*/
+ (void)updateRequestTimeout:(NSTimeInterval)timeout;
/**  更新请求头 设置*/
+ (void)updateCommonHttpHeaders:(NSDictionary *)newHttpHeaders;

/** GET请求 */
//+ (void)GET:(NSString *)URLString
// parameters:(id)parameters
//   progress:(void (^)(NSProgress * downloadProgress))ypDownloadProgress
//    success:(void (^)(id responseObject))success
//    failure:(void (^)(NSError *error))failure withSourceController:(UIViewController *)sourceVC;
+ (void)GET:(NSString *)URLString
 parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure withSourceController:(UIViewController *)sourceVC;

/** 无文件POST请求*/
+ (void)POST:(NSString *)URLString
 parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure withSourceController:(UIViewController *)sourceVC;

/** 有文件POST请求 */
+ (void)POST:(NSString *)URLString
    parameters:(id)parameters
constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
      progress:(void (^)(NSProgress * uploadProgress))ypUploadProgress
       success:(void (^)(id responseObject))success
       failure:(void (^)(NSError * error))failure withSourceController:(UIViewController *)sourceVC;


/** 取消指定的请求任务*/
+ (void)cancelRequestByURLStr:(NSString *)urlStr;



//----------------------自定义请求相关方法⬆️--------------------------


@end

