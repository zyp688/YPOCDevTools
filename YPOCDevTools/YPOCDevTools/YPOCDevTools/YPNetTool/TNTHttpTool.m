//
//  TNTHttpTool.m
//  TNTOCDevTools
//
//  Created by TNT on 2020/8/20.
//  Copyright © 2020 TNT. All rights reserved.
//

#import "TNTHttpTool.h"

#import "AFNetworkActivityIndicatorManager.h"

// - 声明请求方式类型，市面上多数只用GET,POST，这里也只封装了最常用的
typedef NS_ENUM(NSUInteger,HTTPREQUESTTYPE) {
    HTTPREQUEST_GET = 100, ///> GET请求方式
    HTTPREQUEST_POST,   ///> POST请求方式
    HTTPREQUEST_UNKNOWN ///> 未知请求方式
};

@interface TNTHttpCommonConfig ()
// 注意:!!! 目前想到的可用的配置有这些...此配置作用于所有使用到该工具的请求

/** 请求头字典*/
@property (strong, nonatomic) NSDictionary *httpHeaders;
/** 请求超时时间*/
@property (assign, nonatomic) NSTimeInterval requestTimeout;
/** 最大请求并发数*/
@property (assign, nonatomic) NSInteger maxConcurrentOperationCount;
/** 直接获取原始数据的白名单*/
@property (strong, nonatomic) NSMutableArray *fetchOriginDataWhiteList;
/** 网络请求逻辑成功时的状态码*/
@property (assign, nonatomic) NSInteger successCode;

@end
@implementation TNTHttpCommonConfig
@end

@interface TNTHttpTool ()

/** 请求任务的队列数组*/
@property(nonatomic, strong) NSMutableArray *tasksArr;

@end

@implementation TNTHttpTool

// MARK: - 线程安全的获取请求本工具的单例对象
static id _instance;
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        ((TNTHttpTool *)_instance).commonConfig = [((TNTHttpTool *)_instance) defaultCommonConfig];
        ((TNTHttpTool *)_instance).tasksArr = [NSMutableArray array];
        // 使用工具时 --- 同步开启 监测网络状态
        ((TNTHttpTool *)_instance).netWorkReachabilityStatus = -10086;
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        [((TNTHttpTool *)_instance) configReachabilityStatusByAFNetwork];
    });
    return _instance;
}

// MARK: - 通用的请求配置 默认配置
- (TNTHttpCommonConfig *)defaultCommonConfig{
    TNTHttpCommonConfig *commonConfig = [TNTHttpCommonConfig new];
    commonConfig.maxConcurrentOperationCount = maxConcurrentOperationCount;
    commonConfig.requestTimeout = requestTimeout;
    commonConfig.httpHeaders = httpHeaders;
    commonConfig.fetchOriginDataWhiteList = [NSMutableArray array];
    commonConfig.successCode = 200;
    return commonConfig;
}

// MARK: - 添加 直接返回原始数据 的白名单
- (TNTHttpTool *(^)(NSString *))fetchOriginData {
    @TNTWeakify(self);
    return ^(NSString *suffUrl){
        @TNTStrongify(self);
        if (![self.commonConfig.fetchOriginDataWhiteList containsObject:suffUrl]) {
            [self.commonConfig.fetchOriginDataWhiteList addObject:suffUrl];
        }
        return self;
    };
}

// MARK: - GET 请求
- (TNTHttpTool *(^)(NSString *, NSDictionary *))GET {
    @TNTWeakify(self);
    return ^(NSString *suffUrl, NSDictionary *params){
        @TNTStrongify(self);
        self.REQUEST(@"GET", TNTHttpBaseURL, suffUrl, nil, nil, params, ^(id responseObject) {
            @TNTStrongify(self);
            self.success ? self.success(responseObject) : nil;
            self.complete ? self.complete(nil, responseObject) : nil;
        }, ^(NSError *error) {
            @TNTStrongify(self);
            self.failure ? self.failure(error) : nil;
            self.complete ? self.complete(error, nil) : nil;
        });
        return self;
    };
}

