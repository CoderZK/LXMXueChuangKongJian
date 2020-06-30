//
//  LxmMineNewNavItemView.h
//  mag
//
//  Created by 李晓满 on 2018/11/22.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LxmMineNewNavItemViewDelegate;
@interface LxmMineNewNavItemView : UITableViewHeaderFooterView
@property (nonatomic,assign)id<LxmMineNewNavItemViewDelegate>delegate;
-(void)LxmMineNewNavItemViewWithTag:(NSInteger)btnTag;
- (instancetype)initWithFrame:(CGRect)frame withTitleArr:(NSArray *)titleArr;
@end
@protocol LxmMineNewNavItemViewDelegate <NSObject>

-(void)LxmMineNewNavItemView:(LxmMineNewNavItemView *)view btnAtIndex:(NSInteger)index;

@end

