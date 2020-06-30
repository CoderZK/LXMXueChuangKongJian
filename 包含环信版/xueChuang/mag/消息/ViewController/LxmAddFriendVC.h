//
//  LxmAddFriendVC.h
//  mag
//
//  Created by 宋乃银 on 2018/7/22.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LxmAddFriendVC : BaseTableViewController

@end

@protocol LxmAddFriendCellDelegate;
@interface LxmAddFriendCell : UITableViewCell
@property (nonatomic , strong) LxmFindNewFriendListModel * model;
@property (nonatomic , weak)id<LxmAddFriendCellDelegate>delegate;
@end
@protocol LxmAddFriendCellDelegate<NSObject>
- (void)LxmAddFriendCellBtnClick:(LxmAddFriendCell *)cell;
@end
