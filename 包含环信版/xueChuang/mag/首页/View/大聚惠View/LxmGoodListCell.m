//
//  LxmGoodListCell.m
//  mag
//
//  Created by 李晓满 on 2018/7/16.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmGoodListCell.h"
#import "LxmStarImgView.h"

@interface LxmGoodListCell()

@property (nonatomic, strong) UIView *topLine;//分割线

/**
 个人信息模块
 */
@property (nonatomic , strong) UIView * publicInfoView;
@property (nonatomic , strong) UIImageView * headerImgView;
@property (nonatomic , strong) UIButton * headerImgBgBtn;
@property (nonatomic , strong) UIImageView * sexImgView;
@property (nonatomic , strong) UILabel * nameLab;
@property (nonatomic , strong) LxmStarImgView * startView;

@property (nonatomic , strong) UIImageView * dianImgView;
@property (nonatomic , strong) UILabel * typeLab;

/**
 标题价格模块
 */
@property (nonatomic , strong) UIView * titleView;
@property (nonatomic , strong) UILabel * titleLab;
@property (nonatomic , strong) UILabel * moneyLab;

/**
 发布内容模块
 */
@property (nonatomic , strong) UILabel * contentLab;
/**
 图片内容模块
 */
@property (nonatomic , strong) UIView * contentImgView;
@property (nonatomic , strong) UIImageView * leftImgView;
@property (nonatomic , strong) UIImageView * centerImgView;
@property (nonatomic , strong) UIImageView * rightImgView;
/**
 订单状态模块
 */
@property (nonatomic , strong) UIView * stateView;
@property (nonatomic , strong) UIButton * dianzanBtn;
@property (nonatomic , strong) UIButton * commentBtn;
@property (nonatomic , strong) UILabel * totalLab;

@property (nonatomic , assign)LxmGoodListCell_style type;

@end

@implementation LxmGoodListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(LxmGoodListCell_style)type{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.type = type;
        [self addSubview:self.topLine];
        [self addSubview:self.publicInfoView];
        [self.publicInfoView addSubview:self.headerImgBgBtn];
        [self.publicInfoView addSubview:self.headerImgView];
        [self.publicInfoView addSubview:self.sexImgView];
        [self.publicInfoView addSubview:self.nameLab];
        [self.publicInfoView addSubview:self.startView];
        [self.publicInfoView addSubview:self.dianImgView];
        [self.publicInfoView addSubview:self.typeLab];
        
        [self addSubview:self.titleView];
        [self.titleView addSubview:self.titleLab];
        [self.titleView addSubview:self.moneyLab];
        
        [self addSubview:self.contentLab];
        
        [self addSubview:self.contentImgView];
        [self.contentImgView addSubview:self.leftImgView];
        [self.contentImgView addSubview:self.centerImgView];
        [self.contentImgView addSubview:self.rightImgView];
        
        [self addSubview:self.stateView];
        [self.stateView addSubview:self.dianzanBtn];
        [self.stateView addSubview:self.commentBtn];
        [self.stateView addSubview:self.totalLab];
        
        [self setConstrains];
        
    }
    return self;
}

- (void)setConstrains{
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self);
        make.height.equalTo(@10);
    }];
    if (self.type == LxmGoodListCell_style_minePage) {
        [self.publicInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topLine.mas_bottom);
            make.leading.trailing.equalTo(self);
            make.height.equalTo(@0);
        }];
        
    }else{
        [self.publicInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topLine.mas_bottom);
            make.leading.trailing.equalTo(self);
            make.height.equalTo(@60);
        }];
    }
    self.publicInfoView.layer.masksToBounds = YES;
    [self.headerImgBgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.equalTo(self.publicInfoView);
        make.width.equalTo(@50);
    }];
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self.publicInfoView).offset(15);
        make.width.height.equalTo(@30);
    }];
    [self.sexImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImgView);
        make.leading.equalTo(self.headerImgView.mas_trailing).offset(5);
        make.width.height.equalTo(@15);
    }];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sexImgView);
        make.leading.equalTo(self.sexImgView.mas_trailing).offset(3);
    }];
    [self.startView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.sexImgView);
        make.bottom.equalTo(self.headerImgView).offset(2);
        make.width.equalTo(@83);
        make.height.equalTo(@15);
    }];
    [self.dianImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.publicInfoView);
        make.width.height.equalTo(@6);
        make.trailing.equalTo(self.typeLab.mas_leading).offset(-3);
    }];
    [self.typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.publicInfoView);
        make.trailing.equalTo(self.publicInfoView).offset(-15);
    }];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.publicInfoView.mas_bottom);
        make.leading.trailing.equalTo(self.publicInfoView);
        make.height.equalTo(@30);
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView).offset(10);
        make.leading.equalTo(self.titleView).offset(15);
        make.trailing.equalTo(self.titleView).offset(-115);
    }];
    [self.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLab);
        make.trailing.equalTo(self.titleView).offset(-15);
    }];
    
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.mas_bottom).offset(10);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        
    }];
    
    [self.contentImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLab.mas_bottom).offset(10);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@((ScreenW-30-20)/3));
    }];
    [self.leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.equalTo(self.contentImgView);
        make.width.equalTo(@((ScreenW-30-20)/3));
    }];
    [self.centerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentImgView);
        make.centerX.equalTo(self.contentImgView);
        make.width.equalTo(@((ScreenW-30-20)/3));
    }];
    [self.rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.trailing.equalTo(self.contentImgView);
        make.width.equalTo(@((ScreenW-30-20)/3));
    }];
    
    
    [self.stateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentImgView.mas_bottom).offset(5);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@50);
    }];
    
    [self.dianzanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(self.stateView);
        make.height.equalTo(@20);
        make.width.equalTo(@80);
    }];
    
    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.dianzanBtn.mas_trailing);
        make.top.equalTo(self.stateView);
        make.height.equalTo(@20);
        make.width.equalTo(@80);
    }];
    
    [self.totalLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.equalTo(self.stateView);
    }];
    
    
}
- (UIView *)topLine {
    if (!_topLine) {
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = BGGrayColor;
    }
    return _topLine;
}

