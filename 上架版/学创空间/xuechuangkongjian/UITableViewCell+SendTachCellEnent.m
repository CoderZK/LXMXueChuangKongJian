//
//  UITableViewCell+SendTachCellEnent.m
//  yumeiren
//
//  Created by zk on 2020/11/24.
//  Copyright © 2020 李晓满. All rights reserved.
//

#import "UITableViewCell+SendTachCellEnent.h"

@implementation UITableViewCell (SendTachCellEnent)

- (void)addSubview:(UIView *)view {
    [super addSubview:view];
    if (![view isEqual:self.contentView]) {
        [self.contentView addSubview:view];
    }
}

@end
