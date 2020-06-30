//
//  LxmAddAdressVC.h
//  mag
//
//  Created by 李晓满 on 2018/7/20.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LxmAddAdressVC : BaseTableViewController
- (instancetype)initWithTableViewStyle:(UITableViewStyle)style withModel:(LxmMyAddressModel *)model;
@property (nonatomic , copy)void(^refreshBlock)(void);

@end

@interface LxmAddAdressCell : UITableViewCell
@property (nonatomic , strong) UIImageView * accImgView;
@property (nonatomic , strong) UIImageView * iconImgView;
@property (nonatomic , strong) UILabel * titleLab;
@end
