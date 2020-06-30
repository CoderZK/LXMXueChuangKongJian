//
//  LxmPayMoneyAbleVC.h
//  mag
//
//  Created by 李晓满 on 2018/7/18.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"
typedef NS_ENUM(NSInteger) {
    LxmPayMoneyAbleVC_type_fbjn,
    LxmPayMoneyAbleVC_type_wgmdsp
}LxmPayMoneyAbleVC_type;
@interface LxmPayMoneyAbleVC : BaseTableViewController
@property(nonatomic,weak)BaseViewController * preVC;

- (instancetype)initWithTableViewStyle:(UITableViewStyle)style type:(LxmPayMoneyAbleVC_type)type;

@end

@protocol LxmPayMoneyAbleCellDelegate;
@interface LxmPayMoneyAbleCell : UITableViewCell
@property (nonatomic , strong)LxmCanListModel * model;
@property (nonatomic , weak)id<LxmPayMoneyAbleCellDelegate>delegate;
@end

@protocol LxmPayMoneyAbleCellDelegate<NSObject>
- (void)LxmPayMoneyAbleCell:(LxmPayMoneyAbleCell *)cell btnAtIndex:(NSInteger)index;
@end
