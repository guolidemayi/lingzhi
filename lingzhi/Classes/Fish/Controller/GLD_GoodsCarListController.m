//
//  GLD_GoodsCarListController.m
//  lingzhi
//
//  Created by 锅里的 on 2019/5/12.
//  Copyright © 2019 com.lingzhi. All rights reserved.
//

#import "GLD_GoodsCarListController.h"
#import "GLD_CarListCell.h"
#import "GLD_GoodsDetailController.h"
#import "GLD_MessageUserInfoTool.h"
#import "GLD_ExpressAddressView.h"
#import <AlipaySDK/AlipaySDK.h>

@interface GLD_GoodsCarListController ()<UITableViewDataSource, UITableViewDelegate,GLD_CarListCellDelegate>

@property (nonatomic, copy)UITableView *home_table;
@property (nonatomic, strong)NSMutableArray *dataArrM;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIButton *payBut;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *payType;

@end

@implementation GLD_GoodsCarListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.home_table];
    [self.view addSubview:self.priceLabel];
    [self.view addSubview:self.payBut];
    [self.home_table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(self.view);
        make.bottom.equalTo(self.priceLabel.mas_top);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.equalTo(self.view);
        make.right.equalTo(self.payBut.mas_left);
        make.height.equalTo(WIDTH(64));
    }];
    [self.payBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.width.equalTo(WIDTH(100));
        make.height.equalTo(WIDTH(64));
        make.bottom.equalTo(self.view);
    }];
    
    [self getStoreListData];
}
//GLD_CarListCellDelegate
- (void)payCount:(NSInteger)count andIndex:(NSInteger)index{
    
    GLD_StoreDetailModel *model = self.dataArrM[index];
    model.count = @(count);
    CGFloat money = 0;
    for (GLD_StoreDetailModel *storeModel in self.dataArrM) {
        money += (storeModel.price.floatValue * MAX(storeModel.count.integerValue, 1));
    }
    self.priceLabel.text = [NSString stringWithFormat:@"    总记：%.2f元",money];
}
- (void)getStoreListData{
    
    NSArray *arr = [GLD_MessageUserInfoTool readDiskAllCache];
    WS(weakSelf);
    if (arr.count > 0) {
        [weakSelf.dataArrM addObjectsFromArray:arr];
//        [weakSelf.home_table.mj_footer endRefreshing];
    }else{
//        [weakSelf.home_table.mj_footer endRefreshingWithNoMoreData];
    }
    [weakSelf.home_table.mj_header endRefreshing];
    [weakSelf.home_table reloadData];
    CGFloat money = 0;
    for (GLD_StoreDetailModel *storeModel in self.dataArrM) {
        money += (storeModel.price.floatValue * MAX(storeModel.count.integerValue, 1));
    }
    self.priceLabel.text = [NSString stringWithFormat:@"    总记：%.2f元",money];
    
  
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 刷新
    GLD_StoreDetailModel *storeModel = self.dataArrM[indexPath.row];
    [GLD_MessageUserInfoTool removeAdsList:storeModel];
    [self.dataArrM removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    CGFloat money = 0;
    for (GLD_StoreDetailModel *storeModel in self.dataArrM) {
        money += (storeModel.price.floatValue * MAX(storeModel.count.integerValue, 1));
    }
    self.priceLabel.text = [NSString stringWithFormat:@"    总记：%.2f元",money];
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArrM.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self getStoreDetailCell:indexPath];
}
- (GLD_CarListCell *)getStoreDetailCell:(NSIndexPath *)indexPath{
    GLD_CarListCell *cell = [self.home_table dequeueReusableCellWithIdentifier:@"GLD_CarListCell"];
    cell.detailModel = self.dataArrM[indexPath.row];
    cell.delegate = self;
    cell.indexPath = indexPath;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GLD_StoreDetailModel *storeModel = self.dataArrM[indexPath.row];
    
    //            self.title = @"积分商城";
    GLD_GoodsDetailController *detailVc = [[GLD_GoodsDetailController alloc]init];
    detailVc.storeModel = storeModel;
    detailVc.type = storeModel.type;
    [self.navigationController pushViewController:detailVc animated:YES];
    
}

- (void)payButClick:(UIButton *)senser{
    for (GLD_StoreDetailModel *storeModel in self.dataArrM) {
        if(storeModel.count){
            dispatch_async(dispatch_get_main_queue(), ^{
                
                WS(weakSelf);
                [GLD_ExpressAddressView expressAddressView:^(NSString *address) {
                    weakSelf.address = address;
                    [weakSelf showChoosePayTypeAlert];
                }];
            });
            return;
        }
    }
    [CAToast showWithText:@"请选择商品数量"];
}

