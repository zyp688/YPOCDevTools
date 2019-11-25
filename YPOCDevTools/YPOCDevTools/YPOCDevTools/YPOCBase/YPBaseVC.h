//
//  YPBaseVC.h
//  YPToolsUpdate
//
//  Created by Work_Zyp on 13/5/12.
//  Copyright © 2013年 Work_Zyp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YPBaseVC : UIViewController <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,UITabBarControllerDelegate,UIActionSheetDelegate,UISearchBarDelegate,UIWebViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

//-----------------Attributes属性⬇️----------------------

/**
 @brief safeView上边的留白部分
 */
@property (strong, nonatomic) UIView *topBackView;
/**
 @brief 结合Masonry的安全区域·用于适配各种机型
 */
@property (nonatomic, strong) UIView *safeView;
/**
 @brief safeView下边的留白部分
 */
@property (strong, nonatomic) UIView *bottomBackView;

//-----------------Attributes属性⬆️----------------------



//-----------------Methods方法⬇️----------------------



//-----------------Methods方法⬆️----------------------


@end
