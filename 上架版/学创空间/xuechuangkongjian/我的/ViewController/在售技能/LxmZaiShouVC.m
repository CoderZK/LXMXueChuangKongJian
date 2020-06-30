//
//  LxmZaiShouVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/18.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmZaiShouVC.h"
#import "LxmMineNewNavItemView.h"
#import "LxmSaleAbleVC.h"
#import "LxmPayMoneyAbleVC.h"
@interface LxmZaiShouVC ()<LxmMineNewNavItemViewDelegate>
@property (nonatomic , strong)UIScrollView * scrollView;
@property (nonatomic , strong)LxmSaleAbleVC * zaishouVC;
@property (nonatomic , strong)LxmPayMoneyAbleVC * perchusVC;
@property (nonatomic , strong)LxmMineNewNavItemView * navView;
@end

@implementation LxmZaiShouVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navView = [[LxmMineNewNavItemView alloc] initWithFrame:CGRectMake(0, 0, 220, 44) withTitleArr:@[@"发布的技能",@"购买的技能"]];
    self.navView.delegate = self;
    self.navigationItem.titleView = self.navView;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width*2.0, 0);
    [self.view addSubview:self.scrollView];
    
    self.zaishouVC = [[LxmSaleAbleVC alloc] init];
    self.zaishouVC .view.frame = _scrollView.bounds;
    self.zaishouVC .view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.scrollView addSubview:self.zaishouVC.view];
    self.zaishouVC.preVC = self;
    [self.scrollView addSubview:self.zaishouVC.view];
    [self addChildViewController:self.zaishouVC ];
    
    self.perchusVC = [[LxmPayMoneyAbleVC alloc] initWithTableViewStyle:UITableViewStylePlain type:LxmPayMoneyAbleVC_type_fbjn];;
    self.perchusVC.view.frame = CGRectMake(self.scrollView.bounds.size.width, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
    self.perchusVC.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.scrollView addSubview:self.perchusVC.view];
    self.perchusVC.preVC = self;
    [self addChildViewController:self.perchusVC];
    
    if (self.isPerchusVC == YES) {
        [self.scrollView setContentOffset:CGPointMake(self.view.bounds.size.width, 0) animated:YES];
        [self.navView LxmMineNewNavItemViewWithTag:1];
    }
    
}
#pragma titleView的代理事件
-(void)LxmMineNewNavItemView:(LxmMineNewNavItemView *)view btnAtIndex:(NSInteger)index{
    [self.scrollView setContentOffset:CGPointMake(index*self.view.bounds.size.width, 0) animated:YES];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.scrollView) {
        
        NSInteger toN=scrollView.contentOffset.x/self.view.bounds.size.width;
        [self.navView LxmMineNewNavItemViewWithTag:toN];
    }
}




@end
