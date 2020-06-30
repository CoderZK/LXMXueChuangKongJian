//
//  LxmSaleJiNengCell.m
//  mag
//
//  Created by 李晓满 on 2018/7/18.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmSaleJiNengCell.h"
#import "LxmHeaderImgView.h"
@interface LxmSaleJiNengCell()

/**
 商品信息模块
 */
@property (nonatomic , strong) UIView * goodInfoView;
@property (nonatomic , strong) UIImageView * picImgView;
@property (nonatomic , strong) UILabel * titleLab;
@property (nonatomic , strong) UILabel * moneyLab;
@property (nonatomic , strong) UILabel * contentLab;
/**
 抢单人信息模块
 */

@property (nonatomic , strong) LxmHeaderImgView * peopleView;
@property (nonatomic , strong) UIButton * peopleinfoBtn;
@property (nonatomic , strong) UILabel * totalLab;
/**
 订单状态模块
 */
@property (nonatomic , strong) UIView * stateView;
@property (nonatomic , strong) UILabel * stateLab;
@property (nonatomic , strong) UIButton * peopleBtn;
@property (nonatomic , strong) UIButton * stateBtn;

@end
@implementation LxmSaleJiNengCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.goodInfoView];
        [self.goodInfoView addSubview:self.picImgView];
        [self.goodInfoView addSubview:self.titleLab];
        [self.goodInfoView addSubview:self.moneyLab];
        [self.goodInfoView addSubview:self.contentLab];
        
        [self addSubview:self.peopleView];
        [self.peopleView addSubview:self.totalLab];
        [self.peopleView addSubview:self.peopleinfoBtn];

        [self addSubview:self.stateView];
        [self.stateView addSubview:self.stateLab];
        [self.stateView addSubview:self.peopleBtn];
        [self.stateView addSubview:self.stateBtn];
        
        [self setConstrains];
        UIView * line = [[UIView alloc] init];
        line.backgroundColor = LineColor;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.leading.trailing.equalTo(self);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}
- (void)setConstrains{
    [self.goodInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self);
        make.height.equalTo(@120);
    }];
    [self.picImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self.goodInfoView).offset(15);
        make.width.height.equalTo(@80);
    }];
    [self.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLab);
        make.trailing.equalTo(self.goodInfoView).offset(-15);
        make.width.equalTo(@85);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.picImgView.mas_trailing).offset(15);
        make.top.equalTo(self.picImgView);
        make.trailing.equalTo(self.moneyLab.mas_leading).offset(-5);
    }];
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.titleLab);
        make.trailing.equalTo(self.goodInfoView).offset(-15);
        make.top.equalTo(self.titleLab.mas_bottom).offset(10);
    }];

    [self.peopleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.stateView.mas_top);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@50);
    }];
    [self.peopleinfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.peopleView);
        make.height.equalTo(@50);
    }];
    
    [self.totalLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.trailing.equalTo(self.peopleView);
    }];

    [self.stateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@60);
    }];
    [self.stateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.leading.equalTo(self.stateView);
    }];
    [self.peopleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.stateView);
        make.trailing.equalTo(self.stateBtn.mas_leading).offset(-15);
        make.width.equalTo(@80);
        make.height.equalTo(@30);
    }];
    [self.stateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.stateView);
        make.trailing.equalTo(self.stateView);
        make.width.equalTo(@80);
        make.height.equalTo(@30);
    }];
    
}

- (UIView *)goodInfoView{
    if (!_goodInfoView) {
        _goodInfoView = [[UIView alloc] init];
    }
    return _goodInfoView;
}
- (UIImageView *)picImgView{
    if (!_picImgView) {
        _picImgView = [[UIImageView alloc] init];
        _picImgView.image = [UIImage imageNamed:@"whequemoren"];
    }
    return _picImgView;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont boldSystemFontOfSize:18];
        _titleLab.textColor = CharacterDarkColor;
        _titleLab.numberOfLines = 2;
        _titleLab.text = @"手工润唇膏";
    }
    return _titleLab;
}
- (UILabel *)moneyLab{
    if (!_moneyLab) {
        _moneyLab = [[UILabel alloc] init];
        _moneyLab.font = [UIFont boldSystemFontOfSize:18];
        _moneyLab.textColor = CharacterDarkColor;
        _moneyLab.text = @"20元/支";
        _moneyLab.textAlignment = NSTextAlignmentRight;
    }
    return _moneyLab;
}

