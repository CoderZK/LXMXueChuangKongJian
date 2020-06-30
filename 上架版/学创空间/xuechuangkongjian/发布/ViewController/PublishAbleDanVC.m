//
//  PublishAbleDanVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/17.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "PublishAbleDanVC.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import "MXPhotoPickerController.h"
#import "UIViewController+MXPhotoPicker.h"
#import "MXImageEditController.h"
//#import "PayVC.h"

@interface PublishAbleDanVC ()<LxmPublishImgViewDelegate,UITextFieldDelegate,LxmLeftLabRightNumViewDelegate,LxmPublishAbleOtherInfoViewDelegate,UITextViewDelegate>
@property (nonatomic , strong)LxmHomeBannerModel * typeModel;
@property (nonatomic , strong)UIView * headerView;
@property (nonatomic , strong)LxmPublishAbleDanTitleView * titleView;
@property (nonatomic , strong)IQTextView * contentView;
@property (nonatomic , strong)LxmPublishImgView * contentImgView;
@property (nonatomic , strong)LxmPublishAbleOtherInfoView * otherInfoView;
@property (nonatomic , strong)NSMutableArray * imgs;
@property (nonatomic , assign)NSInteger selectIndex;
@end

@implementation PublishAbleDanVC
- (instancetype)initWithTableViewStyle:(UITableViewStyle)style LxmHomeBannerModel:(LxmHomeBannerModel *)model;{
    self = [super initWithTableViewStyle:style];
    if (self) {
        self.typeModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发布技能";
    
    self.imgs = [NSMutableArray array];
    self.tableView.backgroundColor = [UIColor whiteColor];
    UIButton * rightbtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [rightbtn setTitle:@"发布" forState:UIControlStateNormal];
    rightbtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightbtn setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
    [rightbtn addTarget:self action:@selector(publishBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightbtn];
    [self initHeaderView];
}

- (void)publishBtnClick{
    if (self.titleView.titleTF.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入您的技能!"];
        return;
    }
    if (self.titleView.titleTF.text.length > 10) {
        [SVProgressHUD showErrorWithStatus:@"技能描述应小于10个字"];
        return;
    }
    
    if (self.contentView.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"具体写一下吧..."];
        return;
    }
    
    if (self.contentView.text.length > 1000) {
        [SVProgressHUD showErrorWithStatus:@"输入内容应小于1000字"];
        return;
    }
    
    if (self.otherInfoView.priceView.numTF.text.floatValue == 0) {
        [SVProgressHUD showErrorWithStatus:@"您还没有输入价格!"];
        return;
    }
    if (self.otherInfoView.danweiView.rightTF.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"您还没有输入单位!"];
        return;
    }
    if (self.otherInfoView.danweiView.rightTF.text.length >4) {
        [SVProgressHUD showErrorWithStatus:@"单位应小于4个字"];
        return;
    }
    if (self.selectIndex == 0) {
        [SVProgressHUD showErrorWithStatus:@"您还没有选择交付方式"];
        return;
    }
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"token"] = SESSION_TOKEN;
    dic[@"typeId"] = self.typeModel.ID;
    dic[@"schoolId"] = @([LxmTool ShareTool].userModel.schoolId);
    dic[@"title"] = self.titleView.titleTF.text;
    dic[@"content"] = self.contentView.text;
    dic[@"money"] = self.otherInfoView.priceView.numTF.text;
    dic[@"unit"] = self.otherInfoView.danweiView.rightTF.text;
    dic[@"sendType"] = @(self.selectIndex);
    
    [SVProgressHUD show];
    [LxmNetworking NetWorkingUpLoad:[LxmURLDefine user_releaseCan] images:self.imgs parameters:dic name:@"img" success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] intValue] == 1) {
            [LxmEventBus sendEvent:@"publishAbleDanSuccess" data:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

- (void)initHeaderView{
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 350+230)];
    self.headerView.backgroundColor = UIColor.whiteColor;
    self.tableView.tableHeaderView = self.headerView;
    
    self.titleView = [[LxmPublishAbleDanTitleView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    [self.headerView addSubview:self.titleView];
    
    self.contentView = [[IQTextView alloc] initWithFrame:CGRectMake(15, 50, ScreenW - 30, 200)];
    self.contentView.placeholder = @"具体写一下吧......";
    self.contentView.font = [UIFont systemFontOfSize:15];
    self.contentView.delegate = self;
    [self.headerView addSubview:self.contentView];
    
    self.contentImgView = [[LxmPublishImgView alloc] initWithFrame:CGRectMake(0, 250, ScreenW, 100)];
    [self.contentImgView.selectBtn addTarget:self action:@selector(uploadImg) forControlEvents:UIControlEventTouchUpInside];
    self.contentImgView.switchBtn.hidden = YES;
    self.contentImgView.nimingLab.hidden = YES;
    self.contentImgView.delegate = self;
    [self.headerView addSubview:self.contentImgView];
    
    self.otherInfoView = [[LxmPublishAbleOtherInfoView alloc] initWithFrame:CGRectMake(0, 350, ScreenW, 230)];
    self.otherInfoView.delegate = self;
    self.otherInfoView.priceView.numTF.delegate = self;
    self.otherInfoView.priceView.delegate = self;
    self.otherInfoView.danweiView.rightTF.delegate = self;
    self.otherInfoView.priceView.numTF.keyboardType = UIKeyboardTypeDecimalPad;
    [self.headerView addSubview:self.otherInfoView];
    
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = LineColor;
    [self.headerView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.headerView);
        make.height.equalTo(@0.5);
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.otherInfoView.priceView.numTF) {
        if (self.otherInfoView.priceView.numTF.text.floatValue == 0) {
            [SVProgressHUD showErrorWithStatus:@"您还没有输入价格!"];
            self.otherInfoView.priceLab.text = @"￥0";
        }else if (self.otherInfoView.priceView.numTF.text.floatValue > 9999) {
            [SVProgressHUD showErrorWithStatus:@"不能超过9999"];
            self.otherInfoView.priceView.numTF.text = @"0";
        } else{
            if (self.otherInfoView.danweiView.rightTF.text.length == 0 ) {
                self.otherInfoView.priceLab.text = @"￥0";
            }else{
                self.otherInfoView.priceLab.text = [NSString stringWithFormat:@"￥%0.2f/%@",self.otherInfoView.priceView.numTF.text.floatValue,self.otherInfoView.danweiView.rightTF.text];
            }
        }
    }
    if (textField == self.otherInfoView.danweiView.rightTF) {
        if (self.otherInfoView.danweiView.rightTF.text == 0) {
            [SVProgressHUD showErrorWithStatus:@"您还没有输入单位!"];
            self.otherInfoView.priceLab.text = @"￥0";
        }else{
            
            
            if (self.otherInfoView.danweiView.rightTF.text.length == 0) {
                [SVProgressHUD showErrorWithStatus:@"您还没有输入单位!"];
                self.otherInfoView.priceLab.text = @"￥0";
            }else {
                self.otherInfoView.priceLab.text = [NSString stringWithFormat:@"￥%0.2f/%@",self.otherInfoView.priceView.numTF.text.floatValue,self.otherInfoView.danweiView.rightTF.text];
            }
        }
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length > 1000) {
        [SVProgressHUD showErrorWithStatus:@"文字不能超过1000字"];
        [textView resignFirstResponder];
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {


    
    if (textField == self.otherInfoView.priceView.numTF) {
        NSMutableString *futureString = [NSMutableString stringWithString:textField.text];
           [futureString insertString:string atIndex:range.location];
           
        if ([futureString containsString:@"-"]) {
            return NO;
        }
           NSInteger flag = 0;
           // 这个可以自定义,保留到小数点后两位,后几位都可以
           const NSInteger limited = 2;
           
           for (NSInteger i = futureString.length - 1; i >= 0; i--) {
               
               if ([futureString characterAtIndex:i] == '.') {
                   // 如果大于了限制的就提示
                   if (flag > limited) {
                       
                       [SVProgressHUD showErrorWithStatus:@"请输入最多两位小数的数值"];
                       return NO;
                   }
                   
                   break;
               }
               
               flag++;
           }
    }
    
    
    
    
   
    
    return YES;
}


- (void)checkTextContent:(NSString *)text {
    if ([text isEqualToString:@"次"]||[text isEqualToString:@"时"]||[text isEqualToString:@"天"]) {
        
    }
}



- (void)jiaJianClick{
    if (self.otherInfoView.priceView.numTF.text.floatValue == 0) {
        [SVProgressHUD showErrorWithStatus:@"您还没有输入价格!"];
        self.otherInfoView.priceLab.text = @"￥0";
        return;
    }else {
        if (self.otherInfoView.danweiView.rightTF.text.length == 0 ) {
            self.otherInfoView.priceLab.text = @"￥0";
        }else{
            self.otherInfoView.priceLab.text = [NSString stringWithFormat:@"￥%0.2f/%@",self.otherInfoView.priceView.numTF.text.floatValue,self.otherInfoView.danweiView.rightTF.text];
        }
    }
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
                [self.imgs lxm_add1Object:image];
                self.contentImgView.imgs = self.imgs;
                if (self.imgs.count==0) {
                    self.contentImgView.maxLab.text = @"(最多上传9张图片)";
                    self.headerView.frame = CGRectMake(0, 0, ScreenW, 350+230);
                    self.contentImgView.frame = CGRectMake(0, 250, ScreenW, 100);
                }else{
                    self.contentImgView.maxLab.text = self.imgs.count == 9?@"(最多上传9张图片)":[NSString stringWithFormat:@"还可上传%ld张",9-self.imgs.count];
                    self.headerView.frame = CGRectMake(0, 0, ScreenW, 400+230);
                    self.contentImgView.frame = CGRectMake(0, 250, ScreenW, 150);
                }
                self.otherInfoView.frame = CGRectMake(0, CGRectGetMaxY(self.contentImgView.frame), ScreenW, 230);
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
                [self.imgs lxm_add1Object:image];
            }
            self.contentImgView.imgs = self.imgs;
            if (self.imgs.count==0) {
                self.contentImgView.maxLab.text = @"(最多上传9张图片)";
                self.headerView.frame = CGRectMake(0, 0, ScreenW, 350+230);
                self.contentImgView.frame = CGRectMake(0, 250, ScreenW, 100);
            }else{
                self.contentImgView.maxLab.text = self.imgs.count == 9?@"(最多上传9张图片)":[NSString stringWithFormat:@"还可上传%ld张",9-self.imgs.count];
                self.headerView.frame = CGRectMake(0, 0, ScreenW, 400+230);
                self.contentImgView.frame = CGRectMake(0, 250, ScreenW, 150);
            }
            self.otherInfoView.frame = CGRectMake(0, CGRectGetMaxY(self.contentImgView.frame), ScreenW, 230);
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
            self.headerView.frame = CGRectMake(0, 0, ScreenW, 350+230);
            self.contentImgView.frame = CGRectMake(0, 250, ScreenW, 100);
        }else{
            self.contentImgView.maxLab.text = self.imgs.count == 9?@"(最多上传9张图片)":[NSString stringWithFormat:@"还可上传%ld张",9-self.imgs.count];
            self.headerView.frame = CGRectMake(0, 0, ScreenW, 400+230);
            self.contentImgView.frame = CGRectMake(0, 250, ScreenW, 150);
        }
        self.otherInfoView.frame = CGRectMake(0, CGRectGetMaxY(self.contentImgView.frame), ScreenW, 230);
        [self.headerView layoutIfNeeded];
        
    }]];
    [self presentViewController:alertView animated:YES completion:nil];
    
}

