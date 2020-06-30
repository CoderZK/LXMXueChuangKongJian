//
//  LxmPaiMaiAndZiXunBottomView.h
//  mag
//
//  Created by 李晓满 on 2018/7/11.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LxmPaiMaiAndZiXunBottomViewDelegate;
@interface LxmPaiMaiAndZiXunBottomView : UIView
@property (nonatomic , weak)id<LxmPaiMaiAndZiXunBottomViewDelegate>delegate;
@property (nonatomic , strong) LxmArticleDetailModel * model;
@end
@protocol LxmPaiMaiAndZiXunBottomViewDelegate<NSObject>
- (void)lxmPaiMaiAndZiXunBottomView:(LxmPaiMaiAndZiXunBottomView *)bottomView btnAtIndex:(NSInteger)index;
@end
