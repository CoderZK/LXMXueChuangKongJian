//
//  LxmSelectCityVC.m
//  mag
//
//  Created by 李晓满 on 2018/7/3.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmSelectCityVC.h"
#import "LxmTableIndexView.h"
#import "LxmSelectSchoolVC.h"
#import <CoreLocation/CoreLocation.h>

@interface LxmSelectCityVC ()<UITextFieldDelegate, LxmTableIndexViewDelegate,CLLocationManagerDelegate>

@property (nonatomic , strong)UIButton * currentLocationBtn;
@property (nonatomic , strong)UITextField * tf;
@property (nonatomic , strong)UIButton * tfBtn;
@property (nonatomic , strong)NSMutableArray * dataArr1;
@property (nonatomic , strong)NSMutableDictionary * dataDict;
@property (nonatomic , strong)LxmTableIndexView *indexView;
@property (nonatomic , strong)NSArray * keyArr;
@property (nonatomic , strong)UILabel * isNoDataLB;

@property (nonatomic,strong ) CLLocationManager *locationManager;//定位服务
@property (nonatomic,copy)    NSString *currentCity;//城市

@property (nonatomic,strong) UIView * underlineView;

@end

@implementation LxmSelectCityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择城市";
    
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
- (void)locatemap{
    
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager requestWhenInUseAuthorization];
        self.currentCity = [[NSString alloc]init];
        [self.locationManager requestWhenInUseAuthorization];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 10;
        [self.locationManager startUpdatingLocation];
    }
}
#pragma mark - 定位失败
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    self.underlineView.hidden = NO;
    [self.currentLocationBtn setTitle:@"定位失败" forState:UIControlStateNormal];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请在设置中打开定位" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication]openURL:settingURL];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - 定位成功
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    [self.locationManager stopUpdatingLocation];
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    //地理反编码 可以根据坐标(经纬度)确定位置信息(街道 门牌等)
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count >0) {
            CLPlacemark *placeMark = placemarks[0];
            self.currentCity = placeMark.locality;
            if (!self.currentCity) {
                self.underlineView.hidden = NO;
                [SVProgressHUD showErrorWithStatus:@"无法定位当前城市"];
                [self.currentLocationBtn setTitle:@"定位失败" forState:UIControlStateNormal];
            }else{
                self.underlineView.hidden = YES;
                [self.currentLocationBtn setTitle:self.currentCity forState:UIControlStateNormal];
                [self.currentLocationBtn addTarget:self action:@selector(pushWithCityID) forControlEvents:UIControlEventTouchUpInside];
            }
        }else if (error == nil && placemarks.count){
            NSLog(@"NO location and error return");
        }else if (error){
            NSLog(@"loction error:%@",error);
        }
    }];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.dataArr1 = [NSMutableArray array];
    self.dataDict = [NSMutableDictionary dictionary];
    
    self.keyArr = [NSArray array];
    [self loadData];
    
    [self locatemap];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.locationManager stopUpdatingLocation];
}


