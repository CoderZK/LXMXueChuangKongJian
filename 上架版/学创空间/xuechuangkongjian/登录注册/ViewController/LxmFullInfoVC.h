//
//  LxmFullInfoVC.h
//  mag
//
//  Created by 李晓满 on 2018/7/3.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LxmFullInfoVC : BaseTableViewController

@property (nonatomic , strong)NSString * headerImgStr;
@property (nonatomic , strong)NSString * nikeName;
@property (nonatomic , assign)BOOL isLogin;
@property (assign, nonatomic) BOOL isFirtstLogin;

//返回按钮的回调
@property (copy, nonatomic) void (^fullInfoPerfectSuccess)(void);

@end
