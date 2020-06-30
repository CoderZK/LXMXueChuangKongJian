//
//  AroundDetailVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/12.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "AroundDetailVC.h"
#import "PopListView.h"
#import "SNY_AdScrollView.h"
#import <WebKit/WebKit.h>
#import "LxmPingJiaCell.h"
#import "LxmLiuYanView.h"
#import "PingJiaVC.h"
#import "LxmStarImgView.h"
#import <UShareUI/UShareUI.h>

@interface AroundDetailVC ()<PopListViewDelegate,UIScrollViewDelegate,LxmAroundDetailTopItemViewDelegate,UMSocialShareMenuViewDelegate>
@property (nonatomic , strong) PopListView * popListView;
@property (nonatomic , strong) UIView * headerView;
@property (nonatomic , strong) SNY_AdScrollView * bannerView;
@property (nonatomic , strong) LxmAroundDetailTopItemView * infoItem;
@property (nonatomic , strong)WKWebView * webView;
@property (nonatomic , strong) UIButton * bottomBtn;
@property (nonatomic , strong)LxmLiuYanView * liuYanView;

@property (nonatomic , strong) LxmAroundModel * detailModel;

//评价列表
@property (nonatomic , strong) UILabel * noneDataView;
@property (nonatomic , assign) NSInteger page;
@property (nonatomic , strong) NSMutableArray * dataArr;
@property (nonatomic , strong) NSString * time;

@end

@implementation AroundDetailVC


- (UILabel *)noneDataView{
    if (!_noneDataView) {
        _noneDataView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 200)];
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
    self.navigationItem.title = @"内容详情";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = self.noneDataView;
    [self initTableHeader];
    UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [rightBtn setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    self.popListView = [[PopListView alloc] initWithTitleArr:@[@"分享"] currectIndex:0 isAccShow:NO];
    self.popListView.delegate = self;
    [self initBottomView];
    
    [self loadDetailData];
    
    self.dataArr = [NSMutableArray array];
    self.time = [NSString getCurrentTimeChuo];
    self.page = 1;
    [self loadCommentList];
    __weak typeof(self) safe_self = self;
    NSInteger * safe_page = &_page;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.time = [NSString getCurrentTimeChuo];
        * safe_page = 1;
        [safe_self loadCommentList];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [safe_self loadCommentList];
    }];
}


