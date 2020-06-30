//
//  LxmHomeNewCell.h
//  mag
//
//  Created by 李晓满 on 2018/11/22.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LxmHomeNewCellDelegate;

@interface LxmHomeNewCell : UITableViewCell

@property (nonatomic , strong)LxmHomeModel * model;

@property (nonatomic , copy)void(^selectImgBlock)(NSInteger index);

@property (nonatomic , copy)void(^pageToDetail)(void);

@property (nonatomic , strong) UIButton * commentBtn;

@property (nonatomic , weak) id<LxmHomeNewCellDelegate>delegate;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isMine:(BOOL)isMine;

@end

@protocol LxmHomeNewCellDelegate<NSObject>

- (void)LxmHomeNewCellZanClick:(LxmHomeNewCell *)cell;

- (void)headerImgViewClick:(LxmHomeNewCell *)cell;

@end
