//
//  LxmHomeCell.h
//  mag
//
//  Created by 李晓满 on 2018/7/4.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LxmHomeCellDelegate;
@interface LxmHomeCell : UITableViewCell
@property (nonatomic , strong)LxmHomeModel * model;
@property (nonatomic , copy)void(^selectImgBlock)(NSInteger index);
@property (nonatomic , strong) UIButton * commentBtn;
//@property (nonatomic , strong) UIButton * peopleinfoBtn;
@property (nonatomic , weak) id<LxmHomeCellDelegate>delegate;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isMine:(BOOL)isMine;
@end

@protocol LxmHomeCellDelegate<NSObject>
- (void)LxmHomeCellZanClick:(LxmHomeCell *)cell;

- (void)imgCollectionClick:(LxmHomeCell *)cell;

- (void)headerImgViewClick:(LxmHomeCell *)cell;

@end

