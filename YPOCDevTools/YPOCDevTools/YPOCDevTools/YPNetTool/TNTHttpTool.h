//
//  TNTHttpTool.h
//  TNTOCDevTools
//
//  Created by TNT on 2020/8/20.
//  Copyright © 2020 TNT. All rights reserved.
//  链式编程工具  --- 依赖【AFNetWorking 4.0】的 网络请求工具类

#import <Foundation/Foundation.h>

#import "AFNetworking.h"
#import "TNTInterface.h"

static CGFloat const compressionQuality = 0.01; ///> 上传图片的压缩比例
#warning -TODO!!! 不调试时，推荐关闭
static BOOL const onDebug = YES; ///> 是否开启打印输出网络请求日志的模式
static NSTimeInterval const requestTimeout = 30; ///> 请求超时时间配置
static NSInteger const maxConcurrentOperationCount = 5; ///> 最大请求并发数配置， 不宜过大！ 容易衍生出问题
static BOOL const onRetryRequestSwitch = YES; ///> 请求出错时，主动进行容错 【如果开启，则会触发一次递归容错】
static NSDictionary * const httpHeaders = nil; ///> 请求头字典配置
#warning -TODO!!! 必须配置 === 逻辑请求正常时的状态码
static NSInteger const successCode = 200; ///> 请求成功的状态码 --- 【结合不通的后台逻辑业务进行处理】



// ------------------------⏬ 【Config】通用配置 ⏬------------------------
@interface TNTHttpCommonConfig : NSObject

@end
// ------------------------⏫ 【Config】通用配置 ⏫------------------------



// ------------------------⏬ 【Block】声明区 ⏬------------------------
/**
 @brief - 声明 POST 上传数据时的Block
 @param formData - 上传的数据
*/
typedef void(^FormDataBlock)(id<AFMultipartFormData> formData);

/**
 @brief - 声明 请求进度的Block
 @param progress - 进度
*/
typedef void(^ProgressBlock)(NSProgress *progress);

/**
 @brief - 声明 网络请求成功时的回调Block
 @param responseObject - 数据结果
*/
typedef void(^SuccessBlock)(id responseObject);

/**
 @brief - 声明 网络请求失败时的回调Block
 @param error - 错误
*/
typedef void(^FailureBlock)(NSError *error);

/**
 @brief - 声明 网络请求完成时的回调Block，不论成功或者失败，都会调用
 @param error - 错误
 @param responseObject - 数据结果
*/
typedef void(^CompleteBlock)(NSError *error, id responseObject);
// ------------------------⏫ 【Block】声明区 ⏫------------------------



@interface TNTHttpTool : NSObject

// ------------------------⏬ 【Methods】方法区 ⏬------------------------

/**
 @brief -多线程获取单例对象
 @return    - 返回单例对象
*/
+ (instancetype)sharedInstance;

/**
 @brief - 更新基础配置
 @return    工具对象本身
 @discussion    - 不对外暴露了.
 //@property (copy, nonatomic) void (^updateCommonConfig)(TNTHttpCommonConfig *config);
*/


/**
 @brief - 获取原始数据
 @param  suffUrl - 请求后缀 直接将对应后缀的请求加入白名单，将此请求响应的原始数据返回
 @return    工具对象本身
*/
@property (copy, nonatomic) TNTHttpTool*(^fetchOriginData)(NSString *suffUrl);

/**
 @brief - Http GET请求
 @param  suffUrl - 请求后缀
 @param  params - 请求参数
 
 @return    工具对象本身
*/
@property (copy, nonatomic) TNTHttpTool*(^GET)(NSString *suffUrl,NSDictionary *params);

/**
 @brief - Http POST请求
 @param  suffUrl - 请求后缀
 @param  params - 请求参数
 
 @return    工具对象本身
*/
@property (copy, nonatomic) TNTHttpTool*(^POST)(NSString *suffUrl,NSDictionary *params);


/**
 @brief - 上传一张图片请求
 @param  suffUrl - 请求后缀
 @param  image - 对应上传的图片
 
 @return    工具对象本身
*/
@property (copy, nonatomic) TNTHttpTool*(^uploadOneImage)(NSString *suffUrl,UIImage *image, ProgressBlock progressBlock);

/**
 @brief - 上传多张图片请求 【图片二进制数据循环上传】
 @param  suffUrl - 请求后缀
 @param  images - 对应上传的多张图片的数组
 @param  progressBlock - 上传进度
 
 @return    工具对象本身
*/
@property (copy, nonatomic) TNTHttpTool*(^uploadMultipleImages)(NSString *suffUrl,NSArray <UIImage*>*images, ProgressBlock progressBlock);

/**
 @brief - 上传多张图片请求【递归方式，一张一张的传】
 @param  suffUrl - 请求后缀
 @param  images - 对应上传的多张图片的数组
 @param  progressBlock - 上传进度
 @param  idx - 初始上传图片 在数组中对应的索引值
 @return    工具对象本身
*/
@property (copy, nonatomic) TNTHttpTool*(^uploadMultipleImagesOneByOne)(NSString *suffUrl,NSArray <UIImage*>*images, ProgressBlock progressBlock, NSUInteger idx);

/**
 @brief - Http 通用请求
 @param  method - 请求方式
 @param  preUrl - 请求前缀
 @param  suffUrl - 请求后缀
 @param  params - 请求参数

 @return    工具对象本身
*/
@property (copy, nonatomic) TNTHttpTool*(^REQUEST)(NSString *method, NSString *preUrl, NSString *suffUrl, ProgressBlock progressBlock, FormDataBlock formDatablock, NSDictionary *params, SuccessBlock success, FailureBlock failure);

//- (TNTHttpTool *)requestWithMethod:(NSString *)method preUrl:(NSString *)preUrl suffUrl:(NSString *)suffUrl formData:(NSData *)data params:(NSDictionary *)params success:(SuccessBlock )success failure:(FailureBlock )failure;

// ------------------------⏫ 【Methods】方法区 ⏫------------------------




// ------------------------⏬ 【Attributes】属性区 ⏬ ------------------------

@property (strong, nonatomic) TNTHttpCommonConfig *commonConfig;

/** 监听的网络状态持有者*/
@property (assign, nonatomic) AFNetworkReachabilityStatus netWorkReachabilityStatus;

/** 请求成功后的异步回调*/
@property (copy, nonatomic) SuccessBlock success;

/** 请求失败后的异步回调*/
@property (copy, nonatomic) FailureBlock failure;

/** 请求完成后的异步回调- 忽略成功与失败*/
@property (copy, nonatomic) CompleteBlock complete;

// ------------------------⏫ 【Attributes】属性区 ⏫ ------------------------

@end




