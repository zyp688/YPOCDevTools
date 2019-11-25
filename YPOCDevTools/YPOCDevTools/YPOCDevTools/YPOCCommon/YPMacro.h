//
//  YPMacro.h
//  YPToolsUpdate
//
//  Created by Work_Zyp on 2017/5/5.
//  Copyright © 2017年 Work_Zyp. All rights reserved.
//

#ifndef YPMacro_h
#define YPMacro_h


//----------------------系统⬇️----------------------------
/** 获取系统版本*/
#define kYP_iOS_VERSION     ([[[UIDevice currentDevice] systemVersion] floatValue])
#define kYP_CURRENT_SYSTEM_VERSION      ([[UIDevice currentDevice] systemVersion])
/** 获取当前语言*/
#define kYP_CURRENT_LANGUAGE        ([[NSLocale preferredLanguages] objectAtIndex:0])
/** 是否高于iOS对应value的系统（包涵iOS对应的系统value）eg:kYP_OVER_iOS_SYSTEM(8.0) */
#define kYP_OVER_iOS_SYSTEM(value)      (([[[UIDevice currentDevice] systemVersion] floatValue] >= (value)) ? YES : NO)

//判断是否 Retina屏,设备是否iPhone5
#define kYP_SCREEN_ISRETINA     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
/** 判断是否为iPhone */
#define kYP_DEVICE_ISIPHONE     (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
/** 判断是否是iPad */
#define kYP_DEVICE_ISIPAD       (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
/** 判断是否为iPod */
#define kYP_DEVICE_ISIPOD       ([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"])

/** 设备是否为iPhone 4/4S 分辨率320x480，像素640x960，@2x */
#define kYP_DEVICE_ISIPHONE_4       ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
/** 设备是否为iPhone 5C/5/5S 分辨率320x568，像素640x1136，@2x */
#define kYP_DEVICE_ISIPHONE_5       ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
/** 设备是否为iPhone 6 分辨率375x667，像素750x1334，@2x */
#define kYP_DEVICE_ISIPHONE_6       ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
/** 设备是否为iPhone 6 Plus 分辨率414x736，像素1242x2208，@3x */
#define kYP_DEVICE_ISIPHONE_6P      ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
/** 设备是否为iPhone X 响应11系统，具备安全区 */
#define kYP_DEVICE_ISIPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})


/**判断是真机还是模拟器*/
#if TARGET_OS_IPHONE
//iPhone Device
#endif
#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif

//检查系统版本
#define kYP_SYSTEM_VERSION_EQUAL_TO(v)      ([[[UIDevice currentDevice] systemVersion] compare:(v) options:NSNumericSearch] == NSOrderedSame)
#define kYP_SYSTEM_VERSION_GREATER_THAN(v)      ([[[UIDevice currentDevice] systemVersion] compare:(v) options:NSNumericSearch] == NSOrderedDescending)
#define kYP_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)      ([[[UIDevice currentDevice] systemVersion] compare:(v) options:NSNumericSearch] != NSOrderedAscending)
#define kYP_SYSTEM_VERSION_LESS_THAN(v)     ([[[UIDevice currentDevice] systemVersion] compare:(v) options:NSNumericSearch] == NSOrderedAscending)
#define kYP_SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:(v) options:NSNumericSearch] != NSOrderedDescending)

//----------------------系统⬆️----------------------------



//-------------------UI布局相关Frame⬇️-------------------------
/**  keyWindow 主窗口*/
#define kYP_KEY_WINDOW      [UIApplication sharedApplication].keyWindow

/** 获取屏幕 宽度、高度*/
#define kYP_SCREEN_W        ([UIScreen mainScreen].bounds.size.width)
#define kYP_SCREEN_H        ([UIScreen mainScreen].bounds.size.height)

