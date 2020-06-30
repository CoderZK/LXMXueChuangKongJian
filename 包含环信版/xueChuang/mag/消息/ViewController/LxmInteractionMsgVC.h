//
//  LxmInteractionMsgVC.h
//  mag
//
//  Created by 宋乃银 on 2018/7/21.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LxmInteractionMsgVC : BaseTableViewController

@end

@interface LxmInteractionMsgCell : UITableViewCell
@property (nonatomic , strong) LxmFindInterMsgModel * dataModel;
@property (nonatomic , copy) void (^headImageViewHandle)();
@end

