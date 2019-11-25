//
//  YPNetTool.m
//  YPToolsUpdate
//
//  Created by Work_Zyp on 13/5/9.
//  Copyright © 2013年 Work_Zyp. All rights reserved.
//

#import "YPNetTool.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "YPHeader.h"

const void *network_tasksArr_key = @"network_tasksArr_key";

//  网络请求静态参数设置
/**  默认请求超时时间60s*/
static NSTimeInterval requestTimeout = 60;
/**  基础Url*/
static NSString *baseURLString = kBaseURL;
/**  允许得到直接返回未经判断处理的请求结果*/
static BOOL isOriginalResponse = YES;
/**  默认请求头 设置*/
static NSDictionary *httpHeaders = nil;

@implementation YPNetTool

+ (void)load {
    static NSMutableArray *tasksArr = nil;
    if (!tasksArr) {
        tasksArr = [NSMutableArray array];
        objc_setAssociatedObject(self, network_tasksArr_key, tasksArr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

+ (NSMutableArray *)getTasksArr {
    return objc_getAssociatedObject(self, network_tasksArr_key);
}


#pragma mark -
#pragma mark -网络请求 之 安全取数据 Dict 、Array 、String等
/**安全取字典,如果为非字典类型，则返回nil*/
+ (NSDictionary *)safeDictOfObject:(id)object withKey:(NSString *)key {
    @try {
        NSDictionary *dict = [object objectForKey:key];
        if (![dict isKindOfClass:[NSDictionary class]]) {
            dict = nil;
        }
        return dict;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    return nil;
}
/**安全取数组，如果为非数组类型，则返回nil*/
+ (NSArray *)safeArrayOfObject:(id)object withKey:(NSString *)key {
    @try {
        NSArray *arr = [object objectForKey:key];
        if (![arr isKindOfClass:[NSArray class]]) {
            arr = nil;
        }
        return arr;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    return nil;
}
/**安全取字符串，如果为非字符串类型，则返回长度为0的字符串*/
+ (NSString *)safeStringOfObject:(id)object withKey:(NSString *)key {
    @try {
        NSString *str = [object objectForKey:key];
        if (![str isKindOfClass:[NSString class]]) {
            str = [NSString stringWithFormat:@"%@",str];
        }
        return str;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    return nil;
}
/**安全取 BOOL值*/
+ (BOOL)safeBoolOfObject:(id)object withKey:(NSString *)key {
    @try {
        NSString *valueStr = [NSString stringWithFormat:@"%@",object[key]];
        return [valueStr boolValue];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    return NO;
}
/**安全取 NSInteger值*/
+ (NSInteger)safeIntegerOfObject:(id)object withKey:(NSString *)key {
    @try {
        NSString *valueStr = [NSString stringWithFormat:@"%@",object[key]];
        return [valueStr integerValue];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    return 0;
}
/**安全取 NSInteger值 并带有默认值*/
+ (NSInteger)safeIntegerOfObject:(id)object withKey:(NSString *)key withDefaultValue:(NSInteger)defaultVal {
    @try {
        return [[object objectForKey:key] integerValue];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    return defaultVal;
}


#pragma mark -
#pragma mark - 网络请求相关方法

+ (void)updateBaseUrlWithNewBaseUrl:(NSString *)newBaseUrl {
    baseURLString = newBaseUrl;
}

+ (BOOL)isEnableOriginal {
    return isOriginalResponse;
}

/**  允许得到直接返回未经判断处理的请求结果*/
+ (void)enableGetOriginaResponse:(BOOL)isOriginal {
    isOriginalResponse = isOriginal;
}

+ (NSTimeInterval)requestTimeout {
    return requestTimeout;
}

+ (void)updateRequestTimeout:(NSTimeInterval)timeout {
    requestTimeout = timeout;
}

+ (void)updateCommonHttpHeaders:(NSDictionary *)newHttpHeaders {
    httpHeaders = newHttpHeaders;
}

/** GET请求 */
//+ (void)GET:(NSString *)URLString
// parameters:(id)parameters
//   progress:(void (^)(NSProgress * downloadProgress))ypDownloadProgress
//    success:(void (^)(id responseObject))success
//    failure:(void (^)(NSError *error))failure withSourceController:(UIViewController *)sourceVC {
//    NSString *requestURL = [NSString stringWithFormat:@"%@%@",baseURLString,URLString];
////    NSString *Url = [requestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//     NSString *Url = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    AFHTTPSessionManager *manager = [self getSessionManager];
//    
//    @try {
//        if (sourceVC) {
//            kMBProgressHUD_Show(sourceVC.view);
//        }
//        [manager GET:Url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
//            if (downloadProgress) {
//                ypDownloadProgress(downloadProgress);
//            }
//        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            if (sourceVC) {
//                kMBProgressHUD_Hide(sourceVC.view);
//            }
//            if ([self isEnableOriginal]) {
//                if (success) {
//                    success(responseObject);
//                }
//            }else{
//                NSString *codeStr = kSafeGetString(responseObject[@"code"]);
//                if ([codeStr integerValue] == 0) {
//                    if (success) {
//                        success(responseObject);
//                    }
//                }else{
//                    [sourceVC.view makeToast:responseObject[@"msg"]];
//                }
//            }
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            if (sourceVC) {
//                kMBProgressHUD_Hide(sourceVC.view);
//                [sourceVC.view makeToast:kError_Tips];
//            }
//            if (failure) {
//                failure(error);
//                if (sourceVC) {
//                    [sourceVC.view makeToast:kError_Tips];
//                }
//                DLog(@"Error is %@",error);
//            }
//        }];
//
//    } @catch (NSException *exception) {
//        DLog(@"Catch到该接口数据有变动->%@",URLString);
//    } @finally {
//        
//    }
//    
//}

+ (void)GET:(NSString *)URLString
 parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure withSourceController:(UIViewController *)sourceVC {
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",baseURLString,URLString];
    if (@available(iOS 9.0, *)) {
        requestURL = [requestURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }else {
        requestURL = [requestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    AFHTTPSessionManager *manager = [self getSessionManager];
    
    @try {
        if (sourceVC) {
            kYP_MBProgressHUD_Show(sourceVC.view);
        }
        NSURLSessionTask *sessionTask = [manager GET:requestURL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (sourceVC) {
                kYP_MBProgressHUD_Hide(sourceVC.view);
            }
            if ([self isEnableOriginal]) {
                if (success) {
                    success(responseObject);
                }
            }else{
                NSString *codeStr = kYP_SafeGetString(responseObject[@"code"]);
                if ([codeStr integerValue] == 0) {
                    if (success) {
                        success(responseObject);
                    }
                }else{
                    [sourceVC.view makeToast:responseObject[@"msg"]];
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (sourceVC) {
                kYP_MBProgressHUD_Hide(sourceVC.view);
                [sourceVC.view makeToast:kYP_DEFAULT_ERROR_TIP];
            }
            if (failure) {
                failure(error);
                if (sourceVC) {
                    [sourceVC.view makeToast:kYP_DEFAULT_ERROR_TIP];
                }
                YPLog(@"Error is %@",error);
            }
        }];
        
        [[self getTasksArr] addObject:sessionTask];
        
        
    } @catch (NSException *exception) {
        YPLog(@"Catch到该接口数据有变动->%@",URLString);
    } @finally {
        
    }
    
}

/**  无文件POST*/
+ (void)POST:(NSString *)URLString
  parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure withSourceController:(UIViewController *)sourceVC {
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",baseURLString,URLString];
    if (@available(iOS 9.0, *)) {
        requestURL = [requestURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }else {
        requestURL = [requestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    AFHTTPSessionManager *manager = [self getSessionManager];
    @try {
        if (sourceVC) {
            kYP_MBProgressHUD_Show(sourceVC.view);
        }
        NSURLSessionTask *sessionTask = [manager POST:requestURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (sourceVC) {
                kYP_MBProgressHUD_Hide(sourceVC.view);
            }
            if ([self isEnableOriginal]) {
                if (success) {
                    success(responseObject);
                }
            }else{
                NSString *codeStr = kYP_SafeGetString(responseObject[@"code"]);
                if ([codeStr integerValue] == 0) {
                    if (success) {
                        success(responseObject);
                    }
                }else{
                    [sourceVC.view makeToast:responseObject[@"msg"]];
                }
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (sourceVC) {
                kYP_MBProgressHUD_Hide(sourceVC.view);
                [sourceVC.view makeToast:kYP_DEFAULT_ERROR_TIP];
            }
            if (failure) {
                failure(error);
                if (sourceVC) {
                    [sourceVC.view makeToast:kYP_DEFAULT_ERROR_TIP];
                }
                YPLog(@"Error is %@",error);
            }
            
        }];
        
        [[self getTasksArr] addObject:sessionTask];
        
    } @catch (NSException *exception) {
        YPLog(@"Catch到该接口数据有变动->%@",URLString);
    } @finally {
        
    }
    
}

/**有文件 POST*/
+ (void)POST:(NSString *)URLString
  parameters:(id)parameters
constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
    progress:(void (^)(NSProgress * uploadProgress))ypUploadProgress
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError * error))failure withSourceController:(UIViewController *)sourceVC {
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",baseURLString,URLString];
    if (@available(iOS 9.0, *)) {
        requestURL = [requestURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }else {
        requestURL = [requestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    AFHTTPSessionManager *manager = [self getSessionManager];
    @try {
        if (sourceVC) {
            kYP_MBProgressHUD_Show(sourceVC.view);
        }
        NSURLSessionTask *sessionTask = [manager POST:requestURL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            if (formData) {
                block(formData);
            }
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            if (uploadProgress) {
                ypUploadProgress(uploadProgress);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (sourceVC) {
                kYP_MBProgressHUD_Hide(sourceVC.view);
            }
            if ([self isEnableOriginal]) {
                if (success) {
                    success(responseObject);
                }
            }else{
                NSString *codeStr = kYP_SafeGetString(responseObject[@"code"]);
                if ([codeStr integerValue] == 0) {
                    if (success) {
                        success(responseObject);
                    }
                }else{
                    [sourceVC.view makeToast:responseObject[@"msg"]];
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (sourceVC) {
                kYP_MBProgressHUD_Hide(sourceVC.view);
                [sourceVC.view makeToast:kYP_DEFAULT_ERROR_TIP];
            }
            if (failure) {
                failure(error);
                if (sourceVC) {
                    [sourceVC.view makeToast:kYP_DEFAULT_ERROR_TIP];
                }
                YPLog(@"Error is %@",error);
            }
        }];
        
        [[self getTasksArr] addObject:sessionTask];
        
    } @catch (NSException *exception) {
        YPLog(@"Catch到该接口数据有变动->%@",URLString);
    } @finally {
        
    }
}

+ (AFHTTPSessionManager *)getSessionManager {
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    AFHTTPSessionManager *mgr = [self sharedHttpSessionManager];
    //    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.requestSerializer.timeoutInterval = [self requestTimeout];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                          @"application/octet-stream",
                                                                          @"text/html",
                                                                          @"text/json",
                                                                          @"text/plain",
                                                                          @"text/javascript",
                                                                          @"text/xml",
                                                                          @"image/*"]];
    
    /*
     //  请求头设置
     [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
     [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
     [mgr.requestSerializer setValue:@"APP" forHTTPHeaderField:@"X-REQUEST-SIDE"];
     NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
     [mgr.requestSerializer setValue:appVersion forHTTPHeaderField:@"App-version"];
     */
    [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    if (httpHeaders) {
        for (NSString *key in httpHeaders.allKeys) {
            if (httpHeaders[key]) {
                [mgr.requestSerializer setValue:httpHeaders[key] forHTTPHeaderField:key];
            }
        }
    }
    // 设置允许同时最大并发数量，过大容易出问题
    mgr.operationQueue.maxConcurrentOperationCount = 5;
    
    return mgr;
}


static AFHTTPSessionManager *manager;
+(AFHTTPSessionManager *)sharedHttpSessionManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
    });
    
    return manager;
}

#pragma mark -
#pragma mark - 取消指定的网络请求
+ (void)cancelRequestByURLStr:(NSString *)urlStr {
    NSMutableArray *tasksArr = [self getTasksArr];
    for (NSURLSessionTask *sessionTask in tasksArr) {
        if ([sessionTask.currentRequest.URL.absoluteString isEqualToString:urlStr]) {
            [sessionTask cancel];
            break;
        }
    }
}

@end