/**  设置Frame*/
#define kYP_RectMake(x,y,width,height)      CGRectMake((x), (y), (width), (height))
/**  设置Size*/
#define kYP_SizeMake(width,height)      CGSizeMake((width), (height))
/**  屏幕宽度实际值比例系数 414*/
#define kYP_ScaleW      (kScreenWidth / 414.0)
/**  屏幕宽度像素比例系数  1242*/
#define kYP_PixScaleW       (kScreenWidth / 1242.0)
/** x,y正常传，witdth，height传入像素读取值*/
#define kYP_RectWHPix(x,y,width,height)     CGRectMake(x, y, (width) * kYPPixScaleW, (height) * kYPPixScaleW)
/**  x，y，width，height全像素取点*/
#define kYP_RectPix(x,y,width,height)       CGRectMake((x) * kYPPixScaleW, (y) * kYPPixScaleW, (width) * kYPPixScaleW, (height) * kYPPixScaleW)

/** 常用控件高度*/
#define kYP_TabBar_Height        49.0f
#define kYP_StatusBar_Height     20.0f
#define kYP_NavigationBar_Height     44.0f
// 导航整体高度下的原点Y
#define kYP_Nav_Origin_Y        (kYP_DEVICE_ISIPHONE_X ? 88.0 : 64.0)

//-------------------UI布局相关Frame⬆️-------------------------



//-------------------打印日志⬇️-------------------------
/**DEBUG  模式下打印日志,当前行*/
#ifdef DEBUG

#define YPLog(FORMAT, ...)      fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

#else

#define YPLog(...)

#endif

//#ifdef DEBUG
//#   define YPLog(fmt, ...) NSLog((@"[类 方法]%s 行数:[Line %d] 打印内容:"fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
//#else
//#   define YPLog(...)
//#endif

//Printing while in the debug model and pop an alert.       模式下打印日志,当前行 并弹出一个警告
#ifdef DEBUG
#   define ULog(fmt, ...)       { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
#else
#   define ULog(...)
#endif

/** print 打印rect,size,point */
#ifdef DEBUG
#define kYPLogPoint(point)      NSLog(@"%s = { x:%.4f, y:%.4f }", #point, point.x, point.y)
#define kYPLogSize(size)        NSLog(@"%s = { w:%.4f, h:%.4f }", #size, size.width, size.height)
#define kYPLogRect(rect)        NSLog(@"%s = { x:%.4f, y:%.4f, w:%.4f, h:%.4f }", #rect, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
#endif
//-------------------打印日志⬆️-------------------------



//----------------------内存⬇️----------------------------
/** 使用ARC和不使用ARC*/
#if __has_feature(objc_arc)
//compiling with ARC
#else
// compiling without ARC
#endif

/** 释放一个对象*/
#define kYP_SAFE_RELEASE(_id_)      if(_id_) { [_id_ release], _id_ = nil; }

/**  弱引用*/
#define kYP_Weakify(_id_)        __weak typeof(_id_)  weak##_id_ = _id_;
///**  强引用*/
#define kYP_Strongify(_id_)      __strong typeof(_id_)  _id_ = weak##_id_;

//----------------------内存⬆️----------------------------



//----------------------图片⬇️----------------------------
/** 读取本地图片，不缓存，适用于不常用的大图，只能访问工程根木录条件下的图片*/
#define kYP_ImageWithResourceAndType(_file_,_ext_)      [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:_file_ ofType:_ext_]]
/** 读取本地图片，不缓存，适用于不常用的大图，只能访问工程根木录条件下的图片*/
#define kYP_ImageWithResource(_file_)       kYP_ImageWithResourceAndType(_file_,nil)
/** 定义UIImage对象，自动缓存，适用于程序常用的小图片，并且能够访问Assets.ccassets文件下的图片*/
#define kYP_ImageNamed(_name_)      [UIImage imageNamed:_name_]
//建议使用前两种宏定义,性能高于后者 PS：前两种


//----------------------图片⬆️----------------------------