- (void)loadDetailData{
    if (ISLOGIN) {
        NSDictionary * dic = @{
                               @"token":SESSION_TOKEN,
                               @"nearId":self.nearId
                               };
        [LxmNetworking networkingPOST:[LxmURLDefine user_getNearInfo] parameters:dic returnClass:[LxmAroundDetailRootModel class] success:^(NSURLSessionDataTask *task, LxmAroundDetailRootModel * responseObject) {
            if (responseObject.key.intValue == 1) {
                self.detailModel = responseObject.result;
                
                if (self.detailModel.pic&&![self.detailModel.pic isEqualToString:@""]) {
                    NSMutableArray *arr1 = [NSMutableArray array];
                    NSArray * arr = [self.detailModel.pic componentsSeparatedByString:@","];
                    if (arr.count>0) {
                        for (NSString * str in arr) {
                            LxmHomeBannerModel * model = [[LxmHomeBannerModel alloc] init];
                            model.pic = str;
                            [arr1 lxm_add1Object:model];
                        }
                        self.bannerView.dataArr = arr1;
                    }
                }
                self.infoItem.model = self.detailModel;
                CGFloat h = [self.detailModel.address getSizeWithMaxSize:CGSizeMake(ScreenW-30, 999) withFontSize:15].height;
                self.infoItem.frame = CGRectMake(0, 150, ScreenW, 100+15+h+5+20+15);
                 NSString * ss = @"<div style=\"font-size: 40px;overflow: hidden;width: 100%\"><style>img{max-width:100%;display:block;margin:0 auto;width: 100%}</style>";
                NSString * conent = [NSString stringWithFormat:@"%@%@</div>",ss,self.detailModel.content];
                [self.webView loadHTMLString:conent?conent:@"" baseURL:nil];
                self.webView.frame = CGRectMake(15, 150+self.infoItem.height, ScreenW - 30, self.webView.height);
                self.liuYanView.frame  = CGRectMake(0, 150+self.infoItem.height+self.webView.height, ScreenW, 50);
                self.liuYanView.liuYanLab.text = [NSString stringWithFormat:@"评价(%d)",self.detailModel.evaluateNum.intValue];
                
                self.headerView.frame = CGRectMake(0, 0, ScreenW, 150+self.infoItem.height+self.webView.height+50);
            }else{
                [UIAlertController showAlertWithKey:responseObject.key message:responseObject.message];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先登录"];
    }
}

- (void)loadCommentList{
    [SVProgressHUD show];
    if (ISLOGIN) {
        NSDictionary * dict = @{
                                @"token":SESSION_TOKEN,
                                @"nearId":self.nearId,
                                @"pageNum":@(self.page),
                                @"time":self.time
                                };
        NSString * str = [LxmURLDefine user_findNearEvaList];
        [LxmNetworking networkingPOST:str parameters:dict returnClass:[LxmAroundCommentRootModel class] success:^(NSURLSessionDataTask *task, LxmAroundCommentRootModel * responseObject) {
            [SVProgressHUD dismiss];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            if (responseObject.key.intValue == 1) {
                if (self.page == 1) {
                    [self.dataArr removeAllObjects];
                }
                LxmAroundCommentModel1 * model = responseObject.result;
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
    LxmPingJiaCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmPingJiaCell"];
    if (!cell)
    {
        cell = [[LxmPingJiaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmPingJiaCell"];
    }
    LxmAroundCommentModel * model = [self.dataArr lxm_object1AtIndex:indexPath.row];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    LxmAroundCommentModel * model = [self.dataArr lxm_object1AtIndex:indexPath.row];
    return model.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void)initBottomView{
    UIView * bottomView = nil;
    if (kDevice_Is_iPhoneX) {
        self.tableView.frame = CGRectMake(0, 0, ScreenW, ScreenH-34-50);
        bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - 44-StateBarH - 50-34 , ScreenW, 50+34)];
    }else{
        self.tableView.frame = CGRectMake(0, 0, ScreenW, ScreenH);
        bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH - 44-StateBarH - 50 , ScreenW, 50)];
    }
    bottomView.backgroundColor = [UIColor whiteColor];
    self.bottomBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    [self.bottomBtn setBackgroundImage:[UIImage imageNamed:@"blue"] forState:UIControlStateNormal];
    [self.bottomBtn setTitle:@"评价" forState:UIControlStateNormal];
    [self.bottomBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.bottomBtn addTarget:self action:@selector(bottomBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:self.bottomBtn];
    [self.view addSubview:bottomView];
}
//去支付
- (void)bottomBtnClick{
    if (ISLOGIN) {
        self.detailModel.nearId = self.nearId;
        PingJiaVC * vc = [[PingJiaVC alloc] initWithTableViewStyle:UITableViewStylePlain model:self.detailModel];
        WeakObj(self);
        vc.refreshPreVC = ^{
            selfWeak.time = [NSString getCurrentTimeChuo];
            selfWeak.page = 1;
            [selfWeak loadCommentList];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先登录!"];
    }
   
}


- (void)initTableHeader{
    
    
    self.headerView = [[UIView alloc] init];
    self.headerView.backgroundColor = UIColor.whiteColor;
    
    self.bannerView = [[SNY_AdScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 150)];
    [self.headerView addSubview:self.bannerView];
    
   
    self.infoItem = [[LxmAroundDetailTopItemView alloc] initWithFrame:CGRectMake(0, 150, ScreenW, 100+15+5+20+15)];
    self.infoItem.delegate = self;
    [self.headerView addSubview:self.infoItem];
  
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 150+self.infoItem.height, ScreenW, 0)];
    [self.webView sizeToFit];
    [self.headerView addSubview:self.webView];
    
    self.liuYanView  = [[LxmLiuYanView alloc] initWithFrame:CGRectMake(0, 150+self.infoItem.height+5, ScreenW, 50)];
    self.liuYanView.liuYanLab.text = @"评价(5)";
    self.liuYanView.backgroundColor = UIColor.whiteColor;
    [self.headerView addSubview:self.liuYanView];
   
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = LineColor;
    [self.headerView addSubview:line];

    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.headerView).offset(15);
        make.trailing.equalTo(self.headerView).offset(-15);
        make.bottom.equalTo(self.headerView);
        make.height.equalTo(@0.5);
    }];
    self.headerView.frame = CGRectMake(0, 0, ScreenW, 150+self.infoItem.height+5);
    self.tableView.tableHeaderView = self.headerView;
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    self.webView.scrollView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"contentSize"])
    {
        self.webView.height = self.webView.scrollView.contentSize.height;
        self.webView.frame =  CGRectMake(15, 150+self.infoItem.height, ScreenW -30, self.webView.height);
        [self.webView sizeToFit];
        self.liuYanView.frame = CGRectMake(0, 150+self.infoItem.height+self.webView.height, ScreenW, 50);
        self.headerView.frame = CGRectMake(0, 0, ScreenW, 150+self.infoItem.height+self.webView.height+50);
        [self.headerView layoutIfNeeded];
        [self.tableView reloadData];
    }
}


