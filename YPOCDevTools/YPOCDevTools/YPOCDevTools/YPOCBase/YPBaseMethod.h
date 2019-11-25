//
//  YPBaseMethod.h
//  YPToolsUpdate
//
//  Created by Work_Zyp on 13/5/11.
//  Copyright © 2013年 Work_Zyp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

/**
 @brief 可用于被检测的输入内容---类型
 @see INPUTSTRINGCHECKTYPE
 */
typedef enum {
    /** *电话号码 */
    INPUTSTRINGCHECK_MOBILENUMBER,
    /** *邮箱 */
    INPUTSTRINGCHECK_EMAIL,
    /** *身份证号 */
    INPUTSTRINGCHECK_IDENTITYCARD,
    /** *emoji表情 */
    INPUTSTRINGCHECK_HASEMOJI,
    
}INPUTSTRINGCHECKTYPE;

/**
 @brief 时间转换后显示的格式
 @see DATESHOWTYPE
 */
typedef enum {
    /** *YYYY-MM-dd HH:mm:ss 年月日 时分秒*/
    DATESHOW_YMD_HMS,
    /** *YYYY-MM-dd HH:mm 年月日 时分*/
    DATESHOW_YND_HM,
    /** *YYYY-MM-dd 年月日*/
    DATESHOW_YMD,
    
}DATESHOWTYPE;

/**
 @brief 通用常用的一些方法总结 工具类
 */
@interface YPBaseMethod : NSObject

//-----------------Attributes属性⬇️----------------------

//-----------------Attributes属性⬆️----------------------


//！-----------------Methods方法⬇️----------------------

/**
 @brief 检测相机是否被拒绝使用的状态
 @return    相机是否获得用户授权的状态
 */
+ (BOOL)yp_getCameraPermissionStatus;

/**
 @brief 检测输入的内容是否合法
 @param checkType   检测的类型:INPUTSTRINGCHECKTYPE，支持手机，邮箱，身份证检测
 */
+ (BOOL)yp_isValidateWithInputString:(NSString *)str checkType:(INPUTSTRINGCHECKTYPE)checkType;

/**
 @brief 兼容iOS6隐藏系统Tabbar的方法
 @param hide    是否隐藏
 @param tabBarController    操作是否隐藏的tabBarController对象
 */
+ (void)yp_makeTabBarHidden:(BOOL)hide withTabBarController:(nullable UITabBarController *)tabBarController;

/**
 @brief 打印工程库内所有的字体库
*/
+ (void)yp_logAllCharacterStyle;

/**
 @brief Unix时间戳 转 时间格式的字符串
 @param unixTime    待转换的unix时间戳
 @param isSecond    是否为秒级的转换 秒级时间戳:10位 毫秒级:13位
 @param showType    显示的类型
 @return    DATESHOWTYPE--符合showType对应类型的时间的字符串
 */
+ (NSString *)yp_timeStrWithUnixTime:(double)unixTime isSecondLev:(BOOL)isSecond withDateShowType:(DATESHOWTYPE)showType;

/**
 @brief 根据文字字号获取lab高度值
 @param str 内容
 @param font    字体
 @param width   控件宽度
 @return    高度值
 */
+ (CGFloat)yp_labelHeightofString:(nullable NSString *)str
                        withFont:(nullable UIFont *)font
                       withWidth:(CGFloat)width;

/**
 @brief 根据文字字号获取lab宽度值
 @param str 内容
 @param font    字体
 @param height  控件高度
 @return    宽度值
 */
+(CGFloat)yp_labelWidthOfString:(nullable NSString *)str
                       withFont:(nullable UIFont *)font
                     withHeight:(CGFloat)height;

//！-----------------Methods方法⬆️----------------------

@end



/*! 废弃...
 根据色值 如：@"ffffff"  返回颜色值
+ (nullable UIColor *)yp_colorFromHexString:(nullable NSString *)hexString;
 设置行间距
+ (void)yp_setLableSpaceWithString:(nullable NSString *)str withLineSpacing:(CGFloat)LineSpacing withLable:(nullable UILabel *)lable;
 
  模拟显示网络加载状态
+ (void)yp_simulateRequestDataWithSourceViewController:(nullable UIViewController *)vc withWatiTime:(NSTimeInterval)waitTime;
*/
