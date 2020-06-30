//
//  AroundDetailVC.h
//  mag
//
//  Created by 李晓满 on 2018/7/12.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface AroundDetailVC : BaseTableViewController
@property (nonatomic , copy) void(^refreshMyCollection)(void);
@property (nonatomic , strong) NSNumber *nearId;
@property (nonatomic , strong) NSNumber *typeID;
@end

@protocol LxmAroundDetailTopItemViewDelegate;
@interface LxmAroundDetailTopItemView : UIView
@property (nonatomic , strong) LxmAroundModel * model;
@property (nonatomic , weak) id<LxmAroundDetailTopItemViewDelegate>delegate;
@end
@protocol LxmAroundDetailTopItemViewDelegate<NSObject>
- (void)LxmAroundDetailTopItemViewCollectionClick;
@end
