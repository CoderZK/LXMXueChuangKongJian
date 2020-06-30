//
//  LxmYueDanPayVC.h
//  mag
//
//  Created by 李晓满 on 2018/7/16.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LxmYueDanPayVC : BaseTableViewController
- (instancetype)initWithTableViewStyle:(UITableViewStyle)style detailModel:(LxmGoodsDetailModel *)detailModel;
@property (nonatomic , copy)void(^refreshPreVC)(void);
@property (nonatomic , strong)NSNumber * ecId;
@property (nonatomic , strong)NSNumber * billId;
@end
@interface LxmLeftAndRightTextView : UIView
@property (nonatomic,strong) UILabel * textlab;
@property (nonatomic,strong) UILabel * rightlab;
@property (nonatomic,strong) UIView * lineView;
@end
