//
//  LxmURLDefine.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/11/7.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmURLDefine.h"

@implementation LxmURLDefine

/**
 获取图片地址
 */
+(NSString *)getPicImgWthPicStr:(NSString *)pic{
    NSString * picStr = @"";
    if (pic) {
        if ([pic hasPrefix:@"http:"]) {
            picStr = pic;
        }else{
            picStr = [Base_Img_URL stringByAppendingString:pic];
        }
    }
    return picStr;
}
/**
 获取分享信息
 */
+(NSString *)app_shareInfo{
    return [Base_URL stringByAppendingString:@"app_shareInfo.do"];
}

/**
 举报
 */
+(NSString *)user_report{
    return [Base_URL stringByAppendingString:@"user_report.do"];
}

/**
 发送验证码接口
 */
+ (NSString *)app_sendMobile{
    return [Base_URL stringByAppendingString:@"app_sendMobile.do"];
}
/**
 上传用户设备信息
 */
+ (NSString *)user_upUmeng{
    return [Base_URL stringByAppendingString:@"user_upUmeng.do"];
}
/**
 注册接口
 */
+ (NSString *)app_register{
    return [Base_URL stringByAppendingString:@"app_register.do"];
}

/**
 检查资料是否完善
 */
+ (NSString *)user_hasPerfect{
    return [Base_URL stringByAppendingString:@"user_hasPerfect.do"];
}
/**
 登录接口
 */
+ (NSString *)app_login{
    return [Base_URL stringByAppendingString:@"app_login.do"];
}
/**
 第三方登录接口
 */
+ (NSString *)app_three_login{
    return [Base_URL stringByAppendingString:@"app_three_login.do"];
}
/**
 获取个人信息
 */
+ (NSString *)user_getMyInfo{
    return [Base_URL stringByAppendingString:@"user_getMyInfo.do"];
}
/**
 完善信息
 */
+ (NSString *)user_editUserInfo{
    return [Base_URL stringByAppendingString:@"user_editUserInfo.do"];
}
/**
 获取城市列表
 */
+ (NSString *)app_findCityList{
    return [Base_URL stringByAppendingString:@"app_findCityList.do"];
}
/**
 根据城市获取学校列表
 */
+ (NSString *)app_findSchoolList{
    return [Base_URL stringByAppendingString:@"app_findSchoolList.do"];
}
/**
 获取定位城市id
 */
+ (NSString *)app_getLocationId{
    return [Base_URL stringByAppendingString:@"app_getLocationId.do"];
}
/**
 用户协议
 */
+ (NSString *)app_getBaseInfo{
    return [Base_URL stringByAppendingString:@"app_getBaseInfo.do"];
}
/**
 忘记密码
 */
+ (NSString *)app_findPassword{
    return [Base_URL stringByAppendingString:@"app_findPassword.do"];
}
/**
 获取banner列表
 */
+ (NSString *)user_findBannerList{
     return [Base_URL stringByAppendingString:@"user_findBannerList.do"];
}
/**
 获取Banner富文本详情
 */
+ (NSString *)user_findBannerInfo{
    return [Base_URL stringByAppendingString:@"user_findBannerInfo.do"];
}
/**
 获取八大模块信息
 */
+ (NSString *)user_findMuduleList{
    return [Base_URL stringByAppendingString:@"user_findMuduleList.do"];
}
/**
 获取发布类型列表
 */
+ (NSString *)user_findReleaseTypeList{
    return [Base_URL stringByAppendingString:@"user_findReleaseTypeList.do"];
}
/**
 退出登录
 */
+ (NSString *)user_logout{
    return [Base_URL stringByAppendingString:@"user_logout.do"];
}
/**
 发布抢活
 */
+ (NSString *)user_releaseHelp{
    return [Base_URL stringByAppendingString:@"user_releaseHelp.do"];
}
/**
 发布校园商家
 */
+ (NSString *)user_releaseCan{
    return [Base_URL stringByAppendingString:@"user_releaseCan.do"];
}
/**
 获取我的资产信息
 */
+ (NSString *)user_getMyAssetsInfo{
    return [Base_URL stringByAppendingString:@"user_getMyAssetsInfo.do"];
}
/**
 支付抢活订单
 */
+ (NSString *)user_payHelpOrder{
    return [Base_URL stringByAppendingString:@"user_payHelpOrder.do"];
}

/**
 获取首页抢活列表
 */
