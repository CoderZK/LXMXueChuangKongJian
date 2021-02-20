//
//  AdScrollView.h
//  testAdScroolView
//
//  Created by sny on 15/7/5.
//  Copyright (c) 2015年 sny. All rights reserved.
//

#import "SNY_AdScrollView.h"
#import "UIImageView+WebCache.h"
#import "SNY_AdScrollViewItem.h"

@interface SNY_AdScrollView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UICollectionView * _collectionView;
    NSArray * _imgUrlArray;
    UIPageControl * _pageControl;
    NSTimer * _timer;
    int _qianJin;
}
@end

@implementation SNY_AdScrollView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        [self initScrollView];
    }
    return self;
    
}
-(void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    _collectionView.backgroundColor=self.backgroundColor;
}
-(void)initScrollView
{
    _qianJin=1;
    UICollectionViewFlowLayout * layout=[[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing=0;
    layout.minimumLineSpacing=0;
    _collectionView=[[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    _collectionView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _collectionView.pagingEnabled=YES;
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    _collectionView.showsHorizontalScrollIndicator=NO;
    _collectionView.backgroundColor=[UIColor whiteColor];
    [_collectionView registerClass:[SNY_AdScrollViewItem class] forCellWithReuseIdentifier:@"SNY_AdScrollViewItem"];
    [self addSubview:_collectionView];
    

    _pageControl =  [[UIPageControl alloc] initWithFrame:CGRectMake(self.bounds.size.width-100, self.bounds.size.height-20,100, 20)];
    _pageControl.hidesForSinglePage = YES;
//    [_pageControl setValue:[UIImage imageNamed:@"bannerselect"] forKeyPath:@"_currentPageImage"];
//    [_pageControl setValue:[UIImage imageNamed:@"bannerunselect"] forKeyPath:@"_pageImage"];
    
//    _pageControl setIndicatorImage:<#(nullable UIImage *)#> forPage:<#(NSInteger)#>
    
    
    [self addSubview:_pageControl];
}

-(void)setDataArr:(NSArray *)dataArr
{
    if (_dataArr!=dataArr)
    {
        _dataArr=dataArr;
        [_timer invalidate];
        _timer = nil;
        if (_dataArr.count>1)
        {
            _timer = [NSTimer scheduledTimerWithTimeInterval:5 target: self selector: @selector(onTimer)  userInfo:nil  repeats: YES];
            [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        }
    }
    if (_dataArr.count>1)
    {
        if (_timer==nil)
        {
            _timer = [NSTimer scheduledTimerWithTimeInterval:5 target: self selector: @selector(onTimer)  userInfo:nil  repeats: YES];
            [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
            
        }

    }
    [_collectionView reloadData];
     _pageControl.numberOfPages = (int)_dataArr.count;
//    CGSize size = [_pageControl sizeForNumberOfPages:(int)_dataArr.count];
  //  _pageControl.frame = CGRectMake(0, self.bounds.size.height-20, size.width, 20);
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.mas_bottom).offset(-30);
        make.height.equalTo(@20);
    }];
}
-(void)onTimer
{
    NSArray * cells=[_collectionView visibleCells];
    SNY_AdScrollViewItem * cell=cells.lastObject;
    NSIndexPath * indexPath=[_collectionView indexPathForCell:cell];
    if (indexPath.item==0)
    {
         _qianJin=1;
    }
    else if (indexPath.item==_dataArr.count-1)
    {
        _qianJin=-1;
    }
    [_collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.item+_qianJin inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionLeft];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SNY_AdScrollViewItem * cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"SNY_AdScrollViewItem" forIndexPath:indexPath];
    LxmHomeBannerModel * m =  [_dataArr lxm_object1AtIndex:indexPath.row];
    cell.img = [LxmURLDefine getPicImgWthPicStr:m.pic];
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return collectionView.bounds.size;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(sny_adScrollView:selectedIndex:)])
    {
        [self.delegate sny_adScrollView:self selectedIndex:indexPath.item];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _pageControl.currentPage=(int)scrollView.contentOffset.x/self.frame.size.width;
//    if (@available(iOS 14.0, *)) {
//        [_pageControl setIndicatorImage:[UIImage imageNamed:@"bannerselect"] forPage:(int)scrollView.contentOffset.x/self.frame.size.width];
//    } else {
//        // Fallback on earlier versions
//    }
}
@end
