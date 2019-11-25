//
//  YPBaseMethod.m
//  YPToolsUpdate
//
//  Created by Work_Zyp on 13/5/11.
//  Copyright © 2013年 Work_Zyp. All rights reserved.
//

#import "YPBaseMethod.h"


@implementation YPBaseMethod

#pragma mark -
#pragma mark - yp_getCameraPermissionStatus 检测相机权限 并显示相机被拒绝时的提示框
+ (BOOL)yp_getCameraPermissionStatus {
    NSString *mediaType = AVMediaTypeVideo;// Or AVMediaTypeAudio
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    return (authStatus == AVAuthorizationStatusDenied) ? NO : YES;
    /* 如状态为NO时，建议的处理提示情况...
     UIAlertController *alertC = [UIAlertController new];
     UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"您的相机功能好像有问题哦~\n去“设置>隐私>相机”开启一下吧" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
     NSLog(@"相机权限被拒绝...");
     }];
     [alertC addAction:sureAction];
     */
}

#pragma mark -
#pragma mark - yp_isValidateWithInputString: checkType: 检测输入内容合法性
+ (BOOL)yp_isValidateWithInputString:(NSString *)str checkType:(INPUTSTRINGCHECKTYPE)checkType {
    switch (checkType) {
        case INPUTSTRINGCHECK_MOBILENUMBER://手机号合法性检测
        {
            NSString * MOBILE = @"^((13[0-9])|(17[0-9])|(147)|(15[0-9])|(18[0-9]))\\d{8}$";
            NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
            return ([regextestmobile evaluateWithObject:str] == YES) ? YES : NO;
        }
            break;
        case INPUTSTRINGCHECK_EMAIL://邮箱合法性检测
        {
            NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
            NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
            return [emailTest evaluateWithObject:str];
        }
            break;
        case INPUTSTRINGCHECK_IDENTITYCARD://二代身份证合法性检测
        {
            if (str.length != 18) {
                return NO;
            }
            NSArray *codeArray =
            [NSArray arrayWithObjects:@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7",
             @"9", @"10", @"5", @"8", @"4", @"2", nil];
            NSDictionary *checkCodeDic = [NSDictionary
                                          dictionaryWithObjects:[NSArray arrayWithObjects:@"1", @"0", @"X", @"9", @"8", @"7", @"6",
                                                                 @"5", @"4", @"3", @"2", nil]
                                          forKeys:[NSArray arrayWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6",
                                                   @"7", @"8", @"9", @"10", nil]];
            
            NSScanner *scan = [NSScanner scannerWithString:[str substringToIndex:17]];
            
            int val;
            BOOL isNum = [scan scanInt:&val] && [scan isAtEnd];
            if (!isNum) {
                return NO;
            }
            int sumValue = 0;
            
            for (int i = 0; i < 17; i++) {
                sumValue += [[str substringWithRange:NSMakeRange(i, 1)] intValue] *
                [[codeArray objectAtIndex:i] intValue];
            }
            NSString *strlast =
            [checkCodeDic objectForKey:[NSString stringWithFormat:@"%d", sumValue % 11]];
            
            if ([strlast isEqualToString:[[str
                                           substringWithRange:NSMakeRange(17, 1)] uppercaseString]]) {
                return YES;
            }
            return NO;
        }
            break;
        case INPUTSTRINGCHECK_HASEMOJI://是否含有emoji表情的检测
        {
            __block BOOL isEomji = NO;
            [str enumerateSubstringsInRange:NSMakeRange(0, [str length])
                                    options:NSStringEnumerationByComposedCharacterSequences
                                 usingBlock:^(NSString *substring, NSRange substringRange,
                                              NSRange enclosingRange, BOOL *stop) {
                                     const unichar hs = [substring characterAtIndex:0];
                                     // surrogate pair
                                     if (0xd800 <= hs && hs <= 0xdbff) {
                                         if (substring.length > 1) {
                                             const unichar ls = [substring characterAtIndex:1];
                                             const int uc =
                                             ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                             if (0x1d000 <= uc && uc <= 0x1f77f) {
                                                 isEomji = YES;
                                             }
                                         }
                                     } else {
                                         // non surrogate
                                         if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                                             isEomji = YES;
                                         } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                             isEomji = YES;
                                         } else if (0x2934 <= hs && hs <= 0x2935) {
                                             isEomji = YES;
                                         } else if (0x3297 <= hs && hs <= 0x3299) {
                                             isEomji = YES;
                                         } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d ||
                                                    hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c ||
                                                    hs == 0x2b1b || hs == 0x2b50 || hs == 0x231a) {
                                             isEomji = YES;
                                         }
                                         if (!isEomji && substring.length > 1) {
                                             const unichar ls = [substring characterAtIndex:1];
                                             if (ls == 0x20e3) {
                                                 isEomji = YES;
                                             }
                                         }
                                     }
                                 }];
            return isEomji;
        }
            break;
        default:
            break;
    }
}


#pragma mark -
#pragma mark - LogAllCharacterStyle 打印工程内所有字体库
+ (void)yp_logAllCharacterStyle{
    NSMutableArray *ar = [NSMutableArray array];
    for(NSString *fontfamilyname in [UIFont familyNames])
    {
        [ar addObject:fontfamilyname];
        NSLog(@"family:'%@'",fontfamilyname);

        for(NSString *fontName in [UIFont fontNamesForFamilyName:fontfamilyname])
        {
            NSLog(@"\tfont:'%@'",fontName);
        }
        NSLog(@"*************");
    }
}


