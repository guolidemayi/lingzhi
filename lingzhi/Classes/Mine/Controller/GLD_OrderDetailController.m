//
//  GLD_OrderDetailController.m
//  lingzhi
//
//  Created by 博学明辨 on 2020/2/17.
//  Copyright © 2020 com.lingzhi. All rights reserved.
//

#import "GLD_OrderDetailController.h"
#import "GLD_OrderDetailModel.h"
#import "GLD_OrderDetailCell.h"

@interface GLD_OrderDetailController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation GLD_OrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self getOrderList];
    self.title = @"订单详情";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    GLD_OrderDetailModel *model = self.dataArr[indexPath.row];
//    CGFloat height = [YXUniversal calculateCellHeight:0 width:DEVICE_WIDTH - 30 text:model.goodsName font:(15)];
    return 100;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLD_OrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLD_OrderDetailCell"];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}
- (void)getOrderList{
    WS(weakSelf);
    NSInteger offset = self.dataArr.count;
    
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = orderDetailRequest;
    config.requestParameters = @{@"orderNo" : GetString(self.orderId),
                                 };
    
    [self.NetManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        if (!error) {
            NSDictionary *dict = result[@"data"];
            NSArray *arr = dict[@"goodsLists"];
            for (NSDictionary *dic in arr) {
                GLD_OrderDetailModel *model = [[GLD_OrderDetailModel alloc]initWithDictionary:dic error:&error];
                [weakSelf.dataArr addObject:model];
                
            }
            [weakSelf.tableView reloadData];
            
        }else{
            [CAToast showWithText:@"请求失败，请重试"];
        }
       
    }];
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorColor = [UIColor clearColor];
        [_tableView registerNib:[UINib nibWithNibName:@"GLD_OrderDetailCell" bundle:nil] forCellReuseIdentifier:@"GLD_OrderDetailCell"];
    }
    return _tableView;
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

@end