- (void)LxmPublishAbleOtherInfoView:(LxmPublishAbleOtherInfoView *)view btnAtnIndex:(NSInteger)index{
    NSLog(@"%ld",index);
    self.selectIndex = index+1;
}

@end

@implementation LxmPublishAbleDanTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel * textLab = [[UILabel alloc] init];
        textLab.textColor = CharacterGrayColor;
        textLab.text = @"校园商家:";
        textLab.font = [UIFont systemFontOfSize:16];
        [self addSubview:textLab];
        [textLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.centerY.equalTo(self);
        }];
        
        self.titleTF = [[UITextField alloc] init];
        self.titleTF.placeholder = @"教摄影";
        self.titleTF.font = [UIFont systemFontOfSize:16];
        [self addSubview:self.titleTF];
        [self.titleTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).offset(-15);
            make.leading.equalTo(textLab.mas_trailing).offset(10);
            make.centerY.equalTo(textLab);
        }];
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(15, 49.5, ScreenW-30, 0.5)];
        line.backgroundColor = LineColor;
        [self addSubview:line];
        
    }
    return self;
}

@end


@interface LxmPublishAbleOtherInfoView()

@property (nonatomic , strong) NSMutableArray * btnArr;

@end

@implementation LxmPublishAbleOtherInfoView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.btnArr = [NSMutableArray array];
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 10)];
        line.backgroundColor = BGGrayColor;
        [self addSubview:line];
        
        self.priceView = [[LxmLeftLabRightNumView alloc] initWithFrame:CGRectMake(0, 10, ScreenW, 50)];
        self.priceView.textlab.text = @"价格";
        [self addSubview:self.priceView];
        self.priceView.isFloat = YES;
        
        self.danweiView = [[LxmTextTFView alloc] initWithFrame:CGRectMake(0, 60, ScreenW, 50)];
        self.danweiView.textlab.text = @"单位:";
        self.danweiView.rightTF.placeholder = @"每次/每小时/每天 请输入...";
        self.danweiView.rightImgView.hidden = YES;
        [self.danweiView.rightTF mas_updateConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.danweiView).offset(-15);
        }];
        [self addSubview:self.danweiView];
        
        UIView * styleView = [[UIView alloc] initWithFrame:CGRectMake(15, 110, ScreenW - 30, 60)];
        [self addSubview:styleView];
        
        CGFloat space = (ScreenW - 30-4*70)/3;
        for (int i = 0; i<4; i++) {
            UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake((70+space)*i, 0, 70, 60)];
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d",41+i]] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d",45+i]] forState:UIControlStateSelected];
            if (i == 0) {
                [btn setTitle:@"邮寄" forState:UIControlStateNormal];
                btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
            }else if (i == 1){
                [btn setTitle:@"线上" forState:UIControlStateNormal];
                btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
            }else if (i == 2){
                [btn setTitle:@"当面" forState:UIControlStateNormal];
                btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
            }else if (i == 3){
                [btn setTitle:@"其它" forState:UIControlStateNormal];
                btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 8)];
            }
            btn.tag = i;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.btnArr lxm_add1Object:btn];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
            [styleView addSubview:btn];
        }
        
        
        UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 170, ScreenW, 10)];
        line1.backgroundColor = BGGrayColor;
        [self addSubview:line1];
        
        UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(15, 180, ScreenW - 30, 50)];
        [self addSubview:bottomView];
        
        UILabel * jiageLab = [[UILabel alloc] init];
        jiageLab.textColor = CharacterDarkColor;
        jiageLab.font = [UIFont systemFontOfSize:15];
        jiageLab.text = @"价格:";
        [bottomView addSubview:jiageLab];
        
        self.priceLab = [[UILabel alloc] init];
        self.priceLab.textColor = YellowColor;
        self.priceLab.font = [UIFont boldSystemFontOfSize:18];
        self.priceLab.text = @"￥0";
        [bottomView addSubview:self.priceLab];
        
        [jiageLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.priceLab.mas_leading).offset(-5);
            make.centerY.equalTo(bottomView);
        }];
        [self.priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.trailing.equalTo(bottomView);
        }];
    }
    return self;
}
- (void)btnClick:(UIButton *)btn{
    for (UIButton * btnn in self.btnArr) {
        btnn.selected = btnn == btn?YES:NO;
    }
    if ([self.delegate respondsToSelector:@selector(LxmPublishAbleOtherInfoView:btnAtnIndex:)]) {
        [self.delegate LxmPublishAbleOtherInfoView:self btnAtnIndex:btn.tag];
    }
    
}

@end
