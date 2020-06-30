//
//  LxmMyQiangDanCell.m
//  mag
//
//  Created by 李晓满 on 2018/7/18.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmMyQiangDanCell.h"
#import "LxmStarImgView.h"
#import "LxmImgCollectionView.h"
#import "LxmHeaderImgView.h"
#import "LxmHomeStateBtn.h"
@interface LxmMyQiangDanCell()<LxmImgCollectionViewDelegate>
/**
 个人信息模块
 */
@property (nonatomic , strong) UIView * publicInfoView;
@property (nonatomic , strong) UILabel * orderInfolab;
@property (nonatomic , strong) UIImageView * headerImgView;
@property (nonatomic , strong) UIImageView * sexImgView;
@property (nonatomic , strong) UILabel * nameLab;
@property (nonatomic , strong) LxmStarImgView * startView;


@property (nonatomic , strong) UIImageView * dianImgView;
@property (nonatomic , strong) UILabel * typeLab;

/**
 发布内容模块
 */
@property (nonatomic , strong) UILabel * contentLab;

/**
 图片内容模块
 */
@property (nonatomic , strong) LxmImgCollectionView * contentImgView;


/**
 抢单人信息模块
 */
@property (nonatomic , strong) LxmHeaderImgView * peopleView;
@property (nonatomic , strong) UILabel * totalLab;
@property (nonatomic , strong) UIButton * peopleinfoBtn;

/**
 订单状态模块
 */
@property (nonatomic , strong) UIView * stateView;
@property (nonatomic , strong) LxmHomeStateBtn * stateBtn;
@property (nonatomic , strong) UIButton * selectBtn;



@end
@implementation LxmMyQiangDanCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
        [self addSubview:self.publicInfoView];
        [self.publicInfoView addSubview:self.headerImgView];
        [self.publicInfoView addSubview:self.sexImgView];
        [self.publicInfoView addSubview:self.nameLab];
        [self.publicInfoView addSubview:self.startView];
        [self.publicInfoView addSubview:self.dianImgView];
        [self.publicInfoView addSubview:self.typeLab];
        [self.publicInfoView addSubview:self.orderInfolab];
        [self.publicInfoView addSubview:self.dianImgView];
        [self.publicInfoView addSubview:self.typeLab];
        
        [self addSubview:self.contentLab];
        
        [self addSubview:self.contentImgView];
        
        [self addSubview:self.peopleView];
        [self.peopleView addSubview:self.totalLab];
        [self.peopleView addSubview:self.peopleinfoBtn];
        
        [self addSubview:self.stateView];
        [self.stateView addSubview:self.nameLab];
        [self.stateView addSubview:self.sexImgView];
        [self.stateView addSubview:self.stateBtn];
        [self.stateView addSubview:self.selectBtn];
        
        [self setConstrains];
        UIView * line = [[UIView alloc] init];
        line.backgroundColor = LineColor;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.leading.trailing.equalTo(self);
            make.height.equalTo(@0.5);
        }];
        __weak typeof(self)safe_self = self;
        self.contentImgView.selectItemBlock = ^(NSInteger index) {
            if (safe_self.selectImgBlock) {
                safe_self.selectImgBlock(index);
            }
        };
    }
    return self;
}
- (void)setConstrains{
    [self.publicInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self);
        make.height.equalTo(@60);
    }];
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self.publicInfoView).offset(10);
        make.width.height.equalTo(@40);
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
        make.centerY.equalTo(self.sexImgView);
        make.width.height.equalTo(@6);
        make.trailing.equalTo(self.typeLab.mas_leading).offset(-3);
    }];
    [self.typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sexImgView);
        make.trailing.equalTo(self.publicInfoView).offset(-15);
    }];
    
    [self.orderInfolab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.startView);
        make.trailing.equalTo(self.publicInfoView).offset(-15);
    }];
    
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.publicInfoView.mas_bottom);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
    }];
    
    [self.contentImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLab.mas_bottom).offset(10);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@((ScreenW-30-20)/3));
    }];
   
    [self.peopleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentImgView.mas_bottom);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@50);
    }];
    [self.peopleinfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentImgView.mas_bottom);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@50);
    }];
   
    [self.totalLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.trailing.equalTo(self.peopleView);
    }];
    
    [self.stateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.peopleView.mas_bottom);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@60);
    }];
    [self.stateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.stateView);
        make.leading.equalTo(self.stateView);
        make.width.equalTo(self.selectBtn);
        make.height.equalTo(@35);
    }];
   
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.stateView);
        make.trailing.equalTo(self.stateView);
        make.width.equalTo(@((ScreenW-60)/3));
        make.height.equalTo(@35);
    }];
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
        _headerImgView.layer.cornerRadius = 20;
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
        _startView.layer.masksToBounds = YES;
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
        _typeLab.font = [UIFont systemFontOfSize:14];
        _typeLab.text = @"跑腿";
        _typeLab.textColor = CharacterLightGrayColor;
    }
    return _typeLab;
}
- (UILabel *)orderInfolab{
    if (!_orderInfolab) {
        _orderInfolab = [[UILabel alloc] init];
        _orderInfolab.font = [UIFont systemFontOfSize:14];
        _orderInfolab.text = @"订单编号:43070215545";
        _orderInfolab.textColor = CharacterLightGrayColor;
    }
    return _orderInfolab;
}

