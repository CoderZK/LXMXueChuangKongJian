//
//  TabBarController.m
//  recordnote
//
//  Created by 李晓满 on 2017/12/20.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "TabBarController.h"
#import "BaseNavigationController.h"
#import "XckjHomeVC.h"
#import "AbleVC.h"
#import "PublishVC.h"
#import "MessageVC.h"
#import "LxmMineVC.h"
#import "LxmLoginAndRegisterVC.h"
#import "LxmTabbar.h"

@interface TabBarController ()
{
    LxmTabbar *_myTabbar;
}
@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _myTabbar = [[LxmTabbar alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 49)];
    [_myTabbar.centerButton addTarget:self action:@selector(publish) forControlEvents:UIControlEventTouchUpInside];
    [self setValue:_myTabbar forKey:@"tabBar"];
    
    _myTabbar.backgroundImage = [UIImage imageNamed:@"white1"];
    _myTabbar.shadowImage = [UIImage new];
    _myTabbar.barTintColor = UIColor.whiteColor;
    _myTabbar.tintColor = UIColor.whiteColor;
    _myTabbar.layer.shadowColor = CharacterLightGrayColor.CGColor;
    _myTabbar.layer.shadowRadius = 5;
    _myTabbar.layer.shadowOpacity = 0.5;
    _myTabbar.layer.shadowOffset = CGSizeMake(0, 0);
    
    if (@available(iOS 13.0, *)) {
           UITabBarAppearance *tabBarAppearance = [[UITabBarAppearance alloc] init];
           tabBarAppearance.backgroundImage = [UIImage imageNamed:@"tabbarwhite"];
           tabBarAppearance.shadowColor = UIColor.whiteColor;
           tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = @{NSForegroundColorAttributeName : CharacterDarkColor};
           tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = @{NSForegroundColorAttributeName : CharacterLightGrayColor};
           self.tabBar.standardAppearance = tabBarAppearance;
       }
    
    NSArray *imgArr = @[@"ico_21",@"ico_22",@"",@"ico_23",@"ico_24"];
    NSArray *selectedImgArr = @[@"ico_31",@"ico_32",@"",@"ico_33",@"ico_34"];
    
    NSArray *barTitleArr = @[@"首页",@"校园商家",@"",@"消息",@"我的"];
    NSArray *className = @[@"XckjHomeVC",@"AbleVC",@"",@"MessageVC",@"LxmMineVC"];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 0; i < className.count; i++)
    {
        
        NSString *str = [className lxm_object1AtIndex:i];
        BaseViewController *vc = [[NSClassFromString(str) alloc] initWithTableViewStyle:UITableViewStyleGrouped];
        NSString *str1 = [imgArr lxm_object1AtIndex:i];
        
        //让图片保持原来的模样，未选中的图片
        vc.tabBarItem.image = [[UIImage imageNamed:str1] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        //图片选中时的图片
        NSString *str2 = [selectedImgArr lxm_object1AtIndex:i];
        vc.tabBarItem.selectedImage = [[UIImage imageNamed:str2] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:CharacterLightGrayColor} forState:UIControlStateNormal];
        [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:CharacterDarkColor} forState:UIControlStateSelected];
        
        //页面的bar上面的title值
        NSString *str3 = [barTitleArr lxm_object1AtIndex:i];
        vc.tabBarItem.title = str3;
    
        //给每个页面添加导航栏
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
        [arr lxm_add1Object:nav];
        
    }
    self.viewControllers = arr;
}
//设置tabbar上第三个按钮为不可选中状态，其他的按钮为可选择状态
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    return ![viewController isEqual:tabBarController.viewControllers[2]];
}

- (void)publish {
    if (ISLOGIN) {
        BaseNavigationController * nav = [[BaseNavigationController alloc] initWithRootViewController:[[PublishVC alloc] init]];
        [self presentViewController:nav animated:YES completion:nil];
    } else {
        LxmLoginAndRegisterVC * vc = [[LxmLoginAndRegisterVC alloc] init];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    }
    
}

@end