#pragma mark -
#pragma mark - hidTabBar 【兼容iOS6-隐藏Tabbar通用方法】
+ (void)yp_makeTabBarHidden:(BOOL)hide withTabBarController:(UITabBarController *)tabBarController {
    if ( [tabBarController.view.subviews count] < 2 ) {
        return;
    }
    UIView *contentView;
    if ( [[tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] ) {
        contentView = [tabBarController.view.subviews objectAtIndex:1];
    } else {
        contentView = [tabBarController.view.subviews objectAtIndex:0];
    }
    if (hide) {
        contentView.frame = tabBarController.view.bounds;
    } else {
        contentView.frame = CGRectMake(tabBarController.view.bounds.origin.x,
                                       tabBarController.view.bounds.origin.y,
                                       tabBarController.view.bounds.size.width,
                                       tabBarController.view.bounds.size.height -
                                       tabBarController.tabBar.frame.size.height);
    }
    tabBarController.tabBar.hidden = hide;
}

#pragma mark -
#pragma mark - yp_timeStrWithUnixTime: isSecondLev: withDateShowType: Unix时间戳 返回时间字符串
+ (NSString *)yp_timeStrWithUnixTime:(double)unixTime isSecondLev:(BOOL)isSecond withDateShowType:(DATESHOWTYPE)showType {
    //转换为秒级时间戳
    (isSecond == YES) ? 0 : (unixTime = unixTime / 1000);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *showFormatString = @"";
    switch (showType)
    {
        case DATESHOW_YMD_HMS:
            showFormatString = @"YYYY-MM-dd HH:mm:ss";
            break;
        case DATESHOW_YND_HM:
            showFormatString = @"YYYY-MM-dd HH:mm";
            break;
        case DATESHOW_YMD:
            showFormatString = @"YYYY-MM-dd";
            break;
        default:
            break;
    }
    [formatter setDateFormat:showFormatString];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:unixTime];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

#pragma mark -
#pragma mark - labelHeightofString: withFont: withWidth:  根据文字字号获取lab高度
+ (CGFloat)yp_labelHeightofString:(NSString *)str withFont:(UIFont *)font withWidth:(CGFloat)width
{
    if ([str isKindOfClass:[NSString class]]) {
        NSDictionary *attributes = @{NSFontAttributeName: font};
        CGRect rect = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT)options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        return rect.size.height;
    }
    return 0;
}

#pragma mark -
#pragma mark - labelWidthOfString: withFont: withHeight:  根据文字字号获取lab宽度
+ (CGFloat)yp_labelWidthOfString:(NSString *)str withFont:(UIFont *)font withHeight:(CGFloat)height
{
    if ([str isKindOfClass:[NSString class]]) {
        NSDictionary *attributes = @{NSFontAttributeName: font};
        CGRect rect = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, height)options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        return rect.size.width;
    }
    return 0;
}



@end


//废弃...
/*
 #pragma mark -
 #pragma mark - colorFromHexString: 【根据色值赋值】
 + (UIColor *)yp_colorFromHexString:(NSString *)hexString {
 NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
 if([cleanString length] == 3) {
 cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
 [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
 [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
 [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
 }
 if([cleanString length] == 6) {
 cleanString = [cleanString stringByAppendingString:@"ff"];
 }
 unsigned int baseValue;
 [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
 float red = ((baseValue >> 24) & 0xFF)/255.0f;
 float green = ((baseValue >> 16) & 0xFF)/255.0f;
 float blue = ((baseValue >> 8) & 0xFF)/255.0f;
 float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
 
 return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
 }
 
 //#pragma mark -
 //#pragma mark - imageWithImage: scaledToSize: 根据一定的尺寸重绘图片
 //+ (UIImage *)yp_imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
 //    // Create a graphics image context
 //    UIGraphicsBeginImageContext(newSize);
 //    // Tell the old image to draw in this new context, with the desired
 //    // new size
 //    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
 //    // Get the new image from the context
 //    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
 //    // End the context
 //    UIGraphicsEndImageContext();
 //    // Return the new image.
 //    return newImage;
 //}
 
 //#pragma mark -
 //#pragma mark - setLabelSpaceWithString: withLineSpaceing: withLable: 设置行间距
 //+ (void)yp_setLableSpaceWithString:(nullable NSString*)str withLineSpacing:(CGFloat)LineSpacing withLable:(UILabel*_Nullable)lable {
 //    lable.text = str;
 //    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:str];
 //    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
 //    [paragraphStyle1 setLineSpacing:LineSpacing];
 //    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [str length])];
 //    [lable setAttributedText:attributedString1];
 //    [lable sizeToFit];
 //}
 
 //#pragma mark -
 //#pragma mark - simulateRequestDataWithSourceViewController: withWaitTime: 模拟网络请求状态
 //+ (void)yp_simulateRequestDataWithSourceViewController:(nullable UIViewController *)vc withWatiTime:(NSTimeInterval)waitTime {
 //    [MBProgressHUD showHUDAddedTo:vc.view animated:YES];
 //    [self performSelector:@selector(yp_simulateHideHUD:) withObject:vc afterDelay:waitTime];
 //}
 //- (void)yp_simulateHideHUD:(UIViewController *)vc {
 //    [MBProgressHUD hideHUDForView:vc.view animated:YES];
 //}
 */
