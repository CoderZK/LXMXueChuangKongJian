//
//  LxmSelectCityVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/3.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmSelectSchoolVC.h"
#import "LxmTableIndexView.h"
#import "LxmFullInfoVC.h"
#import "LxmModifyUserInfoVC.h"

@interface LxmSelectSchoolVC ()<UITextFieldDelegate, LxmTableIndexViewDelegate>
@property (nonatomic , strong)UIButton * currentLocationBtn;
@property (nonatomic , strong)UITextField * tf;
@property (nonatomic , strong)UIButton * tfBtn;
@property (nonatomic , strong)NSMutableArray * dataArr1;
@property (nonatomic , strong)NSMutableDictionary * dataDict;
@property (nonatomic , strong)LxmTableIndexView *indexView;
@property (nonatomic , strong)NSArray * keyArr;
@property (nonatomic , strong)UILabel * isNoDataLB;
@end

@implementation LxmSelectSchoolVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"学校";
    self.tableView.sectionIndexColor = CharacterDarkColor;//修改右边索引字体的颜色
    [self initHeaderView];
    self.indexView = [[LxmTableIndexView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 20, 0, 20, self.view.bounds.size.height)];
    self.indexView.delegate = self;
    [self.view addSubview:self.indexView];
    
    self.isNoDataLB =[[UILabel alloc] initWithFrame:CGRectMake(0, ScreenH / 2.0-(StateBarH+44) , ScreenW, 20)];
    self.isNoDataLB.text = @"没有数据!";
    self.isNoDataLB.font = [UIFont systemFontOfSize:16];
    self.isNoDataLB.textAlignment = NSTextAlignmentCenter;
    self.isNoDataLB.textColor = [UIColor blackColor];
    self.isNoDataLB.hidden = YES;
    [self.tableView addSubview:self.isNoDataLB];
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.dataArr1 = [NSMutableArray array];
    self.dataDict = [NSMutableDictionary dictionary];
    
    self.keyArr = [NSArray array];
    [self loadData];
}

