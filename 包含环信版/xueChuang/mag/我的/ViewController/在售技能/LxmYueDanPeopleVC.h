//
//  LxmYueDanPeopleVC.h
//  mag
//
//  Created by 李晓满 on 2018/7/19.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LxmYueDanPeopleVC : BaseTableViewController
@property (nonatomic , strong) NSNumber *billId;
@end
@interface LxmYueDanPeopleCell : UITableViewCell
@property (nonatomic , strong) LxmBuyMyCanUserModel * model;
@end
