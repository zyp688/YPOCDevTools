//
//  UITableView+YPMethods.h
//  YPToolsUpdate
//
//  Created by Work_Zyp on 2017/1/10.
//  Copyright © 2017年 Work_Zyp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (YPMethods)

/** 让TableView多余的Cell不可见*/
- (void)yp_hideBottomEmptyCells;

/** 分隔线左间距为0*/
- (void)yp_hideSeparatorLeftInset;

@end
