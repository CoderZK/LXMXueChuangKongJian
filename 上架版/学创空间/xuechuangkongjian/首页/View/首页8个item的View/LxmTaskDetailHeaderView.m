//
//  LxmTaskDetailHeaderView.m
//  mag
//
//  Created by 李晓满 on 2018/7/9.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmTaskDetailHeaderView.h"
@interface LxmTaskDetailHeaderView()
@property (nonatomic , strong)UIView * topView;
@property (nonatomic , strong) UIImageView * headerImgView;
@property (nonatomic , strong) UIImageView * sexImgView;
@property (nonatomic , strong) UILabel * nameLab;
@property (nonatomic , strong) UIButton * dianzanBtn;

@property (nonatomic , strong) UILabel * contentLab;
@property (nonatomic , strong) UILabel * timeLab;
@property (nonatomic , assign) NSInteger sectionIndex;
@end

@implementation LxmTaskDetailHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier withIndex:(NSInteger)index{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.sectionIndex = index;
        
        [self addSubview:self.topView];
        [self.topView addSubview:self.headerImgView];
        [self.topView addSubview:self.sexImgView];
        [self.topView addSubview:self.nameLab];
        [self addSubview:self.contentLab];
        [self addSubview:self.timeLab];
   
        UIView * line = [[UIView alloc] init];
        line.backgroundColor = LineColor;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.sexImgView);
            make.trailing.equalTo(self).offset(-15);
            make.bottom.equalTo(self);
            make.height.equalTo(@0.5);
        }];
        
        UIButton * bgBtn = [[UIButton alloc] init];
        bgBtn.tag = index;
        [bgBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bgBtn];
        [bgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(self);
            make.height.equalTo(self);
        }];
        [bgBtn addSubview:self.dianzanBtn];
        
        [self setConstrains];
       
    }
    return self;
}
- (void)btnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(LxmTaskDetailHeaderView:btnAnIndex:)]) {
        [self.delegate LxmTaskDetailHeaderView:self btnAnIndex:btn.tag];
    }
}



- (void)setConstrains{
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self);
        make.height.equalTo(@60);
    }];
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView);
        make.leading.equalTo(self.topView).offset(15);
        make.width.height.equalTo(@30);
    }];
    [self.sexImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView);
        make.leading.equalTo(self.headerImgView.mas_trailing).offset(10);
        make.width.height.equalTo(@15);
    }];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView);
        make.leading.equalTo(self.sexImgView.mas_trailing).offset(3);
        make.trailing.equalTo(self.dianzanBtn.mas_leading);
    }];
    [self.dianzanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView);
        make.trailing.equalTo(self).offset(-15);
    }];
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.leading.equalTo(self.sexImgView);
        make.trailing.equalTo(self).offset(-15);
    }];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLab.mas_bottom);
        make.leading.equalTo(self.sexImgView);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@20);
    }];
}
- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.userInteractionEnabled = YES;
    }
    return _topView;
}
- (UIImageView *)headerImgView{
    if (!_headerImgView) {
        _headerImgView = [[UIImageView alloc] init];
        _headerImgView.image = [UIImage imageNamed:@"moren"];
        _headerImgView.layer.cornerRadius = 15;
        _headerImgView.layer.masksToBounds = YES;
    }
    return _headerImgView;
}
- (UIImageView *)sexImgView{
    if (!_sexImgView) {
        _sexImgView = [[UIImageView alloc] init];
        _sexImgView.image = [UIImage imageNamed:@"female"];
    }
    return _sexImgView;
}
- (UILabel *)nameLab{
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] init];
        _nameLab.font = [UIFont systemFontOfSize:15];
        _nameLab.text = @"巴啦啦小魔仙";
        _nameLab.textColor = CharacterDarkColor;
    }
    return _nameLab;
}
- (UIButton *)dianzanBtn{
    if (!_dianzanBtn) {
        _dianzanBtn = [[UIButton alloc] init];
        [_dianzanBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        [_dianzanBtn setTitle:@"11" forState:UIControlStateNormal];
        [_dianzanBtn setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        _dianzanBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _dianzanBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -2);
        _dianzanBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
        [_dianzanBtn addTarget:self action:@selector(dianzanClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dianzanBtn;
}

- (UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab = [[UILabel alloc] init];
        _contentLab.font = [UIFont systemFontOfSize:14];
        _contentLab.text = @"钱太少了钱太少了钱太少了钱太少了钱太少了钱太少了钱太少了钱太少了";
        _contentLab.textColor = CharacterDarkColor;
        _contentLab.numberOfLines = 0;
    }
    return _contentLab;
}
- (UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.font = [UIFont systemFontOfSize:14];
        _timeLab.text = @"12:12";
        _timeLab.textColor = CharacterLightGrayColor;
    }
    return _timeLab;
}

- (void)setModel:(LxmCommentListModel *)model{
    _model = model;
    [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:[LxmURLDefine getPicImgWthPicStr:model.userPic]] placeholderImage:[UIImage imageNamed:@"moren"] options:SDWebImageRetryFailed];
    self.sexImgView.image = [UIImage imageNamed:model.sex.intValue == 1?@"male":@"female"];
    self.nameLab.text = model.userName;
    self.contentLab.text = model.content;
    self.timeLab.text = [NSString stringWithTime:model.createTime];
    [self.dianzanBtn setTitle:[NSString stringWithFormat:@"%d ",model.likeNum.intValue] forState:UIControlStateNormal];
    [self.dianzanBtn setImage:[UIImage imageNamed:model.likeStatus.intValue == 1? @"like":@"dislike"] forState:UIControlStateNormal];
}

- (void)dianzanClick{
    if ([self.delegate respondsToSelector:@selector(LxmTaskDetailHeaderView:zanIndex:)]) {
        [self.delegate LxmTaskDetailHeaderView:self zanIndex:self.sectionIndex];
    }
}

@end
