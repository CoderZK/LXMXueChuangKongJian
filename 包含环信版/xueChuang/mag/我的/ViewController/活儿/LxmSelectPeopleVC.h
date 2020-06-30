//
//  LxmSelectPeopleVC.h
//  mag
//
//  Created by 李晓满 on 2018/7/18.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LxmSelectPeopleVC : BaseTableViewController
@property (nonatomic , strong) NSNumber * billId;
@property (nonatomic , copy)void(^refreshPreBlock)(void);
@end

@interface LxmSelectPeopleCell : UITableViewCell
@property (nonatomic , strong)LxmMyQingDanPeopleModel * model;
@property (nonatomic , copy) void (^chatButtonHandle)();
@end
