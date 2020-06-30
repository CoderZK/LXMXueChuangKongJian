//
//  LxmLvAndPaiMaiItemView.h
//  mag
//
//  Created by 李晓满 on 2018/7/10.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LxmLvAndPaiMaiItemViewDelegate;
@interface LxmLvAndPaiMaiItemView : UIView
@property (nonatomic , strong) LxmArticleDetailModel * detailModel;
@property (nonatomic , weak) id<LxmLvAndPaiMaiItemViewDelegate>delegate;
@end
@protocol LxmLvAndPaiMaiItemViewDelegate<NSObject>
- (void)LxmLvAndPaiMaiItemViewCollectionClick;
@end
