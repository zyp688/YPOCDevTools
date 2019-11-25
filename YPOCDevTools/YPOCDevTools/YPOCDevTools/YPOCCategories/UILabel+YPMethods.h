//
//  UILabel+YPMethods.h
//  YPToolsUpdate
//
//  Created by Work_Zyp on 16/5/6.
//  Copyright © 2016年 Work_Zyp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YPBaseMethod.h"


@interface UILabel (YPMethods)

/**
 @brief target-action 为label直接添加点击响应事件
 */
@property (strong, nonatomic) id target;
@property (assign, nonatomic) SEL action;
/**
 *  添加点击事件的方法
 *
 *  @param target 响应者
 *  @param action 响应方法
 */
- (void)addTarget:(id)target action:(SEL)action;

/**
 *  快速定制Lable 无title
 *
 *  @param frame   大小
 *  @param bgColor 背景颜色
 *
 *  @return UILabel对象
 */
- (id)initWithFrame:(CGRect)frame withBgColor:(UIColor *)bgColor;

/**
 *  快速定制Label 有title
 *
 *  @param frame         大小
 *  @param bgColor       背景色
 *  @param text          文字
 *  @param textColor     文字颜色
 *  @param textAlignment 文字对齐方式
 *  @param fontSize      文字大小
 *  @param isBold        文字是否加粗
 *  @param isAuto   Label自适应文字高度开关
 *  @return UILabel对象
 */
- (id)initWithFrame:(CGRect)frame withBgColor:(UIColor *)bgColor withText:(NSString *)text withTextColor:(UIColor *)textColor withTextAlignment:(NSTextAlignment)textAlignment withFontSize:(CGFloat)fontSize withIsBold:(BOOL)isBold withAutoHeight:(BOOL)isAuto;


@end
