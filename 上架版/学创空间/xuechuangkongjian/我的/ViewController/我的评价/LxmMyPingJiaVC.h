//
//  LxmMyPingJiaVC.h
//  mag
//
//  Created by 李晓满 on 2018/7/19.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LxmMyPingJiaVC : BaseTableViewController

@end


@protocol LxmMyPingJiaCellDelegate;
@interface LxmMyPingJiaCell : UITableViewCell
@property (nonatomic , weak) id<LxmMyPingJiaCellDelegate>delegate;
@property (nonatomic , strong)LxmMyEvaluateListModel *model;
@end
@protocol LxmMyPingJiaCellDelegate<NSObject>
- (void)LxmMyPingJiaCell:(LxmMyPingJiaCell *)cell btnAtIndex:(NSInteger)index;
@end


@protocol LxmMyPingJiaCollectionViewDelegate;
@interface LxmMyPingJiaCollectionView : UIControl
@property (nonatomic , strong)NSArray *titleArr;

@property (nonatomic , weak)id<LxmMyPingJiaCollectionViewDelegate>delegate;
@property (nonatomic , copy)void(^selectItemBlock)(NSInteger index);
@end

@protocol LxmMyPingJiaCollectionViewDelegate<NSObject>
- (void)LxmMyPingJiaImgCollectionViewClick;
@end


@interface LxmMyPingJiaImgCollectionCell : UICollectionViewCell
@property (nonatomic , strong)UIImageView *imgView;

@end
