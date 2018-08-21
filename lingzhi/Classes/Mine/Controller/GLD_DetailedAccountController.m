//
//  GLD_DetailedAccountController.m
//  lingzhi
//
//  Created by yiyangkeji on 2018/2/9.
//  Copyright © 2018年 com.lingzhi. All rights reserved.
//

#import "GLD_DetailedAccountController.h"
#import "GLD_CountModel.h"

@interface GLD_DetailedAccountController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *table_apply;
@property (nonatomic, strong) GLD_NetworkAPIManager *NetManager;//

@property (nonatomic, strong) NSMutableArray *titleArr;//
@end

@implementation GLD_DetailedAccountController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.table_apply];
    self.NetManager = [GLD_NetworkAPIManager shareNetManager];
    [self sendVerificationClick];
    // Do any additional setup after loading the view.
}
- (void)sendVerificationClick{
    //验证码
    WS(weakSelf);
    
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = @"api/user/moneyHistory";
    config.requestParameters = @{@"limit" : @"10",
                                 @"moneyType" : self.type,
                                 @"userId" : GetString([AppDelegate shareDelegate].userModel.userId),
                                 @"offset":[NSString stringWithFormat:@"%zd",self.titleArr.count]
                                 };
    
    [self.NetManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        
        if(!error){
            GLD_CountDataModel *model = [[GLD_CountDataModel alloc]initWithDictionary:result[@"data"] error:nil];
            [weakSelf.titleArr addObjectsFromArray:model.list];
            if (!IsExist_Array(model.list) && !IsExist_Array(weakSelf.titleArr)) {
               
                self.noDataLabel.text = @"暂无交易记录";
                self.noDataLabel.hidden = NO;
            }else{
                self.noDataLabel.hidden = YES;
            }
            [weakSelf.table_apply reloadData];
        }else{
            [CAToast showWithText:@"请求错误"];
        }
    }];
    
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"countCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"countCell"];
        
    }
    GLD_CountModel *model = self.titleArr[indexPath.row];
    cell.textLabel.font = WTFont(15);
    cell.detailTextLabel.font = WTFont(14);
    cell.detailTextLabel.textColor = [UIColor redColor];
    cell.detailTextLabel.text = model.money;
    cell.textLabel.text = model.type;
    UILabel *accLabel = [UILabel creatLableWithText:model.createTime andFont:WTFont(12) textAlignment:NSTextAlignmentRight textColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTnewGray]];
    accLabel.frame = CGRectMake(0, 0, 100, 25);
    cell.accessoryView = accLabel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (UITableView *)table_apply{
    if (!_table_apply) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        self.table_apply = tableView;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        [tableView setSeparatorInset:UIEdgeInsetsMake(0, W(15), 0, W(15))];
        
        WS(weakSelf)
        tableView.mj_header = [GLD_RefreshHeader headerWithRefreshingBlock:^{
            [weakSelf.titleArr removeAllObjects];
            [weakSelf sendVerificationClick];
        }];
        tableView.mj_footer = [YXFooterRefresh footerWithRefreshingBlock:^{
            [weakSelf sendVerificationClick];
        }];
        //        [tableView registerClass:[GLD_MapDetailCell class] forCellReuseIdentifier:GLD_MapDetailCellIdentifier];
        //        tableView.rowHeight = 0;
        tableView.sectionFooterHeight = 0.001;
    }
    return _table_apply;
}
- (NSMutableArray *)titleArr {
    if (!_titleArr) {
        _titleArr = [NSMutableArray array];
    }
    return _titleArr;
}
@end
