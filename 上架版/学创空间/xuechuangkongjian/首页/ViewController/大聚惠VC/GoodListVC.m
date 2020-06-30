//
//  GoodListVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/30.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "GoodListVC.h"
#import "LxmGoodListTopView.h"
#import "AllGoodListVC.h"

@interface GoodListVC ()<LxmGoodListTopViewDelegate>
@property (nonatomic , strong)LxmGoodListTopView * topView;
@property (nonatomic , strong)UIScrollView * scrollView;
@property (nonatomic , strong)AllGoodListVC * ableVC;
@property (nonatomic , strong)LxmGoodListModel * currentModel;
@property (nonatomic , strong)NSMutableArray * totalArr;
@property (nonatomic , strong)NSMutableArray * goodListVCArr;
@property (nonatomic , assign)NSInteger currentIndex;
@end

@implementation GoodListVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)loadTypeList{
    if (ISLOGIN) {
        [LxmNetworking networkingPOST:[LxmURLDefine user_findECTypeList] parameters:@{@"token":SESSION_TOKEN} returnClass:[LxmGoodListRootModel class] success:^(NSURLSessionDataTask *task, LxmGoodListRootModel * responseObject) {
            if (responseObject.key.intValue == 1) {
                NSMutableArray * tempArr = [NSMutableArray array];
                LxmGoodListModel * model = [[LxmGoodListModel alloc] init];
                model.ID = @0;
                model.content = @"全部";
                [tempArr lxm_add1Object:model];
                [tempArr addObjectsFromArray:responseObject.result];
                self.topView.titleArr = tempArr;
                self.totalArr = tempArr;
                self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width*tempArr.count, 0);
                
                for (int i = 0; i<tempArr.count; i++) {
                    
                    AllGoodListVC *goodListVC = [[AllGoodListVC alloc] initWithTableViewStyle:UITableViewStylePlain];
                    goodListVC.view.frame = CGRectMake(self.scrollView.bounds.size.width*i, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
                    goodListVC.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
                    [self.scrollView addSubview:goodListVC.view];
                    goodListVC.preVC = self;
                    if (i == 0) {
                        LxmGoodListModel * model = tempArr[0];
                        goodListVC.currentModel = model;
                    }
                    [self.scrollView addSubview:goodListVC.view];
                    [self addChildViewController:goodListVC];
                    [self.goodListVCArr lxm_add1Object:goodListVC ];
                }
                
            }else{
                [UIAlertController showAlertWithKey:responseObject.key message:responseObject.message];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先登录!"];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"学创空间商城";
    self.topView = [[LxmGoodListTopView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    self.topView.delegate = self;
    [self.view addSubview:self.topView];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height-50)];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width*9, 0);
    [self.view addSubview:self.scrollView];
    self.totalArr = [NSMutableArray array];
    self.goodListVCArr = [NSMutableArray array];
    [self loadTypeList];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.scrollView) {
        NSInteger toN=scrollView.contentOffset.x/self.view.bounds.size.width;
        [self.topView lxmGoodListTopViewSelectIndex:toN];
        if (self.currentIndex != toN) {
            LxmGoodListModel * model = [self.totalArr lxm_object1AtIndex:toN];
            GoodListVC * goodListVC = [self.goodListVCArr lxm_object1AtIndex:toN];
            goodListVC.currentModel = model;
        }
        self.currentIndex = toN;
    }
}
- (void)LxmGoodListTopView:(LxmGoodListTopView *)topView btnAtIndex:(NSInteger)index{
    [self.scrollView setContentOffset:CGPointMake(index*self.view.bounds.size.width, 0) animated:YES];
    if (self.currentIndex != index) {
        LxmGoodListModel * model = [self.totalArr lxm_object1AtIndex:index];
        GoodListVC * goodListVC = [self.goodListVCArr lxm_object1AtIndex:index];
        goodListVC.currentModel = model;
    }
    self.currentIndex = index;
}


@end
