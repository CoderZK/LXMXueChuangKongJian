//
//  LxmHomeNewItemView.m
//  mag
//
//  Created by 李晓满 on 2018/11/21.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmHomeNewItemView.h"
@interface LxmHomeNewItemView()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end
@implementation LxmHomeNewItemView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.equalTo(self).offset(15);
            make.bottom.trailing.equalTo(self).offset(-15);
        }];
    }
    return self;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 15;
        layout.minimumInteritemSpacing = 15;
        layout.itemSize = CGSizeMake((ScreenW - 45)*0.5, 40);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[LxmHomeNewCollectionCell class] forCellWithReuseIdentifier:@"LxmHomeNewCollectionCell"];
    }
    return _collectionView;
}

- (void)setItemArr:(NSArray *)itemArr {
    _itemArr = itemArr;
    [self.collectionView reloadData];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemArr.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LxmHomeNewCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LxmHomeNewCollectionCell" forIndexPath:indexPath];
    LxmHomeBannerModel * model = [self.itemArr lxm_object1AtIndex:indexPath.item];
    cell.bgImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld",indexPath.item + 1]];
    cell.iconImgView.image= [UIImage imageNamed:[NSString stringWithFormat:@"11%ld",indexPath.item + 1]];
    cell.textLabel.text = model.content;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    LxmHomeBannerModel * model = [self.itemArr lxm_object1AtIndex:indexPath.item];
    if (self.clickBlock) {
        self.clickBlock(model);
    }
}

@end

@implementation LxmHomeNewCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
        [self addSubview:self.bgImgView];
        [self addSubview:self.iconImgView];
        [self addSubview:self.textLabel];
        [self setConstrains];
    }
    return self;
}

/**
 设置约束
 */
- (void)setConstrains {
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.trailing.equalTo(self);
    }];
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.leading.equalTo(self).offset(20);
        make.width.height.equalTo(@25);
    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.trailing.equalTo(self).offset(-20);
        make.leading.equalTo(self.iconImgView.mas_trailing);
    }];
}

/**
 初始化子视图
 */
- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
    }
    return _bgImgView;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
    }
    return _iconImgView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:12];
        _textLabel.textColor = UIColor.whiteColor;
        _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _textLabel;
}

@end