//----------------------颜色类⬇️---------------------------
/** rgb颜色转换(16进制->10进制)*/
#define kYP_HEX_Color(value)        [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0 green:((float)((value & 0xFF00) >> 8))/255.0 blue:((float)(value & 0xFF))/255.0 alpha:1.0]
/** 带有RGBA的颜色设置*/
#define kYP_RGBA_Color(R, G, B, A)      [UIColor colorWithRed:(R)/255.0 green:(G)/255.0 blue:(B)/255.0 alpha:(A)]
/** 获取RGB颜色*/
#define kYP_RGB_Color(r,g,b)        kYP_RGBA_Color(r,g,b,1.0f)
/** 透明色*/
#define kYP_Clear_Color     [UIColor clearColor]
/**  随机颜色*/
#define kYP_Random_Color        kYP_RGB_Color(arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256))

/**  常用色值*/
#define kYP_COLOR_BLUE             kYP_HEX_Color(0x41CEF2)
#define kYP_COLOR_GRAY             kYP_HEX_Color(0xababab) //171
#define kYP_COLOR_333               kYP_HEX_Color(0x333333) //51
#define kYP_COLOR_666               kYP_HEX_Color(0x666666) //102
#define kYP_COLOR_888               kYP_HEX_Color(0x888888) //136
#define kYP_COLOR_999               kYP_HEX_Color(0x999999) //153
#define kYP_COLOR_PLACEHOLD         kYP_HEX_Color(0xc5c5c5) //197
#define kYP_COLOR_RED               kYP_HEX_Color(0xff5400) //红色
#define kYP_COLOR_GREEN             kYP_HEX_Color(0x31d8ab)//绿色
#define kYP_COLOR_YELLOW              kYP_HEX_Color(0xffa200)//黄色
#define kYP_COLOR_SEPARATE_LINE        kYP_HEX_Color(0xC8C8C8)//200
#define kYP_COLOR_LIGHTGRAY            kYP_RGBA_Color(200, 200, 200, 0.4)//淡灰色

//----------------------颜色类⬆️--------------------------



//----------------------通知中心⬇️--------------------------
/**  通知对象*/
#define kYP_NotificationCenter      [NSNotificationCenter defaultCenter]
/**  发通知*/
#define kYP_PostNotification(_name_,_obj_)      [kYP_NotificationCenter postNotificationName:_name_ object:_obj_]
/**  接收通知*/
#define kYP_AddObserver(_action_,_name_)        [kYP_NotificationCenter addObserver:self selector:@selector(_action_) name:_name_ object:nil]
/** 移除对象所有通知*/
#define kYP_RemoveAllObserver(_id_)     [[NSNotificationCenter defaultCenter] removeObserver:_id_]
/** 移除对象指定通知*/
#define kYP_RemoveObserverWithName(_id_,_name_,_obj_)       [[NSNotificationCenter defaultCenter] removeObserver:_id_ name:_name_ object:_obj_];
//----------------------通知中心⬆️--------------------------



//----------------------本地沙盒⬇️--------------------------
#define kYP_UserDefaults        [NSUserDefaults standardUserDefaults]
/** 根据Key值保存Object到沙盒中*/
#define kYP_UserDefaultsSetObjectForKey(_object_,_key_)     \
{\
[kYP_UserDefaults setObject:_object_ forKey:_key_];\
[kYP_UserDefaults synchronize];\
}
/** 根据Key值获取沙盒中对应的内容*/
#define kYP_UserDefaultsValueForKey(_key_)      [kYP_UserDefaults valueForKey:(_key_)]
/** 根据Key值删除沙盒中对应的内容*/
#define kYP_UserDefaultsRemoveObjectForKey(_key_) \
{\
[kYP_UserDefaults removeObjectForKey:_key_];\
[kYP_UserDefaults synchronize];\
}
//----------------------本地沙盒⬆️--------------------------



//----------------------GCD⬇️----------------------------
#define kYP_GCDWithGlobal(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define kYP_GCDWithMain(block) dispatch_async(dispatch_get_main_queue(),block)
//----------------------GCD⬆️----------------------------


