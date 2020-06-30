//
//  TaskDetailVC.h
//  mag
//
//  Created by 李晓满 on 2018/7/9.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface TaskDetailVC : BaseTableViewController
//1 发布成功
@property (nonatomic, assign) NSInteger jumpType;
@property (nonatomic , strong)NSNumber * billId;
@property (strong, nonatomic) UIViewController *backViewControlller;
@end

