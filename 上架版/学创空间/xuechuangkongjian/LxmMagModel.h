//
//  LxmMagModel.h
//  mag
//
//  Created by 李晓满 on 2018/7/23.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface LxmMagModel : NSObject

@end

@interface LxmThirdInfoModel : NSObject<NSCoding>
@property (nonatomic , strong) NSString * threeId;
@property (nonatomic , strong) NSString * telentPass;
@property (nonatomic , strong) NSString * threeName;
@property (nonatomic , strong) NSString * headimg;
@property (nonatomic , assign) NSInteger   type;
@end


@interface LxmYueDanHeadImgModel : NSObject
@property (nonatomic , strong) NSNumber * buyUserId;
@property (nonatomic , strong) NSString * buyUserHead;
@end


@interface LxmUserInfoModel : NSObject<NSCoding>

@property (nonatomic , strong) NSString * headimg;
@property (nonatomic , assign) NSInteger  sex;
@property (nonatomic , strong) NSString * nickname;
@property (nonatomic , assign) NSInteger  goodRate;
@property (nonatomic , assign) NSInteger  schoolId;
@property (nonatomic , strong) NSString * schoolName;
@property (nonatomic , strong) NSString * institute;
@property (nonatomic , assign) NSInteger  type;
@property (nonatomic , assign) NSInteger  userId;
@end


@interface LxmFullInfoModel : NSObject
@property (nonatomic , strong) NSString * code;
@property (nonatomic , strong) NSNumber * ID;
@property (nonatomic , strong) NSString * name;
@property (nonatomic , strong) NSNumber * provinceId;
@property (nonatomic , strong) NSNumber * status;
@property (nonatomic , strong) NSNumber * cityId;
@property (nonatomic , strong) NSString * createTime;
@property (nonatomic , strong) NSNumber * isDelete;
@end

@interface LxmFullInfoRootModel : NSObject
@property (nonatomic , strong) NSNumber * key;
@property (nonatomic , strong) NSString * message;
@property (nonatomic , strong) NSArray<LxmFullInfoModel *> *result;
@end

@interface LxmHomeBannerModel : NSObject
@property (nonatomic , assign) BOOL  isMyCollection;
@property (nonatomic , strong) NSNumber * bannerId;
@property (nonatomic , strong) NSNumber * type;
@property (nonatomic , strong) NSString * pic;
@property (nonatomic , strong) NSNumber * otherId;
@property (nonatomic , strong) NSNumber * ID;
@property (nonatomic , strong) NSString * content;
@property (nonatomic,  strong) NSNumber * typeId;
@end

@interface LxmHomeBannerRootModel : NSObject
@property (nonatomic , strong) NSNumber * key;
@property (nonatomic , strong) NSString * message;
@property (nonatomic , strong) NSArray<LxmHomeBannerModel *> *result;
@end


@interface LxmHeadImgModel : NSObject
@property (nonatomic , strong) NSNumber * robUserId;
@property (nonatomic , strong) NSString * robUserHead;
@property (nonatomic , strong) NSNumber * robUserSex;
@property (nonatomic , strong) NSString * robUserName;

@end

@interface LxmHomeModel : NSObject
@property (nonatomic , strong) NSNumber * allotId;
@property (nonatomic , strong) NSNumber * billId;
@property (nonatomic , strong) NSNumber * isAnonymity;
@property (nonatomic , strong) NSNumber * relUserId;
@property (nonatomic , strong) NSString * relUserHead;
@property (nonatomic , strong) NSNumber * relSex;
@property (nonatomic , strong) NSString * relNickname;
@property (nonatomic , strong) NSNumber * relRate;
@property (nonatomic , strong) NSString * typeName;
@property (nonatomic , strong) NSString * content;
@property (nonatomic , strong) NSString * img;
@property (nonatomic , strong) NSNumber * robNum;
@property (nonatomic , strong) NSArray<LxmHeadImgModel *> *robList;
@property (nonatomic , strong) NSNumber * likeNum;
@property (nonatomic , strong) NSNumber * commentNum;
@property (nonatomic , strong) NSString * money;
@property (nonatomic , strong) NSNumber * state;
@property (nonatomic , assign) CGFloat  height;

