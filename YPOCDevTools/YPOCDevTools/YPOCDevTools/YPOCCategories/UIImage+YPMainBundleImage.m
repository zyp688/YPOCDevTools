//
//  UIImage+YPMainBundleImage.m
//  YPToolsUpdate
//
//  Created by Work_Zyp on 2017/1/10.
//  Copyright © 2017年 Work_Zyp. All rights reserved.
//

#import "UIImage+YPMainBundleImage.h"

static NSString *YPGetIconString(YPIconImageSize iconSize) {
    
    NSString *iconS = nil;
    switch (iconSize) {
        case YPIconImageSize29: {
            iconS = @"29";
            break;
        }
        case YPIconImageSize40: {
            iconS = @"40";
            break;
        }
        case YPIconImageSize60: {
            iconS = @"60";
            break;
        }
    }
    return iconS;
}

@implementation UIImage (YPMainBundleImage)

+ (NSString *)yp_getLaunchImageName {
    NSString *viewOrientation = (UIInterfaceOrientationIsLandscape(
                                                                   [[UIApplication sharedApplication] statusBarOrientation]))
    ? @"Landscape"
    : @"Portrait";
    NSString *launchImageName = nil;
    NSArray *launchImagesArray =
    [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    for (NSDictionary *dict in launchImagesArray) {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        
        if (CGSizeEqualToSize(imageSize, screenSize) &&
            [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            launchImageName = dict[@"UILaunchImageName"];
        }
    }
    return launchImageName;
}

+ (UIImage *)yp_getLaunchImage {
    return [UIImage imageNamed:[self yp_getLaunchImageName]];
}

+ (NSString *)yp_getIconImageNameWithSize:(YPIconImageSize)iconImageSize {
    NSArray *iconArr = [[[[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleIcons"]
                         objectForKey:@"CFBundlePrimaryIcon"] objectForKey:@"CFBundleIconFiles"];
    
    NSString *iconString = nil;
    NSString *iconSize = YPGetIconString(iconImageSize);
    
    for (NSString *string in iconArr) {
        NSRange range = [string rangeOfString:iconSize];
        if (range.location != NSNotFound) {
            iconString = string;
            NSLog(@"%@", iconString);
        } else {
            NSLog(@"Not Found");
        }
    }
    return iconString;
}

+ (UIImage *)yp_getIconImageWithSize:(YPIconImageSize)iconImageSize {
    return [UIImage imageNamed:[self yp_getIconImageNameWithSize:iconImageSize]];
}



@end
