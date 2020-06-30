//
//  LxmTableIndexView.h
//  recordnote
//
//  Created by 李晓满 on 2018/1/11.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LxmTableIndexViewDelegate;
@interface LxmTableIndexView : UIView

@property (nonatomic, weak) id<LxmTableIndexViewDelegate>delegate;

- (void)reloadData;

@end


@protocol LxmTableIndexViewDelegate <NSObject>

@optional
- (NSArray <NSString *>*)indexTitlesForIndexView:(LxmTableIndexView *)view;

- (void)indexView:(LxmTableIndexView *)view didSelectedAtIndex:(NSInteger)index;

@end
