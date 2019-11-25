//
//  UIImageView+YPMethods.h
//  YPToolsUpdate
//
//  Created by Work_Zyp on 16/5/12.
//  Copyright © 2016年 Work_Zyp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (YPMethods)

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
 *  快速定制UIImageView
 *
 *  @param frame   大小
 *  @param imgName 图片名字
 *
 *  @return UIImageView对象
 */
- (instancetype)initWithFrame:(CGRect)frame withImgName:(NSString *)imgName;

@end
