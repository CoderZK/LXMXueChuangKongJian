//
//  LxmAbleVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/2.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmAbleVC.h"
#import "LxmGoodListTopView.h"
#import "LxmSubAbleVC.h"
#import "LxmLoginAndRegisterVC.h"
#import "SNYQRCodeVC.h"
#import "LxmMyPageVC.h"
#import "BaseNavigationController.h"

@interface LxmAbleVC ()<UIScrollViewDelegate,LxmGoodListTopViewDelegate,SNYQRCodeVCDelegate>
@property (nonatomic , strong)LxmGoodListTopView * topView;
@property (nonatomic , strong)UIScrollView * scrollView;
@property (nonatomic , strong)LxmSubAbleVC * ableVC;
@property (nonatomic , strong)LxmGoodListModel * currentModel;
@property (nonatomic , strong)NSMutableArray * totalArr;
@property (nonatomic , strong)NSMutableArray * ableVCArr;
@property (nonatomic , assign)NSInteger currentIndex;
@end

@implementation LxmAbleVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    WeakObj(self);
    [LxmEventBus registerEvent:@"publishAbleDanSuccess" block:^(id data) {
        [selfWeak refreshList];
    }];
    [LxmEventBus registerEvent:@"deleteAbleDan" block:^(id data) {
        [selfWeak refreshList];
    }];
    [LxmEventBus registerEvent:@"upAbleDanSuccess" block:^(id data) {
        [selfWeak refreshList];
    }];
}

- (void)refreshList {
    WeakObj(self);
    [selfWeak.totalArr removeAllObjects];
    [selfWeak.ableVCArr removeAllObjects];
    [selfWeak loadTypeList];
}

