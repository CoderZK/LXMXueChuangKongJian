//
//  LxmGoodListTopView.h
//  mag
//
//  Created by 李晓满 on 2018/7/13.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LxmGoodListTopViewDelegate;
@interface LxmGoodListTopView : UIView
@property (nonatomic , weak)id<LxmGoodListTopViewDelegate>delegate;
@property (nonatomic , strong)NSArray *titleArr;
- (void)lxmGoodListTopViewSelectIndex:(NSInteger)index;
@end
@protocol LxmGoodListTopViewDelegate<NSObject>
- (void)LxmGoodListTopView:(LxmGoodListTopView *)topView btnAtIndex:(NSInteger)index;
@end



@interface LxmGoodCataCell : UICollectionViewCell
@property (nonatomic , strong) UILabel * titleLab;
@property (nonatomic , strong) UIImageView * imgView;
@end