@property (nonatomic , strong) NSNumber * likeStatus;
@property (nonatomic , strong) NSNumber * orderId;
@property (nonatomic , strong) NSString * orderNo;
@property (nonatomic , assign) BOOL isDetail;
//1 首页 2 首页详情
@property (nonatomic , assign) NSInteger pageType;
@end

@interface LxmHomeModel1 : NSObject
@property (nonatomic , strong) NSString * time;
@property (nonatomic , strong) NSArray<LxmHomeModel *> *list;
@end

@interface LxmHomeRootModel : NSObject
@property (nonatomic , strong) NSNumber * key;
@property (nonatomic , strong) NSString * message;
@property (nonatomic , strong) LxmHomeModel1 * result;
@end


@interface LxmHomeDetailRootModel : NSObject
@property (nonatomic , strong) NSNumber * key;
@property (nonatomic , strong) NSString * message;
@property (nonatomic , strong) LxmHomeModel * result;
@end

@interface LxmGoodListModel : NSObject
@property (nonatomic , strong) NSNumber * ID;
@property (nonatomic , strong) NSString * content;
@end

@interface LxmGoodListRootModel : NSObject
@property (nonatomic , strong) NSNumber * key;
@property (nonatomic , strong) NSString * message;
@property (nonatomic , strong)  NSArray<LxmGoodListModel *> *result;
@end


/**
 校园商家列表model
 */
@interface LxmCanListModel : NSObject
@property (nonatomic , assign) BOOL isfbjn;
@property (nonatomic , strong) NSNumber * allotId;
@property (nonatomic , strong) NSString * relUserHead;
@property (nonatomic , strong) NSNumber * relSex;
@property (nonatomic , strong) NSString * relNickname;
@property (nonatomic , strong) NSNumber * relRate;
@property (nonatomic , strong) NSString * orderNo;
@property (nonatomic , strong) NSNumber * number;
@property (nonatomic , strong) NSNumber * allMoney;
@property (nonatomic , strong) NSNumber * orderId;
@property (nonatomic , strong) NSNumber * status;

@property (nonatomic , strong) NSNumber * ecId;
@property (nonatomic , strong) NSNumber * billId;
@property (nonatomic , strong) NSNumber * relUserId;
@property (nonatomic , strong) NSString * userHead;
@property (nonatomic , strong) NSNumber * sex;
@property (nonatomic , strong) NSString * nickname;
@property (nonatomic , strong) NSNumber * goodRate;
@property (nonatomic , strong) NSNumber * sendType;
@property (nonatomic , strong) NSString * title;
@property (nonatomic , strong) NSString * money;
@property (nonatomic , strong) NSString * unit;
@property (nonatomic , strong) NSString * content;
@property (nonatomic , strong) NSString * img;
@property (nonatomic , strong) NSNumber * likeNum;
@property (nonatomic , strong) NSNumber * commentNum;
@property (nonatomic , strong) NSNumber * buyUserNum;
@property (nonatomic , assign) CGFloat height;
@property (nonatomic , strong) NSNumber * state;
@property (nonatomic , strong) NSNumber *billState;
@property (nonatomic , strong) NSArray<LxmYueDanHeadImgModel *> * buyUserList;
@end

@interface LxmCanListModel1 : NSObject
@property (nonatomic , strong) NSString * time;
@property (nonatomic , strong) NSArray<LxmCanListModel *>*list;
@end

@interface LxmCanListRootModel : NSObject
@property (nonatomic , strong) NSNumber * key;
@property (nonatomic , strong) NSString * message;
@property (nonatomic , strong) LxmCanListModel1 *result;
@end


/**
 任务详情留言区model
 */
