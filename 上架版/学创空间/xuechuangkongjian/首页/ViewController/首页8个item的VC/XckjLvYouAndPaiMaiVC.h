//
//  XckjLvYouAndPaiMaiVC.h
//  mag
//
//  Created by 李晓满 on 2018/7/9.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface XckjLvYouAndPaiMaiVC : BaseTableViewController
- (instancetype)initWithTableViewStyle:(UITableViewStyle)style currentModel:(LxmHomeBannerModel *)model;
@property(nonatomic , strong)BaseViewController * preVC;
@end
