//
//  LxmPingJiaVC.h
//  mag
//
//  Created by 李晓满 on 2018/7/13.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LxmPingJiaVC : BaseTableViewController

- (instancetype)initWithTableViewStyle:(UITableViewStyle)style model:(LxmAroundModel *)model;
@property (nonatomic , copy) void(^refreshPreVC)(void);

@end

@interface LxmPingJiaImgItemCell : UICollectionViewCell
@property (nonatomic , strong) UIImageView *imgView;
@property (nonatomic,strong) UIButton * deleteBtn;
@end

@protocol LxmPingJiaImgCellDelegate;
@interface LxmPingJiaImgCell : UITableViewCell
@property (nonatomic , strong) NSMutableArray * imgArr;
@property (nonatomic , weak)id<LxmPingJiaImgCellDelegate>delegate;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withImg:(NSMutableArray *)imgs;
@end
@protocol LxmPingJiaImgCellDelegate<NSObject>
- (void)LxmPingJiaImgCell:(LxmPingJiaImgCell *)cell btnAtIndex:(NSInteger)index;
- (void)LxmPingJiaImgCell:(LxmPingJiaImgCell *)cell deleteAtIndex:(NSInteger)index;
@end
