//
//  LxmPaiMaiAndZiXunBottomView.m
//  mag
//
//  Created by 李晓满 on 2018/7/11.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmPaiMaiAndZiXunBottomView.h"
@interface LxmPaiMaiAndZiXunBottomView()
@property (nonatomic , strong) UIView * bottomView;
@property (nonatomic , strong) UIButton * dianzanBtn;
@property (nonatomic , strong) UIButton * commentBtn;
@end
@implementation LxmPaiMaiAndZiXunBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.bottomView];
        [self.bottomView addSubview:self.dianzanBtn];
        [self.bottomView addSubview:self.commentBtn];
        
        [self setConstrains];
        UIView * line = [[UIView alloc] init];
        line.backgroundColor = LineColor;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(self);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}
- (void)setConstrains{
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self);
        make.height.equalTo(@50);
    }];
    [self.dianzanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomView);
        make.leading.equalTo(self);
        make.width.equalTo(@(ScreenW*0.5));
    }];
    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomView);
        make.leading.equalTo(self.dianzanBtn.mas_trailing);
        make.width.equalTo(@(ScreenW*0.5));
    }];
}
- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
    }
    return _bottomView;
}
- (UIButton *)dianzanBtn{
    if (!_dianzanBtn) {
        _dianzanBtn = [[UIButton alloc] init];
        [_dianzanBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        [_dianzanBtn setTitle:@"超赞" forState:UIControlStateNormal];
        [_dianzanBtn setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        _dianzanBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
        _dianzanBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _dianzanBtn.tag = 0;
        [_dianzanBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dianzanBtn;
}
- (UIButton *)commentBtn{
    if (!_commentBtn) {
        _commentBtn = [[UIButton alloc] init];
        [_commentBtn setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
        [_commentBtn setTitle:@"留言" forState:UIControlStateNormal];
        [_commentBtn setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        _commentBtn.tag = 1;
        _commentBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
        _commentBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_commentBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentBtn;
}
- (void)btnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(lxmPaiMaiAndZiXunBottomView:btnAtIndex:)]) {
        [self.delegate lxmPaiMaiAndZiXunBottomView:self btnAtIndex:btn.tag];
    }
}
- (void)setModel:(LxmArticleDetailModel *)model{
    _model = model;
    [self.dianzanBtn setImage:[UIImage imageNamed:model.likeStatus.intValue == 1 ?@"like":@"dislike"] forState:UIControlStateNormal];
}

@end