- (void)loadData{
    NSMutableDictionary * d = [NSMutableDictionary dictionary];
    [d setObject:SESSION_TOKEN forKey:@"token"];
    if (self.tf.text.length>0) {
        [d setObject:self.tf.text forKey:@"schoolName"];
    }
    [d setObject:self.cityID forKey:@"cityId"];
    if (self.dataArr1.count==0) {
        [SVProgressHUD show];
    }
    [LxmNetworking networkingPOST:[LxmURLDefine app_findSchoolList] parameters:d returnClass:[LxmFullInfoRootModel class] success:^(NSURLSessionDataTask *task, LxmFullInfoRootModel* responseObject) {
        [SVProgressHUD dismiss];
        if (responseObject.key.intValue == 1) {
            NSArray * arr = responseObject.result;
            if ([arr isKindOfClass:[NSArray class]]) {
                self.dataArr1 = [NSMutableArray arrayWithArray:arr];
            }
            if (self.dataArr1.count>0) {
                for (LxmFullInfoModel * m in self.dataArr1) {
                    if (m.name)
                    {
                        //将取出的名字转换成字母
                        NSMutableString *pinyin = [m.name mutableCopy];
                        CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
                        CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
                        //将拼音转换成大写拼音
                        NSString * upPinyin = [pinyin uppercaseString];
                        //取出第一个首字母当做字典的key
                        NSString * firstStr = [upPinyin substringToIndex:1];
                        
                        NSMutableArray * arr = [self.dataDict objectForKey:firstStr];
                        if (!arr)
                        {
                            arr = [NSMutableArray array];
                            [self.dataDict setObject:arr forKey:firstStr];
                        }
                        [arr lxm_add1Object:m];
                    }
                    NSLog(@"%@",self.dataDict);
                    
                    self.keyArr = [self.dataDict.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                        return [obj1 compare:obj2];
                    }];
                    NSLog(@"self.keyArr=%@",self.keyArr);
                }
                
                
            }
        }else{
            [UIAlertController showAlertWithKey:responseObject.key message:responseObject.message];
        }
        [self.indexView reloadData];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _keyArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString * key = [_keyArr lxm_object1AtIndex:section];
    return [[_dataDict objectForKey:key] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    NSString * key = [self.keyArr lxm_object1AtIndex:indexPath.section];
    LxmFullInfoModel * model = [[self.dataDict objectForKey:key] lxm_object1AtIndex:indexPath.row];
    cell.textLabel.text = model.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString * key = [_keyArr lxm_object1AtIndex:indexPath.section];
    LxmFullInfoModel * model = [[self.dataDict objectForKey:key] lxm_object1AtIndex:indexPath.row];
    NSArray * arr = self.navigationController.viewControllers;
    for (BaseViewController * vc in arr) {
        if ([vc isKindOfClass:[LxmFullInfoVC class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"LxmFullInfoModel" object:@{@"selectModel":model}];
        }
        if ([vc isKindOfClass:[LxmModifyUserInfoVC class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"LxmFullInfoModel" object:@{@"selectModel":model}];
        }
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView * headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
    if (!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"headerView"];
        UILabel * lab = [[UILabel alloc] init];
        lab.textColor = CharacterGrayColor;
        lab.tag = 403;
        lab.font = [UIFont systemFontOfSize:15];
        [headerView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(headerView).offset(15);
            make.centerY.equalTo(headerView);
            make.height.equalTo(@15);
        }];
    }
    UILabel * titleLab = (UILabel *)[headerView viewWithTag:403];
    NSString * key = [_keyArr lxm_object1AtIndex:section];
    titleLab.text = [NSString stringWithFormat:@"%@",key];
    
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UITableViewHeaderFooterView * footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footerView"];
    if (!footerView) {
        footerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"footerView"];
    }
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void)btnCLick:(UIButton *)btn{
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.hidden = YES;
    _tf.hidden = NO;
    [_tf becomeFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"您还没有输入搜索内容!"];
        return NO;
    }else{
        _tf.text = textField.text;
        [_dataArr1 removeAllObjects];
        [_dataDict removeAllObjects];
        _keyArr = nil;
        [_indexView reloadData];
        NSLog(@"点击了搜索");
        _tfBtn.hidden = YES;
        _tf.hidden = NO;
        [_tf resignFirstResponder];
        [self loadData];
        return YES;
    }
}
- (void)initHeaderView{
    UIView * headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    headView.backgroundColor = BGGrayColor;
    self.tableView.tableHeaderView = headView;
    
    UITextField * tf = [[UITextField alloc] initWithFrame:CGRectMake(15, 10, ScreenW-30, 30)];
    _tf = tf;
    tf.layer.cornerRadius = 5;
    tf.layer.masksToBounds = YES;
    tf.returnKeyType = UIReturnKeySearch;
    tf.delegate = self;
    tf.hidden = YES;
    tf.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    tf.placeholder = @"搜索";
    tf.leftViewMode = UITextFieldViewModeAlways;
    tf.backgroundColor = [UIColor whiteColor];
    [headView addSubview:tf];
    
    UIView * lView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    tf.leftView = lView;
    
    UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
    imgView.image = [UIImage imageNamed:@"ico_sousuo"];
    [lView addSubview:imgView];
    
    
    UIButton * tfBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 10, ScreenW-30, 30)];
    _tfBtn = tfBtn;
    tfBtn.backgroundColor = [UIColor whiteColor];
    tfBtn.layer.cornerRadius = 5;
    tfBtn.layer.masksToBounds = YES;
    [tfBtn setImage:[UIImage imageNamed:@"ico_sousuo"] forState:UIControlStateNormal];
    [tfBtn setTitle:@" 搜索" forState:UIControlStateNormal];
    tfBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [tfBtn setTitleColor:CharacterLightGrayColor forState:UIControlStateNormal];
    [tfBtn addTarget:self action:@selector(btnCLick:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:tfBtn];
}

#pragma mark - LxmTableIndexViewDelegate

- (NSArray<NSString *> *)indexTitlesForIndexView:(LxmTableIndexView *)view {
    return _keyArr;
}
- (void)indexView:(LxmTableIndexView *)view didSelectedAtIndex:(NSInteger)index {
    if (index< [self.tableView numberOfSections]) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

@end