- (void)rightBtnClick{
    
    CGPoint point = [self.view convertPoint:CGPointMake(ScreenW - 110, StateBarH+44) fromView:self.navigationController.navigationBar];
    if (self.popListView.isShow){
        [self.popListView disMissAnimation:NO];
    }else{
        [self.popListView showAtPoint:point animation:YES isShow:YES];
    }
}
-(void)PopListView:(PopListView *)view  didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //分享
    [self loadShareData];
}
//获取分享信息
- (void)loadShareData{
    
    [LxmNetworking networkingPOST:[LxmURLDefine app_shareInfo] parameters:@{@"type":@4,@"id":self.nearId,@"deviceType":@"2"} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"key"] intValue] == 1) {
            //分享
            LxmShareInfoModel * shareModel = [LxmShareInfoModel mj_objectWithKeyValues:responseObject[@"result"]];
            // self继承自UIViewController
            [UMSocialUIManager setShareMenuViewDelegate:self];
            [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_AlipaySession)]];
            [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
                [self shareWithtype:platformType withModel:shareModel];
            }];
        }else{
            [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)shareWithtype:(UMSocialPlatformType)platformType withModel:(LxmShareInfoModel *)model {
    // 根据获取的platformType确定所选平台进行下一步操作
    if (platformType == UMSocialPlatformType_WechatSession) {
        [self shareWeChatTitle:model.title content:model.content pic:model.pic url:model.url ok:^{
            
        } error:^{
            
        }];
    }else if (platformType == UMSocialPlatformType_WechatTimeLine){
        [self shareWXPYQTitle:model.title content:model.content pic:model.pic url:model.url ok:^{
            
        } error:^{
            
        }];
    }else if (platformType == UMSocialPlatformType_QQ){
        [self shareQQTitle:model.title content:model.content pic:model.pic url:model.url ok:^{
            
        } error:^{
            
        }];
    }else{
        //支付宝
        [self shareZFBTitle:model.title content:model.content pic:model.pic url:model.url  ok:^{
            
        } error:^{
            
        }];
    }
}
- (void)LxmAroundDetailTopItemViewCollectionClick{
    if (ISLOGIN) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        dic[@"articleId"] = self.nearId;
        dic[@"token"] = SESSION_TOKEN;
        dic[@"typeId"] = @9;
        [LxmNetworking networkingPOST:[LxmURLDefine user_collectArticle] parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"key"] intValue] == 30001) {
                [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
                self.detailModel.collectStatus = @1;
                self.infoItem.model = self.detailModel;
                if (self.refreshMyCollection) {
                    self.refreshMyCollection();
                }
            }else if ([responseObject[@"key"] intValue] == 30002) {
                [SVProgressHUD showSuccessWithStatus:@"已取消收藏"];
                self.detailModel.collectStatus = @2;
                self.infoItem.model = self.detailModel;
                if (self.refreshMyCollection) {
                    self.refreshMyCollection();
                }
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

@interface LxmAroundDetailTopItemView()
@property (nonatomic , strong)UILabel *titleLab;
@property (nonatomic , strong)UIButton *collectionBtn;

@property (nonatomic , strong) LxmStarImgView * startView;
@property (nonatomic , strong) UILabel * numLab;

@property (nonatomic , strong) UIView * line1;

@property (nonatomic , strong) UILabel * detailLab;
@property (nonatomic , strong) UILabel * timeLab;

@property (nonatomic , strong) UIView * line2;

@end

@implementation LxmAroundDetailTopItemView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLab];
        [self addSubview:self.startView];
        [self addSubview:self.numLab];
        [self addSubview:self.collectionBtn];
        [self addSubview:self.line1];
        
        [self addSubview:self.detailLab];
        [self addSubview:self.timeLab];
        [self addSubview:self.line2];
        
        
        [self setConstrains];
    }
    return self;
}
- (void)setConstrains{
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self.collectionBtn.mas_leading);
        make.height.equalTo(@50);
    }];
    [self.startView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab.mas_bottom);
        make.leading.equalTo(self).offset(15);
        make.width.equalTo(@83);
        make.height.equalTo(@15);
    }];
    [self.numLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.startView);
        make.leading.equalTo(self.startView.mas_trailing).offset(5);
        make.height.equalTo(@15);
        make.trailing.equalTo(self.collectionBtn.mas_leading);
    }];
    [self.collectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(27.5);
        make.trailing.equalTo(self).offset(-15);
        make.width.equalTo(@60);
        make.height.equalTo(@30);
    }];
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(100);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@0.5);
    }];
    [self.detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line1.mas_bottom).offset(15);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
    }];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailLab.mas_bottom).offset(5);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
    }];
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.equalTo(self);
        make.height.equalTo(@0.5);
    }];
    
}
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont boldSystemFontOfSize:18];
        _titleLab.textColor = CharacterDarkColor;
        _titleLab.numberOfLines = 0;
        _titleLab.text = @"一点点";
    }
    return _titleLab;
}

