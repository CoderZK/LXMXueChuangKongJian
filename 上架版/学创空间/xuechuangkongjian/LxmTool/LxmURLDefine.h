//
//  LxmURLDefine.h
//  JawboneUP
//
//  Created by 李晓满 on 2017/11/7.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Base_URL @"https://mobile.xuechuangkongjian.com/mag/"
#define Base_Img_URL @"https://mobile.xuechuangkongjian.com/mag/downloadFile.do?id="

//#define Base_URL @"http://192.168.0.103:8080/mag/"

@interface LxmURLDefine : NSObject

/**
 获取图片地址
 */
+(NSString *)getPicImgWthPicStr:(NSString *)pic;

/**
 获取分享信息
 */
+(NSString *)app_shareInfo;

/**
 举报
 */
+(NSString *)user_report;

/**
 发送验证码接口
 */
+ (NSString *)app_sendMobile;
/**
 上传用户设备信息
 */
+ (NSString *)user_upUmeng;
/**
 注册接口
 */
+ (NSString *)app_register;
/**
 检查资料是否完善
 */
+ (NSString *)user_hasPerfect;
/**
 登录接口
 */
+ (NSString *)app_login;

/**
 第三方登录接口
 */
+ (NSString *)app_three_login;

/**
 获取个人信息
 */
+ (NSString *)user_getMyInfo;

/**
 完善信息
 */
+ (NSString *)user_editUserInfo;
/**
 获取城市列表
 */
+ (NSString *)app_findCityList;
/**
 根据城市获取学校列表
 */
+ (NSString *)app_findSchoolList;
/**
 获取定位城市id
 */
+ (NSString *)app_getLocationId;
/**
 用户协议
 */
+ (NSString *)app_getBaseInfo;
/**
忘记密码
 */
+ (NSString *)app_findPassword;
/**
 获取banner列表
 */
+ (NSString *)user_findBannerList;
/**
 获取Banner富文本详情
 */
+ (NSString *)user_findBannerInfo;
/**
 获取八大模块信息
 */
+ (NSString *)user_findMuduleList;

/**
 获取发布类型列表
 */
+ (NSString *)user_findReleaseTypeList;
/**
 退出登录
 */
+ (NSString *)user_logout;

/**
发布抢活
 */
+ (NSString *)user_releaseHelp;
/**
 发布校园商家
 */
+ (NSString *)user_releaseCan;
/**
 获取我的资产信息
 */
+ (NSString *)user_getMyAssetsInfo;

/**
 支付抢活订单
 */
+ (NSString *)user_payHelpOrder;
/**
 获取首页抢活列表
 */
+ (NSString *)user_findIndexHelpList;
/**
 获取抢活任务详情
 */
+ (NSString *)user_getHelpInfo;

/**
 获取校园商家分类列表
 */
+ (NSString *)user_findCanTypeList;

/**
 获取校园商家列表
 */
+ (NSString *)user_findCanList;
/**
根据类型获取抢活列表
 */
+ (NSString *)user_findHelpListFromType;
/**
 留言任务
 */
+ (NSString *)user_insertBillComment;
/**
 获取任务留言列表
 */
+ (NSString *)user_findBillCommentList;
/**
 回复任务留言
 */
+ (NSString *)user_insertBillReply;
/**
 删除回复
 */
+ (NSString *)user_deleteBillReply;
/**
 删除任务留言
 */
+ (NSString *)user_deleteBillComment;
/**
 任务列表/详情 点赞
 */
+ (NSString *)user_likeBill;
/**
 抢活报名抢单
 */
+ (NSString *)user_enrollHelp;
/**
 获取我发布的活
 */
+ (NSString *)user_findMyHelpList;

/**
 获取抢单人列表
 */
+ (NSString *)user_findRobHelpUserList;

/**
 取消我发布的活订单
 */
+ (NSString *)user_cannelMyRelHelp;

/**
 选择抢单人
 */
+ (NSString *)user_choiceHelpUser;
/**
 获取抢活承接人列表
 */
+ (NSString *)user_findHelpUserList;
/**
 完成我发布的活订单
 */
+ (NSString *)user_finishMyRelHelp;

/**
 评价承接人
 */
+ (NSString *)user_evaHelpUser;

/**
获取我抢的活列表
 */
+ (NSString *)user_findMyRobHelpList;
/**
 取消我抢的活订单
 */
+ (NSString *)user_cannelMyRobHelp;
/**
 完成我抢的活订单
 */
+ (NSString *)user_finishMyRobHelp;

/**
 查看我抢的活评价
 */
+ (NSString *)user_getMyRobHelpEva;
/**
 删除我抢的活订单
 */
+ (NSString *)user_deleteMyRobHelp;

/**
 根据类型获取文章列表
 */
+ (NSString *)user_findArticleListFromType;
/**
 获取文章详情
 */
+ (NSString *)user_getArticleInfo;
/**
 留言文章
 */
+ (NSString *)user_insertArticleComment;
/**
 获取文章留言列表
 */
+ (NSString *)user_findArticleCommentList;

/**
 点赞、取消点赞文章相关
 */
+ (NSString *)user_likeArticle;
/**
 收藏、取消收藏文章
 */
+ (NSString *)user_collectArticle;

/**
 删除文章留言
 */
+ (NSString *)user_deleteArticleComment;
/**
 回复文章留言
 */
+ (NSString *)user_insertArticleReply;
/**
 删除文章留言回复
 */
+ (NSString *)user_deleteArticleReply;

/**
 提交旅游报名订单
 */
+ (NSString *)user_insertTourOrder;
/**
 支付旅游报名订单
 */
+ (NSString *)user_payTourOrder;

/**
 根据类型获取周边列表
 */
+ (NSString *)user_findNearList;

