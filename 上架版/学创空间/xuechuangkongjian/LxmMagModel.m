//
//  LxmMagModel.m
//  mag
//
//  Created by 李晓满 on 2018/7/23.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmMagModel.h"

@implementation LxmMagModel

@end

@implementation LxmThirdInfoModel
//归档
- (void)encodeWithCoder:(NSCoder *)aCoder {
    if (self.threeId) {
        [aCoder encodeObject:self.threeId forKey:@"threeId"];
    }
    if (self.headimg) {
        [aCoder encodeObject:self.headimg forKey:@"headimg"];
    }
    if (self.threeName) {
        [aCoder encodeObject:self.threeName forKey:@"threeName"];
    }
    if (self.telentPass) {
        [aCoder encodeObject:self.telentPass forKey:@"telentPass"];
    }
    
    [aCoder encodeInteger:self.type forKey:@"type"];
}

//解档
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.headimg = [aDecoder decodeObjectForKey:@"headimg"];
        self.threeId = [aDecoder decodeObjectForKey:@"threeId"];
        self.threeName = [aDecoder decodeObjectForKey:@"threeName"];
        self.telentPass = [aDecoder decodeObjectForKey:@"telentPass"];
        self.type = [aDecoder decodeIntegerForKey:@"type"];
    }
    return self;
}
@end


@implementation LxmYueDanHeadImgModel

@end

@implementation LxmUserInfoModel
//归档
- (void)encodeWithCoder:(NSCoder *)aCoder {
    if (self.headimg) {
        [aCoder encodeObject:self.headimg forKey:@"headimg"];
    }
    if (self.nickname) {
        [aCoder encodeObject:self.nickname forKey:@"nickname"];
    }
    if (self.schoolName) {
        [aCoder encodeObject:self.schoolName forKey:@"schoolName"];
    }
    if (self.institute) {
        [aCoder encodeObject:self.institute forKey:@"institute"];
    }
    [aCoder encodeInteger:self.sex forKey:@"sex"];
    [aCoder encodeInteger:self.goodRate forKey:@"goodRate"];
    [aCoder encodeInteger:self.schoolId forKey:@"schoolId"];
    [aCoder encodeInteger:self.type forKey:@"type"];
    [aCoder encodeInteger:self.userId forKey:@"userId"];
}

//解档
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.headimg = [aDecoder decodeObjectForKey:@"headimg"];
        self.nickname = [aDecoder decodeObjectForKey:@"nickname"];
        self.schoolName = [aDecoder decodeObjectForKey:@"schoolName"];
        self.institute = [aDecoder decodeObjectForKey:@"institute"];
        self.sex = [aDecoder decodeIntegerForKey:@"sex"];
        self.goodRate = [aDecoder decodeIntegerForKey:@"goodRate"];
        self.schoolId = [aDecoder decodeIntegerForKey:@"schoolId"];
        self.type = [aDecoder decodeIntegerForKey:@"type"];
        self.userId = [aDecoder decodeIntegerForKey:@"userId"];
    }
    return self;
}

@end


@implementation LxmFullInfoModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"ID":@"id"
             };
}
@end
@implementation LxmFullInfoRootModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"result":@"LxmFullInfoModel"};
}
@end

@implementation LxmHomeBannerModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"ID":@"id"
             };
}
@end
@implementation LxmHomeBannerRootModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"result":@"LxmHomeBannerModel"};
}
@end



/**
 首页列表model
 */
@implementation LxmHeadImgModel

@end

@implementation LxmHomeModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"robList":@"LxmHeadImgModel"};
}

@end

@implementation LxmHomeModel1
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"list":@"LxmHomeModel"};
}
@end

@implementation LxmHomeRootModel


@end

@implementation LxmHomeDetailRootModel


@end

@implementation LxmGoodListModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"ID":@"id"
             };
}
@end

@implementation LxmGoodListRootModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"result":@"LxmGoodListModel"};
}
@end


@implementation LxmCanListModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"buyUserList":@"LxmYueDanHeadImgModel"};
}

@end

@implementation LxmCanListModel1

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"list":@"LxmCanListModel"};
}

@end

@implementation LxmCanListRootModel

@end


/**
 任务详情留言模块
 */
@implementation LxmCommentReplyListModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"ID":@"id"
             };
}

- (void)setContent:(NSString *)content{
    _content = content;
    CGFloat height = [content getSizeWithMaxSize:CGSizeMake(ScreenW -70-40, 999) withFontSize:14].height;
   self.height = 60+(height>20?height:20)+20+10;
}

@end

@implementation LxmCommentListModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"replyList":@"LxmCommentReplyListModel"};
}

- (void)setContent:(NSString *)content{
    _content = content;
    CGFloat h = [self.content getSizeWithMaxSize:CGSizeMake(ScreenW -70, 999) withFontSize:14].height;
    self.height = 60+(h>20?h:20)+20+10;
}

- (CGFloat)height{
    
    if (_height == 0) {
        return 0.01;
    }else{
        return _height;
    }
}


@end

@implementation LxmCommentList1Model
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"list":@"LxmCommentListModel"};
}

@end

@implementation LxmCommentRootModel

@end


//我发布的活

