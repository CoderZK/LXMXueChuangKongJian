//
//  LxmPublishDanVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/17.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmPublishDanVC.h"
#import "IQKeyboardManagerConstants.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import "MXPhotoPickerController.h"
#import "UIViewController+MXPhotoPicker.h"
#import "MXImageEditController.h"
#import "LxmPayVC.h"
#import "LxmTaskDetailVC.h"

@interface LxmPublishDanVC ()<LxmPublishImgViewDelegate,UITextFieldDelegate,LxmLeftLabRightNumViewDelegate,UITextViewDelegate>
@property (nonatomic , strong)LxmHomeBannerModel * typeModel;
@property (nonatomic , strong)UIView * headerView;
@property (nonatomic , strong)IQTextView * contentView;
@property (nonatomic , strong)LxmPublishImgView * contentImgView;
@property (nonatomic , strong)LxmLeftLabRightNumView *peopleView;
@property (nonatomic , strong)LxmLeftLabRightNumView *moneyView;
@property (nonatomic , strong)UIView * totalView;
@property (nonatomic , strong)UILabel *totalMoneyLab;
@property (nonatomic , strong)NSMutableArray * imgs;

@end

@implementation LxmPublishDanVC

- (instancetype)initWithTableViewStyle:(UITableViewStyle)style LxmHomeBannerModel:(LxmHomeBannerModel *)model{
    self = [super initWithTableViewStyle:style];
    if (self) {
        self.typeModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.typeModel.content;
    self.imgs = [NSMutableArray array];
    UIButton * rightbtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [rightbtn setTitle:@"发布" forState:UIControlStateNormal];
    rightbtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightbtn setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
    [rightbtn addTarget:self action:@selector(publishBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightbtn];
    [self initHeaderView];
}

- (void)publishBtnClick{
    
    if (self.contentView.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"写点什么吧......"];
        return;
    }
    
    if (self.contentView.text.length > 500) {
        [SVProgressHUD showErrorWithStatus:@"输入不能超过500个字"];
        return;
    }
    
    if (self.peopleView.numTF.text.intValue == 0) {
        [SVProgressHUD showErrorWithStatus:@"您还没有选择所需人数!"];
        return;
    }
    
    if (self.moneyView.numTF.text.intValue == 0) {
        [SVProgressHUD showErrorWithStatus:@"您还没有提供赏金!"];
        return;
    }
    
    if (self.peopleView.numTF.text.intValue > 20) {
        [SVProgressHUD showErrorWithStatus:@"人数不能超过20"];
        return;
    }
    
    if (self.moneyView.numTF.text.intValue > 1000) {
        [SVProgressHUD showErrorWithStatus:@"赏金不能超过1000元"];
        return;
    }
    
    if ((self.peopleView.numTF.text.intValue * self.moneyView.numTF.text.intValue) > 9999) {
        [SVProgressHUD showErrorWithStatus:@"总赏金不能超过9999元"];
        return;
    }
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[@"token"] = SESSION_TOKEN;
    dict[@"typeId"] = self.typeModel.ID;
    dict[@"schoolId"] = @([LxmTool ShareTool].userModel.schoolId);
    dict[@"content"] = self.contentView.text;
    dict[@"isAnonymity"] = self.contentImgView.switchBtn.selected == YES?@1:@2;
    dict[@"needNum"] = self.peopleView.numTF.text;
    dict[@"money"] =  @(self.moneyView.numTF.text.floatValue);
    
    [SVProgressHUD show];
    [LxmNetworking NetWorkingUpLoad:[LxmURLDefine user_releaseHelp] images:self.imgs parameters:dict name:@"img" success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] intValue] == 1) {
            LxmPayVC * vc = [[LxmPayVC alloc] initWithTableViewStyle:UITableViewStylePlain type:1];
            vc.orderID = responseObject[@"result"][@"orderId"];
            vc.billId = responseObject[@"result"][@"billId"];
            vc.backViewController = self.backViewController;
            vc.orderMoney = @(self.moneyView.numTF.text.floatValue*self.peopleView.numTF.text.floatValue);
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

- (void)initHeaderView{
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 450)];
    self.headerView.backgroundColor = UIColor.whiteColor;
    self.tableView.tableHeaderView = self.headerView;
    
    self.contentView = [[IQTextView alloc] initWithFrame:CGRectMake(15, 0, ScreenW - 30, 200)];
    self.contentView.placeholder = @"写点什么吧......";
    self.contentView.font = [UIFont systemFontOfSize:15];
    self.contentView.delegate = self;
    [self.headerView addSubview:self.contentView];
    
    self.contentImgView = [[LxmPublishImgView alloc] initWithFrame:CGRectMake(0, 200, ScreenW, 100)];
    [self.contentImgView.selectBtn addTarget:self action:@selector(uploadImg) forControlEvents:UIControlEventTouchUpInside];
    [self.contentImgView.switchBtn addTarget:self action:@selector(switchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.contentImgView.delegate = self;
    [self.headerView addSubview:self.contentImgView];
    
    self.peopleView = [[LxmLeftLabRightNumView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.contentImgView.frame), ScreenW, 50)];
    self.peopleView.textlab.text = @"所需人数:";
    self.peopleView.numTF.delegate = self;
    self.peopleView.delegate = self;
    [self.headerView addSubview:self.peopleView];
    
    self.moneyView = [[LxmLeftLabRightNumView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.peopleView.frame), ScreenW, 50)];
    self.moneyView.textlab.text = @"赏金:";
    self.moneyView.numTF.delegate = self;
    self.moneyView.delegate = self;
    [self.headerView addSubview:self.moneyView];
    
    self.totalView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.moneyView.frame), ScreenW, 50)];
    [self.headerView addSubview:self.totalView];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 0.5)];
    line.backgroundColor = LineColor;
    [self.totalView addSubview:line];
    
    self.totalMoneyLab = [[UILabel alloc] init];
    self.totalMoneyLab.textColor = YellowColor;
    [self.totalView addSubview:self.totalMoneyLab];
    
    [self.totalMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.totalView);
        make.trailing.equalTo(self.totalView).offset(-15);
    }];
    
    NSString * money = @"合计:￥0.00";
    NSMutableAttributedString * att  = [[NSMutableAttributedString alloc] initWithString:money];
    [att addAttribute:NSForegroundColorAttributeName value:CharacterDarkColor range:NSMakeRange(0, 3)];
    self.totalMoneyLab.attributedText = att;
    
    UIView * topline = [[UIView alloc] init];
    topline.backgroundColor = LineColor;
    [self.headerView addSubview:topline];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.headerView);
        make.height.equalTo(@0.5);
    }];
}

