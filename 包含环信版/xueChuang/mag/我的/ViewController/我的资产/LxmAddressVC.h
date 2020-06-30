//
//  LxmAddressVC.h
//  mag
//
//  Created by 李晓满 on 2018/7/19.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"
@protocol LxmAddressVCDelegate;
@interface LxmAddressVC : BaseTableViewController
@property (nonatomic , weak) id<LxmAddressVCDelegate>delegate;
@end
@protocol LxmAddressVCDelegate<NSObject>
- (void)selectModel:(LxmMyAddressModel *)model;
@end

@protocol LxmAddressCellDelegate;
@interface LxmAddressCell : UITableViewCell
@property (nonatomic , strong) LxmMyAddressModel * model;
@property (nonatomic , weak) id<LxmAddressCellDelegate>delegate;
@end
@protocol LxmAddressCellDelegate<NSObject>
- (void)lxmAddressCell:(LxmAddressCell *)cell btnAtIndex:(NSInteger)index;

@end
