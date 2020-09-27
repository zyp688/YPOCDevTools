//
//  ViewController.m
//  YPOCDevTools
//
//  Created by WorkZyp on 2019/3/5.
//  Copyright © 2019年 Zyp. All rights reserved.
//

#import "ViewController.h"
#import "UILabel+YPMethods.h"


#import "TNTHttpTool.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
//    [YPNetTool GET:@"http://ultravideo.cs.tut.fi/video/ShakeNDry_1920x1080_30fps_420_8bit_AVC_MP4.mp4" parameters:nil success:^(id responseObject) {
//
//    } failure:^(NSError *error) {
//
//    } withSourceController:nil];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:self.view.bounds];
    [lbl addTarget:self action:@selector(start)];
    [self.view addSubview:lbl];
    
    UILabel *lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, 300, 200)];
    lbl2.backgroundColor = [UIColor yellowColor];
    [lbl2 addTarget:self action:@selector(stop)];
    [self.view addSubview:lbl2];
    
    // GET请求
    [TNTHttpTool sharedInstance].GET(TNTGetWetherURL, @{@"key":@"S6DHidqN9roivBcbq",@"location":@"beijing",@"language":@"zh-Hans"}).success = ^(id responseObject) {
        
    };
    // 上传图片
//    UIImage *uploadImg =  [UIImage imageNamed:@""];
//    [TNTHttpTool sharedInstance].uploadOneImage(TNTUploadImageURL,uploadImg, ^(NSProgress *progress){
//        //上传进度
//    }).success = ^(id responseObject) {
//
//    };
    // 上传多张图片
//    NSArray *images = @[uploadImg,uploadImg];
//    [TNTHttpTool sharedInstance].uploadMultipleImages(TNTUploadImageURL, images, ^(NSProgress *progress){
//        //上传进度
//    }).success = ^(id responseObject) {
//
//    };
    
    
    
    
}



@end
