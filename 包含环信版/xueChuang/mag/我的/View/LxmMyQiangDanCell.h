//
//  LxmMyQiangDanCell.h
//  mag
//
//  Created by 李晓满 on 2018/7/18.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LxmMyQiangDanCellDelegate;
@interface LxmMyQiangDanCell : UITableViewCell
@property (nonatomic , weak)id<LxmMyQiangDanCellDelegate>delegate;
@property (nonatomic , copy)void(^selectImgBlock)(NSInteger index);
@property (nonatomic , strong)LxmHomeModel * model;
@end
@protocol LxmMyQiangDanCellDelegate<NSObject>
- (void)lxmMyQiangDanCell:(LxmMyQiangDanCell *)cell btnAtIndex:(NSInteger)index;
- (void)imgCollectionClick:(LxmMyQiangDanCell *)cell;
- (void)peopleFinishDanClick:(LxmMyQiangDanCell *)cell;
@end
