//
//  LxmImgCollectionView.h
//  mag
//
//  Created by 李晓满 on 2018/7/26.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LxmImgCollectionViewDelegate;
@interface LxmImgCollectionView : UIControl
@property (nonatomic , strong)NSArray *titleArr;

@property (nonatomic , weak)id<LxmImgCollectionViewDelegate>delegate;
@property (nonatomic , copy)void(^selectItemBlock)(NSInteger index);
@end

@protocol LxmImgCollectionViewDelegate<NSObject>
- (void)LxmImgCollectionViewClick;
@end


@interface LxmImgCollectionCell : UICollectionViewCell
@property (nonatomic , strong)UIImageView *imgView;

@end
