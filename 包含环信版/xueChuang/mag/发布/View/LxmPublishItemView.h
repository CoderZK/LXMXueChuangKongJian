//
//  LxmPublishItemView.h
//  mag
//
//  Created by 李晓满 on 2018/7/17.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LxmPublishItemView : UIView

@property (nonatomic , copy)void(^clickBlock)(NSInteger item);
@property (nonatomic , strong)NSArray * dataArr;

@end
@interface LxmPublishItemCell: UICollectionViewCell

@property (nonatomic , strong)UIImageView * imgView;
@property (nonatomic , strong)UILabel * titleLab;

@end
