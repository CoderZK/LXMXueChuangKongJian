//
//  LxmFullInfoVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/3.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmFullInfoVC.h"
#import "LxmTextTFView.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import "MXPhotoPickerController.h"
#import "UIViewController+MXPhotoPicker.h"
#import "LxmSelectCityVC.h"
#import "TabBarController.h"

@interface LxmFullInfoVC ()
@property (nonatomic,strong) UIView * headerView;
@property (nonatomic,strong) UIImageView * imgView;
@property (nonatomic,strong) UIButton * sexBtn;
@property (nonatomic,strong) UIButton * selectSchoolBtn;
@property (nonatomic,strong) LxmTextTFView * touxiangView;
@property (nonatomic,strong) LxmTextTFView * nickNameView;
@property (nonatomic,strong) LxmTextTFView * sexView;
@property (nonatomic,strong) LxmTextTFView * schoolView;
@property (nonatomic,strong) LxmTextTFView * gardenView;

@property (nonatomic , strong)LxmFullInfoModel * selectModel;

//返回的按钮
@property (strong, nonatomic) UIButton *backButton;

@end

@implementation LxmFullInfoVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(selectModel:) name:@"LxmFullInfoModel" object:nil];
}
- (void)selectModel:(NSNotification *)noti{
    NSDictionary * dict = [noti object];
    LxmFullInfoModel * model = dict[@"selectModel"];
    self.selectModel = model;
    self.schoolView.rightTF.text = self.selectModel.name;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"完善信息";
    
    UIButton * rightbtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [rightbtn setTitle:@"完成" forState:UIControlStateNormal];
    rightbtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightbtn setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
    [rightbtn addTarget:self action:@selector(finishBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightbtn];
    self.tableView.tableHeaderView = self.headerView;
    [self setConstrains];
    self.isFirtstLogin == YES ? [self initBackButton] : nil;
}

- (void)initBackButton {
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [self.backButton setBackgroundImage:[UIImage imageNamed:@"home_back"] forState:UIControlStateNormal];
    self.backButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.backButton setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
}

- (void)leftBtnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setConstrains{
    [self.touxiangView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.headerView);
        make.height.equalTo(@50);
    }];
    [self.nickNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.headerView);
        make.top.equalTo(self.touxiangView.mas_bottom);
        make.height.equalTo(@50);
    }];
    [self.sexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.headerView);
        make.top.equalTo(self.nickNameView.mas_bottom);
        make.height.equalTo(@50);
    }];
    [self.schoolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.headerView);
        make.top.equalTo(self.sexView.mas_bottom);
        make.height.equalTo(@50);
    }];
    [self.gardenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.headerView);
        make.top.equalTo(self.schoolView.mas_bottom);
        make.height.equalTo(@50);
    }];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.touxiangView);
        make.trailing.equalTo(self.touxiangView).offset(-40);
        make.width.height.equalTo(@30);
    }];
    [self.sexBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.bottom.equalTo(self.sexView);
    }];
    [self.selectSchoolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.bottom.equalTo(self.schoolView);
    }];
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 250)];
        [_headerView addSubview:self.touxiangView];
        [_headerView addSubview:self.nickNameView];
        [_headerView addSubview:self.sexView];
        [_headerView addSubview:self.schoolView];
        [_headerView addSubview:self.gardenView];
    }return _headerView;
}
- (LxmTextTFView *)touxiangView{
    if (!_touxiangView) {
        _touxiangView = [[LxmTextTFView alloc] init];
        _touxiangView.textlab.text = @"头像";
        _touxiangView.rightTF.hidden = YES;
        [_touxiangView addSubview:self.imgView];
    }return _touxiangView;
}
- (LxmTextTFView *)nickNameView{
    if (!_nickNameView) {
        _nickNameView = [[LxmTextTFView alloc] init];
        _nickNameView.textlab.text = @"昵称";
        _nickNameView.rightTF.placeholder = @"请输入昵称";
        if (self.nikeName) {
            _nickNameView.rightTF.text = self.nikeName;
        }
        _nickNameView.rightImgView.hidden = YES;
    }return _nickNameView;
}
- (LxmTextTFView *)sexView{
    if (!_sexView) {
        _sexView = [[LxmTextTFView alloc] init];
        _sexView.textlab.text = @"性别";
        _sexView.rightTF.placeholder = @"请选择性别";
        _sexView.rightTF.userInteractionEnabled = NO;
        [_sexView addSubview:self.sexBtn];
    }return _sexView;
}
- (LxmTextTFView *)schoolView{
    if (!_schoolView) {
        _schoolView = [[LxmTextTFView alloc] init];
        _schoolView.textlab.text = @"学校";
        _schoolView.rightTF.placeholder = @"请选择学校";
        _schoolView.rightTF.userInteractionEnabled = NO;
        [_schoolView addSubview:self.selectSchoolBtn];
    }return _schoolView;
}

