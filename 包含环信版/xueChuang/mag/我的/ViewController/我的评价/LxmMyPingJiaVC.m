//
//  LxmMyPingJiaVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/19.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmMyPingJiaVC.h"
#import "LxmAroundDetailVC.h"

@interface LxmMyPingJiaVC ()<LxmMyPingJiaCellDelegate>
@property (nonatomic , strong) UILabel * noneDataView;
@property (nonatomic , assign) NSInteger page;
@property (nonatomic , strong) NSMutableArray * dataArr;
@property (nonatomic , strong) NSString * time;
@end

@implementation LxmMyPingJiaVC
- (UILabel *)noneDataView{
    if (!_noneDataView) {
        _noneDataView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
        _noneDataView.text = @"没有数据!";
        _noneDataView.font = [UIFont systemFontOfSize:16];
        _noneDataView.textAlignment = NSTextAlignmentCenter;
        _noneDataView.textColor = [UIColor blackColor];
        _noneDataView.hidden = YES;
    }
    return _noneDataView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的评价";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView addSubview:self.noneDataView];
    [self.noneDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.tableView);
    }];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 0.5)];
    line.backgroundColor = LineColor;
    self.tableView.tableHeaderView = line;
    
    self.dataArr = [NSMutableArray array];
    self.time = [NSString getCurrentTimeChuo];
    self.page = 1;
    [self loadMyEvaluateList];
    __weak typeof(self) safe_self = self;
    NSInteger * safe_page = &_page;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.time = [NSString getCurrentTimeChuo];
        * safe_page = 1;
        [safe_self loadMyEvaluateList];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [safe_self loadMyEvaluateList];
    }];
    
    if (kDevice_Is_iPhoneX) {
        self.tableView.frame = CGRectMake(0, 0, ScreenW, self.view.bounds.size.height -34);
    }else{
        self.tableView.frame = CGRectMake(0, 0, ScreenW, self.view.bounds.size.height);
    }
}
- (void)loadMyEvaluateList{
    [SVProgressHUD show];
    if (ISLOGIN) {
        NSDictionary * dict = @{
                                @"token":SESSION_TOKEN,
                                @"pageNum":@(self.page),
                                @"time":self.time
                                };
        NSString * str = [LxmURLDefine user_findMyEvaList];
        [LxmNetworking networkingPOST:str parameters:dict returnClass:[LxmMyEvaluateListRootModel class] success:^(NSURLSessionDataTask *task, LxmMyEvaluateListRootModel * responseObject) {
            [SVProgressHUD dismiss];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            if (responseObject.key.intValue == 1) {
                if (self.page == 1) {
                    [self.dataArr removeAllObjects];
                }
                LxmMyEvaluateListModel1 * model = responseObject.result;
                NSArray * dataArr =  [NSMutableArray arrayWithArray:model.list];
                [self.dataArr addObjectsFromArray:dataArr];
                if (self.dataArr.count == 0) {
                    self.noneDataView.hidden = NO;
                }else{
                    self.noneDataView.hidden = YES;
                }
                self.time = model.time;
                self.page++;
                [self.tableView reloadData];
            }else{
                [UIAlertController showAlertWithKey:responseObject.key message:responseObject.message];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [SVProgressHUD dismiss];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先登录"];
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LxmMyPingJiaCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmMyPingJiaCell"];
    if (!cell)
    {
        cell = [[LxmMyPingJiaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmMyPingJiaCell"];
    }
    
    LxmMyEvaluateListModel * model = [self.dataArr objectAtIndex:indexPath.row];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LxmMyEvaluateListModel * model = [self.dataArr objectAtIndex:indexPath.row];
    return model.height;
}

- (void)LxmMyPingJiaCell:(LxmMyPingJiaCell *)cell btnAtIndex:(NSInteger)index{
    NSIndexPath * indexP = [self.tableView indexPathForCell:cell];
    LxmMyEvaluateListModel * model = [self.dataArr objectAtIndex:indexP.row];
    if (index == 31) {
        //跳转周边
        LxmAroundDetailVC * vc = [[LxmAroundDetailVC alloc] initWithTableViewStyle:UITableViewStylePlain];
        vc.nearId = model.nearId;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        //删除评价
        UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"确定要删除这条评价吗?" preferredStyle:UIAlertControllerStyleAlert];
        [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self deleteWithID:model.evaId];
        }]];
        [self presentViewController:alertView animated:YES completion:nil];
        
    }
}

- (void)deleteWithID:(NSNumber *)evaID{
    if (ISLOGIN) {
        NSDictionary * dic = @{
                               @"token":SESSION_TOKEN,
                               @"evaId":evaID
                               };
        [LxmNetworking networkingPOST:[LxmURLDefine user_deleteMyEva] parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"key"] intValue] == 1) {
                [SVProgressHUD showSuccessWithStatus:@"已删除"];
                self.time = [NSString getCurrentTimeChuo];
                self.page = 1;
                [self loadMyEvaluateList];
            }else{
                [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先登录!"];
    }
}


@end

#import "LxmStarImgView.h"
#import "LxmImgCollectionView.h"
@interface LxmMyPingJiaCell()
/**
 个人信息模块
 */
@property (nonatomic , strong) UIView * publicInfoView;
@property (nonatomic , strong) UIImageView * headerImgView;
@property (nonatomic , strong) UIImageView * sexImgView;
@property (nonatomic , strong) UILabel * nameLab;
@property (nonatomic , strong) LxmStarImgView * startView;
@property (nonatomic , strong) UILabel * timeLab;
/**
 发布内容模块
 */
@property (nonatomic , strong) UILabel * contentLab;

/**
 图片内容模块
 */
@property (nonatomic , strong) LxmMyPingJiaCollectionView * contentImgView;
/**
 抢单信息模块
 */
@property (nonatomic , strong) UIView * stateView;
@property (nonatomic , strong) UIButton * stateBtn;
@property (nonatomic , strong) UIImageView * picImg;
@property (nonatomic , strong) UILabel * titlelab;
@property (nonatomic , strong) UIButton * deleteBtn;

@end

@implementation LxmMyPingJiaCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self addSubview:self.publicInfoView];
        [self.publicInfoView addSubview:self.headerImgView];
        [self.publicInfoView addSubview:self.sexImgView];
        [self.publicInfoView addSubview:self.nameLab];
        [self.publicInfoView addSubview:self.startView];
        [self.publicInfoView addSubview:self.timeLab];
        
        [self addSubview:self.contentLab];
        
        [self addSubview:self.contentImgView];
        
        [self addSubview:self.stateView];
        [self addSubview:self.stateBtn];
        [self.stateBtn addSubview:self.picImg];
        [self.stateBtn addSubview:self.titlelab];
        [self addSubview:self.deleteBtn];
        
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
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.publicInfoView);
        make.trailing.equalTo(self.publicInfoView).offset(-15);
    }];
    
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.publicInfoView.mas_bottom).offset(10);
        make.leading.equalTo(@60);
        make.trailing.equalTo(self).offset(-15);
    }];
    
    [self.contentImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLab.mas_bottom).offset(10);
        make.leading.equalTo(self).offset(60);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@((ScreenW-30-20-45)/3));
    }];
    
    [self.stateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentImgView.mas_bottom);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@100);
    }];
    [self.stateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self.stateView);
        make.trailing.equalTo(self.deleteBtn.mas_leading);
        make.height.equalTo(@100);
    }];
    [self.picImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.leading.equalTo(self.stateView);
        make.width.height.equalTo(@60);
    }];
    [self.titlelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.stateView);
        make.leading.equalTo(self.picImg.mas_trailing).offset(10);
        make.trailing.equalTo(self.deleteBtn.mas_leading);
    }];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.centerY.equalTo(self.stateView);
        make.width.equalTo(@((ScreenW-60)/3));
        make.height.equalTo(@40);
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
    }
    return _startView;
}