- (UIView *)publicInfoView{
    if (!_publicInfoView) {
        _publicInfoView = [[UIView alloc] init];
    }
    return _publicInfoView;
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
- (LxmStarImgView *)startView{
    if (!_startView) {
        _startView = [[LxmStarImgView alloc] init];
    }
    return _startView;
}
- (UIImageView *)dianImgView{
    if (!_dianImgView) {
        _dianImgView = [[UIImageView alloc] init];
        _dianImgView.backgroundColor = [UIColor colorWithRed:81/255.0 green:224/255.0 blue:245/255.0 alpha:1];
        _dianImgView.layer.cornerRadius = 3;
        _dianImgView.layer.masksToBounds = YES;
    }
    return _dianImgView;
}
- (UILabel *)typeLab{
    if (!_typeLab) {
        _typeLab = [[UILabel alloc] init];
        _typeLab.font = [UIFont systemFontOfSize:15];
        _typeLab.text = @"邮寄";
        _typeLab.textColor = CharacterLightGrayColor;
    }
    return _typeLab;
}

- (UIView *)titleView{
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
    }
    return _titleView;
}
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont boldSystemFontOfSize:18];
        _titleLab.textColor = CharacterDarkColor;
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

- (UIView *)contentImgView{
    if (!_contentImgView) {
        _contentImgView = [[UIView alloc] init];
    }
    return _contentImgView;
}
- (UIImageView *)leftImgView{
    if (!_leftImgView) {
        _leftImgView = [[UIImageView alloc] init];
        _leftImgView.image = [UIImage imageNamed:@"pic_4"];
        _leftImgView.contentMode = UIViewContentModeScaleAspectFill;
        _leftImgView.layer.masksToBounds = YES;
    }
    return _leftImgView;
}
- (UIImageView *)centerImgView{
    if (!_centerImgView) {
        _centerImgView = [[UIImageView alloc] init];
        _centerImgView.image = [UIImage imageNamed:@"pic_4"];
        _centerImgView.contentMode = UIViewContentModeScaleAspectFill;
        _centerImgView.layer.masksToBounds = YES;
    }
    return _centerImgView;
}
- (UIImageView *)rightImgView{
    if (!_rightImgView) {
        _rightImgView = [[UIImageView alloc] init];
        _rightImgView.image = [UIImage imageNamed:@"pic_4"];
        _rightImgView.contentMode = UIViewContentModeScaleAspectFill;
        _rightImgView.layer.masksToBounds = YES;
    }
    return _rightImgView;
}
- (UIButton *)headerImgBgBtn{
    if (!_headerImgBgBtn) {
        _headerImgBgBtn = [[UIButton alloc] init];
        [_headerImgBgBtn addTarget:self action:@selector(headerClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerImgBgBtn;
}
- (UIView *)stateView{
    if (!_stateView) {
        _stateView = [[UIView alloc] init];
    }
    return _stateView;
}


- (UIButton *)dianzanBtn{
    if (!_dianzanBtn) {
        _dianzanBtn = [[UIButton alloc] init];
        [_dianzanBtn setImage:[UIImage imageNamed:@"dislike"] forState:UIControlStateNormal];
        [_dianzanBtn setTitle:@"11" forState:UIControlStateNormal];
        [_dianzanBtn setTitleColor:CharacterGrayColor forState:UIControlStateNormal];
        _dianzanBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _dianzanBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    }
    return _dianzanBtn;
}

- (UIButton *)commentBtn{
    if (!_commentBtn) {
        _commentBtn = [[UIButton alloc] init];
        [_commentBtn setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
        [_commentBtn setTitle:@"8" forState:UIControlStateNormal];
        [_commentBtn setTitleColor:CharacterGrayColor forState:UIControlStateNormal];
        _commentBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _commentBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    }
    return _commentBtn;
}

- (UILabel *)totalLab{
    if (!_totalLab) {
        _totalLab = [[UILabel alloc] init];
        _totalLab.font = [UIFont systemFontOfSize:12];
        _totalLab.textColor = CharacterGrayColor;
    }
    return _totalLab;
}

- (void)setModel:(LxmCanListModel *)model{
    _model = model;
    //60+25+10
    CGFloat titleHeight = 0 ;
    if (self.type == LxmGoodListCell_style_minePage){
        titleHeight = 0;
    }else{
        titleHeight = 60;
    }
    self.startView.starNum = model.goodRate.intValue;
    [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:[LxmURLDefine getPicImgWthPicStr:model.userHead]] placeholderImage:[UIImage imageNamed:@"moren"] options:SDWebImageRetryFailed];
    self.sexImgView.image = [UIImage imageNamed:model.sex.intValue == 1?@"male":@"female"];
    self.nameLab.text = model.nickname;
    self.typeLab.text = [NSString returnTypeNameWithType:model.sendType.intValue];
    self.dianImgView.backgroundColor = [UIColor colorWithType:model.sendType.intValue];
    self.titleLab.text = model.title;
    self.moneyLab.text = [NSString stringWithFormat:@"%d元/%@",model.money.intValue,model.unit];
    
    CGFloat connectHeight = [model.content getSizeWithMaxSize:CGSizeMake(ScreenW-30, 999) withFontSize:14].height;
    self.contentLab.text = model.content;
    
    CGFloat imgViewHeight = 0;
    if ([model.img isEqualToString:@""]||!model.img) {
        [self.contentImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        imgViewHeight = 0;
    }else{
        [self.contentImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@((ScreenW-30-20)/3));
        }];
        NSArray * imgs = [model.img componentsSeparatedByString:@","];
        if (imgs.count == 1) {
            [self.leftImgView sd_setImageWithURL:[NSURL URLWithString:[LxmURLDefine getPicImgWthPicStr:imgs.firstObject]] placeholderImage:[UIImage imageNamed:@"whequemoren"] options:SDWebImageRetryFailed];
            self.leftImgView.hidden = NO;
            self.centerImgView.hidden = self.rightImgView.hidden = YES;
        }else if (imgs.count == 2){
            [self.leftImgView sd_setImageWithURL:[NSURL URLWithString:[LxmURLDefine getPicImgWthPicStr:imgs.firstObject]] placeholderImage:[UIImage imageNamed:@"whequemoren"] options:SDWebImageRetryFailed];
            [self.centerImgView sd_setImageWithURL:[NSURL URLWithString:[LxmURLDefine getPicImgWthPicStr:imgs[1]]] placeholderImage:[UIImage imageNamed:@"whequemoren"] options:SDWebImageRetryFailed];
            self.leftImgView.hidden = self.centerImgView.hidden = NO;
            self.rightImgView.hidden = YES;
        }else{
            [self.leftImgView sd_setImageWithURL:[NSURL URLWithString:[LxmURLDefine getPicImgWthPicStr:imgs.firstObject]] placeholderImage:[UIImage imageNamed:@"whequemoren"] options:SDWebImageRetryFailed];
            [self.centerImgView sd_setImageWithURL:[NSURL URLWithString:[LxmURLDefine getPicImgWthPicStr:imgs[1]]] placeholderImage:[UIImage imageNamed:@"whequemoren"] options:SDWebImageRetryFailed];
            [self.rightImgView sd_setImageWithURL:[NSURL URLWithString:[LxmURLDefine getPicImgWthPicStr:imgs[2]]] placeholderImage:[UIImage imageNamed:@"whequemoren"] options:SDWebImageRetryFailed];
            self.leftImgView.hidden = self.centerImgView.hidden = self.rightImgView.hidden =  NO;
        }
        imgViewHeight = (ScreenW-30-20)/3;
    }
    
    [self.dianzanBtn setTitle:[NSString stringWithFormat:@"%@",model.likeNum.intValue > 100 ? @"100+" : [NSString stringWithFormat:@"%d",model.likeNum.intValue] ] forState:UIControlStateNormal];
    if (model.likeNum.intValue > 0) {
         [self.dianzanBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    }else {
        [self.dianzanBtn setImage:[UIImage imageNamed:@"dislike"] forState:UIControlStateNormal];
    }
    [self.commentBtn setTitle:[NSString stringWithFormat:@"%@",model.commentNum.intValue > 100 ? @"100+" : [NSString stringWithFormat:@"%d",model.commentNum.intValue]] forState:UIControlStateNormal];
    self.totalLab.text = [NSString stringWithFormat:@"%d人已约单",model.buyUserNum.intValue];
    
    model.height = 10 + (titleHeight > 40 ? 40 : titleHeight) + 5 + 25 + 10 + (connectHeight > 40 ? 40 : connectHeight) + 10 + imgViewHeight + 5 + 50;
}
- (void)headerClick{
    if ([self.delegate respondsToSelector:@selector(LxmGoodListCellHeaderImgViewClick:)]) {
        [self.delegate LxmGoodListCellHeaderImgViewClick:self];
    }
}
@end