- (void)switchBtnClick{
    self.contentImgView.switchBtn.selected=!self.contentImgView.switchBtn.selected;
}

- (void)uploadImg{
    // 上传图片
    if (self.imgs.count>=9) {
        [SVProgressHUD showErrorWithStatus:@"最多上传9张图片"];
        return;
    }
    
    //上传图片
    UIAlertController * actionController = [UIAlertController alertControllerWithTitle:@"选择图片上传方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * a1 = [UIAlertAction actionWithTitle:@"打开相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.imgs.count<9) {
            [self showMXPhotoCameraAndNeedToEdit:YES completion:^(UIImage *image, UIImage *originImage, CGRect cutRect) {
                [self.imgs addObject:image];
                self.contentImgView.imgs = self.imgs;
                if (self.imgs.count==0) {
                    self.contentImgView.maxLab.text = @"(最多上传9张图片)";
                    self.headerView.frame = CGRectMake(0, 0, ScreenW, 450);
                    self.contentImgView.frame = CGRectMake(0, 200, ScreenW, 100);
                }else{
                    self.contentImgView.maxLab.text = self.imgs.count == 9?@"(最多上传9张图片)":[NSString stringWithFormat:@"还可上传%ld张",9-self.imgs.count];
                    self.headerView.frame = CGRectMake(0, 0, ScreenW, 500);
                    self.contentImgView.frame = CGRectMake(0, 200, ScreenW, 150);
                }
                self.peopleView.frame = CGRectMake(0, CGRectGetMaxY(self.contentImgView.frame), ScreenW, 50);
                self.moneyView.frame = CGRectMake(0, CGRectGetMaxY(self.peopleView.frame), ScreenW, 50);
                self.totalView.frame = CGRectMake(0, CGRectGetMaxY(self.moneyView.frame), ScreenW, 50);
                [self.headerView layoutIfNeeded];
            }];
        }
        
    }];
    
    UIAlertAction * a2 = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showMXPickerWithMaximumPhotosAllow:9 - self.imgs.count completion:^(NSArray *assets) {
            NSArray *assetArr = assets;
            for (int i = 0; i < assets.count; i++)
            {
                ALAsset *asset = assetArr[i];
                CGImageRef thum = [asset aspectRatioThumbnail];
                UIImage *image = [UIImage imageWithCGImage:thum];
                [self.imgs addObject:image];
            }
            self.contentImgView.imgs = self.imgs;
            if (self.imgs.count==0) {
                self.contentImgView.maxLab.text = @"(最多上传9张图片)";
                self.headerView.frame = CGRectMake(0, 0, ScreenW, 450);
                self.contentImgView.frame = CGRectMake(0, 200, ScreenW, 100);
            }else{
                self.contentImgView.maxLab.text = self.imgs.count == 9?@"(最多上传9张图片)":[NSString stringWithFormat:@"还可上传%ld张",9-self.imgs.count];
                self.headerView.frame = CGRectMake(0, 0, ScreenW, 500);
                self.contentImgView.frame = CGRectMake(0, 200, ScreenW, 150);
            }
            self.peopleView.frame = CGRectMake(0, CGRectGetMaxY(self.contentImgView.frame), ScreenW, 50);
            self.moneyView.frame = CGRectMake(0, CGRectGetMaxY(self.peopleView.frame), ScreenW, 50);
            self.totalView.frame = CGRectMake(0, CGRectGetMaxY(self.moneyView.frame), ScreenW, 50);
            [self.headerView layoutIfNeeded];
        }];
    }];
    UIAlertAction * a3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [actionController addAction:a1];
    [actionController addAction:a2];
    [actionController addAction:a3];
    [self presentViewController:actionController animated:YES completion:nil];
}

