//
//  LxmTaskBottomView.h
//  mag
//
//  Created by 李晓满 on 2018/7/9.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef  NS_ENUM(NSInteger){
    LxmTaskBottomView_style_qiangdan,
    LxmTaskBottomView_style_baoming,
    LxmTaskBottomView_style_yudan,
    LxmTaskBottomView_style_GoodsDetail //商品详情购买
}LxmTaskBottomView_style;

@protocol LxmTaskBottomViewDelegate;
@interface LxmTaskBottomView : UIView

@property (nonatomic , strong) UIButton * dianzanBtn;
@property (nonatomic , weak)id<LxmTaskBottomViewDelegate>delegate;
@property (nonatomic , strong) LxmArticleDetailModel * model;
@property (nonatomic , strong) LxmGoodsDetailModel * detailModel;

- (instancetype)initWithFrame:(CGRect)frame withStyle:(LxmTaskBottomView_style)style;

@end
@protocol LxmTaskBottomViewDelegate<NSObject>
- (void)lxmTaskBottomView:(LxmTaskBottomView *)bottomView btnAtIndex:(NSInteger)index;
@end