+ (NSString *)user_findIndexHelpList{
    return [Base_URL stringByAppendingString:@"user_findIndexHelpList.do"];
}
/**
 获取抢活任务详情
 */
+ (NSString *)user_getHelpInfo{
    return [Base_URL stringByAppendingString:@"user_getHelpInfo.do"];
}
/**
 获取校园商家分类列表
 */
+ (NSString *)user_findCanTypeList{
    return [Base_URL stringByAppendingString:@"user_findCanTypeList.do"];
}
/**
 获取校园商家列表
 */
+ (NSString *)user_findCanList{
    return [Base_URL stringByAppendingString:@"user_findCanList.do"];
}
/**
 根据类型获取抢活列表
 */
+ (NSString *)user_findHelpListFromType{
    return [Base_URL stringByAppendingString:@"user_findHelpListFromType.do"];
}
/**
 留言任务
 */
+ (NSString *)user_insertBillComment{
    return [Base_URL stringByAppendingString:@"user_insertBillComment.do"];
}
/**
 获取任务留言列表
 */
+ (NSString *)user_findBillCommentList{
    return [Base_URL stringByAppendingString:@"user_findBillCommentList.do"];
}
/**
 回复任务留言
 */
+ (NSString *)user_insertBillReply{
    return [Base_URL stringByAppendingString:@"user_insertBillReply.do"];
}
/**
 删除回复
 */
+ (NSString *)user_deleteBillReply{
    return [Base_URL stringByAppendingString:@"user_deleteBillReply.do"];
}
/**
 删除任务留言
 */
+ (NSString *)user_deleteBillComment{
    return [Base_URL stringByAppendingString:@"user_deleteBillComment.do"];
}
/**
 任务列表/详情 点赞
 */
+ (NSString *)user_likeBill{
    return [Base_URL stringByAppendingString:@"user_likeBill.do"];
}
/**
 抢活报名抢单
 */
+ (NSString *)user_enrollHelp{
    return [Base_URL stringByAppendingString:@"user_enrollHelp.do"];
}
/**
 获取我发布的活
 */
+ (NSString *)user_findMyHelpList{
    return [Base_URL stringByAppendingString:@"user_findMyHelpList.do"];
}
/**
 获取抢单人列表
 */
+ (NSString *)user_findRobHelpUserList{
    return [Base_URL stringByAppendingString:@"user_findRobHelpUserList.do"];
}
/**
 取消我发布的活订单
 */
+ (NSString *)user_cannelMyRelHelp{
    return [Base_URL stringByAppendingString:@"user_cannelMyRelHelp.do"];
}
/**
 选择抢单人
 */
+ (NSString *)user_choiceHelpUser{
    return [Base_URL stringByAppendingString:@"user_choiceHelpUser.do"];
}
/**
 获取抢活承接人列表
 */
+ (NSString *)user_findHelpUserList{
    return [Base_URL stringByAppendingString:@"user_findHelpUserList.do"];
}
/**
 完成我发布的活订单
 */
+ (NSString *)user_finishMyRelHelp{
    return [Base_URL stringByAppendingString:@"user_finishMyRelHelp.do"];
}
/**
 评价承接人
 */
+ (NSString *)user_evaHelpUser{
    return [Base_URL stringByAppendingString:@"user_evaHelpUser.do"];
}
/**
 获取我抢的活列表
 */
+ (NSString *)user_findMyRobHelpList{
    return [Base_URL stringByAppendingString:@"user_findMyRobHelpList.do"];
}
/**
 取消我抢的活订单
 */
+ (NSString *)user_cannelMyRobHelp{
    return [Base_URL stringByAppendingString:@"user_cannelMyRobHelp.do"];
}
/**
 完成我抢的活订单
 */
+ (NSString *)user_finishMyRobHelp{
    return [Base_URL stringByAppendingString:@"user_finishMyRobHelp.do"];
}
/**
 查看我抢的活评价
 */
+ (NSString *)user_getMyRobHelpEva{
     return [Base_URL stringByAppendingString:@"user_getMyRobHelpEva.do"];
}
/**
 删除我抢的活订单
 */
+ (NSString *)user_deleteMyRobHelp{
    return [Base_URL stringByAppendingString:@"user_deleteMyRobHelp.do"];
}
/**
 根据类型获取文章列表
 */
+ (NSString *)user_findArticleListFromType{
    return [Base_URL stringByAppendingString:@"user_findArticleListFromType.do"];
}
/**
 获取文章详情
 */
