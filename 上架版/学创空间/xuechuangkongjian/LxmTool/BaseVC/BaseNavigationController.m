//
//  BaseNavigationController.m
//  Lxm_learnSny海食汇
//
//  Created by sny on 15/10/13.
//  Copyright © 2015年 cznuowang. All rights reserved.
//

#import "BaseNavigationController.h"
#import "BaseTableViewController.h"
@interface BaseNavigationController()
@end
@implementation BaseNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    if (self = [super initWithRootViewController:rootViewController]) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;

    }
    return self;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
//    //设置背景图,把导航栏黑线去掉
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = nil;
    }
    
    //设置bar的title颜色
    self.navigationBar.titleTextAttributes=@{
                                             NSForegroundColorAttributeName:CharacterDarkColor,
                                         NSFontAttributeName:[UIFont systemFontOfSize:20]
                                             
                                             };
    //设置bar的左右按钮颜色
    [self.navigationBar setTintColor:CharacterDarkColor];
    [self.navigationBar setBarTintColor:CharacterDarkColor];
}

@end