- (void)showChoosePayTypeAlert{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择支付方式" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    WS(weakSelf);
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"支付宝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        weakSelf.payType = @"zfbPay";
        [weakSelf payToDaiJinQuanGoods];
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"微信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.payType = @"wxPay";
        [weakSelf payToDaiJinQuanGoods];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)payToDaiJinQuanGoods{
    
    NSString *toUserId ;
    NSMutableArray *arrM = [NSMutableArray array];
    CGFloat money = 0;
    for (GLD_StoreDetailModel *model in self.dataArrM) {
        toUserId = model.userId;
        if (model.count > 0) {
            
            NSDictionary  *dict = @{@"goodsId":GetString(model.storeId),
                                    @"goodscount":model.count,
                                    @"prize":model.price
            };
            money += (model.price.floatValue * MAX(model.count.integerValue, 1));
            [arrM addObject:dict];
        }
    }
    WS(weakSelf);
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = wxPayGoodsRequest;
    config.requestParameters = @{@"amount":@(money),
                                 @"fromUserId":GetString([AppDelegate shareDelegate].userModel.userId),
                                 @"payType":GetString(self.payType),
                                 @"address":GetString(self.address),
                                 @"prize":@(money),
                                 @"toUserId":GetString(toUserId),
                                 @"goodsLists":arrM
                                 };
    [self.NetManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        if (!error) {
            if ([result[@"code"] integerValue] == 200) {
                if([weakSelf.payType isEqualToString:@"zfbPay"]){
                    [weakSelf payToALiPayWithString:result[@"data"][@"body"]];
                }else if([weakSelf.payType isEqualToString:@"wxPay"]){
                    if (!WXApi.isWXAppInstalled) {
                        [CAToast showWithText:@"请安装微信"];
                        return;
                    }
                    [weakSelf payToWeChatWithDic:result[@"data"]];
                    //                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
            }
        }
    }];
}
- (void)payToALiPayWithString:(NSString *)string
{
  
    
    WS(weakSelf);
    [[AlipaySDK defaultService] payOrder:string fromScheme:@"com.hhlmcn.huihuilinmeng" callback:^(NSDictionary *resultDic) {
        NSLog(@"status:%@ reslut = %@", resultDic[@"resultStatus"], resultDic[@"result"]);
        NSString *resultStatus = resultDic[@"resultStatus"];
        if ([resultStatus isEqualToString:@"9000"]) {
            NSLog(@"支付成功");
            [GLD_MessageUserInfoTool removeAllObj];
            [weakSelf.navigationController popViewControllerAnimated:YES];
            //            [weakSelf queryPayStatus];
        } else if ([resultStatus isEqualToString:@"4000"]) {
            [CAToast showWithText:@"支付失败"];
        } else if ([resultStatus isEqualToString:@"5000"]) {
            [CAToast showWithText:@"支付订单重复"];
        } else if ([resultStatus isEqualToString:@"6001"]) {
            NSLog(@"支付取消");
            return;
        } else if ([resultStatus isEqualToString:@"6002"]) {
            [CAToast showWithText:@"请检查网络连接"];
        } else {
            [CAToast showWithText:@"支付错误"];
        }
    }];
}
- (void)payToWeChatWithDic:(NSDictionary *)dic
{
    
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = dic[@"partnerid"];  // 商户号
    request.prepayId = dic[@"prepayid"]; // 预支付交易会话ID
    request.package = dic[@"package"];    // 扩展字段(固定值)
    request.nonceStr = dic[@"noncestr"]; // 随机字符串
    NSString *timeStampString = dic[@"timestamp"];
    if (!IsExist_String(timeStampString)) return;
    UInt32 num;
    sscanf([timeStampString UTF8String], "%u", &num);
    request.timeStamp = num;     // 时间戳
    request.sign = dic[@"sign"]; // 签名
    [WXApi sendReq:request];
}
#pragma mark - WXApiManagerDelegate
- (void)onResp:(BaseResp *)resp{
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp *)resp;
        // 返回结果 0:成功 -1:错误 -2:用户取消
        if (response.errCode == -2) {
            [CAToast showWithText:@"用户取消"];
            return;
        }
        if (response.errCode == 0) {
            [GLD_MessageUserInfoTool removeAllObj];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        
    }
}
- (UITableView *)home_table{
    if (!_home_table) {
        UITableView *table = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        
        table.delegate = self;
        table.dataSource = self;
        table.estimatedRowHeight = 0;
        table.estimatedSectionHeaderHeight = 0;
        table.estimatedSectionFooterHeight = 0;
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        [table setSeparatorInset:UIEdgeInsetsMake(0, W(15), 0, W(15))];
        //        [table mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.edges.equalTo(self.view);
        //        }];
        WS(weakSelf);
        //        table.mj_footer = [YXFooterRefresh footerWithRefreshingBlock:^{
        //            [weakSelf getStoreListData];
        //
        //        }];
//        table.mj_header = [GLD_RefreshHeader headerWithRefreshingBlock:^{
//            [weakSelf.dataArrM removeAllObjects];
//            [weakSelf getStoreListData];
//
//        }];
        table.rowHeight = 130;
        [table registerNib:[UINib nibWithNibName:@"GLD_CarListCell" bundle:nil] forCellReuseIdentifier:@"GLD_CarListCell"];
        _home_table = table;
    }
    return _home_table;
}
- (NSMutableArray *)dataArrM{
    if (!_dataArrM) {
        _dataArrM = [NSMutableArray array];
    }
    return _dataArrM;
}
- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [UILabel creatLableWithText:@"" andFont:WTFont(15) textAlignment:NSTextAlignmentLeft textColor:[UIColor redColor]];
        _priceLabel.backgroundColor = [UIColor whiteColor];
        
    }
    return _priceLabel;
}
- (UIButton *)payBut{
    if (!_payBut) {
        _payBut = [UIButton new];
        [_payBut setTitle:@"去支付" forState:UIControlStateNormal];
        [_payBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _payBut.backgroundColor = [UIColor redColor];
        [_payBut addTarget:self action:@selector(payButClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payBut;
}
@end
