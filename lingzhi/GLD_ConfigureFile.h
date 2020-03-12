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
#define expressRequest @"api/version/delivery"//抢单列表 1（0，总的）
#define sendExpressRequest @"api/version/addDelivery"//发布快递 1
#define robExpressRequest @"api/version/deliveryState"//抢单 1
#define sendGoodsRequest @"api/version/addProduct"//发布商品 1
#define sendCommentRequest @"api/comment/addComment"//发布评论 1
#define getCommentListRequest @"api/comment/getComments"//获取评论列表 1
#define getShopGoodsListRequest @"api/version/getShopGoods"//获取商家商品列表 1
#define getRedPointRequest @"api/version/isHaveNewMessagePoint"//红点接口 1
#define scorePayGoodsRequest @"api/version/payGoods"//积分商城商品支付 1
#define wxPayGoodsRequest @"api/wx/weixinPay"//代金券商城商品支付
#define deleteGoodsRequest @"api/version/deleteProduct"//删除商品
#define mailAdressRequest @""//邮寄地址
#define getGoodsCategory @"api/version/goodCategory"//商品分类
#define getGoodsListWithCategory @"api/version/categoryWithGoods"//分类商品
#define getShareListRequest @"api/version/categoryWithApps"//共享应用
#define deliveryCategoryRequest @"api/version/deliveryCategory"//a跑腿四张图


#define orderDetailRequest @"api/order/orderInfo"//订单详情

#define shopCateList       @"api/shop/goodsClassify"//商品分类列表
#define ShopAddCate        @"api/shop/addGoodsClassify"//新增商品分类
#define ShopDeleteCate     @"api/shop/delGoodsClassify"//删除分类
#define shopChangeCate     @"api/shop/editGoodsClassify" //修改分类


#define shopDetailUrl     @"http://www.hhlmcn.com/shop/?shopId="
#define KEYWINDOW       [[UIApplication sharedApplication] keyWindow]
#endif /* GLD_ConfigureFile_h */
