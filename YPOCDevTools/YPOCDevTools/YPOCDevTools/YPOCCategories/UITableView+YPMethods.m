//
//  UITableView+YPMethods.m
//  YPToolsUpdate
//
//  Created by Work_Zyp on 2017/1/10.
//  Copyright © 2017年 Work_Zyp. All rights reserved.
//

#import "UITableView+YPMethods.h"

@implementation UITableView (YPMethods)

- (void)yp_hideBottomEmptyCells {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self setTableFooterView:view];
}

- (void)yp_hideSeparatorLeftInset {
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:UIEdgeInsetsZero];
    }

}

@end
