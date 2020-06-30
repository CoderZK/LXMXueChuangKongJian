//
//  lxmMyDanVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/18.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmMyDanVC.h"
#import "LxmMineNewNavItemView.h"
#import "LxmMyFaDanVC.h"
#import "LxmMyQiangDanVC.h"

@interface LxmMyDanVC ()<LxmMineNewNavItemViewDelegate>
@property (nonatomic , strong)UIScrollView * scrollView;
@property (nonatomic , strong)LxmMyFaDanVC * faDanVC;
@property (nonatomic , strong)LxmMyQiangDanVC * qiangDanVC;
@property (nonatomic , strong)LxmMineNewNavItemView * navView;

@end

@implementation LxmMyDanVC



- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    self.navView = [[LxmMineNewNavItemView alloc] initWithFrame:CGRectMake(0, 0, 220, 44) withTitleArr:@[@"我发布的活",@"我抢的活"]];
    self.navView.delegate = self;
    self.navigationItem.titleView = self.navView;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width*2.0, 0);
    [self.view addSubview:self.scrollView];
    
    self.faDanVC = [[LxmMyFaDanVC alloc] init];
    self.faDanVC .view.frame = _scrollView.bounds;
    self.faDanVC .view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.scrollView addSubview:self.faDanVC .view];
    self.faDanVC .preVC = self;
    [self.scrollView addSubview:self.faDanVC .view];
    [self addChildViewController:self.faDanVC ];
    
    self.qiangDanVC = [[LxmMyQiangDanVC alloc] init];
    self.qiangDanVC.view.frame = CGRectMake(self.scrollView.bounds.size.width, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
    self.qiangDanVC.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.scrollView addSubview:self.qiangDanVC.view];
    self.qiangDanVC.preVC = self;
    [self addChildViewController:self.qiangDanVC];
    
    
    if (self.isQiangDanVC == YES) {
        [self.navView LxmMineNewNavItemViewWithTag:1];
        [self.scrollView setContentOffset:CGPointMake(self.view.bounds.size.width, 0) animated:YES];
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
