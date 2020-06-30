//
//  LXMStarView.h
//  DefineStarSelected
//
//  Created by 李晓满 on 15/11/13.
//  Copyright © 2015年 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LXMStarViewDelegate;
@interface LXMStarView : UIView
-(instancetype)initWithFrame:(CGRect)frame withSpace:(CGFloat)space;
@property(nonatomic,assign)NSUInteger starNum;
@property (nonatomic , assign)id<LXMStarViewDelegate> delegate;
@end
@protocol LXMStarViewDelegate <NSObject>
@optional
- (void)didClickStar:(NSInteger )star;
@end
