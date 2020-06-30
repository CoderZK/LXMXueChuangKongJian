//
//  AdScrollView.h
//  testAdScroolView
//
//  Created by lxm on 15/7/5.
//  Copyright (c) 2015年 lxm. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "LxmHomeBannerModel.h"
@protocol SNY_AdScrollViewDelegate;

@interface SNY_AdScrollView : UIView<UIScrollViewDelegate>

@property (nonatomic, unsafe_unretained)id <SNY_AdScrollViewDelegate> delegate;
@property (nonatomic,strong)NSArray * dataArr;

@end

@protocol SNY_AdScrollViewDelegate <NSObject>
@optional
-(void)sny_adScrollView:(SNY_AdScrollView *)scrollView selectedIndex:(NSInteger)index;

@end
