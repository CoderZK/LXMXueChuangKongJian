//
//  SNYPhotoCell.m
//  SNYMediaManager
//
//  Created by admin on 16/6/15.
//  Copyright © 2016年 sny. All rights reserved.
//

#import "MLYPhotoCell.h"
#import "UIImageView+WebCache.h"
@interface MLYPhotoCell ()<UIScrollViewDelegate>
{
    MLYPhotoScrollView * _scrollView;
}
@property(nonatomic,strong)UIActivityIndicatorView * loadingView;
@end

@implementation MLYPhotoCell

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self resetState];
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        _scrollView=[[MLYPhotoScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.delegate=self;
        [self addSubview:_scrollView];
        
        
        UITapGestureRecognizer * tap1=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap1GestureRecognizer:)];
        tap1.numberOfTouchesRequired=1;
        [_scrollView addGestureRecognizer:tap1];
        
        UITapGestureRecognizer * tap2=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2GestureRecognizer:)];
        tap2.numberOfTapsRequired=2;
        [_scrollView addGestureRecognizer:tap2];
        [tap1 requireGestureRecognizerToFail:tap2];
        
        
        UIInterpolatingMotionEffect *xAxis = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        xAxis.minimumRelativeValue = @(-5);
        xAxis.maximumRelativeValue = @(5);
        
        UIInterpolatingMotionEffect *yAxis = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        yAxis.minimumRelativeValue = @(-5);
        yAxis.maximumRelativeValue = @(5);
        UIMotionEffectGroup * group = [[UIMotionEffectGroup alloc] init];
        group.motionEffects = @[xAxis, yAxis];
        [_scrollView addMotionEffect:group];
        
    }
    return self;
}
-(UIActivityIndicatorView *)loadingView
{
    if (!_loadingView)
    {
        _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _loadingView.center = CGPointMake(self.bounds.size.width*0.5, self.bounds.size.height*0.5);
        _loadingView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:_loadingView];
    }
    return _loadingView;
}
-(void)tap1GestureRecognizer:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(photoCellTap:)])
    {
        [self.delegate photoCellTap:self];
    }
}

-(void)tap2GestureRecognizer:(UITapGestureRecognizer *)tap
{
    if (_scrollView.zoomScale>1.0)
    {
        [_scrollView setZoomScale:1.0 animated:YES];
    }
    else
    {
        CGPoint point = [tap locationInView:self];
        if (CGRectContainsPoint(_scrollView.frame, point))
        {
            CGPoint pointAtS = [tap locationInView:_scrollView];
            
            [UIView animateWithDuration:0.3 animations:^{
                _scrollView.zoomScale=4.0;
                _scrollView.contentOffset=CGPointMake(pointAtS.x*_scrollView.zoomScale-pointAtS.x, pointAtS.y*_scrollView.zoomScale-pointAtS.y);
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                _scrollView.zoomScale=4.0;
            }];
        }
    }
}
-(void)setPhoto:(MLYPhoto *)photo
{
    _photo = photo;
    
    if (_photo.image)
    {
        _scrollView.imageView.image = _photo.image;
        [self resetImageViewContentModeAnimation:NO];
    }
    else if (_photo.imageUrl)
    {
        UIImage * image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:_photo.imageUrl.absoluteString];
        if (!image)
        {
            image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:_photo.imageUrl.absoluteString];
        }
        if (!image)
        {
            _scrollView.imageView.hidden = YES;
            _scrollView.frame = CGRectMake((_scrollView.bounds.size.width-60)*0.5, (_scrollView.bounds.size.height-60)*0.5, 60, 60);
            [self.loadingView startAnimating];
            [_scrollView.imageView sd_setImageWithURL:photo.imageUrl placeholderImage:[UIImage imageNamed:@"banner_default_s"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.loadingView stopAnimating];
                    [self resetImageViewContentModeAnimation:YES];
                    _scrollView.imageView.hidden = NO;
                });
                
            }];
            
        }
        else
        {
            _scrollView.imageView.image = image;
            [self resetImageViewContentModeAnimation:NO];
        }

    }
    
    
}
-(void)resetImageViewContentModeAnimation:(BOOL)animation
{
    [UIView animateWithDuration:animation?0.2:0 animations:^{
        
        CGSize size = CGSizeZero;
        if (_scrollView.imageView.image.size.width>self.bounds.size.width || _scrollView.imageView.image.size.height>self.bounds.size.height)
        {
            if (_scrollView.imageView.image.size.width/self.bounds.size.width > _scrollView.imageView.image.size.height/self.bounds.size.height)
            {
                size = CGSizeMake(self.bounds.size.width, _scrollView.imageView.image.size.height/_scrollView.imageView.image.size.width*self.bounds.size.width);
            }
            else
            {
                size = CGSizeMake(self.bounds.size.height*_scrollView.imageView.image.size.width/_scrollView.imageView.image.size.height, self.bounds.size.height);
            }
        }
        else
        {
            size = _scrollView.imageView.image.size;
        }
        _scrollView.frame = CGRectMake((self.bounds.size.width- size.width)*0.5, (self.bounds.size.height- size.height)*0.5, size.width, size.height);
        
        
    }];
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _scrollView.imageView;
}
- (void)prepareForReuse
{
    [super prepareForReuse];
    [self resetState];
}
-(void)resetState
{
    _scrollView.zoomScale = 1;
    _scrollView.contentSize = CGSizeZero;
}
@end

@implementation MLYPhotoScrollView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.maximumZoomScale = 4;
        self.minimumZoomScale = 1;
        self.clipsToBounds = NO;
        
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:_imageView];
        
    }
    return self;
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    return YES;
}

@end
