//
//  LxmHeaderImgView.h
//  mag
//
//  Created by 李晓满 on 2018/7/28.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LxmHeaderImgView : UIView<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic , strong)NSArray * items;
@property (nonatomic , assign) BOOL isGoodList;
@property (nonatomic , strong)UICollectionViewFlowLayout * layout;
@property (nonatomic , strong)UICollectionView * collectionView;
@end
@interface LxmHeaderImgCell : UICollectionViewCell

@property (nonatomic , strong) UIImageView * headerImgView;

@end
