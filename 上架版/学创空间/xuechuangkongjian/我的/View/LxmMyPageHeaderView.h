//
//  LxmMyPageHeaderView.h
//  mag
//
//  Created by 李晓满 on 2018/7/17.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LxmMyPageHeaderViewDelegate;
@interface LxmMyPageHeaderView : UITableViewHeaderFooterView
@property (nonatomic,assign)id<LxmMyPageHeaderViewDelegate>delegate;
-(void)lxmMyPageHeaderViewWithTag:(NSInteger)btnTag;
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier withTitleArr:(NSArray *)titleArr;
@end
@protocol LxmMyPageHeaderViewDelegate <NSObject>

-(void)lxmMyPageHeaderView:(LxmMyPageHeaderView *)view btnAtIndex:(NSInteger)index;

@end
