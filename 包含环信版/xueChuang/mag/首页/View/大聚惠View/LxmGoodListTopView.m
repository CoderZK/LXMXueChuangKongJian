//
//  LxmGoodListTopView.m
//  mag
//
//  Created by 李晓满 on 2018/7/13.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmGoodListTopView.h"

@interface LxmGoodListTopView()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic , strong)UICollectionViewFlowLayout * layout;
@property (nonatomic , strong)UICollectionView * collectionView;
@property (nonatomic , assign)NSInteger selectIndex;
@property (nonatomic , strong)NSArray *titleArr1;
@end

@implementation LxmGoodListTopView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        self.layout = [[UICollectionViewFlowLayout alloc] init];
        self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.layout.minimumInteritemSpacing = 15;
        
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, 0, ScreenW - 30, 50) collectionViewLayout:self.layout];
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.collectionView];
        
        [self.collectionView registerClass:[LxmGoodCataCell class] forCellWithReuseIdentifier:@"LxmGoodCataCell"];
        
        UIView * line = [[UIView alloc] init];
        line.backgroundColor = LineColor;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(self);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}
- (void)setTitleArr:(NSArray *)titleArr{
    self.titleArr1 = titleArr;
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.titleArr1.count;
}
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LxmGoodListModel * model = [self.titleArr1 objectAtIndex:indexPath.item];
    CGFloat w  = [model.content getSizeWithMaxSize:CGSizeMake(ScreenW , 50) withFontSize:18].width;
    return CGSizeMake(w, 50);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LxmGoodCataCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LxmGoodCataCell" forIndexPath:indexPath];
    LxmGoodListModel * model = [self.titleArr1 objectAtIndex:indexPath.item];
    cell.titleLab.text = model.content;
    cell.imgView.hidden = self.selectIndex==indexPath.item?NO:YES;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    self.selectIndex = indexPath.item;
    [self.collectionView reloadData];
    
    if ([self.delegate respondsToSelector:@selector(LxmGoodListTopView:btnAtIndex:)]) {
        [self.delegate LxmGoodListTopView:self btnAtIndex:indexPath.item];
    }
    
}
- (void)lxmGoodListTopViewSelectIndex:(NSInteger)index{
    self.selectIndex = index;
    NSIndexPath *indexP = [NSIndexPath indexPathForItem:index inSection:0];
    [self.collectionView deselectItemAtIndexPath:indexP animated:YES];
    [self.collectionView scrollToItemAtIndexPath:indexP atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [self.collectionView reloadData];
}




@end

@implementation LxmGoodCataCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLab = [[UILabel alloc] init];
        self.titleLab.textColor = CharacterDarkColor;
        self.titleLab.font = [UIFont systemFontOfSize:18];
        [self addSubview:self.titleLab];
        
        self.imgView = [[UIImageView alloc] init];
        self.imgView.backgroundColor = BlueColor;
        self.imgView.layer.cornerRadius = 1.5;
        self.imgView.layer.masksToBounds = YES;
        [self addSubview:self.imgView];
        
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.centerX.equalTo(self);
        }];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-2);
            make.leading.trailing.equalTo(self);
            make.height.equalTo(@3);
        }];
        
    }
    return self;
}
@end
