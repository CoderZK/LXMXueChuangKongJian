//
//  LxmImgCollectionView.m
//  mag
//
//  Created by 李晓满 on 2018/7/26.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmImgCollectionView.h"
@interface LxmImgCollectionView()<UICollectionViewDataSource,UICollectionViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic , strong)UICollectionViewFlowLayout * layout;
@property (nonatomic , strong)UICollectionView * collectionView;
@property (nonatomic , strong)NSArray *titleArr1;
@end
@implementation LxmImgCollectionView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        self.layout = [[UICollectionViewFlowLayout alloc] init];
        self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.layout.minimumInteritemSpacing = 10;
        self.layout.minimumInteritemSpacing = 10;
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenW-30, 0) collectionViewLayout:self.layout];
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.collectionView];
        
        UITapGestureRecognizer * tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCollectionView)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
        [self.collectionView registerClass:[LxmImgCollectionCell class] forCellWithReuseIdentifier:@"LxmImgCollectionCell"];
        
    }
    return self;
}
- (void)setTitleArr:(NSArray *)titleArr{
    self.titleArr1 = titleArr;
    self.collectionView.frame = CGRectMake(0, 0, ScreenW-30, ceil(titleArr.count/3.0)*(((ScreenW-30-20)/3)+10)-10);
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
    return CGSizeMake((ScreenW-30-20)/3, (ScreenW-30-20)/3);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LxmImgCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LxmImgCollectionCell" forIndexPath:indexPath];
    NSString * imgStr = [self.titleArr1 lxm_object1AtIndex:indexPath.item];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[LxmURLDefine getPicImgWthPicStr:imgStr]] placeholderImage:[UIImage imageNamed:@"whequemoren"] options:SDWebImageRetryFailed];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectItemBlock) {
        self.selectItemBlock(indexPath.item);
    }
}

- (void)tapCollectionView{
    if ([self.delegate respondsToSelector:@selector(LxmImgCollectionViewClick)]) {
        [self.delegate LxmImgCollectionViewClick];
    }
}


@end


@interface LxmImgCollectionCell()

@end

@implementation LxmImgCollectionCell
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
        _imgView.layer.cornerRadius = 8;
        _imgView.layer.masksToBounds = YES;
    }
    return _imgView;
}


@end

