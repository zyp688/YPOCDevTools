//
//  UIImage+YPMethods.h
//  YPToolsUpdate
//
//  Created by Work_Zyp on 2017/1/10.
//  Copyright © 2017年 Work_Zyp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (YPMethods)

/** 返回的图片拉伸不变形*/
+ (UIImage *)yp_resizableImage:(NSString *)imageName;

/** 将颜色合成图片*/
+ (UIImage *)yp_imageWithColor:(UIColor *)color;

/** 返回一个圆角矩形的描边图片*/
+ (UIImage *)yp_imageWithCornerSize:(CGSize)size strokeColor:(UIColor *)strokeColor;

/** 图片截取处理*/
+ (UIImage *)yp_rotateImage:(UIImage *)image;

/** view转化成image*/
+ (UIImage *)yp_imageWithView:(UIView *)view;

/** 把image切成圆角*/
- (UIImage *)yp_imageWithCornerSize:(CGSize)size fillColor:(UIColor *)fillColor;




@end
