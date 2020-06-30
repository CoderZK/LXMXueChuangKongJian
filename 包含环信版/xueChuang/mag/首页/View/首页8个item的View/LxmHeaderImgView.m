//
//  LxmHeaderImgView.m
//  mag
//
//  Created by 李晓满 on 2018/7/28.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmHeaderImgView.h"
@interface LxmHeaderImgView()
@property (nonatomic , strong)NSArray * dataArr;
@end

@implementation LxmHeaderImgView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layout = [[UICollectionViewFlowLayout alloc] init];
        self.layout.itemSize = CGSizeMake(26, 26);
        self.layout.minimumInteritemSpacing = 9;
        self.layout.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 12, 210, 26) collectionViewLayout:self.layout];
        self.collectionView.backgroundColor = UIColor.whiteColor;
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.scrollEnabled = NO;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.collectionView];
        
        [self.collectionView registerClass:[LxmHeaderImgCell class] forCellWithReuseIdentifier:@"LxmHeaderImgCell"];
    }
    return self;
}
- (void)setItems:(NSArray *)items{
    self.dataArr = items;
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LxmHeaderImgCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LxmHeaderImgCell" forIndexPath:indexPath];
    if (self.isGoodList) {
        LxmYueDanHeadImgModel * model = [self.dataArr objectAtIndex:indexPath.item];
        [cell.headerImgView sd_setImageWithURL:[NSURL URLWithString:[LxmURLDefine getPicImgWthPicStr:model.buyUserHead]] placeholderImage:[UIImage imageNamed:@"moren"] options:SDWebImageRetryFailed];
    }else{
        LxmHeadImgModel * model = [self.dataArr objectAtIndex:indexPath.item];
        [cell.headerImgView sd_setImageWithURL:[NSURL URLWithString:[LxmURLDefine getPicImgWthPicStr:model.robUserHead]] placeholderImage:[UIImage imageNamed:@"moren"] options:SDWebImageRetryFailed];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
   
}

@end

@implementation LxmHeaderImgCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.headerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 26, 26)];
        self.headerImgView.image = [UIImage imageNamed:@"moren"];
        self.headerImgView.layer.cornerRadius = 13;
        self.headerImgView.layer.masksToBounds = YES;
        [self addSubview:self.headerImgView];
    }
    return self;
}


@end

