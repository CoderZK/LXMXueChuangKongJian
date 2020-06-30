//
//  LxmCommentContentView.h
//  mag
//
//  Created by 李晓满 on 2018/7/20.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LxmCommentContentView : UIView
@property (nonatomic , strong)NSNumber * star;
@property (nonatomic , strong) IQTextView * textView;
- (void)show;
- (void)dismiss;
@end