- (UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab = [[UILabel alloc] init];
        _contentLab.font = [UIFont boldSystemFontOfSize:18];
        _contentLab.numberOfLines = 0;
        _contentLab.text = @"北门圆通,收件人冯全,送至2-231,中午前送达哦";
    }
    return _contentLab;
}

- (LxmImgCollectionView *)contentImgView{
    if (!_contentImgView) {
        _contentImgView = [[LxmImgCollectionView alloc] init];
        _contentImgView.delegate = self;
    }
    return _contentImgView;
}

- (LxmHeaderImgView *)peopleView{
    if (!_peopleView) {
        _peopleView = [[LxmHeaderImgView alloc] init];

        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, ScreenW - 30, 0.5)];
        line.backgroundColor = LineColor;
        [_peopleView addSubview:line];
        _peopleView.layer.masksToBounds = YES;
        
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

- (LxmHomeStateBtn *)stateBtn{
    if (!_stateBtn) {
        _stateBtn = [[LxmHomeStateBtn alloc] init];
        [_stateBtn setBackgroundImage:[UIImage imageNamed:@"doing"] forState:UIControlStateNormal];
        _stateBtn.layer.cornerRadius = 5;
        _stateBtn.layer.masksToBounds = YES;
        _stateBtn.tag = 22;
        [_stateBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _stateBtn;
}

- (UIButton *)selectBtn{
    if (!_selectBtn) {
        _selectBtn = [[UIButton alloc] init];
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
        [_selectBtn setTitle:@"取消申请" forState:UIControlStateNormal];
        [_selectBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _selectBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _selectBtn.layer.cornerRadius = 8;
        _selectBtn.layer.masksToBounds = YES;
        _selectBtn.tag = 23;
        [_selectBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}
- (void)btnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(lxmMyQiangDanCell:btnAtIndex:)]) {
        [self.delegate lxmMyQiangDanCell:self btnAtIndex:btn.tag];
    }
}
- (void)setModel:(LxmHomeModel *)model{
    _model = model;
    self.startView.starNum = model.relRate.intValue;
    //60
    [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:[LxmURLDefine getPicImgWthPicStr:model.relUserHead]] placeholderImage:[UIImage imageNamed:@"moren"] options:SDWebImageRetryFailed];
    self.sexImgView.image = [UIImage imageNamed:model.relSex.intValue == 1?@"male":@"female"];
    self.orderInfolab.text = [NSString stringWithFormat:@"订单编号:%@",model.orderNo];
    self.nameLab.text = model.relNickname;
    self.typeLab.text = model.typeName;
    
    self.contentLab.text = model.content;
    CGFloat contentH = 0;
    if (model.content&&![model.content isEqualToString:@""]) {
        contentH = [model.content getSizeWithMaxSize:CGSizeMake(ScreenW - 30, 9999) withFontSize:18].height + 10;
    }
    CGFloat imgViewHeight = 0;
    if (!model.img||[model.img isEqualToString:@""]) {
        [self.contentImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        imgViewHeight = 0;
    }else{
        NSArray * imgs = [model.img componentsSeparatedByString:@","];
        if (model.isDetail) {
            self.contentImgView.titleArr = imgs;
            [self.contentImgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(ceil(imgs.count/3.0)*(((ScreenW-30-20)/3)+10)-10));
            }];
            imgViewHeight = ceil(imgs.count/3.0)*(((ScreenW-30-20)/3)+10)-10;
        }else{
            if (imgs.count>3) {
                NSMutableArray * tempArr = [NSMutableArray arrayWithArray:imgs];
                self.contentImgView.titleArr = [tempArr subarrayWithRange:NSMakeRange(0, 3)];
            }else{
                self.contentImgView.titleArr = imgs;
            }
            [self.contentImgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@((ScreenW-30-20)/3));
            }];
            imgViewHeight = (ScreenW-30-20)/3;
        }
    }
    
    CGFloat peopleHeight = 0;
    
    if (model.robList.count == 0) {
        [self.peopleView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    }else{
        self.peopleView.items = model.robList;
        [self.peopleView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@50);
        }];
        peopleHeight = 50;
    }
    self.stateBtn.stateMoneyLab.text = model.money;
    if (model.state.intValue == 1) {
        //待匹配
        self.stateBtn.stateLab.text = @"进行中";
        [self.stateBtn setBackgroundImage:[UIImage imageNamed:@"doing"] forState:UIControlStateNormal];
        [self.selectBtn setTitle:@"取消申请" forState:UIControlStateNormal];
        [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
        
    }else if(model.state.intValue == 2){
        //已选择
        self.stateBtn.stateLab.text = @"完成中";
        [self.stateBtn setBackgroundImage:[UIImage imageNamed:@"doing"] forState:UIControlStateNormal];
        [self.selectBtn setTitle:@"已完成" forState:UIControlStateNormal];
        [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
       
    }else if (model.state.intValue == 3){
        //已完成
        self.stateBtn.stateLab.text = @"完成中";
        [self.stateBtn setBackgroundImage:[UIImage imageNamed:@"doing"] forState:UIControlStateNormal];
        //只是显示
        [self.selectBtn setTitle:@"已完成" forState:UIControlStateNormal];
        [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
        
    }else if (model.state.intValue == 4){
        self.stateBtn.stateLab.text = @"已完成";
        [self.stateBtn setBackgroundImage:[UIImage imageNamed:@"deletepic"] forState:UIControlStateNormal];
        [self.selectBtn setTitle:@"查看评价" forState:UIControlStateNormal];
        [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
        
    }else if (model.state.intValue == 5){
        //未选中
        [self.stateBtn setBackgroundImage:[UIImage imageNamed:@"deletepic"] forState:UIControlStateNormal];
        self.stateBtn.stateLab.text = @"未选中";
        [self.selectBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"deletepic"] forState:UIControlStateNormal];
    }
  
    [self layoutIfNeeded];
    
    self.totalLab.text = [NSString stringWithFormat:@"%d人已抢单",model.robNum.intValue];
    
    model.height = 60 + contentH + imgViewHeight + peopleHeight + 60;
    
}
- (void)LxmImgCollectionViewClick{
    if ([self.delegate respondsToSelector:@selector(imgCollectionClick:)]) {
        [self.delegate imgCollectionClick:self];
    }
}
- (void)peopleHeadClick{
    if ([self.delegate respondsToSelector:@selector(peopleFinishDanClick:)]) {
        [self.delegate peopleFinishDanClick:self];
    }
}
@end
