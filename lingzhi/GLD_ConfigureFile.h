//
//  GLD_ConfigureFile.h
//  lingzhi
//
//  Created by yiyangkeji on 2018/7/30.
//  Copyright © 2018年 com.lingzhi. All rights reserved.
//

#ifndef GLD_ConfigureFile_h
#define GLD_ConfigureFile_h

//网络请求
//商品相关
#define inviteSomeBodyRequest @"api/version/getIntegralHistory"//推荐会员收入 1
#define storeListRequest @"api/version/getshangcheng"//商城商品列表 1
#define expressRequest @"api/version/delivery"//抢单列表 1
#define sendExpressRequest @"api/version/addDelivery"//发布快递 1
#define robExpressRequest @"api/version/deliveryState"//抢单
#define sendGoodsRequest @"api/version/addProduct"//发布商品 1
#define sendCommentRequest @"api/comment/addComment"//发布评论 1
#define getCommentListRequest @"api/comment/getComments"//获取评论列表 1
#define getShopGoodsListRequest @"api/version/getShopGoods"//获取商家商品列表 1
#define getRedPointRequest @"api/version/isHaveNewMessagePoint"//红点接口 1
#define scorePayGoodsRequest @"api/version/payGoods"//积分商城商品支付 1
#define wxPayGoodsRequest @"api/wx/weixinPay"//代金券商城商品支付
#define mailAdressRequest @""//邮寄地址

#endif /* GLD_ConfigureFile_h */