+ (NSString *)user_getArticleInfo{
    return [Base_URL stringByAppendingString:@"user_getArticleInfo.do"];
}
/**
 留言文章
 */
+ (NSString *)user_insertArticleComment{
    return [Base_URL stringByAppendingString:@"user_insertArticleComment.do"];
}
/**
 获取文章留言列表
 */
+ (NSString *)user_findArticleCommentList{
     return [Base_URL stringByAppendingString:@"user_findArticleCommentList.do"];
}
/**
 点赞、取消点赞文章相关
 */
+ (NSString *)user_likeArticle{
    return [Base_URL stringByAppendingString:@"user_likeArticle.do"];
}
/**
 收藏、取消收藏文章
 */
+ (NSString *)user_collectArticle{
    return [Base_URL stringByAppendingString:@"user_collectArticle.do"];
}
/**
 删除文章留言
 */
+ (NSString *)user_deleteArticleComment{
    return [Base_URL stringByAppendingString:@"user_deleteArticleComment.do"];
}
/**
 删除文章留言回复
 */
+ (NSString *)user_deleteArticleReply{
    return [Base_URL stringByAppendingString:@"user_deleteArticleReply.do"];
}
/**
 回复文章留言
 */
+ (NSString *)user_insertArticleReply{
    return [Base_URL stringByAppendingString:@"user_insertArticleReply.do"];
}
/**
 提交旅游报名订单
 */
+ (NSString *)user_insertTourOrder{
    return [Base_URL stringByAppendingString:@"user_insertTourOrder.do"];
}
/**
 支付旅游报名订单
 */
+ (NSString *)user_payTourOrder{
    return [Base_URL stringByAppendingString:@"user_payTourOrder.do"];
}
/**
 根据类型获取周边列表
 */
+ (NSString *)user_findNearList{
    return [Base_URL stringByAppendingString:@"user_findNearList.do"];
}
/**
 获取周边详情
 */
+ (NSString *)user_getNearInfo{
    return [Base_URL stringByAppendingString:@"user_getNearInfo.do"];
}
/**
 评价周边
 */
+ (NSString *)user_evaluateNear{
    return [Base_URL stringByAppendingString:@"user_evaluateNear.do"];
}

/**
 获取周边评价列表
 */
+ (NSString *)user_findNearEvaList{
    return [Base_URL stringByAppendingString:@"user_findNearEvaList.do"];
}

/**
 获取电商分类列表
 */
+ (NSString *)user_findECTypeList{
    return [Base_URL stringByAppendingString:@"user_findECTypeList.do"];
}
/**
 获取电商列表
 */
+ (NSString *)user_findECList{
    return [Base_URL stringByAppendingString:@"user_findECList.do"];
}
/**
 获取商品详情
 */
+ (NSString *)user_getECInfo{
    return [Base_URL stringByAppendingString:@"user_getECInfo.do"];
}
/**
 获取商品留言列表
 */
+ (NSString *)user_findECCommentList{
    return [Base_URL stringByAppendingString:@"user_findECCommentList.do"];
}

/**
 留言商品
 */
+ (NSString *)user_insertECComment{
    return [Base_URL stringByAppendingString:@"user_insertECComment.do"];
}
/**
 删除商品留言
 */
+ (NSString *)user_deleteECComment{
    return [Base_URL stringByAppendingString:@"user_deleteECComment.do"];
}

/**
 回复商品留言
 */
+ (NSString *)user_insertECReply{
    return [Base_URL stringByAppendingString:@"user_insertECReply.do"];
}

/**
 删除商品留言回复
 */
+ (NSString *)user_deleteECReply{
    return [Base_URL stringByAppendingString:@"user_deleteECReply.do"];
}
/**
 点赞、取消点赞商品相关
 */
+ (NSString *)user_likeEC{
    return [Base_URL stringByAppendingString:@"user_likeEC.do"];
}
/**
 提交商品购买订单
 */
+ (NSString *)user_insertECOrder{
    return [Base_URL stringByAppendingString:@"user_insertECOrder.do"];
}
/**
 支付商品订单
 */
+ (NSString *)user_payECOrder{
    return [Base_URL stringByAppendingString:@"user_payECOrder.do"];
}
/**
 获取校园商家详情
 */
+ (NSString *)user_getCanInfo{
    return [Base_URL stringByAppendingString:@"user_getCanInfo.do"];
}
/**
 提交校园商家订单
 */
