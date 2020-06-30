//
//  LxmPayVC.h
//  mag
//
//  Created by 李晓满 on 2018/7/12.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LxmPayVC : BaseTableViewController
- (instancetype)initWithTableViewStyle:(UITableViewStyle)style type:(NSInteger)type;
@property (nonatomic , copy)void (^refreshPreVC)(void);
@property (nonatomic , strong)NSString * orderID;
@property (nonatomic , strong)NSNumber * orderMoney;

@property (strong, nonatomic) UIViewController *backViewController;
@property (strong, nonatomic) NSString *billId;

@end
@interface LxmPayCell : UITableViewCell
@property (nonatomic , strong)UIImageView * iconImgView;
@property (nonatomic , strong)UILabel * titleLab;
@property (nonatomic , strong)UIImageView * accImgView;
@end
