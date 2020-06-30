//
//  AroundVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/12.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "AroundVC.h"
#import "AroundDetailVC.h"

@interface AroundVC ()<LxmAroundBottomViewDelegate>
@property (nonatomic , assign)AroundVC_type type;
@property (nonatomic , strong) UILabel * noneDataView;
@property (nonatomic , assign) NSInteger page;
@property (nonatomic , strong) NSMutableArray * dataArr;
@property (nonatomic , strong) NSString * time;
@property (nonatomic , assign) NSInteger currentSelect;
@end

@implementation AroundVC
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
- (instancetype)initWithTableViewStyle:(UITableViewStyle)style type:(AroundVC_type)type{
    self = [super initWithTableViewStyle:style];
    if (self) {
        self.type = type;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"周边推荐";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 0.5)];
    line.backgroundColor = LineColor;
    self.tableView.tableHeaderView = line;
    [self.tableView addSubview:self.noneDataView];
    [self.noneDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.tableView);
    }];

    if (self.type != AroundVC_type_mine) {
        [self initBottomView];
    }
    
    self.dataArr = [NSMutableArray array];
    self.time = [NSString getCurrentTimeChuo];
    self.page = 1;
    [self loadAroundList];
    __weak typeof(self) safe_self = self;
    NSInteger * safe_page = &_page;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.time = [NSString getCurrentTimeChuo];
        * safe_page = 1;
        [safe_self loadAroundList];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [safe_self loadAroundList];
    }];
    
}
- (void)loadAroundList{
    if (ISLOGIN) {
        NSDictionary *dict = [NSDictionary dictionary];
        NSString * str = @"";
        if (self.type == AroundVC_type_mine) {
            str = [LxmURLDefine user_findMyCollectList];
            dict = @{
                     @"token":SESSION_TOKEN,
                     @"typeId":@9,
                     @"pageNum":@(self.page),
                     @"time":self.time
                     };
        }else{
            str = [LxmURLDefine user_findNearList];
            dict = @{
                     @"token":SESSION_TOKEN,
                     @"schoolId":@([LxmTool ShareTool].userModel.schoolId),
                     @"zbType":@(self.currentSelect+1),
                     @"pageNum":@(self.page),
                     @"time":self.time
                     };
        }
        
        
        [LxmNetworking networkingPOST:str parameters:dict returnClass:[LxmAroundRootModel class] success:^(NSURLSessionDataTask *task, LxmAroundRootModel * responseObject) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            if (responseObject.key.intValue == 1) {
                if (self.page == 1) {
                    [self.dataArr removeAllObjects];
                }
                LxmAroundModel1 * model = responseObject.result;
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
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先登录"];
    }
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
    LxmAroundBottomView * bottomContentView = [[LxmAroundBottomView alloc] initWithFrame:CGRectMake(30, 0, ScreenW - 60, 50)];
    bottomContentView.delegate = self;
    [bottomView addSubview:bottomContentView];
    
    [self.view addSubview:bottomView];
}
- (void)LxmAroundBottomView:(LxmAroundBottomView *)view btnAtIndex:(NSInteger)index{
    self.currentSelect = index;
    self.time = [NSString getCurrentTimeChuo];
    self.page = 1;
    [self loadAroundList];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LxmAroundCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmAroundCell"];
    if (!cell)
    {
        cell = [[LxmAroundCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmAroundCell"];
    }
    LxmAroundModel * model = [self.dataArr lxm_object1AtIndex:indexPath.row];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LxmAroundModel * model = [self.dataArr lxm_object1AtIndex:indexPath.row];
    AroundDetailVC * vc = [[AroundDetailVC alloc] initWithTableViewStyle:UITableViewStylePlain];
    if (self.type == AroundVC_type_mine) {
        vc.nearId = model.articleId;
        __weak typeof(self)safe_self = self;
        vc.refreshMyCollection = ^{
            safe_self.time = [NSString getCurrentTimeChuo];
            safe_self.page = 1;
            [safe_self loadAroundList];
        };
    }else{
        vc.nearId = model.nearId;
    }
    [self.navigationController pushViewController:vc animated:YES];
}



@end

@interface LxmAroundCell()
@property (nonatomic , strong) UIImageView * picImgView;
@property (nonatomic , strong) UILabel * titleLab;
@property (nonatomic , strong) UILabel * detailLab;
@property (nonatomic , strong) UILabel * timeLab;

@property (nonatomic , strong) LxmStarImgView * startView;
@property (nonatomic , strong) UILabel * numLab;


@end
@implementation LxmAroundCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.picImgView];
        [self addSubview:self.titleLab];
        [self addSubview:self.detailLab];
        [self addSubview:self.timeLab];
        [self addSubview:self.startView];
        [self addSubview:self.numLab];
        [self setConstrains];
        
        UIView * line = [[UIView alloc] init];
        line.backgroundColor = LineColor;
        [self addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.bottom.trailing.equalTo(self);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}

- (void)setConstrains{
    [self.picImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self).offset(15);
        make.width.height.equalTo(@100);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.picImgView);
        make.leading.equalTo(self.picImgView.mas_trailing).offset(10);
        make.trailing.equalTo(self.startView.mas_leading);
        make.height.equalTo(@45);
    }];
    
    [self.startView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLab);
        make.trailing.equalTo(self).offset(-15);
        make.width.equalTo(@83);
        make.height.equalTo(@15);
    }];
    
    [self.numLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.detailLab);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@20);
    }];
    
    [self.detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab.mas_bottom);
        make.leading.equalTo(self.titleLab);
        make.right.equalTo(self.numLab.mas_left).offset(-4);
    }];
    
    [self.numLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.detailLab);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@20);
        make.width.mas_equalTo(60);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailLab.mas_bottom).offset(5);
        make.leading.equalTo(self.titleLab);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@15);
    }];
    
}
- (UIImageView *)picImgView{
    if (!_picImgView) {
        _picImgView = [[UIImageView alloc] init];
        _picImgView.image = [UIImage imageNamed:@"whequemoren"];
        _picImgView.contentMode = UIViewContentModeScaleAspectFill;
        _picImgView.layer.masksToBounds = YES;
    }
    return _picImgView;
}
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont boldSystemFontOfSize:18];
        _titleLab.textColor = CharacterDarkColor;
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
        _detailLab.numberOfLines = 2;
        _detailLab.textColor = CharacterGrayColor;
        _detailLab.text = @"新北万达广场C-20";
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