+ (NSString *)user_insertCanOrder{
    return [Base_URL stringByAppendingString:@"user_insertCanOrder.do"];
}
/**
 支付校园商家订单
 */
+ (NSString *)user_payCanOrder{
    return [Base_URL stringByAppendingString:@"user_payCanOrder.do"];
}

/**
 获取我发布的技能列表
 */
+ (NSString *)user_findMyCanList{
    return [Base_URL stringByAppendingString:@"user_findMyCanList.do"];
}

/**
 上、下架技能
 */
+ (NSString *)user_editMyCan{
    return [Base_URL stringByAppendingString:@"user_editMyCan.do"];
}
/**
 获取约单人列表
 */
+ (NSString *)user_findBuyMyCanUserList{
    return [Base_URL stringByAppendingString:@"user_findBuyMyCanUserList.do"];
}
/**
 删除技能
 */
+ (NSString *)user_deleteMyCan{
    return [Base_URL stringByAppendingString:@"user_deleteMyCan.do"];
}

/**
 获取我购买的技能列表
 */
+ (NSString *)user_findMyBuyCanList{
    return [Base_URL stringByAppendingString:@"user_findMyBuyCanList.do"];
}
/**
 确认收货商品订单
 */
+ (NSString *)user_confirmMyCan{
    return [Base_URL stringByAppendingString:@"user_confirmMyCan.do"];
}
/**
 删除商品订单
 */
+ (NSString *)user_deleteMyBuyCan{
    return [Base_URL stringByAppendingString:@"user_deleteMyBuyCan.do"];
}

/**
 获取我购买的商品列表
 */
+ (NSString *)user_findMyECList{
    return [Base_URL stringByAppendingString:@"user_findMyECList.do"];
}

/**
 删除订单
 */
+ (NSString *)user_deleteMyEC{
    return [Base_URL stringByAppendingString:@"user_deleteMyEC.do"];
}

/**
 确认收货商品订单 
 */
+ (NSString *)user_confirmMyEC{
    return [Base_URL stringByAppendingString:@"user_confirmMyEC.do"];
}
/**
 获取我的报名列表
 */
+ (NSString *)user_findMyTourList{
    return [Base_URL stringByAppendingString:@"user_findMyTourList.do"];
}
/**
 获取我报名的订单详情
 */
+ (NSString *)user_getMyTourInfo{
    return [Base_URL stringByAppendingString:@"user_getMyTourInfo.do"];
}
/**
 删除我报名的订单
 */
+ (NSString *)user_deleteMyTour{
    return [Base_URL stringByAppendingString:@"user_deleteMyTour.do"];
}
/**
 关闭我报名的订单
 */
+ (NSString *)user_closeMyTour{
    return [Base_URL stringByAppendingString:@"user_closeMyTour.do"];
}
/**
 获取我的评价列表
 */
+ (NSString *)user_findMyEvaList{
    return [Base_URL stringByAppendingString:@"user_findMyEvaList.do"];
}
/**
 删除我的评价
 */
+ (NSString *)user_deleteMyEva{
    return [Base_URL stringByAppendingString:@"user_deleteMyEva.do"];
}
/**
 获取我的收藏列表
 */
+ (NSString *)user_findMyCollectList{
    return [Base_URL stringByAppendingString:@"user_findMyCollectList.do"];
}
/**
 获取账单记录
 */
+ (NSString *)user_findMyConsumeList{
    return [Base_URL stringByAppendingString:@"user_findMyConsumeList.do"];
}
/**
 新增提现地址
 */
+ (NSString *)user_insertCashAddress{
    return [Base_URL stringByAppendingString:@"user_insertCashAddress.do"];
}
/**
 获取提现地址列表
 */
+ (NSString *)user_findCashAddressList{
    return [Base_URL stringByAppendingString:@"user_findCashAddressList.do"];
}
/**
 修改提现地址
 */
+ (NSString *)user_updateCashAddress{
    return [Base_URL stringByAppendingString:@"user_updateCashAddress.do"];
}
/**
 删除提现地址
 */
+ (NSString *)user_deleteCashAddress{
     return [Base_URL stringByAppendingString:@"user_deleteCashAddress.do"];
}
/**
 提交提现申请
 */
+ (NSString *)user_insertCashLog{
    return [Base_URL stringByAppendingString:@"user_insertCashLog.do"];
}
/**
 修改个人信息
 */
+ (NSString *)user_editMyInfo{
     return [Base_URL stringByAppendingString:@"user_editMyInfo.do"];
}
/**
 获取我收到的评价列表
 */
