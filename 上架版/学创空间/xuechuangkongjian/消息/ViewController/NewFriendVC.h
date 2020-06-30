//
//  NewFriendVC.h
//  mag
//
//  Created by 宋乃银 on 2018/7/22.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface NewFriendVC : BaseTableViewController

@property (nonatomic, copy) void(^passFriendBlock)(void);

@end

@protocol LxmNewFriendCellDelegate;
@interface LxmNewFriendCell : UITableViewCell
@property (nonatomic , strong) LxmFindNewFriendListModel * model;
@property (nonatomic , weak) id<LxmNewFriendCellDelegate>delegate;
@end
@protocol LxmNewFriendCellDelegate<NSObject>
- (void)LxmNewFriendCellPassBtnClick:(LxmNewFriendCell *)cell;
@end