// MARK: - POST 请求
- (TNTHttpTool *(^)(NSString *, NSDictionary *))POST {
    @TNTWeakify(self);
    return ^(NSString *suffUrl, NSDictionary *params){
        @TNTStrongify(self);
        self.REQUEST(@"POST", TNTHttpBaseURL, suffUrl, nil, nil, params, ^(id responseObject) {
            @TNTStrongify(self);
            self.success ? self.success(responseObject) : nil;
            self.complete ? self.complete(nil, responseObject) : nil;
        }, ^(NSError *error) {
            @TNTStrongify(self);
            self.failure ? self.failure(error) : nil;
            self.complete ? self.complete(error, nil) : nil;
        });
        return self;
    };
}

// MARK: = 上传 一张 图片的请求
- (TNTHttpTool *(^)(NSString *, UIImage *, ProgressBlock))uploadOneImage {
    @TNTWeakify(self);
    return ^(NSString *suffUrl, UIImage *image, ProgressBlock progressBlock){
        @TNTStrongify(self);
        if (!suffUrl || (suffUrl && suffUrl.length > 0) || !image) {
            TNTLog(@"单张图片上传时----> 【请求后缀】或【图片】为空!!!");
            NSError *err = [NSError errorWithDomain:@"ErrorDomain" code:-99999 userInfo:[NSDictionary dictionaryWithObject:@"单张图片上传时，【请求后缀】或【图片】为空!!!" forKey:NSLocalizedDescriptionKey]];
            self.failure ? self.failure(err) : nil;
            
            return self;
        }
        self.REQUEST(@"POST", TNTHttpBaseURL, suffUrl, progressBlock, ^(id<AFMultipartFormData> formData) {
            NSData *imageData = UIImageJPEGRepresentation(image,compressionQuality);
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
            [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
        }, nil, ^(id responseObject) {
            @TNTStrongify(self);
            self.success ? self.success(responseObject) : nil;
            self.complete ? self.complete(nil, responseObject) : nil;
        }, ^(NSError *error) {
            @TNTStrongify(self);
            self.failure ? self.failure(error) : nil;
            self.complete ? self.complete(error, nil) : nil;
        });
        return self;
    };
}

//MARK: - 上传 多张 图片的请求 【图片二进制数据循环上传】
- (TNTHttpTool *(^)(NSString *, NSArray<UIImage *> *, ProgressBlock))uploadMultipleImages {
    @TNTWeakify(self);
    return ^(NSString *suffUrl, NSArray <UIImage *>*images, ProgressBlock progressBlock){
        @TNTStrongify(self);
        if (!suffUrl || (suffUrl && suffUrl.length > 0) || !images || (images && images.count == 0)) {
            TNTLog(@"二进制数据形式上传多张图片时----> 【请求后缀】或【图片数组】为空!!!");
            NSError *err = [NSError errorWithDomain:@"ErrorDomain" code:-99999 userInfo:[NSDictionary dictionaryWithObject:@"二进制数据形式上传多张图片时,【请求后缀】或【图片数组】为空!!!" forKey:NSLocalizedDescriptionKey]];
            self.failure ? self.failure(err) : nil;
            
            return self;
        }
        self.REQUEST(@"POST", TNTHttpBaseURL, suffUrl, progressBlock, ^(id<AFMultipartFormData> formData) {
            for (int i = 0; i < images.count; i ++) {
                UIImage *image = images[i];
                NSData *imageData = UIImageJPEGRepresentation(image,compressionQuality);
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *str = [formatter stringFromDate:[NSDate date]];
                NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
                [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
            }
        }, nil, ^(id responseObject) {
            @TNTStrongify(self);
            self.success ? self.success(responseObject) : nil;
            self.complete ? self.complete(nil, responseObject) : nil;
        }, ^(NSError *error) {
            @TNTStrongify(self);
            self.failure ? self.failure(error) : nil;
            self.complete ? self.complete(error, nil) : nil;
        });
        return self;
    };
}

// MARK: - 上传 多张 图片的请求 [递归的形式 一张一张的上传]
- (TNTHttpTool *(^)(NSString *, NSArray<UIImage *> *, ProgressBlock, NSUInteger))uploadMultipleImagesOneByOne {
    @TNTWeakify(self);
    return ^(NSString *suffUrl, NSArray <UIImage *>*images, ProgressBlock progressBlock, NSUInteger idx){
        @TNTStrongify(self);
        if (!suffUrl || (suffUrl && suffUrl.length > 0) || !images || (images && images.count == 0)) {
            TNTLog(@"递归形式上传多张图片时----> 【请求后缀】或【图片数组】为空!!!");
            NSError *err = [NSError errorWithDomain:@"ErrorDomain" code:-99999 userInfo:[NSDictionary dictionaryWithObject:@"递归形式上传多张图片时,【请求后缀】或【图片数组】为空!!!" forKey:NSLocalizedDescriptionKey]];
            self.failure ? self.failure(err) : nil;
            return self;
        }
        UIImage *subImg = images[idx];
        __block NSInteger bIdx = idx;
        self.uploadOneImage(suffUrl, subImg, progressBlock).success = ^(id responseObject) {
            @TNTStrongify(self);
            if (bIdx == images.count - 1) {// 上传完了
                self.success ? self.success(responseObject) : nil;
                self.complete ? self.complete(nil, responseObject) : nil;
                return;// 终止递归 不需要再上传了...
            }
            // 递归 上传下一张...
            NSInteger nextIdx = bIdx + 1;
            self.uploadMultipleImagesOneByOne(suffUrl, images, progressBlock, nextIdx);
        };
        
        return self;
    };
}




// MARK: - 网络请求方法
- (TNTHttpTool *(^)(NSString *, NSString *, NSString *, ProgressBlock ,FormDataBlock, NSDictionary *, SuccessBlock, FailureBlock))REQUEST {
    @TNTWeakify(self);
    return ^(NSString *method, NSString *preUrl, NSString *suffUrl, ProgressBlock progressBlock, FormDataBlock formDataBlock, NSDictionary *params, SuccessBlock success, FailureBlock failure){
        @TNTStrongify(self);
        // 异常容错 - 1.监听网络状态生效后，捕获网络状态为没有网络！
        if (self.netWorkReachabilityStatus != -10086 && self.netWorkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
            NSError *err = [NSError errorWithDomain:@"ErrorDomain" code:-99999 userInfo:[NSDictionary dictionaryWithObject:@"网络出现错误，请检查网络连接" forKey:NSLocalizedDescriptionKey]];
            failure ? failure(err) : nil;
            return self;
        }
        // type --- 请求方式
        HTTPREQUESTTYPE type = [method isEqualToString:@"GET"] ? HTTPREQUEST_GET : [method isEqualToString:@"POST"] ? HTTPREQUEST_POST :
        HTTPREQUEST_UNKNOWN;
        // 异常容错 - 2.不支持的非法请求方式
        if (type == HTTPREQUEST_UNKNOWN) {
            TNTLog(@"不支持的非法网络请求方式!当前仅支持GET/POST请求");
            NSError *err = [NSError errorWithDomain:@"ErrorDomain" code:-99999 userInfo:[NSDictionary dictionaryWithObject:@"不支持的非法网络请求方式!当前仅支持GET/POST请求" forKey:NSLocalizedDescriptionKey]];
            failure ? failure(err) : nil;
            return self;
        }
        // 异常容错 - 3.传参异常
        if (!preUrl || (preUrl && preUrl.length > 0) || !suffUrl || (suffUrl && suffUrl.length > 0)) {
            TNTLog(@"请求时----> 【请求前缀】或【请求后缀】为空!!!");
            NSError *err = [NSError errorWithDomain:@"ErrorDomain" code:-99999 userInfo:[NSDictionary dictionaryWithObject:@"请求时,【请求前缀】或【请求后缀】为空!!!" forKey:NSLocalizedDescriptionKey]];
            self.failure ? self.failure(err) : nil;
            return self;
        }
        
        
        // 异常容错 - 4.兼容 URL 中多余'//'衍生的未知问题
        if([preUrl hasSuffix:@"/"] && [suffUrl hasPrefix:@"/"]) {
            preUrl = [preUrl substringToIndex:preUrl.length - 1];
        }
        NSString *requestURL = [NSString stringWithFormat:@"%@%@",preUrl,suffUrl];
        
        // 异常容错 - 5.URL---> UTF8编码
        if (@available(iOS 9.0, *)) {
            requestURL = [requestURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        }else {
            requestURL = [requestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        
        // --- 真正开始 处理请求 ...
        AFHTTPSessionManager *manager = [self getSessionManager];
        @TNTWeakify(self);
        switch (type) {
            case HTTPREQUEST_GET: {
                @try {
                    NSURLSessionTask *sessionTask = [manager GET:requestURL parameters:params headers:self.commonConfig.httpHeaders progress:^(NSProgress * _Nonnull downloadProgress) {
                        progressBlock ? progressBlock(downloadProgress) : nil;
                    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        @TNTStrongify(self);
                        if ([self.commonConfig.fetchOriginDataWhiteList containsObject:suffUrl]) {
                            // 某些特殊业务 需要直接 将原始数据返回 ---
                            success ? success(responseObject) : nil;
                        }else {
                            #warning - 此处根据实际接口文档--数据结构进行处理！！！！
                            NSString *codeStr = [NSString stringWithFormat:@"%@",responseObject[@"code"] ? responseObject[@"code"] : responseObject[@"status"] ? responseObject[@"status"] : @""];
                            if ([codeStr integerValue] == self.commonConfig.successCode) {
                                //                            // 业务逻辑匹配成功...
                                success ? success(responseObject[@"data"]) : nil;
                            }else { // 业务逻辑匹配失败 --- 吐司提示错误信息
                                NSString *msgStr = [NSString stringWithFormat:@"%@",responseObject[@"msg"] ? responseObject[@"msg"] : responseObject[@"message"] ? responseObject[@"message"] : @""];
                                TNTLog(@"逻辑错误 --- 吐司提示信息----%@",msgStr);
                            }
                        }
                        
                        // 维护请求队列 删除对应任务
                        [self removeSessionTask:task];
                        
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        @TNTStrongify(self);
                        failure ? failure(error) : nil;
                        // 维护请求队列 删除对应任务
                        [self removeSessionTask:task];
                        if (onRetryRequestSwitch) {// 开启了容错的话 会再次请求一下
                            self.GET(suffUrl, params);
                        }
                    }];
                    // 维护请求队列 添加任务
                    [self addSessionTask:sessionTask];
                } @catch (NSException *exception) {
                    TNTLog(@"!!!捕获到GET请求接口【%@】数据异常:%@",requestURL,exception);
                } @finally {}
            }
                break;
                
                
            case HTTPREQUEST_POST: {
                @try {
                    NSURLSessionTask *sessionTask = [manager POST:requestURL parameters:params headers:self.commonConfig.httpHeaders constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                        formDataBlock ? formDataBlock(formData) : nil;
                    } progress:^(NSProgress * _Nonnull uploadProgress) {
                        progressBlock ? progressBlock(uploadProgress) : nil;
                    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        @TNTStrongify(self);
                        if ([self.commonConfig.fetchOriginDataWhiteList containsObject:suffUrl]) {
                            // 某些特殊业务 需要直接 将原始数据返回 ---
                            success ? success(responseObject) : nil;
                        }else {
                            #warning - 此处根据实际接口文档--数据结构进行处理！！！！
                            NSString *codeStr = [NSString stringWithFormat:@"%@",responseObject[@"code"] ? responseObject[@"code"] : responseObject[@"status"] ? responseObject[@"status"] : @""];
                            if ([codeStr integerValue] == self.commonConfig.successCode) {
                                //                            // 业务逻辑匹配成功...
                                success ? success(responseObject[@"data"]) : nil;
                            }else { // 业务逻辑匹配失败 --- 吐司提示错误信息
                                NSString *msgStr = [NSString stringWithFormat:@"%@",responseObject[@"msg"] ? responseObject[@"msg"] : responseObject[@"message"] ? responseObject[@"message"] : @""];
                                TNTLog(@"逻辑错误 --- 吐司提示信息----%@",msgStr);
                            }
                        }
                        
                        // 维护请求队列 删除对应任务
                        [self removeSessionTask:task];
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        @TNTStrongify(self);
                        failure ? failure(error) : nil;
                        // 维护请求队列 删除对应任务
                        [self removeSessionTask:task];
                        
                        if (onRetryRequestSwitch) {// 开启了容错的话 会再次请求一下
                            self.POST(suffUrl, params);
                        }
                        
                    }];
                    // 维护请求队列 添加任务
                    [self addSessionTask:sessionTask];
                } @catch (NSException *exception) {
                    TNTLog(@"!!!捕获到POST请求接口【%@】数据异常:%@",requestURL,exception);
                } @finally {}
            }
                break;
            default:{
                
            }
                break;
        }
        
        return self;
    };
}

// MARK: - 添加请求任务
- (void)addSessionTask:(NSURLSessionTask *)task {
    [self.tasksArr addObject:task];
}

// MARK: - 移除请求任务
- (void)removeSessionTask:(NSURLSessionTask *)task {
    for (NSURLSessionTask *__strong subTask in self.tasksArr) {
        if ([subTask.currentRequest.URL.absoluteString isEqualToString:task.currentRequest.URL.absoluteString]) {
            [subTask cancel];
            [self.tasksArr removeObject:subTask];
            subTask = nil;
            // 同步 清除一下 获取原始数据白名单中的 数据
            // --- 意义不大，基本不会出现通一接口两种处理逻辑
            //            for (NSString *subRequestSuffUrl in self.commonConfig.fetchOriginDataWhiteList) {
            //                if ([subTask.currentRequest.URL.absoluteString hasSuffix:subRequestSuffUrl]) {
            //                    [self.commonConfig.fetchOriginDataWhiteList removeObject:subRequestSuffUrl];
            //                    break;
            //                }
            //            }
            break;
        }
    }
}

// MARK: - 获取session管理器
- (AFHTTPSessionManager *)getSessionManager {
    // 更新通用配置
    //self.updateCommonConfig ? self.updateCommonConfig(self.commonConfig) : nil;
    AFHTTPSessionManager *manager = [self sharedHttpSessionManager];
    manager.requestSerializer.timeoutInterval = self.commonConfig.requestTimeout;
    // 设置允许同时最大并发数量，过大容易出问题
    manager.operationQueue.maxConcurrentOperationCount = self.commonConfig.maxConcurrentOperationCount;
    return manager;
}

//MARK: - 线程安全的获取 sessionManager 单例对象
static AFHTTPSessionManager *manager;
- (AFHTTPSessionManager *)sharedHttpSessionManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        // 开启状态栏上的网络加载时的转动的小圈， 即 -- 所有通过AF发送的请求, 都会在电池条上出现圆圈提示
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        // 指定网络请求 响应的格式
        //    manager.responseSerializer = [AFJSONResponseSerializer serializer];
        // 可接收的 Content-Type类型
        NSArray *contentTypes = @[@"application/json",
                                  @"text/html",
                                  @"text/json",
                                  @"text/plain",
                                  @"text/javascript",
                                  @"text/xml",
                                  @"image/*",
                                  @"application/octet-stream",
                                  @"application/zip",];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:contentTypes];
        
        /*
         ** 请求头设置
         [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
         [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
         [manager.requestSerializer setValue:@"APP" forHTTPHeaderField:@"X-REQUEST-SIDE"];
         NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
         [manager.requestSerializer setValue:appVersion forHTTPHeaderField:@"App-version"];
         */
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        // AFNetworking 3.0时 请求头如下配置
        //    if (self.commonConfig.httpHeaders) {
        //        for (NSString *key in self.commonConfig.httpHeaders.allKeys) {
        //            if (self.commonConfig.httpHeaders[key]) {
        //                [manager.requestSerializer setValue:self.commonConfig.httpHeaders[key] forHTTPHeaderField:key];
        //            }
        //        }
        //    }
        
    });
    
    return manager;
}

// MARK: - 处理网络类型检测的结果
-(void)configReachabilityStatusByAFNetwork {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    @TNTWeakify(self);
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 用单例model 记录网络状态，这样可以在APP任何地方调用这个熟悉 都可以得到当前网络状态。
        @TNTStrongify(self);
        self.netWorkReachabilityStatus = status;
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                TNTLog(@"当前网络：未知");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                TNTLog(@"当前网络：网络无连接\n请检查网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                TNTLog(@"当前网络：3G|4G");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                TNTLog(@"当前网络：WiFi");
                break;
            default:
                break;
        }
    }];
}

@end