+ (NSString *)user_findMyRecEvaList{
    return [Base_URL stringByAppendingString:@"user_findMyRecEvaList.do"];
}
/**
 查看他人的主页信息
 */
+ (NSString *)user_getOthersInfo{
    return [Base_URL stringByAppendingString:@"user_getOthersInfo.do"];
}
/**
 查看他人的发布的活儿信息
 */
+ (NSString *)user_findOthersHelpList{
    return [Base_URL stringByAppendingString:@"user_findOthersHelpList.do"];
}
/**
 查看他人发布的技能
 */
+ (NSString *)user_findOthersCanList{
    return [Base_URL stringByAppendingString:@"user_findOthersCanList.do"];
}
/**
 查看他人收到的评价
 */
+ (NSString *)user_findOthersRecEva{
    return [Base_URL stringByAppendingString:@"user_findOthersRecEva.do"];
}
/**
 申请添加好友
 */
+ (NSString *)user_applyFriend{
    return [Base_URL stringByAppendingString:@"user_applyFriend.do"];
}

/**
 获取消息列表信息
 */
+ (NSString *)user_findMsgList{
    return [Base_URL stringByAppendingString:@"user_findMsgList.do"];
}
/**
 获取朋友列表
 */
+ (NSString *)user_findFriendList{
    return [Base_URL stringByAppendingString:@"user_findFriendList.do"];
}
/**
 获取新朋友列表
 */
+ (NSString *)user_findNewFriendList{
    return [Base_URL stringByAppendingString:@"user_findNewFriendList.do"];
}
/**
 通过好友申请
 */
+ (NSString *)user_agreeFriendApply{
    return [Base_URL stringByAppendingString:@"user_agreeFriendApply.do"];
}
/**
 获取互动消息
 */
+ (NSString *)user_findInteractMsgList{
    return [Base_URL stringByAppendingString:@"user_findInteractMsgList.do"];
}
/**
 获取系统消息
 */
+ (NSString *)user_findSystemMsgList{
     return [Base_URL stringByAppendingString:@"user_findSystemMsgList.do"];
}
/**
 添加好友
 */
+ (NSString *)user_findUserList{
    return [Base_URL stringByAppendingString:@"user_findUserList.do"];
}
/**
 获取用户环信信息
 */
+ (NSString *)user_getUserInfoFromHX{
    return [Base_URL stringByAppendingString:@"user_getUserInfoFromHX.do"];
}
/**
 获取账号信息
 */
+ (NSString *)user_getAccountInfo{
    return [Base_URL stringByAppendingString:@"user_getAccountInfo.do"];
}
/**
 绑定第三方
 */
+ (NSString *)user_bindingThree{
    return [Base_URL stringByAppendingString:@"user_bindingThree.do"];
}
/**
 将消息设为已读
 */
+ (NSString *)user_editMsg{
    return [Base_URL stringByAppendingString:@"user_editMsg.do"];
}

/**
 芝麻认证
 */
+ (NSString *)zhima_initialize{
    return [Base_URL stringByAppendingString:@"zhima_initialize.do"];
}
/**
 绑定手机号
 */
+ (NSString *)user_bindingPhone{
    return [Base_URL stringByAppendingString:@"user_bindingPhone.do"];
}
/**
 验证旧手机
 */
+ (NSString *)user_validateOldPhone{
    return [Base_URL stringByAppendingString:@"user_validateOldPhone.do"];
}
/**
 绑定新手机
 */
+ (NSString *)user_bindingNewPhone{
    return [Base_URL stringByAppendingString:@"user_bindingNewPhone.do"];
}

#pragma --mark 游客登录 校园商家 新改接口
/**
 获取校园商家分类列表
 */
+ (NSString *)user_findSkillTypeList {
    return [Base_URL stringByAppendingString:@"user_findSkillTypeList.do"];
}
/**
 获取校园商家列表
 */
+ (NSString *)user_findSkillList {
    return [Base_URL stringByAppendingString:@"user_findSkillList.do"];
}
/**
 获取校园商家详情
 */
+ (NSString *)user_getSkillInfo {
    return [Base_URL stringByAppendingString:@"user_getSkillInfo.do"];
}
/**
 获取校园商家留言列表
 */
+ (NSString *)user_findSkillCommentList {
    return [Base_URL stringByAppendingString:@"user_findSkillCommentList.do"];
}
@end
