//
//  MKTextTableViewCell.m
//  mag
//
//  Created by 比由技术工场 on 2018/9/6.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "MKTextTableViewCell.h"

@implementation MKTextTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