- (UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.font = [UIFont systemFontOfSize:14];
        _timeLab.text = @"2018-05-31";
        _timeLab.textColor = CharacterLightGrayColor;
    }
    return _timeLab;
}
- (UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab = [[UILabel alloc] init];
        _contentLab.font = [UIFont systemFontOfSize:15];
        _contentLab.numberOfLines = 0;
        _contentLab.text = @"北门圆通,收件人冯全,送至2-231,中午前送达哦";
    }
    return _contentLab;
}

- (LxmMyPingJiaCollectionView *)contentImgView{
    if (!_contentImgView) {
        _contentImgView = [[LxmMyPingJiaCollectionView alloc] init];
    }
    return _contentImgView;
}
- (UIView *)stateView{
    if (!_stateView) {
        _stateView = [[UIView alloc] init];
    }
    return _stateView;
}

- (UIButton *)stateBtn{
    if (!_stateBtn) {
        _stateBtn = [[UIButton alloc] init];
        _stateBtn.tag = 31;
        [_stateBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _stateBtn;
}

- (UIImageView *)picImg{
    if (!_picImg) {
        _picImg = [[UIImageView alloc] init];
        _picImg.image = [UIImage imageNamed:@"pic_4"];
    }
    return _picImg;
}
- (UILabel *)titlelab{
    if (!_titlelab) {
        _titlelab = [[UILabel alloc] init];
        _titlelab.font = [UIFont systemFontOfSize:18];
        _titlelab.text = @"抖音是怎样捞金的";
        _titlelab.textColor = CharacterDarkColor;
        _titlelab.numberOfLines = 2;
    }
    return _titlelab;
}

- (UIButton *)deleteBtn{
    if (!_deleteBtn) {
        _deleteBtn = [[UIButton alloc] init];
        [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"deletepic"] forState:UIControlStateNormal];
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        _deleteBtn.layer.cornerRadius = 8;
        _deleteBtn.layer.masksToBounds = YES;
        _deleteBtn.tag = 32;
        [_deleteBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

- (void)setModel:(LxmMyEvaluateListModel *)model{
    _model = model;
    self.startView.starNum = model.score.intValue;
    //60
    [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:[LxmURLDefine getPicImgWthPicStr:model.evaUserHead]] placeholderImage:[UIImage imageNamed:@"moren"] options:SDWebImageRetryFailed];
    self.sexImgView.image = [UIImage imageNamed:model.evaUserSex.intValue == 1?@"male":@"female"];
    self.nameLab.text = model.evaUserNickname;
    if (model.createTime.length>9) {
        NSString * str= model.createTime;
        str = [str substringToIndex:model.createTime.length - 9];
        self.timeLab.text = str;
    }
    self.contentLab.text = model.content;
    CGFloat connectHeight = [model.content getSizeWithMaxSize:CGSizeMake(ScreenW-75, 999) withFontSize:15].height;
    
    CGFloat imgViewHeight = 0;
    if (!model.img||[model.img isEqualToString:@""]) {
        [self.contentImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        imgViewHeight = 0;
    }else{
        NSArray * imgs = [model.img componentsSeparatedByString:@","];
        self.contentImgView.titleArr = imgs;
        [self.contentImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(ceil(imgs.count/3.0)*(((ScreenW-30-20-45)/3)+10)-10));
        }];
        imgViewHeight = ceil(imgs.count/3.0)*(((ScreenW-30-20-45)/3)+10)-10;
    }
    [self.picImg sd_setImageWithURL:[NSURL URLWithString:[LxmURLDefine getPicImgWthPicStr:model.nearImg]] placeholderImage:[UIImage imageNamed:@"whequemoren"] options:SDWebImageRetryFailed];
    self.titlelab.text = model.nearTitle;
    model.height = 60+10+connectHeight+10+imgViewHeight+100;
}

- (void)btnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(LxmMyPingJiaCell:btnAtIndex:)]) {
        [self.delegate LxmMyPingJiaCell:self btnAtIndex:btn.tag];
    }
}