@interface LxmCommentReplyListModel : NSObject
@property (nonatomic , strong) NSNumber * userId;
@property (nonatomic , strong) NSString * userPic;
@property (nonatomic , strong) NSNumber * sex;
@property (nonatomic , strong) NSString * userName;
@property (nonatomic , strong) NSString * toName;
@property (nonatomic , strong) NSString * content;
@property (nonatomic , strong) NSNumber * toUserId;
@property (nonatomic , strong) NSNumber * ID;
@property (nonatomic , strong) NSString * createTime;
@property (nonatomic , strong) NSNumber * likeNum;
@property (nonatomic , strong) NSNumber * likeStatus;
@property (nonatomic , assign) CGFloat height;
@end

@interface LxmCommentListModel : NSObject
@property (nonatomic , strong) NSNumber * commentId;
@property (nonatomic , strong) NSNumber * userId;
@property (nonatomic , strong) NSString * userPic;
@property (nonatomic , strong) NSNumber * sex;
@property (nonatomic , strong) NSString * userName;
@property (nonatomic , strong) NSString * content;
@property (nonatomic , strong) NSString * createTime;
@property (nonatomic , strong) NSNumber * likeNum;
@property (nonatomic , strong) NSNumber * likeStatus;
@property (nonatomic , strong) NSArray<LxmCommentReplyListModel *> * replyList;
@property (nonatomic , strong) NSNumber * isDelete;
@property (nonatomic , assign) CGFloat height;
@end

@interface LxmCommentList1Model : NSObject
@property (nonatomic , strong) NSArray<LxmCommentListModel *> * list;
@property (nonatomic , strong) NSString * time;
@end

@interface LxmCommentRootModel : NSObject
@property (nonatomic , strong) NSNumber * key;
@property (nonatomic , strong) NSString * message;
@property (nonatomic , strong) LxmCommentList1Model * result;
@end

//我发布的活

@interface LxmMyPublishModel : NSObject
@property (nonatomic , strong) NSArray<LxmHomeModel *>*list;
@property (nonatomic , strong) NSString * time;
@end

@interface LxmMyPublishRootModel : NSObject
@property (nonatomic , strong) NSNumber * key;
@property (nonatomic , strong) NSString * message;
@property (nonatomic , strong) LxmMyPublishModel * result;
@end


//抢单人列表

@interface LxmMyQingDanPeopleModel : NSObject

@property (nonatomic , strong) NSNumber * allotId;
@property (nonatomic , strong) NSNumber * robUserId;
@property (nonatomic , strong) NSString * robUserHead;
@property (nonatomic , strong) NSNumber * robUserSex;
@property (nonatomic , strong) NSString * robUserNick;
@property (nonatomic , strong) NSNumber * robUserRate;
@property (nonatomic , strong) NSString * robUserPhone;
@property (nonatomic , strong) NSNumber * money;
@property (nonatomic , strong) NSNumber * needNum;
@property (nonatomic , strong) NSNumber * state;
@property (nonatomic , assign) BOOL isSelect;

@end
@interface LxmMyQingDanPeopleModel1 : NSObject
@property (nonatomic , strong) NSArray<LxmMyQingDanPeopleModel *> * list;
@end
@interface LxmMyQingDanPeopleRootModel : NSObject
@property (nonatomic , strong) NSNumber * key;
@property (nonatomic , strong) NSString * message;
@property (nonatomic , strong) LxmMyQingDanPeopleModel1 * result;
@end

//根据类型获取文章列表
@interface LxmArticleModel : NSObject

@property (nonatomic , strong) NSNumber * articleId;
@property (nonatomic , strong) NSString * title;
@property (nonatomic , strong) NSString * content;
@property (nonatomic , strong) NSString * pic;
@property (nonatomic , strong) NSString * createTime;
@property (nonatomic , strong) NSNumber * commentNum;
@property (nonatomic , strong) NSNumber * likeNum;
@property (nonatomic , assign) CGFloat height;
@end

@interface LxmArticleModel1 : NSObject

@property (nonatomic , strong) NSArray<LxmArticleModel *> * list;
@property (nonatomic , strong) NSString * time;

@end


@interface LxmArticleRootModel : NSObject

