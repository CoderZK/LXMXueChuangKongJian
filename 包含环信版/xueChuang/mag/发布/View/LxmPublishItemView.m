//
//  LxmPublishItemView.m
//  mag
//
//  Created by 李晓满 on 2018/7/17.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmPublishItemView.h"
@interface LxmPublishItemView()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic , strong)UICollectionView * collectionView;
@property (nonatomic , strong)NSArray * items;
@end
@implementation LxmPublishItemView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(80, 80);
        layout.minimumInteritemSpacing = (ScreenW-80*3-60)/2;
        layout.minimumLineSpacing = (ScreenW-80*3-60)/2;
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(30, 15, ScreenW-60, ceil(4/3.0)*(80+(ScreenW-80*3-60)/2)) collectionViewLayout:layout];
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        [self addSubview:self.collectionView];
        [self.collectionView registerClass:[LxmPublishItemCell class] forCellWithReuseIdentifier:@"LxmPublishItemCell"];
    }
    return self;
}

- (void)setDataArr:(NSArray *)dataArr{
    self.items  = dataArr;
    self.collectionView.frame = CGRectMake(30, 15, ScreenW-60, ceil(dataArr.count/3.0)*(80+(ScreenW-80*3-60)/2));
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.items.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LxmPublishItemCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LxmPublishItemCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    LxmHomeBannerModel * model = [self.items objectAtIndex:indexPath.item];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[LxmURLDefine getPicImgWthPicStr:model.pic]] placeholderImage: [UIImage imageNamed:@"homeItemmoren"] options:SDWebImageRetryFailed];
    cell.titleLab.text = model.content;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (self.clickBlock) {
        self.clickBlock(indexPath.item);
    }
}


@end

@implementation LxmPublishItemCell
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
            make.top.centerX.equalTo(self);
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