//删除图片
- (void)LxmPublishImgView:(LxmPublishImgView *)imgView deleteAtIndex:(NSInteger)index{
    
    UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"确定要删除这张图片吗?" preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self.imgs removeObjectAtIndex:index];
        self.contentImgView.imgs = self.imgs;
        if (self.imgs.count==0) {
            self.contentImgView.maxLab.text = @"(最多上传9张图片)";
            self.headerView.frame = CGRectMake(0, 0, ScreenW, 450);
            self.contentImgView.frame = CGRectMake(0, 200, ScreenW, 100);
        }else{
            self.contentImgView.maxLab.text = self.imgs.count == 9?@"(最多上传9张图片)":[NSString stringWithFormat:@"还可上传%ld张",9-self.imgs.count];
            self.headerView.frame = CGRectMake(0, 0, ScreenW, 500);
            self.contentImgView.frame = CGRectMake(0, 200, ScreenW, 150);
        }
        self.peopleView.frame = CGRectMake(0, CGRectGetMaxY(self.contentImgView.frame), ScreenW, 50);
        self.moneyView.frame = CGRectMake(0, CGRectGetMaxY(self.peopleView.frame), ScreenW, 50);
        self.totalView.frame = CGRectMake(0, CGRectGetMaxY(self.moneyView.frame), ScreenW, 50);
        [self.headerView layoutIfNeeded];
        
    }]];
    [self presentViewController:alertView animated:YES completion:nil];

}

#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length > 500) {
        [SVProgressHUD showErrorWithStatus:@"输入不能超过500个字"];
        return;
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 500) {
        [SVProgressHUD showErrorWithStatus:@"输入不能超过500个字"];
        return;
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (textView.text.length > 500) {
        [SVProgressHUD showErrorWithStatus:@"输入不能超过500个字"];
        return;
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.peopleView.numTF) {
        if (self.peopleView.numTF.text.intValue == 0) {
            [SVProgressHUD showErrorWithStatus:@"您还没有输入所需人数!"];
            NSString * money =  [NSString stringWithFormat:@"合计:￥%.2f",0.00];
            NSMutableAttributedString * att  = [[NSMutableAttributedString alloc] initWithString:money];
            [att addAttribute:NSForegroundColorAttributeName value:CharacterDarkColor range:NSMakeRange(0, 3)];
            self.totalMoneyLab.attributedText = att;
            return;
        }
        
        if (self.peopleView.numTF.text.intValue > 20) {
            [SVProgressHUD showErrorWithStatus:@"人数不能超过20人"];
            return;
        }
    }
    
    if (textField == self.moneyView.numTF) {
        if (self.moneyView.numTF.text.intValue == 0) {
            NSString * money = [NSString stringWithFormat:@"合计:￥%.2f",0.00];
            NSMutableAttributedString * att  = [[NSMutableAttributedString alloc] initWithString:money];
            [att addAttribute:NSForegroundColorAttributeName value:CharacterDarkColor range:NSMakeRange(0, 3)];
            self.totalMoneyLab.attributedText = att;
            [SVProgressHUD showErrorWithStatus:@"您还没有输入赏金金额!"];
            return;
        }
        
        if (self.moneyView.numTF.text.intValue > 1000) {
            [SVProgressHUD showErrorWithStatus:@"赏金不能超过1000元"];
            return;
        }
        
    }
    NSNumber * totalMoney =     @(self.moneyView.numTF.text.floatValue*self.peopleView.numTF.text.floatValue);
    NSString * money  = @"";
    if (self.moneyView.numTF.text!=0&&self.peopleView.numTF.text!=0) {
        money = [NSString stringWithFormat:@"合计:￥%.2f",totalMoney.floatValue];
    }else{
        money = [NSString stringWithFormat:@"合计:￥%.2f",0.00];
    }
    NSMutableAttributedString * att  = [[NSMutableAttributedString alloc] initWithString:money];
    [att addAttribute:NSForegroundColorAttributeName value:CharacterDarkColor range:NSMakeRange(0, 3)];
    self.totalMoneyLab.attributedText = att;
}

