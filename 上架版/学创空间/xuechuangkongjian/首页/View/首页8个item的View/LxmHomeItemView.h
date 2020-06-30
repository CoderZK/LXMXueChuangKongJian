//
//  lxmHomeItemView.h
//  mag
//
//  Created by 李晓满 on 2018/7/3.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LxmHomeItemView : UIView
- (instancetype)initWithFrame:(CGRect)frame;
@property (nonatomic , copy)void(^clickBlock)(LxmHomeBannerModel* model);
@property (nonatomic , strong)NSArray *dataArr;

@end

@interface LxmHomeItemCell: UICollectionViewCell

@property (nonatomic , strong)UIImageView * imgView;
@property (nonatomic , strong)UILabel * titleLab;

@end
