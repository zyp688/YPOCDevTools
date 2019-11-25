//
//  UIButton+YPMethods.h
//  YPToolsUpdate
//
//  Created by Work_Zyp on 16/5/9.
//  Copyright © 2016年 Work_Zyp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (YPMethods)

/**
 *  快速定制Button 【有文字无图片】
 *
 *  @param frame      大小
 *  @param bgColor    背景色
 *  @param type       UIButtonType
 *  @param tag        tag值
 *  @param title      文字
 *  @param fontSize   文字大小
 *  @param titleColor 文字颜色
 *  @param isBold     文字是否加粗
 *  @param action     点击事件
 *
 *  @return UIButton对象
 */
- (id)initWithFrame:(CGRect)frame withBgColor:(UIColor *)bgColor withType:(UIButtonType)type withTag:(NSInteger)tag withTitle:(NSString *)title withTitleFontSize:(CGFloat)fontSize withTitleColor:(UIColor *)titleColor withTitleIsBold:(BOOL)isBold withAction:(SEL)action;

/**
 *  快速定制Button 【无文字 有图片】
 *
 *  @param frame      大小
 *  @param type       UIButtonType
 *  @param tag        tag值
 *  @param norImgName 默认图片
 *  @param selImgName 选中图片
 *  @param action     点击事件
 *
 *  @return UIButton对象
 */
- (id)initWithFrame:(CGRect)frame withType:(UIButtonType)type withTag:(NSInteger)tag withNorImgName:(NSString *)norImgName withSelImgName:(NSString *)selImgName withAction:(SEL)action;

/**
 *  快速定制Button 【有文字 有图片】
 *
 *  @param frame      大小
 *  @param type       UIButtonType
 *  @param tag        tag值
 *  @param norImgName 默认图片
 *  @param selImgName 选中图片
 *  @param title      文字
 *  @param fontSize   文字大小
 *  @param titleColor 文字颜色
 *  @param isBold     文字是否加粗
 *  @param action     点击事件
 *
 *  @return UIButton对象
 */
- (id)initWithFrame:(CGRect)frame withBgColor:(UIColor *)bgColor withType:(UIButtonType)type withTag:(NSInteger)tag withNorImgName:(NSString *)norImgName withSelImgName:(NSString *)selImgName withTitle:(NSString *)title withTitleFontSize:(CGFloat)fontSize withTitleColor:(UIColor *)titleColor withTitleIsBold:(BOOL)isBold withAction:(SEL)action;




@end
