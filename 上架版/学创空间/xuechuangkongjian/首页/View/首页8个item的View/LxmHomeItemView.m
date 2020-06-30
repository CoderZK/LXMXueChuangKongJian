//
//  lxmHomeItemView.m
//  mag
//
//  Created by 李晓满 on 2018/7/3.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmHomeItemView.h"
@interface LxmHomeItemView()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic , strong)UICollectionView * collectionView;
@property (nonatomic , strong)NSArray * items;
@end
@implementation LxmHomeItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((ScreenW / 4.0) - 1, 90);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0.;
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.scrollEnabled = false;
        [self addSubview:self.collectionView];
        [self.collectionView registerClass:[LxmHomeItemCell class] forCellWithReuseIdentifier:@"LxmHomeItemCell"];
    }
    return self;
}

- (void)setDataArr:(NSArray *)dataArr{
    self.items = dataArr;
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.items.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LxmHomeItemCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LxmHomeItemCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    LxmHomeBannerModel * model = [self.items lxm_object1AtIndex:indexPath.item];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[LxmURLDefine getPicImgWthPicStr:model.pic]] placeholderImage: [UIImage imageNamed:@"homeItemmoren"] options:SDWebImageRetryFailed];
    cell.titleLab.text = model.content;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    LxmHomeBannerModel * model = [self.items lxm_object1AtIndex:indexPath.item];
    if (self.clickBlock) {
        self.clickBlock(model);
    }
}
@end



@implementation LxmHomeItemCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imgView = [[UIImageView alloc] init];
        self.titleLab = [[UILabel alloc] init];
        self.titleLab.textColor = CharacterDarkColor;
        self.titleLab.font = [UIFont systemFontOfSize:14];
        
        [self addSubview:self.imgView];
        [self addSubview:self.titleLab];
        
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(10);
            make.centerX.equalTo(self);
            make.width.height.equalTo(@50);
        }];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imgView.mas_bottom).offset(5);
            make.centerX.equalTo(self);
            make.height.equalTo(@20);
        }];
        
    }
    return self;
}
@end