- (void)jiaJianClick{
    NSNumber * totalMoney = @(self.moneyView.numTF.text.floatValue*self.peopleView.numTF.text.floatValue);
    NSString * money  = @"";
    if (self.moneyView.numTF.text!=0&&self.peopleView.numTF.text != 0) {
        money = [NSString stringWithFormat:@"合计:￥%.2f",totalMoney.floatValue];
    }else{
        money = [NSString stringWithFormat:@"合计:￥%.2f",0.00];
    }
    NSMutableAttributedString * att  = [[NSMutableAttributedString alloc] initWithString:money];
    [att addAttribute:NSForegroundColorAttributeName value:CharacterDarkColor range:NSMakeRange(0, 3)];
    self.totalMoneyLab.attributedText = att;
}

@end

@interface LxmPublishImgView()

@end

@implementation LxmPublishImgView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, 60, 60)];
        [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"addphoto"] forState:UIControlStateNormal];
        [self addSubview:self.selectBtn];
        
        self.maxLab = [[UILabel alloc] init];
        self.maxLab.textColor = CharacterLightGrayColor;
        self.maxLab.text = @"(最多9张图片)";
        self.maxLab.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.maxLab];

        [self.maxLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.selectBtn.mas_trailing).offset(5);
            make.centerY.equalTo(self.selectBtn);
        }];

        self.nimingLab = [[UILabel alloc] init];
        self.nimingLab.textColor = CharacterGrayColor;
        self.nimingLab.text = @"匿名";
        self.nimingLab.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.nimingLab];
        [self.nimingLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).offset(-3-15-44);
            make.centerY.equalTo(self.selectBtn);
        }];

        self.switchBtn = [[UIButton alloc] init];
        [self.switchBtn setBackgroundImage:[UIImage imageNamed:@"switch_n"] forState:UIControlStateNormal];
        [self.switchBtn setBackgroundImage:[UIImage imageNamed:@"switch_s"] forState:UIControlStateSelected];
        [self addSubview:self.switchBtn];
        [self.switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).offset(-15);
            make.centerY.equalTo(self.selectBtn);
            make.width.equalTo(@44);
            make.height.equalTo(@24);
        }];
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(15, 70, ScreenW-30, 60)];
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.scrollEnabled = YES;
        self.scrollView.userInteractionEnabled = YES;
        self.scrollView.contentSize = CGSizeZero;
        [self addSubview:self.scrollView];
    }
    return self;
}

- (void)setImgs:(NSMutableArray *)imgs{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0; i < imgs.count; i++) {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(i*(60+5), 0, 60, 60)];
        if ([imgs[i] isKindOfClass:[UIImage class]]) {
            img.image = imgs[i];
        }else {
            [img sd_setImageWithURL:[NSURL URLWithString:imgs[i]] placeholderImage:[UIImage imageNamed:@"new_picture_default"] options:SDWebImageRetryFailed];
        }
        img.contentMode = UIViewContentModeScaleAspectFill;
        img.clipsToBounds = YES;
        img.userInteractionEnabled = YES;
        [self.scrollView addSubview:img];
        
        UIButton * deleteBtn = [[UIButton alloc] init];
        [deleteBtn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
        deleteBtn.tag = i;
        [img addSubview:deleteBtn];
        
        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.trailing.equalTo(img);
            make.width.height.equalTo(@40);
        }];
        UIImageView * iconImgView = [[UIImageView alloc] init];
        iconImgView.image = [UIImage imageNamed:@"guanbi"];
        [deleteBtn addSubview:iconImgView];
        
        [iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.trailing.equalTo(deleteBtn);
            make.width.height.equalTo(@20);
        }];
    }
    self.scrollView.contentSize = CGSizeMake(65*imgs.count, 60);
}

