//
//  LxmHomeNewItemView.h
//  mag
//
//  Created by 李晓满 on 2018/11/21.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LxmHomeNewItemView : UIView

@property (nonatomic, strong) NSArray *itemArr;

@property (nonatomic , copy)void(^clickBlock)(LxmHomeBannerModel* model);

@end


@interface LxmHomeNewCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *bgImgView;//背景图

@property (nonatomic, strong) UIImageView *iconImgView;//图标

@property (nonatomic, strong) UILabel *textLabel;//文字

@end