@property (nonatomic , strong) NSNumber * key;
@property (nonatomic , strong) NSString * message;
@property (nonatomic , strong) LxmArticleModel1 * result;

@end

//文章详情

@interface LxmArticleDetailModel : NSObject

@property (nonatomic , strong) NSNumber * typeId;
@property (nonatomic , strong) NSString * pic;
@property (nonatomic , strong) NSString * title;
@property (nonatomic , strong) NSString * createTime;
@property (nonatomic , strong) NSNumber * commentNum;
@property (nonatomic , strong) NSNumber * likeNum;
@property (nonatomic , strong) NSNumber * likeStatus;
@property (nonatomic , strong) NSNumber * collectStatus;
@property (nonatomic , strong) NSString * content;

@property (nonatomic , strong) NSNumber * money;
@property (nonatomic , strong) NSNumber * enrollAmount;
@property (nonatomic , strong) NSNumber * limitNum;
@property (nonatomic , assign) CGFloat height;

@end

@interface LxmArticleDetailRootModel : NSObject

@property (nonatomic , strong) NSNumber * key;
@property (nonatomic , strong) NSString * message;
@property (nonatomic , strong) LxmArticleDetailModel * result;

@end


//周边列表
@interface LxmAroundModel : NSObject

@property (nonatomic , strong) NSNumber * articleId;
@property (nonatomic , strong) NSNumber * nearId;
@property (nonatomic , strong) NSString * pic;
@property (nonatomic , strong) NSString * title;
@property (nonatomic , strong) NSNumber * rate;
@property (nonatomic , strong) NSString * address;
@property (nonatomic , strong) NSString * openTime;
@property (nonatomic , strong) NSNumber * money;
@property (nonatomic , strong) NSNumber * collectStatus;
@property (nonatomic , strong) NSString * content;
@property (nonatomic , strong) NSNumber * evaluateNum;

@end


@interface LxmAroundModel1 : NSObject

@property (nonatomic , strong) NSArray<LxmAroundModel *> * list;
@property (nonatomic , strong) NSString * time;

@end

@interface LxmAroundRootModel : NSObject

@property (nonatomic , strong) NSNumber * key;
@property (nonatomic , strong) NSString * message;
@property (nonatomic , strong) LxmAroundModel1 * result;

@end

@interface LxmAroundDetailRootModel : NSObject

@property (nonatomic , strong) NSNumber * key;
@property (nonatomic , strong) NSString * message;
@property (nonatomic , strong) LxmAroundModel * result;

@end

//周边评价

@interface LxmAroundCommentModel : NSObject

@property (nonatomic , strong) NSNumber * evaId;
@property (nonatomic , strong) NSNumber * userId;
@property (nonatomic , strong) NSString * userHead;
@property (nonatomic , strong) NSNumber * sex;
@property (nonatomic , strong) NSString * nickname;
@property (nonatomic , strong) NSNumber * goodRate;
@property (nonatomic , strong) NSString * createTime;
@property (nonatomic , strong) NSString * content;
@property (nonatomic , strong) NSString * img;

@property (nonatomic , strong) NSString * preimg;

@property (nonatomic , strong) NSNumber * score;
@property (nonatomic , assign) CGFloat height;

@end


@interface LxmAroundCommentModel1 : NSObject

@property (nonatomic , strong) NSArray<LxmAroundCommentModel *> * list;
@property (nonatomic , strong) NSString * time;

@end

@interface LxmAroundCommentRootModel : NSObject

@property (nonatomic , strong) NSNumber * key;
@property (nonatomic , strong) NSString * message;
@property (nonatomic , strong) LxmAroundCommentModel1 * result;

@end


//电商

@interface LxmGoodsListModel1 : NSObject

@property (nonatomic , strong) NSArray<LxmCanListModel *> * list;
@property (nonatomic , strong) NSString * time;

@end

@interface LxmGoodsListRootModel : NSObject

@property (nonatomic , strong) NSNumber * key;
@property (nonatomic , strong) NSString * message;
@property (nonatomic , strong) LxmGoodsListModel1 * result;