//----------------------常用的一些设置⬇️----------------------------
/**  系统 普通字体*/
#define kYP_System_FontSize(fSize)      [UIFont systemFontOfSize:(fSize)]
/**  系统 加粗字体*/
#define kYP_System_BoldFontSize(fSize)      [UIFont boldSystemFontOfSize:(fSize)]
/** 是否存在系统外的默认字体 更改值为YES or NO*/
#define kYP_HasCustomFont      NO
/**  系统外的默认字体库的名字*/
#define kYP_CustomFontName     @"HiraMinProN-W3"
#define kYP_CustomBoldFontName     @""
// --- 使用字体
/**  控件基础字体设置 非加粗*/
#define kYP_BaseNorFont(fSize)      kYP_HasCustomFont ? [UIFont fontWithName:kYP_CustomFontName size:(fSize)] : kYP_System_FontSize(fSize)
/**  控件基础字体设置 加粗*/
#define kYP_BaseBoldFont(fSize)     kYP_HasCustomFont ? [UIFont fontWithName:kYP_CustomBoldFontName size:(fSize)] : kYP_System_BoldFontSize(fSize)

/** 显示加载loading*/
#define kYP_MBProgressHUD_Show(_view_)        [MBProgressHUD showHUDAddedTo:_view_ animated:YES];
/** 隐藏加载loading*/
#define kYP_MBProgressHUD_Hide(_view_)       [MBProgressHUD hideHUDForView:_view_ animated:YES]
//[MBProgressHUD hideAllHUDsForView:view animated:YES]


/** kUrlByStr 拿到URL*/
#define kYP_UrlByStr(_str_)      [NSURL URLWithString:_str_]
/**  安全拿到字符串对象*/
#define kYP_SafeGetString(_str_)         [NSString stringWithFormat:@"%@",_str_]
/** 兼容各种情况下的 字符串为空*/
#define kYP_StringISNull(_str_)    ([kYP_SafeGetString(_str_) isEqual:@"NULL"] || [kYP_SafeGetString(_str_) isKindOfClass:[NSNull class]] || [kYP_SafeGetString(_str_) isEqual:[NSNull null]] || [kYP_SafeGetString(_str_) isEqual:NULL] || [[kYP_SafeGetString(_str_) class] isSubclassOfClass:[NSNull class]] || kYP_SafeGetString(_str_) == nil || kYP_SafeGetString(_str_) == NULL || [[kYP_SafeGetString(_str_) stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0 || [kYP_SafeGetString(_str_) isEqualToString:@"<null>"] || [kYP_SafeGetString(_str_) isEqualToString:@"(null)"]) || kYP_SafeGetString(_str_).length == 0 ? YES : NO


/** 快速查询一段代码的执行时间 */
/** 用法
 TICK
 do your work here
 TOCK
 */
#define TICK NSDate *startTime = [NSDate date];
#define TOCK NSLog(@"Time:%f", -[startTime timeIntervalSinceNow]);

/**  单例化一个类*/
#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname) \
\
static classname *shared##classname = nil; \
\
+ (classname *)shared##classname \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [[self alloc] init]; \
} \
} \
\
return shared##classname; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [super allocWithZone:zone]; \
return shared##classname; \
} \
} \
\
return nil; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return self; \
}

/** 消除一些警告⚠️  屏蔽掉指针变更的警告*/
#define kYP_SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)
/** 应用 YPSuppressPerformSelectorLeakWarning(
 [_target performSelector:_action withObject:self]
 );
 
 id result;
 SuppressPerformSelectorLeakWarning(
 result = [_target performSelector:_action withObject:self]
 );
 */




//----------------------常用的一些设置⬆️----------------------------


//----------------------默认设置信息⬇️----------------------------
/**  请求数据错误时的提示信息*/
#define kYP_DEFAULT_ERROR_TIP      @"网络访问异常，请重试~"
/** 默认背景色*/
#define kYP_DEFAULT_BGCOLOR      kYP_RGB_Color(242,236,231)
/**  网络加载未完成时，默认展示的加载中的图片*/
#define kYP_DEFAULT_WAITING_IMAGE     kYP_ImageWithResourceAndType(@"",@"png")
/**  控件设置时默认的Tag值*/
#define kYP_DEFAULT_TAG     (arc4random() % 1000000 + 1000000)
//----------------------默认设置信息⬆️----------------------------




#endif /* YPMacro_pch */
