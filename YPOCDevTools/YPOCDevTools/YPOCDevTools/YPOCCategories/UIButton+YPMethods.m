//
//  UIButton+YPMethods.m
//  YPToolsUpdate
//
//  Created by Work_Zyp on 16/5/9.
//  Copyright © 2016年 Work_Zyp. All rights reserved.
//

#import "UIButton+YPMethods.h"
#import "UIButton+WebCache.h"

#define kNorTag     100876578

@implementation UIButton (YPMethods)


- (id)initWithFrame:(CGRect)frame withBgColor:(UIColor *)bgColor withType:(UIButtonType)type withTag:(NSInteger)tag withTitle:(NSString *)title withTitleFontSize:(CGFloat)fontSize withTitleColor:(UIColor *)titleColor withTitleIsBold:(BOOL)isBold withAction:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:type];
    btn.frame = frame;
    if (bgColor != nil)
        btn.backgroundColor = bgColor;
    else
        btn.backgroundColor = [UIColor clearColor];
    
    if (!tag)
        btn.tag = kNorTag;
    else
        btn.tag = tag;
    
    if (title != nil)
        [btn setTitle:title forState:UIControlStateNormal];
    
    if (isBold)
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:fontSize];
    else
        btn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    
    if (titleColor != nil)
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
    
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (id)initWithFrame:(CGRect)frame withType:(UIButtonType)type withTag:(NSInteger)tag withNorImgName:(NSString *)norImgName withSelImgName:(NSString *)selImgName withAction:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:type];
    btn.frame = frame;
    if (!tag)
        btn.tag = kNorTag;
    else
        btn.tag = tag;
    
    if (norImgName != nil) {
        if ([norImgName hasPrefix:@"http"]) {
            [btn sd_setImageWithURL:[NSURL URLWithString:norImgName] forState:UIControlStateNormal placeholderImage:nil];
        }else{
            [btn setImage:[UIImage imageNamed:norImgName] forState:UIControlStateNormal];
        }
    }
    
    if (selImgName != nil) {
        if ([selImgName hasPrefix:@"http"]) {
            [btn sd_setImageWithURL:[NSURL URLWithString:selImgName] forState:UIControlStateSelected placeholderImage:nil];
        }else{
            [btn setImage:[UIImage imageNamed:selImgName] forState:UIControlStateSelected];
        }
    }
    
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];

    return btn;
}

- (id)initWithFrame:(CGRect)frame withBgColor:(UIColor *)bgColor withType:(UIButtonType)type withTag:(NSInteger)tag withNorImgName:(NSString *)norImgName withSelImgName:(NSString *)selImgName withTitle:(NSString *)title withTitleFontSize:(CGFloat)fontSize withTitleColor:(UIColor *)titleColor withTitleIsBold:(BOOL)isBold withAction:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:type];
    btn.frame = frame;
    if (bgColor != nil)
        btn.backgroundColor = bgColor;
    else
        btn.backgroundColor = [UIColor clearColor];
    
    if (!tag)
        btn.tag = kNorTag;
    else
        btn.tag = tag;
    
    if (norImgName != nil) {
        if ([norImgName hasPrefix:@"http"]) {
            [btn sd_setImageWithURL:[NSURL URLWithString:norImgName] forState:UIControlStateNormal placeholderImage:nil];
        }else{
            [btn setImage:[UIImage imageNamed:norImgName] forState:UIControlStateNormal];
        }
    }
    
    if (selImgName != nil) {
        if ([selImgName hasPrefix:@"http"]) {
            [btn sd_setImageWithURL:[NSURL URLWithString:selImgName] forState:UIControlStateSelected placeholderImage:nil];
        }else{
            [btn setImage:[UIImage imageNamed:selImgName] forState:UIControlStateSelected];
        }
    }
    
    if (title != nil)
        [btn setTitle:title forState:UIControlStateNormal];
    
    if (isBold)
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:fontSize];
    else
        btn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    
    if (titleColor != nil)
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
  
    if (action) {
        [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    return btn;
    
}


@end