@implementation LxmMyPublishModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"list":@"LxmHomeModel"};
}
@end

@implementation LxmMyPublishRootModel

@end

//抢单人列表

@implementation LxmMyQingDanPeopleModel

@end

@implementation LxmMyQingDanPeopleModel1

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"list":@"LxmMyQingDanPeopleModel"};
}

@end

@implementation LxmMyQingDanPeopleRootModel

@end

//根据类型获取文章列表
@implementation LxmArticleModel


@end

@implementation LxmArticleModel1

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"list":@"LxmArticleModel"};
}

@end


@implementation LxmArticleRootModel


@end


@implementation LxmArticleDetailModel


@end

@implementation LxmArticleDetailRootModel


@end

//周边列表
@implementation LxmAroundModel

@end

@implementation LxmAroundModel1

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"list":@"LxmAroundModel"};
}

@end

@implementation LxmAroundRootModel

@end
@implementation LxmAroundDetailRootModel

@end


@implementation LxmAroundCommentModel

@synthesize height = _height;

- (CGFloat)height {
    if (_height == 0) {
        CGFloat connectHeight = [self.content getSizeWithMaxSize:CGSizeMake(ScreenW-30, 999) withFontSize:18].height+10;
        
        
        CGFloat imgViewHeight = 0;
        if (!self.img||[self.img isEqualToString:@""]) {
            imgViewHeight = 0;
        }else{
            imgViewHeight = (ScreenW-30-20)/3;
        }
        _height = 60+connectHeight+10+imgViewHeight+15;
    }
    return _height;
}


@end


@implementation LxmAroundCommentModel1

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"list":@"LxmAroundCommentModel"};
}

@end

@implementation LxmAroundCommentRootModel


@end

//电商

@implementation LxmGoodsListModel1
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"list":@"LxmCanListModel"};
}

@end

@implementation LxmGoodsListRootModel


@end
//电商商品详情



@implementation LxmGoodsDetailModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"buyUserList":@"LxmYueDanHeadImgModel"};
}
@end

@implementation LxmGoodsDetailRootModel

@end

//获取约单人列表

@implementation LxmBuyMyCanUserModel

@synthesize cellHeight = _cellHeight;

- (CGFloat)cellHeight {
    if (_cellHeight == 0) {
        if (!self.sendAddr) {
            _cellHeight = 60;
        } else {
            NSString *str  = [@"收货地址: " stringByAppendingString:self.sendAddr ];
            CGFloat height = [str getSizeWithMaxSize:CGSizeMake(ScreenW - 30, 9999) withFontSize:14].height+15;
            _cellHeight = 60 + height;
        }
        
    }
    return _cellHeight;
}

@end

@implementation LxmBuyMyCanUserModel1

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"list":@"LxmBuyMyCanUserModel"};
}

@end

@implementation LxmBuyMyCanUserRootModel

@end


//我的报名列表
@implementation LxmMyTourListModel

@end
@implementation LxmMyTourListModel1
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"list":@"LxmMyTourListModel"};
}

@end
@implementation LxmMyTourListRootModel

@end

@implementation LxmMyTourDetailRootModel

@end

//我的评价列表
@implementation LxmMyEvaluateListModel

@end

@implementation LxmMyEvaluateListModel1
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"list":@"LxmMyEvaluateListModel"};
}
@end

@implementation LxmMyEvaluateListRootModel

@end

//我的资产

@implementation LxmMyAssetsInfoModel


@end


@implementation LxmMyAssetsInfoRootModel


@end

@implementation LxmMyConsumeModel


@end

@implementation LxmMyConsumeModel1

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"list":@"LxmMyConsumeModel"};
}

@end

@implementation LxmMyConsumeRootModel


@end


@implementation LxmMyAddressModel


@end


@implementation LxmMyAddressModel1

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"list":@"LxmMyAddressModel"};
}

@end

@implementation LxmMyAddressRootModel


@end


@implementation LxmShareInfoModel


@end

@implementation LxmOtherInfoModel


@end

@implementation LxmMessageInfoModel


@end

@implementation LxmNewFriendListModel


@end


@implementation LxmNewFriendListModel1

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"list":@"LxmNewFriendListModel"};
}
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"friendNum":@"newFriendNum"
             };
}


@end


@implementation LxmNewFriendListRootModel


@end

@implementation LxmFindNewFriendListModel


@end


@implementation LxmFindNewFriendListModel1

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"list":@"LxmFindNewFriendListModel"};
}

@end


@implementation LxmFindNewFriendListRootModel


@end

@implementation LxmFindInterMsgModel


@end

@implementation LxmFindInterMsgModel1

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"list":@"LxmFindInterMsgModel"};
}

@end

@implementation LxmFindInterMsgRootModel

@end

@implementation LxmHuanXinModel 

@end

@implementation LxmAccountInfoModel
- (NSString *)phone{
    if (!_phone) {
        return @"";
    }
    return _phone;
}
- (NSString *)alipay{
    if (!_alipay) {
        return @"";
    }
    return _alipay;
}
- (NSString *)weChat{
    if (!_weChat) {
        return @"";
    }
    return _weChat;
}
- (NSString *)QQ{
    if (!_QQ) {
        return @"";
    }
    return _QQ;
}
@end