@end

//商品详情

@interface LxmGoodsDetailModel : NSObject
@property (nonatomic , strong) NSString * userHead;
@property (nonatomic , strong) NSNumber * sex;
@property (nonatomic , strong) NSString * nickname;
@property (nonatomic , strong) NSNumber * goodRate;
@property (nonatomic , strong) NSString * title;
@property (nonatomic , strong) NSNumber * money;
@property (nonatomic , strong) NSString * unit;
@property (nonatomic , strong) NSNumber * sendType;
@property (nonatomic , strong) NSNumber * likeNum;
@property (nonatomic , strong) NSNumber * likeStatus;
@property (nonatomic , strong) NSString * content;
@property (nonatomic , strong) NSString * img;
@property (nonatomic , strong) NSString * img_kg;
@property (nonatomic , strong) NSNumber * buyUserNum;
@property (nonatomic , strong) NSNumber * relUserId;
@property (nonatomic , strong) NSArray<LxmYueDanHeadImgModel *> * buyUserList;
@property (nonatomic , strong) NSNumber * commentNum;
@property (nonatomic , assign) CGFloat height;
@end

@interface LxmGoodsDetailRootModel : NSObject
@property (nonatomic , strong) NSNumber * key;
@property (nonatomic , strong) NSString * message;
@property (nonatomic , strong) LxmGoodsDetailModel * result;
@end

//获取约单人列表

@interface LxmBuyMyCanUserModel : NSObject

@property (nonatomic , strong) NSString *buyUserHead;
@property (nonatomic , strong) NSNumber *buyUserId;
@property (nonatomic , strong) NSString *buyUserNick;
@property (nonatomic , strong) NSNumber *number;
@property (nonatomic , strong) NSString *matchTime;
@property (nonatomic , strong) NSString *sendAddr;
@property (nonatomic , strong) NSNumber *state;
@property (nonatomic, assign) CGFloat cellHeight;

@end

@interface LxmBuyMyCanUserModel1 : NSObject
@property (nonatomic , strong) NSArray<LxmBuyMyCanUserModel *> * list;
@property (nonatomic , strong) NSString * time;
@end

@interface LxmBuyMyCanUserRootModel : NSObject
@property (nonatomic , strong) NSNumber * key;
@property (nonatomic , strong) NSString * message;
@property (nonatomic , strong) LxmBuyMyCanUserModel1 * result;
@end

//我的报名列表
@interface LxmMyTourListModel : NSObject

@property (nonatomic , strong) NSNumber * applyId;
@property (nonatomic , strong) NSString * pic;
@property (nonatomic , strong) NSString * title;
@property (nonatomic , strong) NSNumber * money;
@property (nonatomic , strong) NSString * createTime;
@property (nonatomic , strong) NSNumber * status;
@property (nonatomic , strong) NSString * name;
@property (nonatomic , strong) NSString * phone;
@property (nonatomic , strong) NSNumber * num;
@property (nonatomic , strong) NSString * remark;
@property (nonatomic , strong) NSNumber * allMoney;
@property (nonatomic , strong) NSNumber * payType;
@property (nonatomic , strong) NSString * payTime;

@end

@interface LxmMyTourListModel1 : NSObject
@property (nonatomic , strong) NSArray<LxmMyTourListModel *> * list;
@property (nonatomic , strong) NSString * time;
@end

@interface LxmMyTourListRootModel : NSObject
@property (nonatomic , strong) NSNumber * key;
@property (nonatomic , strong) NSString * message;
@property (nonatomic , strong) LxmMyTourListModel1 * result;
@end


@interface LxmMyTourDetailRootModel : NSObject

@property (nonatomic , strong) NSNumber * key;
@property (nonatomic , strong) NSString * message;
@property (nonatomic , strong) LxmMyTourListModel * result;

@end


//我的评价列表
@interface LxmMyEvaluateListModel : NSObject

