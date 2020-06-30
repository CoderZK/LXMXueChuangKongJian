//
//  SNYPhotoBrowserView.m
//  SNYMediaManager
//
//  Created by admin on 16/6/15.
//  Copyright © 2016年 sny. All rights reserved.
//

#import "MLYPhotoBrowserView.h"
#import "MLYPhotoCell.h"
#import "UIImageView+WebCache.h"

#import <objc/runtime.h>

const char * kViewIDKey = "kViewIDKey";

@implementation UIView (MLYViewID)

-(void)setViewID:(NSInteger)viewID
{
    objc_setAssociatedObject(self, kViewIDKey, @(viewID+MLYPhotoBrowserViewFirstID), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSInteger)viewID
{
    return [objc_getAssociatedObject(self, kViewIDKey) integerValue];
}

-(UIView *)viewWithID:(NSInteger)ID
{
    for (UIView * view in self.subviews)
    {
        if ([view viewID] == ID)
        {
            return view;
        }
        else
        {
            UIView * tview = [view viewWithID:ID];
            if (tview)
            {
                return tview;
            }
        }
    }
    return nil;
}


@end


@interface MLYPhotoBrowserView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,MLYPhotoCellDelegate>
{
    UICollectionView * _collectionView;
    UILabel * _countLabel;
    
    NSInteger _numberItemCount;
    UIButton * _likeBtn;
    UIButton * _commentBtn;
    
    UIView * _bgView;
    UIImageView * _transfromView;
}

@property(nonatomic,weak)UIView * sourceView;

@end


@implementation MLYPhotoBrowserView


+(instancetype)photoBrowserView
{
    MLYPhotoBrowserView * view = [[MLYPhotoBrowserView alloc] init];
    return view;
}
-(instancetype)init
{
    return [self initWithFrame:CGRectZero];
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:[UIScreen mainScreen].bounds])
    {
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self initCollectionView];
        [self initBottomView];
        
        _bgView = [[UIView alloc] init];
        _transfromView = [[UIImageView alloc] init];
        _transfromView.clipsToBounds = YES;
        [_bgView addSubview:_transfromView];
    }
    return self;
}
-(void)initCollectionView
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing=20;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(-10, -10, self.bounds.size.width+20, self.bounds.size.height+20) collectionViewLayout:layout];
    _collectionView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    _collectionView.pagingEnabled=YES;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[MLYPhotoCell class] forCellWithReuseIdentifier:@"MLYPhotoCell"];
    [self addSubview:_collectionView];
}
-(void)initBottomView
{
    _countLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.bounds.size.width-100)*0.5, self.bounds.size.height-50, 100, 50)];
    _countLabel.font = [UIFont systemFontOfSize:14];
    _countLabel.textAlignment=NSTextAlignmentCenter;
    _countLabel.textColor = [UIColor whiteColor];
    _countLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewContentModeLeft;
    [self addSubview:_countLabel];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.isDragging || scrollView.isDecelerating)
    {
        NSInteger currentIndex = (NSInteger)floor(scrollView.contentOffset.x/scrollView.bounds.size.width);
        
        if (((int)scrollView.contentOffset.x%(int)scrollView.bounds.size.width)*1.0/scrollView.bounds.size.width>0.5)
        {
            currentIndex++;
        }
        
        if (currentIndex>=_numberItemCount)
        {
            _currentIndex = _numberItemCount-1;
        }
        
        if (currentIndex<0)
        {
            currentIndex = 0;
        }
        
        if (self.currentIndex!=currentIndex)
        {
            self.currentIndex = currentIndex;
            _countLabel.text = [NSString stringWithFormat:@"%ld/%ld",self.currentIndex+1,(long)_numberItemCount];
        }
        
    }
}
-(void)reloadData
{
    if (self.currentIndex>=0 && self.currentIndex<_numberItemCount)
    {
        self.currentIndex = 0;
    }
    [_collectionView reloadData];
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.bounds.size;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _numberItemCount;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MLYPhotoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MLYPhotoCell" forIndexPath:indexPath];
    MLYPhoto * photo = [self.dataSource photoBrowserView:self photoForItemAtIndex:indexPath.item];
    cell.photo=photo;
    cell.delegate=self;
    return cell;
}
- (void)photoCellTap:(MLYPhotoCell*)cell
{
    [self dismiss];
}
- (void)showWithItemsSpuerView:(UIView *)view2
{
    self.sourceView = view2;
    
    _numberItemCount = [self.dataSource numberOfItemsInPhotoBrowserView:self];
    if (self.currentIndex<0 || self.currentIndex>=_numberItemCount)
    {
        self.currentIndex = 0;
    }
    _countLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)self.currentIndex+1,(long)_numberItemCount];
    [_collectionView reloadData];
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    
    
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
    [window bringSubviewToFront:self];
    self.frame = [UIScreen mainScreen].bounds;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    [self addSubview:_bgView];
    _bgView.frame = self.bounds;
    
    [self bringSubviewToFront:_bgView];
    
    UIView * fromView = [view2 viewWithID:self.currentIndex+MLYPhotoBrowserViewFirstID];
    //[view2 viewWithTag:MLYPhotoBrowserViewFirstTag+self.currentIndex];
    
    CGRect rect = [window convertRect:fromView.frame fromView:fromView.superview];
    _transfromView.frame = rect;
    
    MLYPhoto * photo = [self.dataSource photoBrowserView:self photoForItemAtIndex:_currentIndex];

    if (photo.imageUrl)
    {
        UIImage * image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:photo.imageUrl.absoluteString];
        if (!image)
        {
            image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:photo.imageUrl.absoluteString];
            
        }
         _transfromView.image = image;
    }
    else if (photo.image)
    {
         _transfromView.image = photo.image;
    }
    
    CGSize size = rect.size;
    
    if (_transfromView.image.size.width>self.bounds.size.width || _transfromView.image.size.height>self.bounds.size.height)
    {
        if (_transfromView.image.size.width/self.bounds.size.width > _transfromView.image.size.height/self.bounds.size.height)
        {
            size = CGSizeMake(self.bounds.size.width, _transfromView.image.size.height/_transfromView.image.size.width*self.bounds.size.width);
        }
        else
        {
            size = CGSizeMake(self.bounds.size.height*_transfromView.image.size.width/_transfromView.image.size.height, self.bounds.size.height);
        }
    }
    else
    {
        size = _transfromView.image.size;
    }
    
    _bgView.alpha = fromView?1:0;
    _transfromView.frame = fromView?rect:CGRectMake((_bgView.bounds.size.width- size.width)*0.5, (_bgView.bounds.size.height- size.height)*0.5, size.width, size.height);
    
    _countLabel.alpha = 0;
    _collectionView.alpha = 0;
    self.backgroundColor = [UIColor clearColor];
    _bgView.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.5 animations:^{
        
        self.backgroundColor = [UIColor blackColor];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 1;
        _transfromView.frame = CGRectMake((_bgView.bounds.size.width- size.width)*0.5, (_bgView.bounds.size.height- size.height)*0.5, size.width, size.height);
        
    } completion:^(BOOL finished) {
        
        [_bgView removeFromSuperview];
        _collectionView.alpha = 1;
        _countLabel.alpha = 1;
        
    }];
    
}
- (void)dismiss
{
    
    UIView * targetView = [self.sourceView viewWithID:MLYPhotoBrowserViewFirstID+self.currentIndex];
    if (targetView)
    {
        [self addSubview:_bgView];
        _collectionView.alpha = 0;
        _countLabel.alpha = 0;
        
        MLYPhoto * photo = [self.dataSource photoBrowserView:self photoForItemAtIndex:_currentIndex];
        
        if (photo.imageUrl)
        {
            UIImage * image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:photo.imageUrl.absoluteString];
            if (!image)
            {
                image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:photo.imageUrl.absoluteString];
                
            }
            _transfromView.image = image;
        }
        else if (photo.image)
        {
            _transfromView.image = photo.image;
        }
        
        CGSize size = targetView.bounds.size;
        if (_transfromView.image.size.width>self.bounds.size.width || _transfromView.image.size.height>self.bounds.size.height)
        {
            if (_transfromView.image.size.width/self.bounds.size.width > _transfromView.image.size.height/self.bounds.size.height)
            {
                size = CGSizeMake(self.bounds.size.width, _transfromView.image.size.height/_transfromView.image.size.width*self.bounds.size.width);
            }
            else
            {
                size = CGSizeMake(self.bounds.size.height*_transfromView.image.size.width/_transfromView.image.size.height, self.bounds.size.height);
            }
        }
        else
        {
            size = _transfromView.image.size;
        }

        _transfromView.frame = CGRectMake((_bgView.bounds.size.width- size.width)*0.5, (_bgView.bounds.size.height- size.height)*0.5, size.width, size.height);
        
        UIWindow * window = [UIApplication sharedApplication].delegate.window;
        CGRect rect = [window convertRect:targetView.frame fromView:targetView.superview];
        
        
        __weak typeof(self)safe_self = self;
        [UIView animateWithDuration:0.5 animations:^{
            safe_self.backgroundColor = [UIColor clearColor];
            _bgView.backgroundColor = [UIColor clearColor];
            _transfromView.frame = rect;
        } completion:^(BOOL finished) {
             [safe_self removeFromSuperview];
        }];

    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            
            self.alpha = 0;
            
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}
@end
