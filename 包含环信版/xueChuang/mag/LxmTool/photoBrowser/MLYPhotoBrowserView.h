//
//  SNYPhotoBrowserView.h
//  SNYMediaManager
//
//  Created by admin on 16/6/15.
//  Copyright © 2016年 sny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLYPhoto.h"


#define MLYPhotoBrowserViewFirstID (6495)
@interface UIView (MLYViewID)

@property(nonatomic,assign)NSInteger viewID;

@end



@class MLYPhotoBrowserView;

@protocol MLYPhotoBrowserViewDataSource <NSObject>

- (NSInteger)numberOfItemsInPhotoBrowserView:(MLYPhotoBrowserView *)photoBrowserView;

- (MLYPhoto *)photoBrowserView:(MLYPhotoBrowserView *)photoBrowserView photoForItemAtIndex:(NSInteger)index;

@end



@interface MLYPhotoBrowserView : UIView

+(instancetype)photoBrowserView;

@property(nonatomic,assign)NSInteger currentIndex;
@property(nonatomic,weak)id<MLYPhotoBrowserViewDataSource>dataSource;

/**
 *  显示照片浏览器
 *
 *  @param view2 包含该组所有imageView的父view ,一般是UICollectionView 或者 UIView
 */
- (void)showWithItemsSpuerView:(UIView *)view2;

- (void)dismiss;



-(void)reloadData;

@end