- (void)setModel:(LxmAroundModel *)model{
    _model = model;
    [self.picImgView sd_setImageWithURL:[NSURL URLWithString:[LxmURLDefine getPicImgWthPicStr:model.pic]] placeholderImage:[UIImage imageNamed:@"whequemoren"] options:SDWebImageRetryFailed];
    self.titleLab.text = model.title;
    self.startView.starNum = model.rate.intValue;
    self.detailLab.text = model.address;
    self.timeLab.text = model.openTime;
    self.numLab.text = [NSString stringWithFormat:@"￥%0.2f/人",model.money.floatValue];
}



@end


@interface LxmAroundBottomView()
@property (nonatomic , strong) NSMutableArray * btnArr;

@end

@implementation LxmAroundBottomView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.btnArr = [NSMutableArray array];
        CGFloat space = (ScreenW - 50*4 -60)/3;
        for (int i= 0; i<4; i++) {
            LxmAroundBtn * btn = [[LxmAroundBtn alloc] initWithFrame:CGRectMake((50+space)*i, 0, 50, 50)];
            btn.tag = i;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0) {
                btn.iconImgView.image = [UIImage imageNamed:@"chi1"];
                btn.titleLab.text = @"美食";
            }else if (i == 1){
                btn.iconImgView.image = [UIImage imageNamed:@"he"];
                btn.titleLab.text = @"饮品";
            }else if (i == 2){
                btn.iconImgView.image = [UIImage imageNamed:@"wan"];
                btn.titleLab.text = @"娱乐";
            }else if (i == 3){
                btn.iconImgView.image = [UIImage imageNamed:@"le"];
                btn.titleLab.text = @"潮服";
            }
            [self addSubview:btn];
            [self.btnArr lxm_add1Object:btn];
        }
    }
    return self;
}
- (void)btnClick:(LxmAroundBtn *)btn{
    for (LxmAroundBtn * btnn in self.btnArr) {
         btnn.selected = btnn == btn?YES:NO;
        if (btnn.selected) {
            if (btnn.tag == 0) {
                btnn.iconImgView.image = [UIImage imageNamed:@"chi1"];
            }else if (btnn.tag == 1){
                btnn.iconImgView.image = [UIImage imageNamed:@"he1"];
            }else if (btnn.tag == 2){
                btnn.iconImgView.image = [UIImage imageNamed:@"wan1"];
            }else if (btnn.tag == 3){
                btnn.iconImgView.image = [UIImage imageNamed:@"le1"];
            }
        }else{
            if (btnn.tag == 0) {
                btnn.iconImgView.image = [UIImage imageNamed:@"chi"];
            }else if (btnn.tag == 1){
                btnn.iconImgView.image = [UIImage imageNamed:@"he"];
            }else if (btnn.tag == 2){
                btnn.iconImgView.image = [UIImage imageNamed:@"wan"];
            }else if (btnn.tag == 3){
                btnn.iconImgView.image = [UIImage imageNamed:@"le"];
            }
        }
    }
    if ([self.delegate respondsToSelector:@selector(LxmAroundBottomView:btnAtIndex:)]) {
        [self.delegate LxmAroundBottomView:self btnAtIndex:btn.tag];
    }
}

@end


@implementation LxmAroundBtn
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.iconImgView];
        [self addSubview:self.titleLab];
        [self setConstrains];
    }
    return self;
}
- (void)setConstrains{
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5);
        make.centerX.equalTo(self);
        make.width.height.equalTo(@28);
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImgView.mas_bottom);
        make.centerX.equalTo(self);
        make.height.equalTo(@12);
    }];
   
}
- (UIImageView *)iconImgView{
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
    }
    return _iconImgView;
}
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont systemFontOfSize:12];
        _titleLab.textColor = CharacterDarkColor;
    }
    return _titleLab;
}
@end
