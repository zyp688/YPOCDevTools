//
//  TNTInterface.h
//  YPOCDevTools
//
//  Created by WorkZyp on 2020/9/24.
//  Copyright © 2020 Zyp. All rights reserved.
//

#ifndef TNTInterface_h
#define TNTInterface_h

/**DEBUG  模式下打印日志,当前行*/
#ifdef DEBUG
#define TNTLog(FORMAT, ...)      fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define TNTLog(...)
#endif

/** 声明临时指针 --- 强弱引用，避免Block循环引用*/
#ifndef TNTWeakify
#if DEBUG
#if __has_feature(objc_arc)
#define TNTWeakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define TNTWeakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define TNTWeakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define TNTWeakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef TNTStrongify
#if DEBUG
#if __has_feature(objc_arc)
#define TNTStrongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define TNTStrongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define TNTStrongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define TNTStrongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif



// ------------------------⏬ 【基础请求地址-接口前缀】配置区 ⏬------------------------
/** **明 本地环境 调试地址*/
static NSString *const TNTHttpBaseURL = @"https://api.seniverse.com";
/** 测试 环境 调试地址*/
// static NSString *const TNTHttpBaseURL = @"http://www.baidu.com/api";
/** 生产 环境 线上地址*/
// static NSString *const TNTHttpBaseURL = @"http://www.baidu.com/api";

// ------------------------⏫ 【基础请求地址-接口前缀】配置区 ⏫------------------------





// ------------------------⏬ 【业务模块请求地址-接口后缀】配置区 ⏬------------------------
/** 获取天气URL*/
static NSString *const TNTGetWetherURL = @"/v3/weather/now.json";
/** 上传图片URL*/
static NSString *const TNTUploadImageURL = @"/v3/weather/now.json";


// ------------------------⏫ 【业务模块请求地址-接口后缀】配置区 ⏫------------------------






#endif /* TNTInterface_h */
