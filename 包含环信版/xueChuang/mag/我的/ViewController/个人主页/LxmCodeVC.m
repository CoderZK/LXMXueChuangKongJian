//
//  LxmCodeVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/18.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmCodeVC.h"

@interface LxmCodeVC ()

@property (nonatomic , strong)UIView * contentView;
@property (nonatomic , strong) UIImageView * headerImgView;
@property (nonatomic , strong) UIImageView * sexImgView;
@property (nonatomic , strong) UILabel * nameLab;
@property (nonatomic , strong) UILabel * schoolLab;
@property (nonatomic , strong) UIImageView * codeImgView;
@property (nonatomic , strong) UILabel * textLab;

@end

@implementation LxmCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"二维码";
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = UIColor.whiteColor;
    self.codeImgView.layer.cornerRadius = 5;
    self.codeImgView.layer.masksToBounds = YES;
    [self.tableView addSubview:self.contentView];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.tableView);
        make.width.equalTo(@(ScreenW - 80));
        make.height.equalTo(@(ScreenW));
    }];
    
    [self.contentView addSubview:self.headerImgView];
    [self.contentView addSubview:self.sexImgView];
    [self.contentView addSubview:self.nameLab];
    [self.contentView addSubview:self.schoolLab];
    [self.contentView addSubview:self.codeImgView];
    [self.contentView addSubview:self.textLab];
    [self setConstrains];
    
}

- (void)setOtherInfoModel:(LxmOtherInfoModel *)otherInfoModel{
    _otherInfoModel = otherInfoModel;
    [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:[LxmURLDefine getPicImgWthPicStr:self.otherInfoModel.otherHead]]  placeholderImage:[UIImage imageNamed:@"moren"] options:SDWebImageRetryFailed];
    self.sexImgView.image = [UIImage imageNamed:self.otherInfoModel.otherSex.intValue == 1?@"male":@"female"];
    self.nameLab.text = self.otherInfoModel.otherNickname;
    self.schoolLab.text = [NSString stringWithFormat:@"%@%@",self.otherInfoModel.schoolName,self.otherInfoModel.institute];
    
    self.codeImgView.image = [self qrImageForString:[NSString stringWithFormat:@"%@",self.otherInfoModel.otherUserID] imageSize:@(ScreenW - 80-60).floatValue];
}
- (void)setModel:(LxmUserInfoModel *)model{
    _model = model;
    [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:[LxmURLDefine getPicImgWthPicStr:self.model.headimg]]  placeholderImage:[UIImage imageNamed:@"moren"] options:SDWebImageRetryFailed];
    self.sexImgView.image = [UIImage imageNamed:self.model.sex == 1?@"male":@"female"];
    self.nameLab.text = self.model.nickname;
    self.schoolLab.text = [NSString stringWithFormat:@"%@%@",self.model.schoolName,self.model.institute];
    self.codeImgView.image = [self qrImageForString:[NSString stringWithFormat:@"%ld",self.model.userId] imageSize:@(ScreenW - 80-60).floatValue];
}

- (void)setConstrains{
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self.contentView).offset(15);
        make.width.height.equalTo(@60);
    }];
    [self.sexImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headerImgView).offset(-18);
        make.leading.equalTo(self.headerImgView.mas_trailing).offset(10);
        make.width.height.equalTo(@15);
    }];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.sexImgView);
        make.leading.equalTo(self.sexImgView.mas_trailing).offset(3);
    }];
    [self.schoolLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headerImgView).offset(10);
        make.bottom.equalTo(self.headerImgView);
        make.leading.equalTo(self.sexImgView);
        make.trailing.equalTo(self.contentView).offset(-3);
    }];
    [self.codeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImgView.mas_bottom).offset(20);
        make.centerX.equalTo(self.contentView);
        make.width.height.equalTo(@(ScreenW - 80-60));
    }];
    [self.textLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-10);
        make.centerX.equalTo(self.contentView);
    }];
}
- (UIImageView *)headerImgView{
    if (!_headerImgView) {
        _headerImgView = [[UIImageView alloc] init];
        _headerImgView.image = [UIImage imageNamed:@"moren"];
        _headerImgView.layer.cornerRadius = 30;
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
- (UILabel *)schoolLab{
    if (!_schoolLab) {
        _schoolLab = [[UILabel alloc] init];
        _schoolLab.font = [UIFont systemFontOfSize:12];
        _schoolLab.text = @"河海大学物联网学院";
        _schoolLab.textColor = CharacterGrayColor;
    }
    return _schoolLab;
}
- (UIImageView *)codeImgView{
    if (!_codeImgView) {
        _codeImgView = [[UIImageView alloc] init];
        _codeImgView.userInteractionEnabled = YES;
        UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress)];
        longPress.cancelsTouchesInView = NO;
        [_codeImgView addGestureRecognizer:longPress];
    }
    return _codeImgView;
}
- (UILabel *)textLab{
    if (!_textLab) {
        _textLab = [[UILabel alloc] init];
        _textLab.font = [UIFont systemFontOfSize:10];
        _textLab.text = @"扫一扫上面的二维码的图案,加我好友";
        _textLab.textColor = CharacterGrayColor;
    }
    return _textLab;
}
- (void)longPress{
    //下载
    UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"确定要保存二维码到相册吗?" preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
         UIImageWriteToSavedPhotosAlbum(self.codeImgView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        
    }]];
    [self presentViewController:alertView animated:YES completion:nil];
    
   
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    if (error) {
        [SVProgressHUD showSuccessWithStatus:@"保存失败"];
    } else {
        
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    }
}

@end
