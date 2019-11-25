//
//  YPBaseVC.m
//  YPToolsUpdate
//
//  Created by Work_Zyp on 13/5/12.
//  Copyright © 2013年 Work_Zyp. All rights reserved.
//

#import "YPBaseVC.h"
#import "Masonry.h"
#import "YPMacro.h"

@interface YPBaseVC ()

@end

@implementation YPBaseVC

#pragma mark ༺ life cycle  生命周期 ༻


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self baseUIConfig];
}

#pragma mark -
#pragma mark - dealloc
- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
#pragma mark - didReceiveMemoryWarning 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        if (self.isViewLoaded && !self.view.window)
        {
            self.view = nil;
        }
    }
}

#pragma mark ༺ delegate 代理方法 ༻

#pragma mark -
#pragma mark - UITableViewDataSoure/UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark -
#pragma mark - UICollectionViewDelegate/UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark ༺ event response 点击事件 ༻


#pragma mark ༺ private methods 私有方法 ༻
- (void)baseUIConfig {
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.topBackView];
    
    [self.view addSubview:self.safeView];
    
    [self.view addSubview:self.bottomBackView];
    
    [self makeBaseConstraints];
}

#pragma mark - makeBaseConstraints 约束
- (void)makeBaseConstraints {
    [self.safeView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else {
            make.top.equalTo(self.view.mas_top);
            make.bottom.equalTo(self.view.mas_bottom);
        }
        make.left.right.equalTo(self.view);
    }];
    
    [self.topBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.equalTo(self.view);
        make.bottom.equalTo(self.safeView.mas_top);
    }];
    
    [self.bottomBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.width.equalTo(self.view);
        make.top.equalTo(self.safeView.mas_bottom);
    }];
    [self.view layoutIfNeeded];
    
}

#pragma mark ༺ getter,setter ༻
- (UIView *)safeView {
    if (!_safeView) {
        _safeView = [UIView new];
    }
    
    return _safeView;
}

- (UIView *)topBackView {
    if (!_topBackView) {
        _topBackView = [UIView new];
    }
    
    return _topBackView;
}

- (UIView *)bottomBackView {
    if (!_bottomBackView) {
        _bottomBackView = [UIView new];
    }
    
    return _bottomBackView;
}

// 兼容iOS11present 不全屏的问题
- (UIModalPresentationStyle)modalPresentationStyle {
    return UIModalPresentationFullScreen;
}

@end