- (LxmStarImgView *)startView{
    if (!_startView) {
        _startView = [[LxmStarImgView alloc] init];
        _startView.starNum = 4;
    }
    return _startView;
}
- (UILabel *)detailLab{
    if (!_detailLab) {
        _detailLab = [[UILabel alloc] init];
        _detailLab.font = [UIFont systemFontOfSize:15];
        _detailLab.textColor = CharacterGrayColor;
        _detailLab.numberOfLines = 0;
        _detailLab.text = @"新北万达广场C-20,新北万达广场C-20,新北万达广场C-20,新北万达广场C-20,新北万达广场C-20,新北万达广场C-20,新北万达广场C-20,";
    }
    return _detailLab;
}
- (UILabel *)numLab{
    if (!_numLab) {
        _numLab = [[UILabel alloc] init];
        _numLab.font = [UIFont boldSystemFontOfSize:15];
        _numLab.textColor = CharacterDarkColor;
        _numLab.text = @"￥50/人";
    }
    return _numLab;
}
- (UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.font = [UIFont systemFontOfSize:15];
        _timeLab.textColor = CharacterLightGrayColor;
        _timeLab.text = @"9:00-15:00";
    }
    return _timeLab;
}
- (UIButton *)collectionBtn{
    if (!_collectionBtn) {
        _collectionBtn = [[UIButton alloc] init];
        [_collectionBtn setBackgroundImage:[UIImage imageNamed:@"blue"] forState:UIControlStateNormal];
        [_collectionBtn setTitle:@"收藏" forState:UIControlStateNormal];
        [_collectionBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _collectionBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _collectionBtn.layer.cornerRadius = 5;
        _collectionBtn.layer.masksToBounds = YES;
        [_collectionBtn addTarget:self action:@selector(collectionClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectionBtn;
}
- (UIView *)line1{
    if (!_line1) {
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = BGGrayColor;
    }
    return _line1;
}
- (UIView *)line2{
    if (!_line2) {
        _line2 = [[UIView alloc] init];
        _line2.backgroundColor = BGGrayColor;
    }
    return _line2;
}
- (void)setModel:(LxmAroundModel *)model{
    _model = model;
    self.titleLab.text = model.title;
    self.startView.starNum = model.rate.intValue;
    self.numLab.text = [NSString stringWithFormat:@"￥%0.2f/人",model.money.floatValue];
    [self.collectionBtn setTitle:model.collectStatus.intValue == 1?@"已收藏":@"收藏" forState:UIControlStateNormal];
    self.detailLab.text = model.address;
    self.timeLab.text = model.openTime;
}
- (void)collectionClick{
    if ([self.delegate respondsToSelector:@selector(LxmAroundDetailTopItemViewCollectionClick)]) {
        [self.delegate LxmAroundDetailTopItemViewCollectionClick];
    }
}

@end

