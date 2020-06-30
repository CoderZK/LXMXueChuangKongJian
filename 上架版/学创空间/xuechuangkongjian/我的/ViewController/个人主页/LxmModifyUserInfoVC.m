//
//  LxmModifyUserInfoVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/18.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmModifyUserInfoVC.h"
#import "LxmFullInfoVC.h"
#import "LxmTextTFView.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import "MXPhotoPickerController.h"
#import "UIViewController+MXPhotoPicker.h"
#import "LxmSelectCityVC.h"
#import "LxmCodeVC.h"

@interface LxmModifyUserInfoVC ()
@property (nonatomic,strong) UIView * headerView;
@property (nonatomic,strong) UIImageView * imgView;
@property (nonatomic,strong) UIButton * selectSchoolBtn;
@property (nonatomic,strong) LxmTextTFView * touxiangView;
@property (nonatomic,strong) LxmTextTFView * nickNameView;
@property (nonatomic,strong) LxmTextTFView * schoolView;
@property (nonatomic,strong) LxmTextTFView * gardenView;
@property (nonatomic , strong) LxmFullInfoModel * selectModel;
@end

@implementation LxmModifyUserInfoVC

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
    self.schoolView.rightTF.text = model.name;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"编辑资料";
    
    UIButton * rightbtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [rightbtn setTitle:@"完成" forState:UIControlStateNormal];
    rightbtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightbtn setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
    [rightbtn addTarget:self action:@selector(finishBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightbtn];
    self.tableView.tableHeaderView = self.headerView;
    [self setConstrains];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:[LxmURLDefine getPicImgWthPicStr:self.model.headimg]]  placeholderImage:[UIImage imageNamed:@"moren"] options:SDWebImageRetryFailed];
    self.nickNameView.rightTF.text = self.model.nickname;
    self.schoolView.rightTF.text = self.model.schoolName;
    self.gardenView.rightTF.text = self.model.institute;
    self.imgView.tag = 123;
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
    [self.schoolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.headerView);
        make.top.equalTo(self.nickNameView.mas_bottom);
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
    [self.selectSchoolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.bottom.equalTo(self.schoolView);
    }];
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 200)];
        [_headerView addSubview:self.touxiangView];
        [_headerView addSubview:self.nickNameView];
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
        _nickNameView.rightImgView.hidden = YES;
    }return _nickNameView;
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
        _imgView.image = [UIImage imageNamed:@"moren"];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
        [_imgView addGestureRecognizer:tap];
    }return _imgView;
}
- (UIButton *)selectSchoolBtn{
    if (!_selectSchoolBtn) {
        _selectSchoolBtn = [[UIButton alloc] init];
        [_selectSchoolBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    }return _selectSchoolBtn;
}

- (void)btnClick{
    //先选择城市 再选择学校
    LxmSelectCityVC * vc = [[LxmSelectCityVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)tapGesture{
    
    UIAlertController * actionController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
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


//完成
- (void)finishBtnClick{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"token"] = [LxmTool ShareTool].session_token;
    dic[@"nickname"] = self.nickNameView.rightTF.text;
    dic[@"institute"] = self.gardenView.rightTF.text;
    if (self.selectModel) {
        dic[@"cityId"] = self.selectModel.cityId;
        dic[@"schoolId"] = self.selectModel.ID;
    }
    
    if (self.imgView.tag == 123) {
        //没有修改头像
        [LxmNetworking networkingPOST:[LxmURLDefine user_editMyInfo] parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([[responseObject objectForKey:@"key"] intValue] == 1) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFICATION_MINE_USERINFO" object:nil];
                if (self.refreshPreVC) {
                    self.refreshPreVC();
                };
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [UIAlertController showAlertWithKey:[responseObject objectForKey:@"key"] message:[responseObject objectForKey:@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }else{
        //头像已修改
        [LxmNetworking NetWorkingUpLoad:[LxmURLDefine user_editMyInfo] image:self.imgView.image parameters:dic name:@"headimg" success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([[responseObject objectForKey:@"key"] intValue] == 1) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFICATION_MINE_USERINFO" object:nil];
                if (self.refreshPreVC) {
                    self.refreshPreVC();
                };
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [UIAlertController showAlertWithKey:[responseObject objectForKey:@"key"] message:[responseObject objectForKey:@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
