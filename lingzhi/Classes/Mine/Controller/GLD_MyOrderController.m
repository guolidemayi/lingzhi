//
//  GLD_MyOrderController.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/12.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_MyOrderController.h"
#import "GLD_MyOrderCell.h"
#import "PCStarRatingView.h"
#import "GLD_OrderModel.h"
#import "GLD_OrderDetailController.h"

@interface GLD_MyOrderController ()<UITableViewDelegate, UITableViewDataSource,PCStarRatingDelegate,GLD_MyOrderCellDelegate>
@property (nonatomic, strong)UITableView *table_apply;
@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, strong)UIView *topView;
@property (nonatomic, strong)UIView *blueLineView;//选择列表蓝条
@property (nonatomic, weak)UIButton *selecBut;
@property (nonatomic, assign)NSInteger selecIndex;

@property (nonatomic, strong)UIView *bgView;
@property (nonatomic, strong)UIView *commentView;
@property (nonatomic, strong) PCStarRatingView *commentStar;

@property (nonatomic, strong)GLD_NetworkAPIManager *NetManager;
@property (nonatomic, strong)GLD_OrderModelListModel *orderListModel;
// stats   0代表全部，1代表未确认，2代表已确认
@property (nonatomic, strong)NSString *status;

//评价商家id
@property (nonatomic, copy)NSString *busnessId;

@end

@implementation GLD_MyOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.topView];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.table_apply];
    self.topView.frame = CGRectMake(0, 0, DEVICE_WIDTH, W(44));
    [self.table_apply mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self.view);
        make.top.equalTo(self.topView.mas_bottom);
    }];
    self.dataArr = [NSMutableArray array];
    self.fd_interactivePopDisabled = YES;
    [self.view addSubview:self.bgView];
    self.NetManager = [GLD_NetworkAPIManager shareNetManager];
    self.status = @"0";
    self.title = @"我的订单";
    [self getOrderList:self.status];
}
- (void)getOrderList:(NSString *)status{
    WS(weakSelf);
    NSInteger offset = self.dataArr.count;
    
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = @"api/order/orderList";
    config.requestParameters = @{@"userId" : GetString([AppDelegate shareDelegate].userModel.userId),
                                 @"status" : status,
                                 @"limit" : @"10",
                                 @"offset" : [NSString stringWithFormat:@"%zd",offset]
                                 };
    
    [self.NetManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        if (!error) {
            GLD_OrderModelListModel *orderListModel = [[GLD_OrderModelListModel alloc] initWithDictionary:result error:nil];
            if (orderListModel.data.count == 0 && !IsExist_Array(weakSelf.dataArr)) {
                weakSelf.noDataLabel.text = @"暂无订单消息";
                weakSelf.noDataLabel.hidden = NO;
                [weakSelf.view bringSubviewToFront:weakSelf.noDataLabel];
            }else{
                weakSelf.noDataLabel.hidden = YES;
            }
            [weakSelf.dataArr addObjectsFromArray:orderListModel.data];
            
            
        }else{
            [CAToast showWithText:@"请求失败，请重试"];
        }
        [weakSelf.table_apply reloadData];
        [weakSelf.table_apply.mj_footer endRefreshing];
        [weakSelf.table_apply.mj_header endRefreshing];
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return W(10);
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self getMyorderCell:indexPath];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GLD_OrderDetailController *vc = [GLD_OrderDetailController new];
    GLD_OrderModel *model = self.dataArr[indexPath.section];
    vc.orderId = model.orderNumber;
    [self.navigationController pushViewController:vc animated:YES];
}
- (GLD_MyOrderCell *)getMyorderCell:(NSIndexPath *)indexPath{
    GLD_MyOrderCell *cell = [GLD_MyOrderCell cellWithReuseIdentifier:@"GLD_MyOrderCell"];
    cell.orderDelegate = self;
    cell.orderModel = self.dataArr[indexPath.section];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLD_OrderModel *model = self.dataArr[indexPath.section];
    
    CGFloat height = W(180);
    if (IsExist_String(model.shopPhone)) {
        height += W(30);
    }
    if (IsExist_String(model.shopName)) {
        height += W(15);
    }
    return height;
}
- (void)businessListClick:(UIButton *)senser{
    [UIView animateWithDuration:.3 animations:^{
        self.blueLineView.mj_x = senser.mj_x;
    }];
    [self.selecBut setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTBLACK] forState:UIControlStateNormal];
    
    [senser setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE] forState:UIControlStateNormal];
    [self.dataArr removeAllObjects];
    self.status = [NSString stringWithFormat:@"%zd",senser.tag - 301];
    [self getOrderList:self.status];
    self.selecBut = senser;
}