@end


@interface LxmMyPingJiaCollectionView()<UICollectionViewDataSource,UICollectionViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic , strong)UICollectionViewFlowLayout * layout;
@property (nonatomic , strong)UICollectionView * collectionView;
@property (nonatomic , strong)NSArray *titleArr1;
@end
@implementation LxmMyPingJiaCollectionView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        self.layout = [[UICollectionViewFlowLayout alloc] init];
        self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.layout.minimumInteritemSpacing = 10;
        self.layout.minimumInteritemSpacing = 10;
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenW-30-45, 0) collectionViewLayout:self.layout];
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.collectionView];
        
        UITapGestureRecognizer * tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCollectionView)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
        [self.collectionView registerClass:[LxmMyPingJiaImgCollectionCell class] forCellWithReuseIdentifier:@"LxmMyPingJiaImgCollectionCell"];
        
    }
    return self;
}
- (void)setTitleArr:(NSArray *)titleArr{
    self.titleArr1 = titleArr;
    self.collectionView.frame = CGRectMake(0, 0, ScreenW-30, ceil(titleArr.count/3.0)*(((ScreenW-30-20-45)/3)+10)-10);
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view == self.collectionView) {
        return YES;
    } else {
        return NO;
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.titleArr1.count;
}
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((ScreenW-30-20-45)/3, (ScreenW-30-20-45)/3);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LxmMyPingJiaImgCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LxmMyPingJiaImgCollectionCell" forIndexPath:indexPath];
    NSString * imgStr = [self.titleArr1 objectAtIndex:indexPath.item];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[LxmURLDefine getPicImgWthPicStr:imgStr]] placeholderImage:[UIImage imageNamed:@"whequemoren"] options:SDWebImageRetryFailed];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectItemBlock) {
        self.selectItemBlock(indexPath.item);
    }
}

- (void)tapCollectionView{
    if ([self.delegate respondsToSelector:@selector(LxmMyPingJiaImgCollectionViewClick)]) {
        [self.delegate LxmMyPingJiaImgCollectionViewClick];
    }
}


@end


@interface LxmMyPingJiaImgCollectionCell()

@end

@implementation LxmMyPingJiaImgCollectionCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imgView];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.bottom.equalTo(self);
        }];
    }
    return self;
}
- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.image = [UIImage imageNamed:@"whequemoren"];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.layer.masksToBounds = YES;
        
    }
    return _imgView;
}


@end