- (UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab = [[UILabel alloc] init];
        _contentLab.font = [UIFont systemFontOfSize:14];
        _contentLab.numberOfLines = 2;
        _contentLab.text = @"北门圆通,收件人冯全,送至2-231,中午前送达哦";
    }
    return _contentLab;
}
- (LxmHeaderImgView *)peopleView{
    if (!_peopleView) {
        _peopleView = [[LxmHeaderImgView alloc] init];
        _peopleView.isGoodList = YES;
        _peopleView.layer.masksToBounds = YES;
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, ScreenW - 30, 0.5)];
        line.backgroundColor = LineColor;
        [_peopleView addSubview:line];
    }
    return _peopleView;
}
- (UIButton *)peopleinfoBtn{
    if (!_peopleinfoBtn) {
        _peopleinfoBtn = [[UIButton alloc] init];
        [_peopleinfoBtn addTarget:self action:@selector(peopleHeadClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _peopleinfoBtn;
}

- (UILabel *)totalLab{
    if (!_totalLab) {
        _totalLab = [[UILabel alloc] init];
        _totalLab.font = [UIFont systemFontOfSize:13];
        _totalLab.textColor = CharacterLightGrayColor;
        _totalLab.text = @"5人已抢单";
    }
    return _totalLab;
}
- (UIView *)stateView{
    if (!_stateView) {
        _stateView = [[UIView alloc] init];
    }
    return _stateView;
}
- (UILabel *)stateLab{
    if (!_stateLab) {
        _stateLab = [[UILabel alloc] init];
        _stateLab.textColor = CharacterDarkColor;
        _stateLab.font = [UIFont systemFontOfSize:14];
        _stateLab.text = @"技能状态: 在售";
    }
    return _stateLab;
}

- (UIButton *)peopleBtn{
    if (!_peopleBtn) {
        _peopleBtn = [[UIButton alloc] init];
        [_peopleBtn setBackgroundImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
        [_peopleBtn setTitle:@"约单人" forState:UIControlStateNormal];
        [_peopleBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _peopleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _peopleBtn.tag = 18;
        _peopleBtn.layer.cornerRadius = 8;
        _peopleBtn.layer.masksToBounds = YES;
        [_peopleBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _peopleBtn;
}
- (UIButton *)stateBtn{
    if (!_stateBtn) {
        _stateBtn = [[UIButton alloc] init];
        [_stateBtn setBackgroundImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
        [_stateBtn setTitle:@"下架" forState:UIControlStateNormal];
        [_stateBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _stateBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _stateBtn.tag = 19;
        _stateBtn.layer.cornerRadius = 8;
        _stateBtn.layer.masksToBounds = YES;
        [_stateBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _stateBtn;
}

- (void)btnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(LxmSaleJiNengCell:btnAtIndex:)]) {
        [self.delegate LxmSaleJiNengCell:self btnAtIndex:btn.tag];
    }
}

- (void)setModel:(LxmCanListModel *)model{
    _model = model;
    if (model.img && ![model.img isEqualToString:@""]) {
        NSArray * arr = [model.img componentsSeparatedByString:@","];
        self.picImgView.hidden = NO;
        [self.picImgView sd_setImageWithURL:[NSURL URLWithString:[LxmURLDefine getPicImgWthPicStr:arr.firstObject]] placeholderImage:[UIImage imageNamed:@"whequemoren"] options:SDWebImageRetryFailed];
        [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.goodInfoView).offset(110);
        }];
    } else {
        self.picImgView.hidden = YES;
        [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.goodInfoView).offset(15);
        }];
    }

    self.titleLab.text = model.title;
    self.contentLab.text = model.content;
    self.moneyLab.text = [NSString stringWithFormat:@"%@元/%@",model.money,model.unit];
    [self.peopleView addSubview:self.totalLab];
    [self.peopleView addSubview:self.peopleinfoBtn];
    if (model.buyUserList.count == 0) {
        self.peopleView.hidden = self.totalLab.hidden = self.peopleinfoBtn.hidden = YES;
    }else{
        self.peopleView.hidden = self.totalLab.hidden = self.peopleinfoBtn.hidden = NO;
        self.peopleView.isGoodList = YES;
        self.peopleView.items = model.buyUserList;
        self.peopleBtn.hidden = NO;
        self.totalLab.text = [NSString stringWithFormat:@"%d人已抢单",model.buyUserNum.intValue];
    }
    self.stateLab.text = model.state.intValue == 1 ?@"技能状态: 在售":@"技能状态: 已下架";
    if (model.state.intValue == 1) {
        if (model.buyUserNum.intValue == 0) {
            self.peopleBtn.hidden = YES;
        }else{
            self.peopleBtn.hidden = NO;
        }
        [self.peopleBtn setBackgroundImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
        [self.peopleBtn setTitle:@"约单人" forState:UIControlStateNormal];
        [self.stateBtn setBackgroundImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
        [self.stateBtn setTitle:@"下架" forState:UIControlStateNormal];
        
    }else{
        self.peopleBtn.hidden = NO;
        [self.peopleBtn setBackgroundImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
        [self.peopleBtn setTitle:@"上架" forState:UIControlStateNormal];
        [self.stateBtn setBackgroundImage:[UIImage imageNamed:@"deletepic"] forState:UIControlStateNormal];
        [self.stateBtn setTitle:@"删除" forState:UIControlStateNormal];
    }
    [self layoutIfNeeded];

}
- (void)peopleHeadClick{
    if ([self.delegate respondsToSelector:@selector(headerImgClick:)]) {
        [self.delegate headerImgClick:self];
    }
}
@end