@property (nonatomic , strong) NSNumber * evaUserId;
@property (nonatomic , strong) NSNumber * evaId;
@property (nonatomic , strong) NSString * evaUserHead;
@property (nonatomic , strong) NSNumber * evaUserSex;
@property (nonatomic , strong) NSString * evaUserNickname;
@property (nonatomic , strong) NSNumber * score;
@property (nonatomic , strong) NSString * createTime;
@property (nonatomic , strong) NSString * content;
@property (nonatomic , strong) NSString * img;
@property (nonatomic , strong) NSString * nearImg;
@property (nonatomic , strong) NSString * nearTitle;
@property (nonatomic , strong) NSNumber * nearId;
@property (nonatomic , assign) CGFloat height;

@end

@interface LxmMyEvaluateListModel1 : NSObject
@property (nonatomic , strong) NSArray<LxmMyEvaluateListModel *> * list;
@property (nonatomic , strong) NSString * time;
@end

@interface LxmMyEvaluateListRootModel : NSObject

@property (nonatomic , strong) NSNumber * key;
@property (nonatomic , strong) NSString * message;
@property (nonatomic , strong) LxmMyEvaluateListModel1 * result;
@property (nonatomic , assign) CGFloat height;

@end

//我的资产


@interface LxmMyAssetsInfoModel : NSObject

@property (nonatomic , strong) NSString * money;
@property (nonatomic , strong) NSString * income;
@property (nonatomic , strong) NSString * expend;

@end


@interface LxmMyAssetsInfoRootModel : NSObject

@property (nonatomic , strong) NSNumber * key;
@property (nonatomic , strong) NSString * message;
@property (nonatomic , strong) LxmMyAssetsInfoModel * result;

@end


@interface LxmMyConsumeModel : NSObject

@property (nonatomic , strong) NSNumber * type;
@property (nonatomic , strong) NSString * typeName;
@property (nonatomic , strong) NSString * money;
@property (nonatomic , strong) NSString * createTime;

@end

@interface LxmMyConsumeModel1 : NSObject

@property (nonatomic , strong) NSArray<LxmMyConsumeModel *> * list;
@property (nonatomic , strong) NSString * time;

@end

@interface LxmMyConsumeRootModel : NSObject

@property (nonatomic , strong) NSNumber * key;
@property (nonatomic , strong) NSString * message;
@property (nonatomic , strong) LxmMyConsumeModel1 * result;

@end

@interface LxmMyAddressModel : NSObject

@property (nonatomic , strong) NSNumber * addrId;
@property (nonatomic , strong) NSNumber * type;
@property (nonatomic , strong) NSString * name;
@property (nonatomic , strong) NSString * account;
@property (nonatomic , strong) NSString * bankName;

@end


@interface LxmMyAddressModel1 : NSObject

@property (nonatomic , strong) NSArray<LxmMyAddressModel *> * list;

@end

@interface LxmMyAddressRootModel : NSObject

@property (nonatomic , strong) NSNumber * key;
@property (nonatomic , strong) NSString * message;
@property (nonatomic , strong) LxmMyAddressModel1 * result;

@end

@interface LxmShareInfoModel : NSObject

@property (nonatomic , strong) NSString * url;
@property (nonatomic , strong) NSString * content;
@property (nonatomic , strong) NSString * title;
@property (nonatomic , strong) NSString * pic;

@end

@interface LxmOtherInfoModel : NSObject
@property (nonatomic , strong) NSNumber * otherUserID;
@property (nonatomic , strong) NSString * otherHead;
@property (nonatomic , strong) NSNumber * otherSex;
@property (nonatomic , strong) NSString * otherNickname;
@property (nonatomic , strong) NSNumber * otherGoodRate;
@property (nonatomic , strong) NSNumber * isFriend;
@property (nonatomic , strong) NSString * institute;
@property (nonatomic,  strong) NSString * schoolName;
@property (nonatomic , strong) NSNumber * type;

@end

