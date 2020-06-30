//
//  LxmMyCollectionVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/19.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmMyCollectionVC.h"
#import "LxmMineNewNavItemView.h"
#import "XckjLvYouAndPaiMaiVC.h"
#import "AroundVC.h"
@interface LxmMyCollectionVC ()<LxmMineNewNavItemViewDelegate>
@property (nonatomic , strong)LxmMineNewNavItemView * topView;
@property (nonatomic , strong)UIScrollView * scrollView;
@property (nonatomic , strong)XckjLvYouAndPaiMaiVC * zixunVC;
@property (nonatomic , strong)AroundVC * aroundVC;
@property (nonatomic , strong)XckjLvYouAndPaiMaiVC * lvYouVC;
@property (nonatomic , strong)XckjLvYouAndPaiMaiVC * paMaiVC;
@end

@implementation LxmMyCollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的收藏";
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.topView = [[LxmMineNewNavItemView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50) withTitleArr:@[@"资讯",@"周边",@"旅游",@"拍卖"]];
    self.topView.delegate = self;
    self.topView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.topView];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 0.5)];
    line.backgroundColor = LineColor;
    [self.view addSubview:line];
    
    if (kDevice_Is_iPhoneX) {
        self.tableView.frame = CGRectMake(0, 50, ScreenW, self.view.bounds.size.height-50-34);
    }else{
        self.tableView.frame = CGRectMake(0, 50, ScreenW, self.view.bounds.size.height-50);
    }
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, self.tableView.height)];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width*4.0, 0);
    [self.view addSubview:self.scrollView];
    
    LxmHomeBannerModel * zixunModel = [[LxmHomeBannerModel alloc] init];
    zixunModel.isMyCollection = YES;
    zixunModel.ID = @10;
    self.zixunVC = [[XckjLvYouAndPaiMaiVC alloc] initWithTableViewStyle:UITableViewStylePlain currentModel:zixunModel];
    self.zixunVC .view.frame = _scrollView.bounds;
    self.zixunVC .view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.scrollView addSubview:self.zixunVC.view];
    self.zixunVC.preVC = self;
    [self.scrollView addSubview:self.zixunVC.view];
    [self addChildViewController:self.zixunVC ];
    
    self.aroundVC = [[AroundVC alloc] initWithTableViewStyle:UITableViewStylePlain type:AroundVC_type_mine];
    self.aroundVC.view.frame = CGRectMake(self.scrollView.bounds.size.width, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
    self.aroundVC.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.scrollView addSubview:self.aroundVC.view];
    self.aroundVC.preVC = self;
    [self addChildViewController:self.aroundVC];
    
    LxmHomeBannerModel * lvYouModel = [[LxmHomeBannerModel alloc] init];
    lvYouModel.isMyCollection = YES;
    lvYouModel.ID = @6;
    self.lvYouVC =  [[XckjLvYouAndPaiMaiVC alloc] initWithTableViewStyle:UITableViewStylePlain currentModel:lvYouModel];
    self.lvYouVC.view.frame = CGRectMake(self.scrollView.bounds.size.width*2, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
    self.lvYouVC.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.scrollView addSubview:self.lvYouVC.view];
    self.lvYouVC.preVC = self;
    [self addChildViewController:self.lvYouVC];
    
    LxmHomeBannerModel * paMaiVCModel = [[LxmHomeBannerModel alloc] init];
    paMaiVCModel.isMyCollection = YES;
    paMaiVCModel.ID = @8;
    self.paMaiVC =  [[XckjLvYouAndPaiMaiVC alloc] initWithTableViewStyle:UITableViewStylePlain currentModel:paMaiVCModel];
    self.paMaiVC.view.frame = CGRectMake(self.scrollView.bounds.size.width*3, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
    self.paMaiVC.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.scrollView addSubview:self.paMaiVC.view];
    self.paMaiVC.preVC = self;
    [self addChildViewController:self.paMaiVC];
    
}
-(void)LxmMineNewNavItemView:(LxmMineNewNavItemView *)view btnAtIndex:(NSInteger)index{
     [self.scrollView setContentOffset:CGPointMake(index*self.view.bounds.size.width, 0) animated:YES];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.scrollView) {
        
        NSInteger toN=scrollView.contentOffset.x/self.view.bounds.size.width;
        [self.topView LxmMineNewNavItemViewWithTag:toN];
    }
}

@end
