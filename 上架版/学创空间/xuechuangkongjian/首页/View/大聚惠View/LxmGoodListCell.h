//
//  LxmGoodListCell.h
//  mag
//
//  Created by 李晓满 on 2018/7/16.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,LxmGoodListCell_style) {
    LxmGoodListCell_style_allgoodlist,
    LxmGoodListCell_style_dianshang,
    LxmGoodListCell_style_minePage
};

@protocol LxmGoodListCellDelegate;
@interface LxmGoodListCell : UITableViewCell
@property (nonatomic , weak) id<LxmGoodListCellDelegate> delegate;
@property (nonatomic , strong) LxmCanListModel * model;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(LxmGoodListCell_style)type;

@end

@protocol LxmGoodListCellDelegate<NSObject>
- (void)LxmGoodListCellHeaderImgViewClick:(LxmGoodListCell *)cell;
@end