@interface LxmMessageInfoModel : NSObject
@property (nonatomic , strong) NSNumber * isNewInter;
@property (nonatomic , strong) NSString * interMsgNum;
@property (nonatomic , strong) NSString * lastInterContent;
@property (nonatomic , strong) NSString * lastInterTime;
@property (nonatomic , strong) NSNumber * isNewSys;
@property (nonatomic , strong) NSNumber * sysMsgNum;
@property (nonatomic , strong) NSString * lastMsgTime;
@property (nonatomic , strong) NSString * lastMsgContent;

@end


@interface LxmNewFriendListModel : NSObject

@property (nonatomic , strong) NSNumber * friendId;
@property (nonatomic , strong) NSString * friendHead;
@property (nonatomic , strong) NSNumber * friendSex;
@property (nonatomic , strong) NSString * friendNickname;
@property (nonatomic , strong) NSNumber * friendGoodRate;

@end


@interface LxmNewFriendListModel1 : NSObject

@property (nonatomic , strong) NSNumber * friendNum;
@property (nonatomic , strong) NSArray<LxmNewFriendListModel *> * list;

@end


@interface LxmNewFriendListRootModel : NSObject

@property (nonatomic , strong) NSNumber * key;
@property (nonatomic , strong) NSString * message;
@property (nonatomic , strong) LxmNewFriendListModel1 * result;

@end

//添加新朋友

@interface LxmFindNewFriendListModel : NSObject

@property (nonatomic , strong) NSNumber * applyId;
@property (nonatomic , strong) NSNumber * inviteId;
@property (nonatomic , strong) NSString * inviteHead;
@property (nonatomic , strong) NSNumber * inviteSex;
@property (nonatomic , strong) NSString * inviteNickname;
@property (nonatomic , strong) NSString * content;
@property (nonatomic , strong) NSNumber * type;

@property (nonatomic , strong) NSNumber * serUserId;
@property (nonatomic , strong) NSString * headimg;
@property (nonatomic , strong) NSNumber * sex;
@property (nonatomic , strong) NSString * nickname;
@property (nonatomic , strong) NSNumber * isFriend;

@end


@interface LxmFindNewFriendListModel1 : NSObject

@property (nonatomic , strong) NSArray<LxmFindNewFriendListModel *> * list;

@end


@interface LxmFindNewFriendListRootModel : NSObject

@property (nonatomic , strong) NSNumber * key;
@property (nonatomic , strong) NSString * message;
@property (nonatomic , strong) LxmFindNewFriendListModel1 * result;

@end

//获取互动消息列表

@interface LxmFindInterMsgModel : NSObject

@property (nonatomic , strong) NSNumber * messageId;
@property (nonatomic , strong) NSNumber * otherUserId;
@property (nonatomic , strong) NSString * otherUserHead;
@property (nonatomic , strong) NSString * otherUserNickname;
@property (nonatomic , strong) NSString * title;
@property (nonatomic , strong) NSString * content;
@property (nonatomic , strong) NSString * createTime;
@property (nonatomic , strong) NSNumber * type;
@property (nonatomic , strong) NSNumber * otherId;
@property (nonatomic , strong) NSString * otherContent;
@property (nonatomic , strong) NSNumber * isRead;
@property (nonatomic , assign) CGFloat height;
@end

@interface LxmFindInterMsgModel1 : NSObject

@property (nonatomic , strong) NSArray<LxmFindInterMsgModel *> * list;
@property (nonatomic , strong) NSString * time;

@end

@interface LxmFindInterMsgRootModel : NSObject

@property (nonatomic , strong) NSNumber * key;
@property (nonatomic , strong) NSString * message;
@property (nonatomic , strong) LxmFindInterMsgModel1 * result;

@end

@interface LxmHuanXinModel : NSObject
@property (nonatomic , strong) NSString * nickname;
@property (nonatomic , strong) NSString * headimg;
@property (nonatomic , strong) NSNumber * sex;
@property (nonatomic , strong) NSNumber * userId;
@end

@interface LxmAccountInfoModel : NSObject
@property (nonatomic , strong) NSString * phone;
@property (nonatomic , strong) NSString * alipay;
@property (nonatomic , strong) NSString * weChat;
@property (nonatomic , strong) NSString * QQ;
@end