- (LxmTextTFView *)gardenView{
    if (!_gardenView) {
        _gardenView = [[LxmTextTFView alloc] init];
        _gardenView.textlab.text = @"学院";
        _gardenView.rightTF.placeholder = @"请输入学院";
        _gardenView.rightImgView.hidden = YES;
    }return _gardenView;
}

- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.layer.masksToBounds = YES;
        _imgView.layer.cornerRadius = 15;
        _imgView.userInteractionEnabled = YES;
        if (self.headerImgStr) {
            [_imgView sd_setImageWithURL:[NSURL URLWithString:self.headerImgStr] placeholderImage:[UIImage imageNamed:@"moren"] options:SDWebImageRetryFailed];
            _imgView.tag = 321;
        }else{
            _imgView.image = [UIImage imageNamed:@"moren"];
            _imgView.tag = 123;
        }
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
        [_imgView addGestureRecognizer:tap];
        
    }return _imgView;
}
- (UIButton *)sexBtn{
    if (!_sexBtn) {
        _sexBtn = [[UIButton alloc] init];
        [_sexBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }return _sexBtn;
}
- (UIButton *)selectSchoolBtn{
    if (!_selectSchoolBtn) {
        _selectSchoolBtn = [[UIButton alloc] init];
        [_selectSchoolBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }return _selectSchoolBtn;
}


- (void)tapGesture{
    
    UIAlertController * actionController = [UIAlertController alertControllerWithTitle:nil message:@"选择图片上传方式" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * a1 = [UIAlertAction actionWithTitle:@"打开相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showMXPhotoCameraAndNeedToEdit:YES completion:^(UIImage *image, UIImage *originImage, CGRect cutRect) {
            self.imgView.tag = 321;
            self.imgView.image = image;
        }];
    }];
    
    UIAlertAction * a2 = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showMXPhotoPickerControllerAndNeedToEdit:YES completion:^(UIImage *image, UIImage *originImage, CGRect cutRect) {
            self.imgView.tag = 321;
            self.imgView.image = image;
        }];
    }];
    UIAlertAction * a3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [actionController addAction:a1];
    [actionController addAction:a2];
    [actionController addAction:a3];
    [self presentViewController:actionController animated:YES completion:nil];
    
}

- (void)btnClick:(UIButton *)btn{
    if (btn == self.sexBtn) {
        //选择性别
        UIAlertController * actionController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction * a1 = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.sexView.rightTF.text = @"男";
        }];
        UIAlertAction * a2 = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.sexView.rightTF.text = @"女";
        }];
        UIAlertAction * a3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [actionController addAction:a1];
        [actionController addAction:a2];
        [actionController addAction:a3];
        [self presentViewController:actionController animated:YES completion:nil];
    }else if (btn == self.selectSchoolBtn){
        //先选择城市 再选择学校
        LxmSelectCityVC * vc = [[LxmSelectCityVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//完成
- (void)finishBtnClick{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    if (self.imgView.tag == 123) {
        [SVProgressHUD showErrorWithStatus:@"请上传头像"];
        return;
    }
    if (self.nickNameView.rightTF.text.length==0) {
        [SVProgressHUD showErrorWithStatus:@"请输入昵称"];
        return;
    }
    if (self.nickNameView.rightTF.text.length>10) {
        [SVProgressHUD showErrorWithStatus:@"昵称长度在1~10"];
        return;
    }
    if(self.sexView.rightTF.text.length == 0){
        [SVProgressHUD showErrorWithStatus:@"请选择性别"];
        return;
    }
    if(self.schoolView.rightTF.text.length == 0){
        [SVProgressHUD showErrorWithStatus:@"请选择学校"];
        return;
    }
    if(self.gardenView.rightTF.text.length == 0){
        [SVProgressHUD showErrorWithStatus:@"请输入学院"];
        return;
    }
    dic[@"token"] = [LxmTool ShareTool].session_token;
    dic[@"nickname"] = self.nickNameView.rightTF.text;
    dic[@"sex"] = [self.sexView.rightTF.text isEqualToString:@"男"]?@1:@2;
    dic[@"cityId"] = self.selectModel.cityId;
    dic[@"schoolId"] = self.selectModel.ID;
    dic[@"institute"] = self.gardenView.rightTF.text;
    [LxmNetworking NetWorkingUpLoad:[LxmURLDefine user_editUserInfo] image:self.imgView.image parameters:dic name:@"headimg" success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject objectForKey:@"key"] intValue] == 1) {
            [SVProgressHUD showSuccessWithStatus:@"资料已完善"];
            self.fullInfoPerfectSuccess ? self.fullInfoPerfectSuccess() : nil;
            [self dismissViewControllerAnimated:YES completion:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"wechatFullInfouccess" object:nil];
        }else{
            LxmTool.ShareTool.isLogin = NO;
            
            [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {

    }];
}

@end