//删除图片
- (void)deleteClick:(UIButton *)deleteBtn{
    if ([self.delegate respondsToSelector:@selector(LxmPublishImgView:deleteAtIndex:)]) {
        [self.delegate LxmPublishImgView:self deleteAtIndex:deleteBtn.tag];
    }
    self.scrollView.contentSize = CGSizeMake(65*self.imgs.count, 60);
}

@end

@interface LxmLeftLabRightNumView()<UITextFieldDelegate>

@end
@implementation LxmLeftLabRightNumView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.textlab];
        [self addSubview:self.lineView];
        
        self.numView = [[UIView alloc] init];
        self.numView.layer.borderColor = LineColor.CGColor;
        self.numView.layer.borderWidth = 0.5;
        self.numView.layer.cornerRadius = 3;
        self.numView.layer.masksToBounds = YES;
        [self addSubview:self.numView];
        
        self.desBtn = [[UIButton alloc] init];
        [self.desBtn setTitle:@"-" forState:UIControlStateNormal];
        [self.desBtn addTarget:self action:@selector(numClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.desBtn setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        self.desBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [self.numView addSubview:self.desBtn];
        
        self.numTF = [[UITextField alloc] init];
        self.numTF.text = @"0";
        self.numTF.keyboardType = UIKeyboardTypeNumberPad;
        self.numTF.delegate = self;
        self.numTF.textAlignment = NSTextAlignmentCenter;
        self.numTF.returnKeyType=UIReturnKeyDone;
        [self.numView addSubview:self.numTF];
        
        self.incBtn = [[UIButton alloc] init];
        [self.incBtn setTitle:@"+" forState:UIControlStateNormal];
        [self.incBtn addTarget:self action:@selector(numClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.incBtn setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        self.incBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.numView addSubview:self.incBtn];
        
        [self.numView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.trailing.equalTo(self).offset(-15);
            make.width.equalTo(@100);
            make.height.equalTo(@30);
        }];
        
        [self.desBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.numView);
            make.width.equalTo(@30);
            make.height.equalTo(@30);
        }];
        [self.numTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.leading.equalTo(self.desBtn.mas_trailing);
            make.trailing.equalTo(self.incBtn.mas_leading);
            make.height.equalTo(@30);
            make.width.equalTo(@40);
        }];
        [self.incBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.trailing.equalTo(self).offset(-15);
            make.width.equalTo(@30);
            make.height.equalTo(@30);
        }];
        
        [self.textlab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.centerY.equalTo(self);
            make.width.equalTo(@100);
        }];
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(self);
            make.height.equalTo(@0.5);
            
        }];
    }
    return self;
}

- (void)numClick:(UIButton *)btn{
    if (btn == self.desBtn) {
        //减
        NSNumber * num = @(self.numTF.text.intValue);
        if (num.intValue>1) {
            num = @(num.intValue-1);
            self.numTF.text = [NSString stringWithFormat:@"%@",num];
        }else  if (num.intValue==1){
            self.numTF.text = [NSString stringWithFormat:@"%@",@1];
            [SVProgressHUD showErrorWithStatus:@"不能再减少了!"];
            return;
        }
        
    }else{
        //加
        
        if (self.numTF.text.intValue < 9999) {
            NSNumber * num = @(self.numTF.text.intValue);
            num = @(num.intValue+1);
            self.numTF.text = [NSString stringWithFormat:@"%@",num];
        }
    }

    if ([self.delegate respondsToSelector:@selector(jiaJianClick)]) {
        [self.delegate jiaJianClick];
    }
}


- (UILabel *)textlab{
    if (!_textlab) {
        _textlab = [[UILabel alloc] init];
        _textlab.font = [UIFont systemFontOfSize:15];
        _textlab.textColor = CharacterDarkColor;
    }return _textlab;
}
- (UIView *)numView{
    if (!_numView) {
        _numView = [[UIView alloc] init];
       
    }return _numView;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }return _lineView;
}

@end
