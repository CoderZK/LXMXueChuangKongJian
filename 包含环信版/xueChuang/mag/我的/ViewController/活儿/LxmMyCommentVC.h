//
//  LxmMyCommentVC.h
//  mag
//
//  Created by 李晓满 on 2018/7/18.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LxmMyCommentVC : BaseTableViewController
@property (nonatomic , strong)LxmMyQingDanPeopleModel * model;
@property (nonatomic , strong)LxmHomeModel * danModel;
@property (nonatomic , copy)void(^refreshPreBlock)(void);
@end
