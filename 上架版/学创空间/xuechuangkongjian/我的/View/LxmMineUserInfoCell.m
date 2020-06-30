//
//  LxmMineUserInfoCell.m
//  mag
//
//  Created by 宋乃银 on 2018/7/7.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmMineUserInfoCell.h"
#import "LxmStarImgView.h"

@interface LxmMineUserInfoCell()

@property (nonatomic, strong) UIImageView * headerImgView;
@property (nonatomic, strong) UIImageView * sexImgView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) LxmStarImgView * starView;

@end

@implementation LxmMineUserInfoCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self addSubview:self.headerImgView];
        [self addSubview:self.sexImgView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.starView];
        [self setLayout];
    }
    return self;
}

- (void)setLayout {
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@60);
        make.centerY.equalTo(self);
        make.leading.equalTo(self).offset(10);
    }];
    
    [self.sexImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@20);
        make.centerY.equalTo(self).offset(-12);
        make.leading.equalTo(self.headerImgView.mas_trailing).offset(10);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sexImgView);
        make.leading.equalTo(self.sexImgView.mas_trailing).offset(2);
    }];
    
    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@83);
        make.height.equalTo(@15);
        make.centerY.equalTo(self).offset(12);
        make.leading.equalTo(self.headerImgView.mas_trailing).offset(10);
    }];
}

- (UIImageView *)headerImgView {
    if (!_headerImgView) {
        _headerImgView = [[UIImageView alloc] init];
        _headerImgView.image = [UIImage imageNamed:@"moren"];
        _headerImgView.layer.cornerRadius = 30;
        _headerImgView.layer.masksToBounds = YES;
    }
    return _headerImgView;
}

- (UIImageView *)sexImgView {
    if (!_sexImgView) {
        _sexImgView = [[UIImageView alloc] init];
        
    }
    return _sexImgView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
    }
    return _nameLabel;
}

- (LxmStarImgView *)starView {
    if (!_starView) {
        _starView = [[LxmStarImgView alloc] init];
        
    }
    return _starView;
}
- (void)setModel:(LxmUserInfoModel *)model{
    _model = model;
    _starView.starNum = model.goodRate;
    _nameLabel.text = model.nickname;
    _sexImgView.image = [UIImage imageNamed:model.sex == 1?@"male":@"female"];
    [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:[LxmURLDefine getPicImgWthPicStr:model.headimg]] placeholderImage:[UIImage imageNamed:@"moren"] options:SDWebImageRetryFailed];
}


@end
