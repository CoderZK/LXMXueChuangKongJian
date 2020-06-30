//
//  LxmTableIndexView.m
//  recordnote
//
//  Created by 李晓满 on 2018/1/11.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmTableIndexView.h"

#define TitleSpace 5
#define TitleItemHeight 20

@interface LxmTableIndexView()
{
    NSMutableArray <UILabel *> *_labels;
    NSArray *_titles;
}
@end

@implementation LxmTableIndexView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _labels = [NSMutableArray array];
        [self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizer:)]];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizer:)]];
    }
    return self;
}

- (void)gestureRecognizer:(UIGestureRecognizer *)pan {
        CGFloat allHeight = _titles.count * (TitleSpace + TitleItemHeight) - TitleSpace;
        CGFloat offset = (self.bounds.size.height - allHeight) * 0.5;
        CGRect rect = CGRectMake(0, offset, self.bounds.size.width, allHeight);
        CGPoint point = [pan locationInView:self];
        if (CGRectContainsPoint(rect, point)) {
            for (UILabel *label in _labels) {
                if (CGRectContainsPoint(label.frame, point)) {
                    if ([self.delegate respondsToSelector:@selector(indexView:didSelectedAtIndex:)]) {
                        [self.delegate indexView:self didSelectedAtIndex:label.tag];
                    }
                    return;
                }
            }
        }
}

- (void)reloadData {
    for (UILabel *label in _labels) {
        [label removeFromSuperview];
    }
    [_labels removeAllObjects];
    
    if ([self.delegate respondsToSelector:@selector(indexTitlesForIndexView:)]) {
        NSArray *titles = [self.delegate indexTitlesForIndexView:self];
        _titles = titles;
        CGFloat allHeight = titles.count * (TitleSpace + TitleItemHeight) - TitleSpace;
        CGFloat offset = (self.bounds.size.height - allHeight) * 0.5;
        for (NSInteger i = 0; i < titles.count; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, offset + i * (TitleItemHeight + TitleSpace), self.bounds.size.width, TitleItemHeight)];
            label.font = [UIFont boldSystemFontOfSize:12];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = CharacterDarkColor;
            label.tag = i;
            label.text = titles[i];
            [self addSubview:label];
            [_labels addObject:label];
        }
    }
}

@end