/**
 获取周边详情
 */
+ (NSString *)user_getNearInfo;
/**
 评价周边
 */
+ (NSString *)user_evaluateNear;

/**
 获取周边评价列表
 */
+ (NSString *)user_findNearEvaList;

/**
 获取电商分类列表
 */
+ (NSString *)user_findECTypeList;
/**
 获取电商列表
 */
+ (NSString *)user_findECList;
/**
 获取商品详情
 */
+ (NSString *)user_getECInfo;

/**
 获取商品留言列表
 */
+ (NSString *)user_findECCommentList;
/**
 留言商品
 */
+ (NSString *)user_insertECComment;
/**
 删除商品留言
 */
+ (NSString *)user_deleteECComment;
/**
 回复商品留言
 */
+ (NSString *)user_insertECReply;

/**
 删除商品留言回复
 */
+ (NSString *)user_deleteECReply;

/**
 点赞、取消点赞商品相关
 */
+ (NSString *)user_likeEC;
/**
 提交商品购买订单
 */
+ (NSString *)user_insertECOrder;
/**
 支付商品订单
 */
+ (NSString *)user_payECOrder;
/**
 获取校园商家详情
 */
+ (NSString *)user_getCanInfo;
/**
 提交校园商家订单
 */
+ (NSString *)user_insertCanOrder;
/**
 支付校园商家订单
 */
+ (NSString *)user_payCanOrder;

/**
 获取我发布的技能列表
 */
+ (NSString *)user_findMyCanList;
/**
 上、下架技能
 */
+ (NSString *)user_editMyCan;

/**
 获取约单人列表
 */
+ (NSString *)user_findBuyMyCanUserList;
/**
 删除技能
 */
+ (NSString *)user_deleteMyCan;
/**
 获取我购买的技能列表
 */
+ (NSString *)user_findMyBuyCanList;
/**
 确认收货商品订单
 */
+ (NSString *)user_confirmMyCan;

/**
 删除我购买技能订单
 */
+ (NSString *)user_deleteMyBuyCan;
/**
 获取我购买的商品列表
 */
+ (NSString *)user_findMyECList;
/**
 删除订单
 */
+ (NSString *)user_deleteMyEC;

/**
 确认收货商品订单
 */
+ (NSString *)user_confirmMyEC;
/**
 获取我的报名列表
 */
+ (NSString *)user_findMyTourList;
/**
 获取我报名的订单详情
 */
+ (NSString *)user_getMyTourInfo;
/**
 删除我报名的订单
 */
+ (NSString *)user_deleteMyTour;

/**
 关闭我报名的订单
 */
+ (NSString *)user_closeMyTour;
/**
 获取我的评价列表
 */
+ (NSString *)user_findMyEvaList;
/**
 删除我的评价
 */
+ (NSString *)user_deleteMyEva;
/**
 获取我的收藏列表
 */
+ (NSString *)user_findMyCollectList;

/**
 获取账单记录
 */
+ (NSString *)user_findMyConsumeList;
/**
 新增提现地址
 */
+ (NSString *)user_insertCashAddress;
/**
 获取提现地址列表
 */
+ (NSString *)user_findCashAddressList;

/**
 修改提现地址
 */
+ (NSString *)user_updateCashAddress;

/**
 删除提现地址
 */
+ (NSString *)user_deleteCashAddress;

/**
 提交提现申请
 */
+ (NSString *)user_insertCashLog;
/**
 修改个人信息
 */
+ (NSString *)user_editMyInfo;

/**
 获取我收到的评价列表
 */
+ (NSString *)user_findMyRecEvaList;


/**
 查看他人的主页信息
 */
+ (NSString *)user_getOthersInfo;
/**
 查看他人的发布的活儿信息
 */
+ (NSString *)user_findOthersHelpList;
/**
 查看他人发布的技能
 */
+ (NSString *)user_findOthersCanList;
/**
 查看他人收到的评价
 */
+ (NSString *)user_findOthersRecEva;
/**
 申请添加好友
 */
+ (NSString *)user_applyFriend;

/**
 获取消息列表信息
 */
+ (NSString *)user_findMsgList;
/**
 获取朋友列表
 */
+ (NSString *)user_findFriendList;

/**
 获取新朋友列表
 */
+ (NSString *)user_findNewFriendList;
/**
 通过好友申请
 */
+ (NSString *)user_agreeFriendApply;
/**
 获取互动消息
 */
+ (NSString *)user_findInteractMsgList;
/**
 获取系统消息
 */
+ (NSString *)user_findSystemMsgList;
/**
 添加好友
 */
+ (NSString *)user_findUserList;

/**
 获取用户环信信息
 */
+ (NSString *)user_getUserInfoFromHX;
/**
 获取账号信息
 */
+ (NSString *)user_getAccountInfo;
/**
 绑定第三方
 */
+ (NSString *)user_bindingThree;
/**
 将消息设为已读
 */
+ (NSString *)user_editMsg;

/**
 芝麻认证
 */
+ (NSString *)zhima_initialize;
/**
 绑定手机号
 */
+ (NSString *)user_bindingPhone;
/**
 验证旧手机
 */
+ (NSString *)user_validateOldPhone;
/**
 绑定新手机
 */
+ (NSString *)user_bindingNewPhone;


#pragma --mark 游客登录 校园商家 新改接口
/**
 获取校园商家分类列表
 */
+ (NSString *)user_findSkillTypeList;
/**
 获取校园商家列表
 */
+ (NSString *)user_findSkillList;
/**
 获取校园商家详情
 */
+ (NSString *)user_getSkillInfo;
/**
 获取校园商家留言列表
 */
+ (NSString *)user_findSkillCommentList;

/**
 屏蔽用户
 */
#define  user_shield  Base_URL"user_shield.do"

@end
