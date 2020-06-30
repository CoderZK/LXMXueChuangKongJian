//
//  LxmTaskDetailCell.h
//  mag
//
//  Created by 李晓满 on 2018/7/9.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LxmTaskDetailCellDelegate;
@interface LxmTaskDetailCell : UITableViewCell
@property (nonatomic , strong) LxmCommentReplyListModel * model;
@property (nonatomic , weak) id<LxmTaskDetailCellDelegate>delegate;
@end
@protocol LxmTaskDetailCellDelegate<NSObject>
- (void)LxmTaskDetailCellZanClick:(LxmTaskDetailCell *)cell;
@end