- (void)loadData{
    NSMutableDictionary * d = [NSMutableDictionary dictionary];
    [d setObject:SESSION_TOKEN forKey:@"token"];
    if (self.tf.text.length>0) {
        [d setObject:self.tf.text forKey:@"cityName"];
    }
    
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:[LxmURLDefine app_findCityList] parameters:d returnClass:[LxmFullInfoRootModel class] success:^(NSURLSessionDataTask *task, LxmFullInfoRootModel* responseObject) {
        
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
                        [arr addObject:m];
                    }
                    NSLog(@"%@",self.dataDict);

                    self.keyArr = [self.dataDict.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                        return [obj1 compare:obj2];
                    }];
                    [SVProgressHUD dismiss];
                    NSLog(@"self.keyArr=%@",self.keyArr);
                }
                [SVProgressHUD dismiss];
            }else {
                [SVProgressHUD dismiss];
            }
        }else{
            [SVProgressHUD dismiss];
            [UIAlertController showAlertWithKey:responseObject.key message:responseObject.message];
        }
        
        [self.indexView reloadData];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.keyArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString * key = [self.keyArr objectAtIndex:section];
    return [[self.dataDict objectForKey:key] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    NSString * key = [self.keyArr objectAtIndex:indexPath.section];
    LxmFullInfoModel * model = [[self.dataDict objectForKey:key] objectAtIndex:indexPath.row];
    cell.textLabel.text = model.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString * key = [self.keyArr objectAtIndex:indexPath.section];
    LxmFullInfoModel * model = [[self.dataDict objectForKey:key] objectAtIndex:indexPath.row];
    LxmSelectSchoolVC * vc = [[LxmSelectSchoolVC alloc] init];
    vc.cityID = model.ID;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)pushWithCityID{
    [LxmNetworking networkingPOST:[LxmURLDefine app_getLocationId] parameters:@{@"cityName":self.currentCity} returnClass:nil success:^(NSURLSessionDataTask *task,id responseObject) {
        if ([[responseObject objectForKey:@"key"] intValue] == 1) {
            LxmSelectSchoolVC * vc = [[LxmSelectSchoolVC alloc] init];
            vc.cityID = responseObject[@"result"][@"cityId"];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [UIAlertController showAlertWithKey:[responseObject objectForKey:@"key"] message:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
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
    NSString * key = [self.keyArr objectAtIndex:section];
    titleLab.text = [NSString stringWithFormat:@"%@",key];
    headerView.contentView.backgroundColor = BGGrayColor;
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
    return 35;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void)btnCLick:(UIButton *)btn{
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.hidden = YES;
    self.tf.hidden = NO;
    [self.tf becomeFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"您还没有输入搜索内容!"];
        return NO;
    }else{
        self.tf.text = textField.text;
        [self.dataArr1 removeAllObjects];
        [self.dataDict removeAllObjects];
        self.keyArr = nil;
        [self.indexView reloadData];
        NSLog(@"点击了搜索");
        self.tfBtn.hidden = YES;
        self.tf.hidden = NO;
        [self.tf resignFirstResponder];
        [self loadData];
        return YES;
    }
}
- (void)initHeaderView{
    UIView * headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50+100)];
    headView.backgroundColor = BGGrayColor;
    self.tableView.tableHeaderView = headView;
    
    UITextField * tf = [[UITextField alloc] initWithFrame:CGRectMake(15, 10, ScreenW-30, 30)];
    self.tf = tf;
    tf.layer.cornerRadius = 5;
    tf.layer.masksToBounds = YES;
    tf.returnKeyType = UIReturnKeySearch;
    tf.delegate = self;
    tf.hidden = YES;
    tf.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    tf.placeholder = @"搜索城市";
    tf.leftViewMode = UITextFieldViewModeAlways;
    tf.backgroundColor = [UIColor whiteColor];
    [headView addSubview:tf];
    
    UIView * lView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    tf.leftView = lView;
    
    UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
    imgView.image = [UIImage imageNamed:@"ico_sousuo"];
    [lView addSubview:imgView];
    
    
    UIButton * tfBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 10, ScreenW-30, 30)];
    self.tfBtn = tfBtn;
    tfBtn.backgroundColor = [UIColor whiteColor];
    tfBtn.layer.cornerRadius = 5;
    tfBtn.layer.masksToBounds = YES;
    [tfBtn setImage:[UIImage imageNamed:@"ico_sousuo"] forState:UIControlStateNormal];
    [tfBtn setTitle:@" 搜索城市" forState:UIControlStateNormal];
    tfBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [tfBtn setTitleColor:CharacterLightGrayColor forState:UIControlStateNormal];
    [tfBtn addTarget:self action:@selector(btnCLick:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:tfBtn];
    
    UIView * locationView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, ScreenW, 100)];
    locationView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:locationView];
    
    UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 200, 20)];
    lab.text = @"定位城市";
    lab.font = [UIFont systemFontOfSize:18];
    lab.textColor = [UIColor colorWithRed:131/255.0 green:185/255.0 blue:240/255.0 alpha:1];
    [locationView addSubview:lab];
    
    self.currentLocationBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 50, 100, 30)];
    self.currentLocationBtn.layer.borderColor = CharacterDarkColor.CGColor;
    self.currentLocationBtn.layer.borderWidth = 0.5;
    self.currentLocationBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.currentLocationBtn setTitle:@"定位中..." forState:UIControlStateNormal];
    [self.currentLocationBtn setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
    [locationView addSubview:self.currentLocationBtn];
    
    self.underlineView = [[UIView alloc] init];
    self.underlineView.backgroundColor = CharacterDarkColor;
    [self.currentLocationBtn addSubview:self.underlineView];
    
    [self.underlineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.currentLocationBtn.titleLabel.mas_bottom);
        make.centerX.equalTo(self.currentLocationBtn.titleLabel);
        make.width.equalTo(@50);
        make.height.equalTo(@0.5);
    }];
    
}

#pragma mark - LxmTableIndexViewDelegate

- (NSArray<NSString *> *)indexTitlesForIndexView:(LxmTableIndexView *)view {
    return self.keyArr;
}
- (void)indexView:(LxmTableIndexView *)view didSelectedAtIndex:(NSInteger)index {
    if (index< [self.tableView numberOfSections]) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}


@end
