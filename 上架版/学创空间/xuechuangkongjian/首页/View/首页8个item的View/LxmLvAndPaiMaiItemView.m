//
//  LxmLvAndPaiMaiItemView.m
//  mag
//
//  Created by 李晓满 on 2018/7/10.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmLvAndPaiMaiItemView.h"
@interface LxmLvAndPaiMaiItemView()
@property (nonatomic , strong)UILabel *titleLab;
@property (nonatomic , strong)UILabel *timeLab;
@property (nonatomic , strong)UIButton *collectionBtn;
@end

@implementation LxmLvAndPaiMaiItemView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLab];
        [self addSubview:self.timeLab];
        [self addSubview:self.collectionBtn];
        [self setConstrains];
    }
    return self;
}
- (void)setConstrains{
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-100);
        make.height.equalTo(@50);
    }];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab.mas_bottom);
        make.leading.trailing.equalTo(self.titleLab);
        make.height.equalTo(@20);
    }];
    [self.collectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.trailing.equalTo(self).offset(-15);
        make.width.equalTo(@60);
        make.height.equalTo(@30);
    }];
}
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = CharacterDarkColor;
        _titleLab.font = [UIFont systemFontOfSize:18];
        _titleLab.numberOfLines = 0;
        _titleLab.text = @"国庆德国+法国+瑞士+意大利12日游";
    }
    return _titleLab;
}
- (UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.textColor = CharacterLightGrayColor;
        _timeLab.font = [UIFont systemFontOfSize:13];
        _timeLab.text = @"";
    }
    return _timeLab;
}
- (UIButton *)collectionBtn{
    if (!_collectionBtn) {
        _collectionBtn = [[UIButton alloc] init];
        [_collectionBtn setBackgroundImage:[UIImage imageNamed:@"blue"] forState:UIControlStateNormal];
        [_collectionBtn setTitle:@"收藏" forState:UIControlStateNormal];
        [_collectionBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _collectionBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _collectionBtn.layer.cornerRadius = 5;
        _collectionBtn.layer.masksToBounds = YES;
        [_collectionBtn addTarget:self action:@selector(collectionClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectionBtn;
}

- (void)collectionClick{
    if ([self.delegate respondsToSelector:@selector(LxmLvAndPaiMaiItemViewCollectionClick)]) {
        [self.delegate LxmLvAndPaiMaiItemViewCollectionClick];
    }
}

- (void)setDetailModel:(LxmArticleDetailModel *)detailModel{
    _detailModel = detailModel;
    self.titleLab.text = detailModel.title;
    [self.collectionBtn setTitle:self.detailModel.collectStatus.intValue == 1?@"已收藏":@"收藏" forState:UIControlStateNormal];
    NSString * timeStr = @"";
    if (detailModel.createTime.length > 16) {
        timeStr = [detailModel.createTime substringToIndex:detailModel.createTime.length - 3];
    }else{
        timeStr = detailModel.createTime;
    }
    self.timeLab.text = [NSString stringWithFormat:@"%@    评论%d·超赞%d",timeStr,detailModel.commentNum.intValue,detailModel.likeNum.intValue];
}

@end
