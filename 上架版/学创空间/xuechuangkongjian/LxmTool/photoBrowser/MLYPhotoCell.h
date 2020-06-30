//
//  SNYPhotoCell.h
//  SNYMediaManager
//
//  Created by admin on 16/6/15.
//  Copyright © 2016年 sny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLYPhoto.h"

@protocol MLYPhotoCellDelegate;
@interface MLYPhotoCell : UICollectionViewCell

@property(nonatomic,strong)MLYPhoto * photo;

@property(nonatomic,weak)id<MLYPhotoCellDelegate>delegate;

@end


@protocol MLYPhotoCellDelegate <NSObject>

-(void)photoCellTap:(MLYPhotoCell*)cell;

@end


@interface MLYPhotoScrollView : UIScrollView<UIScrollViewDelegate>

@property(nonatomic,strong,readonly)UIImageView * imageView;

@end