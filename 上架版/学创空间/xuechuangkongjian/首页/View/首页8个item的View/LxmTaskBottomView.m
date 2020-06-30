//
//  LxmTaskBottomView.m
//  mag
//
//  Created by 李晓满 on 2018/7/9.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmTaskBottomView.h"

@interface LxmTaskBottomView()
@property (nonatomic , strong) UIView * bottomView;

@property (nonatomic , strong) UIButton * commentBtn;
@property (nonatomic , strong) UIButton * baoMingBtn;
//约单时的聊一聊
@property (nonatomic , assign) LxmTaskBottomView_style style;
@end

@implementation LxmTaskBottomView

- (instancetype)initWithFrame:(CGRect)frame withStyle:(LxmTaskBottomView_style)style
{
    self = [super initWithFrame:frame];
    if (self) {
        _style = style;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.bottomView];
        [self.bottomView addSubview:self.dianzanBtn];
        [self.bottomView addSubview:self.commentBtn];
        [self.bottomView addSubview:self.baoMingBtn];
        [self setConstrains];
        
        UIView * line = [[UIView alloc] init];
        line.backgroundColor = [LineColor colorWithAlphaComponent:0.5];
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
        make.leading.equalTo(self).offset(15);
        make.width.equalTo(@60);
    }];
    if (_style == LxmTaskBottomView_style_yudan) {
        [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.bottomView);
            make.leading.equalTo(self.dianzanBtn.mas_trailing).offset(15);
            make.width.equalTo(@60);
        }];
    }else{
        [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.bottomView);
            make.leading.equalTo(self.dianzanBtn.mas_trailing).offset(30);
            make.width.equalTo(@60);
        }];
    }
   
    [self.baoMingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.bottom.equalTo(self.bottomView);
        make.width.equalTo(@((ScreenW-165)*0.5));
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
        _dianzanBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
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
        _commentBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _commentBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
        _commentBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_commentBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentBtn;
}
- (UIButton *)baoMingBtn{
    if (!_baoMingBtn) {
        _baoMingBtn = [[UIButton alloc] init];
        _baoMingBtn.titleLabel.numberOfLines = 0;
        _baoMingBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_baoMingBtn setBackgroundImage:[UIImage imageNamed:@"blue"] forState:UIControlStateNormal];
        if (_style == LxmTaskBottomView_style_qiangdan) {
            [_baoMingBtn setTitle:@"报名抢单" forState:UIControlStateNormal];
            [_baoMingBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        }else if (_style == LxmTaskBottomView_style_baoming){
            NSString * ss = [NSString stringWithFormat:@"报名:￥%@",@"50"];
            NSString * s = [NSString stringWithFormat:@"%@\n已报名:15/30",ss];
            NSRange range = [s rangeOfString:ss];
            NSMutableAttributedString * att  = [[NSMutableAttributedString alloc] initWithString:s];
            [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:range];
            [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(ss.length, s.length-ss.length)];
            [att addAttribute:NSForegroundColorAttributeName value:UIColor.whiteColor range:NSMakeRange(0, s.length)];
            [_baoMingBtn setAttributedTitle:att forState:UIControlStateNormal];
        }else if (_style == LxmTaskBottomView_style_yudan){
            [_baoMingBtn setTitle:@"立即约单" forState:UIControlStateNormal];
            [_baoMingBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        }else if (_style == LxmTaskBottomView_style_GoodsDetail) {
            [_baoMingBtn setTitle:@"立即约单" forState:UIControlStateNormal];
            [_baoMingBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        }
        _baoMingBtn.tag = 2;
        [_baoMingBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _baoMingBtn;
}


- (void)btnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(lxmTaskBottomView:btnAtIndex:)]) {
        [self.delegate lxmTaskBottomView:self btnAtIndex:btn.tag];
    }
}

- (void)setModel:(LxmArticleDetailModel *)model{
    _model = model;
    [self.dianzanBtn setImage:[UIImage imageNamed:model.likeStatus.intValue == 1 ?@"like":@"dislike"] forState:UIControlStateNormal];
    NSString * ss = [NSString stringWithFormat:@"报名:￥%0.2f",model.money.floatValue];
    NSString * s = [NSString stringWithFormat:@"%@\n已报名:%d/%d",ss,model.enrollAmount.intValue,model.limitNum.intValue];
    NSRange range = [s rangeOfString:ss];
    NSMutableAttributedString * att  = [[NSMutableAttributedString alloc] initWithString:s];
    [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:range];
    [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(ss.length, s.length-ss.length)];
    [att addAttribute:NSForegroundColorAttributeName value:UIColor.whiteColor range:NSMakeRange(0, s.length)];
    [_baoMingBtn setAttributedTitle:att forState:UIControlStateNormal];
}

- (void)setDetailModel:(LxmGoodsDetailModel *)detailModel{
    _detailModel = detailModel;
    [self.dianzanBtn setImage:[UIImage imageNamed:detailModel.likeStatus.intValue == 1 ?@"like":@"dislike"] forState:UIControlStateNormal];
}

@end
