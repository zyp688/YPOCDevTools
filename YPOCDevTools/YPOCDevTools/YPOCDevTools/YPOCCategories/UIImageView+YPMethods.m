//
//  UIImageView+YPMethods.m
//  YPToolsUpdate
//
//  Created by Work_Zyp on 16/5/12.
//  Copyright © 2016年 Work_Zyp. All rights reserved.
//

#import "UIImageView+YPMethods.h"
#import "UIImageView+WebCache.h"
#import <objc/runtime.h>

const void *NSObject_imageView_key_target = @"NSObject_imageView_key_target";
const void *NSObject_imageView_key_action = @"NSObject_imageView_key_action";

@implementation UIImageView (YPMethods)

@dynamic target;
- (id)target {
    id object = objc_getAssociatedObject(self, NSObject_imageView_key_target);
    return object;
}
- (void)setTarget:(id)target {
    [self willChangeValueForKey:@"target"];
    objc_setAssociatedObject(self, NSObject_imageView_key_target, target, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"target"];
}

@dynamic action;
- (SEL)action {
    NSString *selStr = objc_getAssociatedObject(self, NSObject_imageView_key_action);
    SEL sel = NSSelectorFromString(selStr);
    return sel;
}
- (void)setAction:(SEL)action {
    [self willChangeValueForKey:@"action"];
    objc_setAssociatedObject(self, NSObject_imageView_key_action, NSStringFromSelector(action), OBJC_ASSOCIATION_COPY);
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


- (instancetype)initWithFrame:(CGRect)frame withImgName:(NSString *)imgName{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        if (imgName) {
            if ([imgName hasPrefix:@"http"])
                [self sd_setImageWithURL:[NSURL URLWithString:imgName] placeholderImage:nil];
            else
                self.image = [UIImage imageNamed:imgName];
        }
    }
    
    return self;
}


@end
