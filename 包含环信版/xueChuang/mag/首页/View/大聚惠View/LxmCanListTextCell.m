//
//  LxmCanListTextCell.m
//  mag
//
//  Created by 李晓满 on 2018/8/9.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmCanListTextCell.h"

@implementation LxmCanListTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.conetntLab = [[UILabel alloc] init];
        self.conetntLab.font = [UIFont systemFontOfSize:15];
        self.conetntLab.textColor = CharacterDarkColor;
        self.conetntLab.numberOfLines = 0;
        [self addSubview:self.conetntLab];
        
        [self.conetntLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.equalTo(self).offset(15);
            make.trailing.equalTo(self).offset(-15);
        }];
    }
    return self;
}


@end
