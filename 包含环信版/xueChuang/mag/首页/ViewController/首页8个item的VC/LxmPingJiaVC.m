//
//  LxmPingJiaVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/13.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmPingJiaVC.h"
#import "LXMStarView.h"
#import "IQKeyboardManagerConstants.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import "MXPhotoPickerController.h"
#import "UIViewController+MXPhotoPicker.h"
#import "MXImageEditController.h"


@interface LxmPingJiaVC ()<LXMStarViewDelegate,LxmPingJiaImgCellDelegate>
@property (nonatomic , strong)LXMStarView * starView;
@property (nonatomic , strong)IQTextView * contentView;
/**
 上传图片数组
 */
@property (nonatomic , strong) NSMutableArray *imgs;
@property (nonatomic , strong) LxmAroundModel *model;
@property (nonatomic , assign) NSInteger starNum;
@end

@implementation LxmPingJiaVC

- (instancetype)initWithTableViewStyle:(UITableViewStyle)style model:(LxmAroundModel *)model{
    self = [super initWithTableViewStyle:style];
    if (self) {
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.starNum = 4;
    self.navigationItem.title = @"评价";
    UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [rightBtn setTitle:@"发布" forState:UIControlStateNormal];
    [rightBtn setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    self.imgs = [NSMutableArray array];
    [self initTableHeaderView];
    
}
- (void)rightBtnClick{
    if (self.contentView.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"写点什么吧....."];
        return;
    }
    NSDictionary * dic = @{
                           @"token":SESSION_TOKEN,
                           @"nearId":self.model.nearId,
                           @"score":@(self.starNum),
                           @"content":self.contentView.text,
                           };
    [SVProgressHUD show];
    [LxmNetworking NetWorkingUpLoad:[LxmURLDefine user_evaluateNear] images:self.imgs parameters:dic name:@"img" success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] intValue] == 1) {
            [SVProgressHUD showSuccessWithStatus:@"评价成功"];
            if (self.refreshPreVC) {
                self.refreshPreVC();
            };
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
  
}
- (void)initTableHeaderView{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 300)];
    headerView.backgroundColor = UIColor.whiteColor;
    self.tableView.tableHeaderView = headerView;
    
    self.starView = [[LXMStarView alloc] initWithFrame:CGRectMake((ScreenW-200)*0.5, 35, 200, 30) withSpace:10];
    self.starView.starNum = self.starNum;
    self.starView.delegate = self;
    [headerView addSubview:self.starView];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(15, 98, ScreenW - 30, 2)];
    line.backgroundColor = LineColor;
    [headerView addSubview:line];
    
    self.contentView = [[IQTextView alloc] initWithFrame:CGRectMake(15, 100, ScreenW - 30, 200)];
    self.contentView.placeholder = @"写点什么吧......";
    self.contentView.font = [UIFont systemFontOfSize:15];
    [headerView addSubview:self.contentView];
    
}
//星星数量
- (void)didClickStar:(NSInteger )star{
    self.starNum = star;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LxmPingJiaImgCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmPingJiaImgCell"];
    if (!cell)
    {
        cell = [[LxmPingJiaImgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmPingJiaImgCell" withImg:self.imgs];
    }
    cell.imgArr = self.imgs;
    cell.delegate = self;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (void)LxmPingJiaImgCell:(LxmPingJiaImgCell *)cell btnAtIndex:(NSInteger)index{
    
    // 上传图片
    if (self.imgs.count>=3) {
        [SVProgressHUD showErrorWithStatus:@"最多上传3张图片"];
        return;
    }
    
    if (index == self.imgs.count) {
        //上传图片
        UIAlertController * actionController = [UIAlertController alertControllerWithTitle:@"选择图片上传方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction * a1 = [UIAlertAction actionWithTitle:@"打开相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (self.imgs.count<3) {
                [self showMXPhotoCameraAndNeedToEdit:YES completion:^(UIImage *image, UIImage *originImage, CGRect cutRect) {
                    [self.imgs addObject:image];
                    NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:0];
                    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                }];
            }
           
        }];
        
        UIAlertAction * a2 = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self showMXPickerWithMaximumPhotosAllow:3 - self.imgs.count completion:^(NSArray *assets) {
                NSArray *assetArr = assets;
                for (int i = 0; i < assets.count; i++)
                {
                    ALAsset *asset = assetArr[i];
                    CGImageRef thum = [asset aspectRatioThumbnail];
                    UIImage *image = [UIImage imageWithCGImage:thum];
                    [self.imgs addObject:image];
                }
                
                NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:0];
                [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            }];
        }];
        UIAlertAction * a3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [actionController addAction:a1];
        [actionController addAction:a2];
        [actionController addAction:a3];
        [self presentViewController:actionController animated:YES completion:nil];
        
    }
}

