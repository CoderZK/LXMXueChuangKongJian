//
//  LxmMyFaDanCell.h
//  mag
//
//  Created by 李晓满 on 2018/7/18.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LxmMyFaDanCellDelegate;
@interface LxmMyFaDanCell : UITableViewCell
@property (nonatomic , weak)id<LxmMyFaDanCellDelegate>delegate;
@property (nonatomic , copy)void(^selectImgBlock)(NSInteger index);
@property (nonatomic , strong) LxmHomeModel * model;

@end
@protocol LxmMyFaDanCellDelegate<NSObject>
- (void)lxmMyFaDanCell:(LxmMyFaDanCell *)cell btnAtIndex:(NSInteger)index;
- (void)imgCollectionClick:(LxmMyFaDanCell *)cell;
- (void)peopleFinishDanClick:(LxmMyFaDanCell *)cell;

@end
