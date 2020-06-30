//
//  LxmSaleJiNengCell.h
//  mag
//
//  Created by 李晓满 on 2018/7/18.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LxmSaleJiNengCellDelegate;
@interface LxmSaleJiNengCell : UITableViewCell

@property (nonatomic , assign) id<LxmSaleJiNengCellDelegate>delegate;
@property (nonatomic , strong) LxmCanListModel * model;

@end
@protocol LxmSaleJiNengCellDelegate<NSObject>
- (void)LxmSaleJiNengCell:(LxmSaleJiNengCell *)cell btnAtIndex:(NSInteger)index;
- (void)headerImgClick:(LxmSaleJiNengCell *)cell;
@end
