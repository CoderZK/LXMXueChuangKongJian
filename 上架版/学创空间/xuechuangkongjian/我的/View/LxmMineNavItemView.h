//
//  LxmMineNavItemView.h
//  mag
//
//  Created by 李晓满 on 2018/7/18.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LxmMineNavItemViewDelegate;
@interface LxmMineNavItemView : UITableViewHeaderFooterView
@property (nonatomic,assign)id<LxmMineNavItemViewDelegate>delegate;
-(void)LxmMineNavItemViewWithTag:(NSInteger)btnTag;
- (instancetype)initWithFrame:(CGRect)frame withTitleArr:(NSArray *)titleArr;
@end
@protocol LxmMineNavItemViewDelegate <NSObject>

-(void)LxmMineNavItemView:(LxmMineNavItemView *)view btnAtIndex:(NSInteger)index;

@end
