//
//  LxmFriendVC.h
//  mag
//
//  Created by 李晓满 on 2018/7/20.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"
#import "LXMStarView.h"

@interface LxmFriendVC : BaseTableViewController
@property(nonatomic,weak)BaseViewController * preVC;
@end

@interface LxmFriendHeaderView : UIControl
@property(nonatomic,strong)UIImageView * iconImgView;
@property(nonatomic,strong)UILabel * textLab;
@property(nonatomic,strong)UILabel * numLab;
@end

@interface LxmFriendCell : UITableViewCell
@property(nonatomic,strong)UIImageView * headerImgView;
@property(nonatomic,strong)UIImageView * sexImgView;
@property(nonatomic,strong)UILabel * nameLab;
@property(nonatomic,strong)LXMStarView * starView;

@property(nonatomic,strong)LxmNewFriendListModel * model;
@end

