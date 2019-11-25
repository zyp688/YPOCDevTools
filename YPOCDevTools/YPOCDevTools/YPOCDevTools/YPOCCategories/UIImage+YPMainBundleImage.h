//
//  UIImage+YPMainBundleImage.h
//  YPToolsUpdate
//
//  Created by Work_Zyp on 2017/1/10.
//  Copyright © 2017年 Work_Zyp. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YPIconImageSize) {
    YPIconImageSize29,
    YPIconImageSize40,
    YPIconImageSize60
};

@interface UIImage (YPMainBundleImage)

/** 返回LaunchImage*/
+ (UIImage *)yp_getLaunchImage;

/** 返回size尺寸的IconImage*/
+ (UIImage *)yp_getIconImageWithSize:(YPIconImageSize)iconImageSize;



@end
