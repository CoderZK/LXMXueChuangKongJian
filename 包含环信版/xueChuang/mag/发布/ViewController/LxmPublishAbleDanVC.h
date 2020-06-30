//
//  LxmPublishAbleDanVC.h
//  mag
//
//  Created by 李晓满 on 2018/7/17.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"
#import "LxmPublishDanVC.h"
#import "LxmTextTFView.h"

@interface LxmPublishAbleDanVC : BaseTableViewController
- (instancetype)initWithTableViewStyle:(UITableViewStyle)style LxmHomeBannerModel:(LxmHomeBannerModel *)model;
@end

@interface LxmPublishAbleDanTitleView : UIView
@property (nonatomic , strong)UITextField * titleTF;
@end

@protocol LxmPublishAbleOtherInfoViewDelegate;
@interface LxmPublishAbleOtherInfoView : UIView
@property (nonatomic , weak)id<LxmPublishAbleOtherInfoViewDelegate>delegate;
@property (nonatomic , strong)LxmLeftLabRightNumView *priceView;
@property (nonatomic , strong)LxmTextTFView *danweiView;
@property (nonatomic , strong)UILabel *priceLab;
@end
@protocol LxmPublishAbleOtherInfoViewDelegate<NSObject>
- (void)LxmPublishAbleOtherInfoView:(LxmPublishAbleOtherInfoView *)view btnAtnIndex:(NSInteger)index;
@end