- (void)loadTypeList{
    if (self.isyouke) {
        [LxmNetworking networkingPOST:[LxmURLDefine user_findSkillTypeList] parameters:nil returnClass:[LxmGoodListRootModel class] success:^(NSURLSessionDataTask *task, LxmGoodListRootModel * responseObject) {
            if (responseObject.key.intValue == 1) {
                NSMutableArray * tempArr = [NSMutableArray array];
                LxmGoodListModel * model = [[LxmGoodListModel alloc] init];
                model.ID = @0;
                model.content = @"全部";
                [tempArr addObject:model];
                [tempArr addObjectsFromArray:responseObject.result];
                self.topView.titleArr = tempArr;
                self.totalArr = tempArr;
                self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width*tempArr.count, 0);
                
                for (int i = 0; i<tempArr.count; i++) {
                    
                    LxmSubAbleVC *ableVC = [[LxmSubAbleVC alloc] initWithTableViewStyle:UITableViewStylePlain];
                    ableVC.view.frame = CGRectMake(self.scrollView.bounds.size.width*i, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
                    ableVC.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
                    [self.scrollView addSubview:ableVC.view];
                    ableVC.isyouke = YES;
                    ableVC.preVC = self;
                    if (i == 0) {
                        LxmGoodListModel * model = [tempArr objectAtIndex:0];
                        ableVC.currentModel = model;
                    }
                    [self.scrollView addSubview:ableVC.view];
                    [self addChildViewController:ableVC];
                    [self.ableVCArr addObject:ableVC ];
                }
                
            }else{
                [UIAlertController showAlertWithKey:responseObject.key message:responseObject.message];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    } else {
        if (ISLOGIN) {
            [LxmNetworking networkingPOST:[LxmURLDefine user_findCanTypeList] parameters:@{@"token":SESSION_TOKEN} returnClass:[LxmGoodListRootModel class] success:^(NSURLSessionDataTask *task, LxmGoodListRootModel * responseObject) {
                if (responseObject.key.intValue == 1) {
                    NSMutableArray * tempArr = [NSMutableArray array];
                    LxmGoodListModel * model = [[LxmGoodListModel alloc] init];
                    model.ID = @0;
                    model.content = @"全部";
                    [tempArr addObject:model];
                    [tempArr addObjectsFromArray:responseObject.result];
                    self.topView.titleArr = tempArr;
                    self.totalArr = tempArr;
                    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width*tempArr.count, 0);
                    
                    for (int i = 0; i<tempArr.count; i++) {
                        
                        LxmSubAbleVC *ableVC = [[LxmSubAbleVC alloc] initWithTableViewStyle:UITableViewStylePlain];
                        ableVC.view.frame = CGRectMake(self.scrollView.bounds.size.width*i, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
                        ableVC.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
                        [self.scrollView addSubview:ableVC.view];
                        ableVC.preVC = self;
                        if (i == 0) {
                            LxmGoodListModel * model = [tempArr objectAtIndex:0];
                            ableVC.currentModel = model;
                        }
                        [self.scrollView addSubview:ableVC.view];
                        [self addChildViewController:ableVC];
                        [self.ableVCArr addObject:ableVC ];
                    }
                    
                }else{
                    [UIAlertController showAlertWithKey:responseObject.key message:responseObject.message];
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
            }];
        }else{
            LxmLoginAndRegisterVC * vc = [[LxmLoginAndRegisterVC alloc] init];
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:vc animated:YES completion:nil];
        }
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"校园商家";
    
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
    [self loadTypeList];
    self.totalArr = [NSMutableArray array];
    self.ableVCArr = [NSMutableArray array];
    
    UIButton * leftbtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [leftbtn setBackgroundImage:[UIImage imageNamed:@"ico_saomiao"] forState:UIControlStateNormal];
    [leftbtn addTarget:self action:@selector(scanBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftbtn];
}

- (void)scanBtnClick{
    if (self.isyouke) {
        UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"您现在是游客身份,确定要登录吗?" preferredStyle:UIAlertControllerStyleAlert];
        [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            LxmLoginAndRegisterVC * vc = [[LxmLoginAndRegisterVC alloc] init];
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            BaseNavigationController * nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
            [UIApplication sharedApplication].delegate.window.rootViewController = nav;
        }]];
        [self presentViewController:alertView animated:YES completion:nil];
        
    } else {
        //扫一扫 加好友
        SNYQRCodeVC * vc = [[SNYQRCodeVC alloc] init];
        vc.delegate = self;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
   
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        NSInteger toN=scrollView.contentOffset.x/self.view.bounds.size.width;
        [self.topView lxmGoodListTopViewSelectIndex:toN];
        if (self.currentIndex != toN) {
            LxmGoodListModel * model = [self.totalArr objectAtIndex:toN];
            LxmSubAbleVC * ableVC = [self.ableVCArr objectAtIndex:toN];
            ableVC.currentModel = model;
        }
        self.currentIndex = toN;
    }
}
- (void)LxmGoodListTopView:(LxmGoodListTopView *)topView btnAtIndex:(NSInteger)index {
     [self.scrollView setContentOffset:CGPointMake(index*self.view.bounds.size.width, 0) animated:YES];
    if (self.currentIndex != index) {
        LxmGoodListModel * model = [self.totalArr objectAtIndex:index];
        LxmSubAbleVC * ableVC = [self.ableVCArr objectAtIndex:index];
        ableVC.currentModel = model;
    }
    self.currentIndex = index;
   
}

#pragma mark - SNYQRCodeVCDelegate

- (void)SNYQRCodeVC:(SNYQRCodeVC *)vc scanResult:(NSString *)str {
    
    [vc.navigationController popViewControllerAnimated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //加好友
        [self loadOtherInfoDataWithID:@(str.integerValue)];
    });
    
}

- (void)loadOtherInfoDataWithID:(NSNumber *)otherID{
    if (ISLOGIN) {
        [LxmNetworking networkingPOST:[LxmURLDefine user_getOthersInfo] parameters:@{@"token":SESSION_TOKEN,@"otherUserId":otherID} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"key"] intValue] == 1) {
                LxmOtherInfoModel * otherModel = [LxmOtherInfoModel mj_objectWithKeyValues:responseObject[@"result"]];
                otherModel.otherUserID = otherID;
                LxmMyPageVC * vc1 = [[LxmMyPageVC alloc] initWithTableViewStyle:UITableViewStylePlain type:LxmMyPageVC_type_other];
                vc1.otherInfoModel = otherModel;
                vc1.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc1 animated:YES];
            }else{
                [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
        
    }else{
        LxmLoginAndRegisterVC * vc = [[LxmLoginAndRegisterVC alloc] init];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    }
}

@end
