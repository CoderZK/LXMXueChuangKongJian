//
//  PopListView.m
//  带箭头的view
//
//  Created by lxm on 15/11/24.
//  Copyright © 2015年 lxm. All rights reserved.
//

#import "PopListView.h"

@interface PopListView ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic , strong) UITableView * tableView;
@property(nonatomic , strong) NSArray * titleArr;
@property(nonatomic , strong) UIButton * bgView;
@property(nonatomic , assign) BOOL isAccShow;
@end

@implementation PopListView

-(void)showAtPoint:(CGPoint)point animation:(BOOL)animation isShow:(BOOL)isShow
{
    self.isShow = isShow;
    if (animation)
    {
        CGRect rect = self.frame;
        rect.origin = CGPointMake(ScreenW - 160, 0);
        rect.size.height=0;
        self.frame = rect;
        UIWindow * window = [UIApplication sharedApplication].delegate.window;
        [window addSubview:self.bgView];
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect rect = self.frame;
            rect.size.height=self.titleArr.count*50;
            self.frame = rect;
        }];
    }
    else
    {
        CGRect rect = self.frame;
        rect.origin = CGPointMake(ScreenW - 160,0);
        rect.size.height=0;
        self.frame = rect;
        UIWindow * window = [UIApplication sharedApplication].delegate.window;
        [window addSubview:_bgView];
    }
}
- (void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    [_tableView reloadData];
}


-(void)disMissAnimation:(BOOL)animation;
{
    if (animation)
    {
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect rect = self.frame;
            rect.size.height=10;
            self.frame = rect;
            
        } completion:^(BOOL finished) {
            [self.bgView removeFromSuperview];
            self.isShow = NO;
        }];
    }
    else
    {
        [_bgView removeFromSuperview];
        self.isShow = NO;
    }
    
    
}
-(void)bgBtnClick
{
    [self disMissAnimation:YES];
}
-(instancetype)initWithTitleArr:(NSArray *)titleArr currectIndex:(NSInteger)index isAccShow:(BOOL)isAccShow
{
    CGRect frame = CGRectMake(0, 0, 140, titleArr.count*50+10);
    if (self=[super initWithFrame:frame])
    {
        _isAccShow = isAccShow;
        _currentIndex = index;
        _bgView = [[UIButton alloc] initWithFrame:CGRectMake(0, StateBarH+44, ScreenW, ScreenH - 44)];
        _bgView.backgroundColor = [CharacterDarkColor colorWithAlphaComponent:0.2];
        [_bgView addTarget:self action:@selector(bgBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
        
        _titleArr=titleArr;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10,frame.size.width, titleArr.count*50) style:UITableViewStylePlain];
        _tableView.backgroundColor=[UIColor whiteColor];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.layer.cornerRadius=6;
        _tableView.layer.masksToBounds=YES;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [[UIView alloc] init];
        
        UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width*0.5+20, 0, 10, 10)];
        imgView.image = [UIImage imageNamed:@"sanjiao"];;
        [self addSubview:imgView];
        
        [self addSubview:_tableView];
        
        [_bgView addSubview:self];
        
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)])
        {
            _tableView.separatorInset=UIEdgeInsetsZero;
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)])
        {
            _tableView.layoutMargins=UIEdgeInsetsZero;
        }

    }
    return self;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        cell.separatorInset=UIEdgeInsetsZero;
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        cell.layoutMargins=UIEdgeInsetsZero;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        
        UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        imgView.image = [UIImage imageNamed:@"duihao"];
        imgView.tag = 111;
        [cell addSubview:imgView];
    }
    UIImageView * imgView = (UIImageView *)[cell viewWithTag:111];
    if (self.isAccShow) {
        cell.accessoryView = imgView;
        if (indexPath.row == self.currentIndex) {
            imgView.hidden = NO;
        }else{
            imgView.hidden = YES;
        }
    }else{
        imgView.hidden = YES;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
   
    cell.backgroundColor=tableView.backgroundColor;
    cell.textLabel.textColor = CharacterDarkColor;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = [_titleArr objectAtIndex:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self disMissAnimation:YES];
    if ([self.delegate respondsToSelector:@selector(PopListView:didSelectRowAtIndexPath:)])
    {
        [self.delegate PopListView:self didSelectRowAtIndexPath:indexPath];
    }
}

@end
