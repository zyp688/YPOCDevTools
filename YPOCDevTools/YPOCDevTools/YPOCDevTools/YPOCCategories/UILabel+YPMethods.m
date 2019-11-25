//
//  UILabel+YPMethods.m
//  YPToolsUpdate
//
//  Created by Work_Zyp on 16/5/6.
//  Copyright © 2016年 Work_Zyp. All rights reserved.
//

#import "UILabel+YPMethods.h"
#import "YPBaseMethod.h"
#import "UIView+Extention.h"
#import <objc/runtime.h>


const void *NSObject_label_key_target = @"NSObject_label_key_target";
const void *NSObject_label_key_action = @"NSObject_label_key_action";

@implementation UILabel (YPMethods)

@dynamic target;
- (id)target {
    id object = objc_getAssociatedObject(self, NSObject_label_key_target);
    return object;
}
- (void)setTarget:(id)target {
    [self willChangeValueForKey:@"target"];
    objc_setAssociatedObject(self, NSObject_label_key_target, target, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"target"];
}

@dynamic action;
- (SEL)action {
    NSString *selStr = objc_getAssociatedObject(self, NSObject_label_key_action);
    SEL sel = NSSelectorFromString(selStr);
    return sel;
}
- (void)setAction:(SEL)action {
    [self willChangeValueForKey:@"action"];
    objc_setAssociatedObject(self, NSObject_label_key_action, NSStringFromSelector(action), OBJC_ASSOCIATION_COPY);
    [self didChangeValueForKey:@"action"];
}

#pragma mark -
#pragma mark - addTarget: action:   添加点击事件
- (void)addTarget:(id)target action:(SEL)action {
    self.target = target;
    self.action = action;
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
    [self addGestureRecognizer:tap];
}

#pragma mark -
#pragma mark - tapHandle: 手势方法
- (void)tapHandle:(UITapGestureRecognizer *)tap {
    if ([self.target respondsToSelector:self.action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.target performSelector:self.action withObject:self];
#pragma clang diagnostic pop
        
    }
}


- (id)initWithFrame:(CGRect)frame withBgColor:(UIColor *)bgColor {
    UILabel *lbl = [[UILabel alloc] initWithFrame:frame];
        if (nil != bgColor) {
            lbl.backgroundColor = bgColor;
        }
    
    return lbl;
}


- (id)initWithFrame:(CGRect)frame withBgColor:(UIColor *)bgColor withText:(NSString *)text withTextColor:(UIColor *)textColor withTextAlignment:(NSTextAlignment)textAlignment withFontSize:(CGFloat)fontSize withIsBold:(BOOL)isBold withAutoHeight:(BOOL)isAuto{
    UILabel *lbl = [[UILabel alloc] initWithFrame:frame];
    
        if (nil != bgColor) {
            lbl.backgroundColor = bgColor;
        }
        if (nil != text) {
            lbl.text = text;
        }
        
        if (nil != textColor) {
            lbl.textColor = textColor;
        }
    
        lbl.textAlignment = textAlignment;
        
        if (isBold) {
            lbl.font = [UIFont boldSystemFontOfSize:fontSize];
        }else{
            lbl.font = [UIFont systemFontOfSize:fontSize];
        }
    if (isAuto) {
        lbl.height = [YPBaseMethod yp_labelHeightofString:text withFont:lbl.font withWidth:frame.size.width];
    }
    return lbl;
}



@end