- (void)commentCallBack:(callBackType)type andBusnessId:(GLD_OrderModel *)busnessId{
    switch (type) {
        case callBackTypeComment:{
            self.bgView.hidden = NO;
            self.commentView.hidden = NO;
            self.busnessId = busnessId.busnessId;
        }   break;
        case callBackTypeCancel:{
            [self.dataArr removeObject:busnessId];
            [self.table_apply reloadData];
        }break;
    }
}
//PCStarRatingViewdelegate
- (void)mannerGrade:(NSString *)grade withView:(UIView *)selfView {
    
    NSLog(@"manner grade:%@",grade);
}
- (UIView *)topView{
    if (!_topView) {
        _topView = [UIView new];
        NSArray *titleArr = @[@"全部",@"未确认",@"已确认"];
        
        for (int i = 0; i < titleArr.count; i++) {
            UIButton * button = [UIButton new];
            [button addTarget:self action:@selector(businessListClick:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0) {
                [button setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE] forState:UIControlStateNormal];
                self.selecBut = button;
            }else{
                [button setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTBLACK] forState:UIControlStateNormal];
            }
            button.tag = 301 + i;
            button.frame = CGRectMake(DEVICE_WIDTH / 3 * i, 0, DEVICE_WIDTH / 3, W(43));
            [button setTitle:titleArr[i] forState:UIControlStateNormal];
            [_topView addSubview:button];
        }
        [_topView addSubview:self.blueLineView];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, W(43), DEVICE_WIDTH, 1)];
        lineView.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTline2Gray];
        [_topView addSubview:lineView];
        self.blueLineView.frame = CGRectMake(0 , W(42), DEVICE_WIDTH / 3, 2);
    }
    return _topView;
}
- (UIView *)blueLineView{
    if (!_blueLineView) {
        _blueLineView = [UIView new];
        _blueLineView.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE];
    }
    return _blueLineView;
}
- (UITableView *)table_apply{
    if (!_table_apply) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        self.table_apply = tableView;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        [tableView setSeparatorInset:UIEdgeInsetsMake(0, W(15), 0, W(15))];
        tableView.rowHeight = W(180);
        [tableView registerClass:[GLD_MyOrderCell class] forCellReuseIdentifier:GLD_MyOrderCellIdentifier];
        //        tableView.rowHeight = 0;
        WS(weakSelf);
        tableView.mj_header = [GLD_RefreshHeader headerWithRefreshingBlock:^{
            [weakSelf.dataArr removeAllObjects];
            [weakSelf getOrderList:weakSelf.status];
        }];
        tableView.mj_footer = [YXFooterRefresh footerWithRefreshingBlock:^{
            [weakSelf getOrderList:weakSelf.status];
        }];
        tableView.sectionFooterHeight = 0.001;
    }
    return _table_apply;
}
//提交评价
- (void)commitCLick{
    if (!IsExist_String(self.busnessId)) {
        return;
    }
    self.bgView.hidden = YES;
//    self.commentView.hidden = YES;
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = @"api/order/orderList";
    config.requestParameters = @{@"userId" : GetString([AppDelegate shareDelegate].userModel.userId),
                                 @"busnessId":self.busnessId
                                 };
    
    [self.NetManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        if (!error) {
            
        }else{
            
        }
        
    }];
}
- (void)closeButClick{
    [UIView animateWithDuration:.3 animations:^{
        self.bgView.hidden = YES;
        self.commentView.hidden = YES;
    }];
}

- (UIView *)commentView{
    if (!_commentView) {
        _commentView = [UIView new];
        _commentView.backgroundColor = [UIColor whiteColor];
        _commentView.hidden = YES;
        UILabel *titleLabel = [UILabel new];
        titleLabel.text = @"欢迎评价";
        titleLabel.font = WTFont(15);
        titleLabel.textColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKblackNew];
        [_commentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_commentView);
            make.top.equalTo(_commentView).offset(W(15));
        }];
        
        UIButton *but = [UIButton new];
        [but setImage:WTImage(@"关闭 copy") forState:UIControlStateNormal];
        [but addTarget:self action:@selector(closeButClick) forControlEvents:UIControlEventTouchUpInside];
        [_commentView addSubview:but];
        [but mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_commentView).offset(W(15));
            make.right.equalTo(_commentView).offset(W(-15));
        }];
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTlineGray];
        [_commentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(titleLabel).offset(10);
            make.width.equalTo(_commentView);
            make.height.equalTo(@(1));
        }];
        
        [_commentView addSubview:self.commentStar];
        [self.commentStar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lineView).offset(W(10));
            make.centerX.equalTo(_commentView);
            make.height.equalTo(WIDTH(22));
            make.width.equalTo(WIDTH(5 * 24));
        }];
        
        UIButton *commitBut = [UIButton new];
        [commitBut setTitle:@"提交" forState:UIControlStateNormal];
        [commitBut setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKwirte] forState:UIControlStateNormal];
        [commitBut setBackgroundImage:WTImage(@"可点击登陆") forState:UIControlStateNormal];
        [commitBut addTarget:self action:@selector(commitCLick) forControlEvents:UIControlEventTouchUpInside];
        [_commentView addSubview:commitBut];
        [commitBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.commentStar.mas_bottom).offset(W(15));
            make.centerX.equalTo(_commentView);
            make.width.equalTo(WIDTH(100));
            make.height.equalTo(WIDTH(40));
        }];
        
        
        
    }
    return _commentView;
}
- ( PCStarRatingView *)commentStar{
    if (!_commentStar) {
        _commentStar = [[PCStarRatingView alloc] init];
        //    tempStar.backgroundColor = [UIColor cyanColor];
        
        _commentStar.imageWidth = W(24.0);
        _commentStar.imageHeight = W(22.0);
        _commentStar.imageCount = 5;
        _commentStar.delegate = self;
        
    }
    return _commentStar;
}
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:self.view.bounds];
        _bgView.hidden = YES;
        [_bgView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeButClick)]];
        _bgView.userInteractionEnabled = YES;
        _bgView.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKblackNew alpha:.3];
        [_bgView addSubview:self.commentView];
        [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.left.equalTo(_bgView);
            make.height.equalTo(WIDTH(240));
        }];
    }
    return _bgView;
}
@end
