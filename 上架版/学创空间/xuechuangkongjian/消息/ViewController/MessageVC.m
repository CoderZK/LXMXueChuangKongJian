//
//  MessageVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/2.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "MessageVC.h"
#import "LxmMineNavItemView.h"
#import "MessageReceiveVC.h"
#import "FriendVC.h"



@interface MessageVC ()<LxmMineNavItemViewDelegate>
@property (nonatomic , strong)UIScrollView * scrollView;
@property (nonatomic , strong)LxmMineNavItemView * navView;
@property (nonatomic , strong)MessageReceiveVC * receiveVC;
@property (nonatomic , strong)FriendVC * friendVC;
@end

@implementation MessageVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navView = [[LxmMineNavItemView alloc] initWithFrame:CGRectMake(0, 7, 220, 30) withTitleArr:@[@"消息",@"朋友"]];
    self.navView.delegate = self;
    self.navigationItem.titleView = self.navView;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width*2.0, 0);
    [self.view addSubview:self.scrollView];
    
    self.receiveVC = [[MessageReceiveVC alloc] init];
    self.receiveVC .view.frame = _scrollView.bounds;
    self.receiveVC .view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.scrollView addSubview:self.receiveVC .view];
    self.receiveVC .preVC = self;
    [self.scrollView addSubview:self.receiveVC .view];
    [self addChildViewController:self.receiveVC ];
    
    self.friendVC = [[FriendVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
    self.friendVC.view.frame = CGRectMake(self.scrollView.bounds.size.width, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
    self.friendVC.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.scrollView addSubview:self.friendVC.view];
    self.friendVC.preVC = self;
    [self addChildViewController:self.friendVC];
}

#pragma titleView的代理事件
-(void)LxmMineNavItemView:(LxmMineNavItemView *)view btnAtIndex:(NSInteger)index{
    [self.scrollView setContentOffset:CGPointMake(index*self.view.bounds.size.width, 0) animated:YES];
    if (index == 0) {
        [self.receiveVC updata]; //刷新界面
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.scrollView) {
        NSInteger toN = scrollView.contentOffset.x/self.view.bounds.size.width;
        [self.navView LxmMineNavItemViewWithTag:toN];
        if (toN == 0) {
            [self.receiveVC updata];//刷新界面
        }
    }
}

@end
