//
//  SubAbleVC.h
//  mag
//
//  Created by 李晓满 on 2018/7/26.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface SubAbleVC : BaseTableViewController
@property(nonatomic , strong)BaseViewController * preVC;
@property (nonatomic , strong)LxmGoodListModel * currentModel;
@property (nonatomic, assign) BOOL isyouke;
@end