- (void)LxmPingJiaImgCell:(LxmPingJiaImgCell *)cell deleteAtIndex:(NSInteger)index
{
    UIAlertController * actionController = [UIAlertController alertControllerWithTitle:@"确定要删除这张图片吗" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * a1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self.imgs removeObjectAtIndex:index];
        NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:0];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    UIAlertAction * a2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [actionController addAction:a1];
    [actionController addAction:a2];
    [self presentViewController:actionController animated:YES completion:nil];
}

@end

@implementation LxmPingJiaImgItemCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        [self addSubview:self.imgView];
        
        self.deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 0, 30, 30)];
        [self.deleteBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [self.deleteBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 14, 14, 0)];
        [self addSubview:self.deleteBtn];
    }
    return self;
}
@end


@interface LxmPingJiaImgCell()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic , strong)UICollectionViewFlowLayout * layout;
@property (nonatomic , strong)UICollectionView * collectionView;
@end

@implementation LxmPingJiaImgCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withImg:(NSMutableArray *)imgs{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imgArr = imgs;
        
        self.layout = [[UICollectionViewFlowLayout alloc] init];
        self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.layout.itemSize = CGSizeMake(80, 80);
        self.layout.minimumInteritemSpacing = (ScreenW-imgs.count*80)/(imgs.count+1);
        self.layout.minimumLineSpacing = 15;
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, 0, ScreenW - 30, 80) collectionViewLayout:self.layout];
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.collectionView];
        
        [self.collectionView registerClass:[LxmPingJiaImgItemCell class] forCellWithReuseIdentifier:@"LxmPingJiaImgItemCell"];
    }
    return self;
}
- (void)setImgArr:(NSMutableArray *)imgArr{
    _imgArr = imgArr;
    [self.collectionView reloadData];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imgArr.count+1;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LxmPingJiaImgItemCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LxmPingJiaImgItemCell" forIndexPath:indexPath];
    if (indexPath.item == self.imgArr.count) {
        cell.imgView.image = [UIImage imageNamed:@"addphoto"];
        cell.deleteBtn.hidden = YES;
    }else{
        id image = [self.imgArr objectAtIndex:indexPath.item];
        if ([image isKindOfClass:[UIImage class]]) {
            cell.imgView.image = image;
        }else{
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"whequemoren"] options:SDWebImageRetryFailed];
        }
        
        cell.deleteBtn.hidden = NO;
        cell.deleteBtn.tag = indexPath.item;
        [cell.deleteBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (indexPath.item == self.imgArr.count) {
        if ([self.delegate respondsToSelector:@selector(LxmPingJiaImgCell:btnAtIndex:)]) {
            [self.delegate LxmPingJiaImgCell:self btnAtIndex:indexPath.item];
        }
    }
}
- (void)btnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(LxmPingJiaImgCell:deleteAtIndex:)]) {
        [self.delegate LxmPingJiaImgCell:self deleteAtIndex:btn.tag];
    }
 
}
@end
