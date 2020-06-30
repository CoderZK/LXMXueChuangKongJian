//
//  LxmTaskDetailHeaderView.h
//  mag
//
//  Created by 李晓满 on 2018/7/9.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LxmTaskDetailHeaderViewDelegate;
@interface LxmTaskDetailHeaderView : UITableViewHeaderFooterView
@property (nonatomic , strong)LxmCommentListModel * model;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier withIndex:(NSInteger)index;
@property (nonatomic , weak)id<LxmTaskDetailHeaderViewDelegate>delegate;
@end
@protocol LxmTaskDetailHeaderViewDelegate<NSObject>
- (void)LxmTaskDetailHeaderView:(LxmTaskDetailHeaderView *)headerView btnAnIndex:(NSInteger)index;
- (void)LxmTaskDetailHeaderView:(LxmTaskDetailHeaderView *)headerView zanIndex:(NSInteger)index;
@end
