//
//  LxmWenZhangCell.m
//  recordnote
//
//  Created by 李晓满 on 2018/1/23.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmWenZhangCell.h"
@interface LxmWenZhangCell()
@property (nonatomic,strong) UILabel * titleLab;
@property (nonatomic,strong) UIImageView * contentImageView;
@property (nonatomic,strong) UILabel * contentLab;
@property (nonatomic,strong) UIView * centerView;
@property (nonatomic,strong) UILabel * dateLab;
@property (nonatomic,strong) UILabel * dianZanLab;
@end
@implementation LxmWenZhangCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        _centerView = [[UIView alloc] init];
        _centerView.layer.masksToBounds = YES;
        [self addSubview:_centerView];
        
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = CharacterDarkColor;
        _titleLab.font = [UIFont systemFontOfSize:18];
        [_centerView addSubview:_titleLab];
        
        
        _contentLab = [[UILabel alloc] init];
        _contentLab.textColor = CharacterGrayColor;
        _contentLab.numberOfLines = 2;
        _contentLab.font = [UIFont systemFontOfSize:13];
        [_centerView addSubview:_contentLab];
        
        _contentImageView = [[UIImageView alloc] init];
        _contentImageView.contentMode = UIViewContentModeScaleAspectFill;
        _contentImageView.layer.cornerRadius = 8;
        _contentImageView.clipsToBounds = YES;
        [_centerView addSubview:_contentImageView];
        
        
        UIView *bottomView = [[UIView alloc] init];
        [self addSubview:bottomView];
        
        _dateLab = [[UILabel alloc] init];
        _dateLab.textColor = CharacterLightGrayColor;
        _dateLab.font = [UIFont systemFontOfSize:13];
        [bottomView addSubview:_dateLab];
        
        _dianZanLab = [[UILabel alloc] init];
        _dianZanLab.textColor = CharacterLightGrayColor;
        _dianZanLab.font = [UIFont systemFontOfSize:13];
        [bottomView addSubview:_dianZanLab];
        
        UIView * bottomLine = [[UIView alloc] init];
        bottomLine.backgroundColor = LineColor;
        [self addSubview:bottomLine];
        
        [_centerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(10);
            make.trailing.leading.equalTo(self);
        }];
        
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.bottom.trailing.equalTo(self);
            make.height.equalTo(@40);
        }];
        
        [_dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bottomView);
            make.leading.equalTo(bottomView).offset(15);
            make.trailing.equalTo(self.dianZanLab.mas_leading).offset(-15);
        }];
        [_dianZanLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bottomView);
            make.leading.equalTo(self.dateLab.mas_trailing);
        }];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.equalTo(self);
            make.height.equalTo(@0.5);
        }];
        [self setConstraints];
        
    }return self;
}

- (void)setConstraints{
    
    [_contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.centerView.mas_top);
        make.right.equalTo(self.centerView.mas_right).offset(-15);
        make.width.height.equalTo(@100);
    }];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.centerView.mas_top);
        make.left.equalTo(self.centerView.mas_left).offset(15);
        make.right.equalTo(self.contentImageView.mas_left).offset(-15);
        make.height.mas_equalTo(30);
    }];
    
    [_contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab.mas_bottom).offset(5);
        make.leading.equalTo(self.centerView).offset(15);
        make.trailing.equalTo(self.contentImageView.mas_leading).offset(-15);
    }];
    
}

- (void)setModel:(LxmArticleModel *)model{
    if (_model!= model) {
        _model = model;
    }
    
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithString:model.content ? model.content :@""];
    NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithAttributedString:attrStr];
    [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, attrStr.length)];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];//调整行间距
    [att addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attrStr length])];
    _contentLab.attributedText = att;
    
    _titleLab.text = model.title;
    
    CGFloat h = 0;
    
    if (model.pic&&![model.pic isEqualToString:@""]) {

        CGFloat contentH = [att boundingRectWithSize:CGSizeMake(ScreenW - 145, 999) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  context:nil].size.height;
        
        [_centerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@100);
        }];
       
        [_contentLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.contentImageView.mas_leading).offset(-15);
            make.height.equalTo(@(contentH>20?40:20));
        }];
        [_contentImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@100);
        }];
        [_contentImageView sd_setImageWithURL:[NSURL URLWithString:[LxmURLDefine getPicImgWthPicStr:model.pic]] placeholderImage:[UIImage imageNamed:@"whequemoren"] options:SDWebImageRetryFailed completed:nil];
        h = 10+100+40;
    }else{
        

        CGFloat contentH = [att boundingRectWithSize:CGSizeMake(ScreenW - 30, 999) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  context:nil].size.height;
        
        contentH = (contentH>21?40:21);
        
        [_centerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(10+30+5+contentH));
        }];
       
        [_contentLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).offset(-15);
            make.height.equalTo(@(contentH));
        }];
        
        [_contentImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        h = 10+30+5+contentH+40;
    }
    [self layoutIfNeeded];
    if (model.createTime.length>3) {
        _dateLab.text = [model.createTime substringToIndex:model.createTime.length-3];
    }
    _dianZanLab.text = [NSString stringWithFormat:@"评论%@·超赞%@  ",model.commentNum,model.likeNum];
    model.height = h;
}



@end
