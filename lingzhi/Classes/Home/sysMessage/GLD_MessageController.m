//
//  GLD_MessageController.m
//  yxvzb
//
//  Created by yiyangkeji on 17/2/8.
//  Copyright © 2017年 sendiyang. All rights reserved.
//

#import "GLD_MessageController.h"


#import "GLD_RemindCell.h"
#import "GLD_RemindModel.h"





@interface GLD_MessageController ()<UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray *_remindArrM;
    
    NSInteger offset;
    NSInteger pagNo;
    
}

@property (nonatomic, weak)UITableView *remindTable;
@property (nonatomic, strong)GLD_NetworkAPIManager *NetManager;


@end

@implementation GLD_MessageController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"站内信";
    _remindArrM = [NSMutableArray array];
    
    offset = 0;
    pagNo = 0;

    self.NetManager = [GLD_NetworkAPIManager new];
    [self setContentView];
    
    [self getRemindMessageContent];
    
}
- (void)getRemindMessageContent{
    
    WS(weakSelf);
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = @"api/other/getStationMessage";
    config.requestParameters = @{@"userId" : GetString(@"1")};
    
    [self.NetManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        
        if (!error) {
            GLD_RemindListModel *model = [[GLD_RemindListModel alloc]initWithDictionary:result error:nil];
            [_remindArrM addObjectsFromArray:model.data];
            [weakSelf.remindTable reloadData];
            [weakSelf.remindTable.mj_header endRefreshing];
            [weakSelf.remindTable.mj_footer endRefreshing];
        }
    }];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
        return _remindArrM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        return [self getRemindCell:indexPath andTableView:tableView];
}



- (GLD_RemindCell *)getRemindCell:(NSIndexPath *)indexPath andTableView : (UITableView *)tableView{
    
    [tableView registerClass:[GLD_RemindCell class] forCellReuseIdentifier:@"GLD_RemindCell"];
    
    GLD_RemindCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLD_RemindCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (IsExist_Array(_remindArrM))
    cell.model = _remindArrM[indexPath.row];;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLD_RemindModel *model = _remindArrM[indexPath.row];
    CGFloat height = [YXUniversal calculateCellHeight:0 width:300 text:model.summary font:12];
        return height + H(82);
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 刷新
    
    GLD_RemindModel *model = _remindArrM[indexPath.row];
    [self delRemind:model];
    [_remindArrM removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}
- (void)delRemind:(GLD_RemindModel *)model{
   
    WS(weakSelf);
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = @"api/other/delStationMessage";
    config.requestParameters = @{@"stationMessageId" : GetString(model.remindId)};
    
    [self.NetManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        
        if (!error) {
            
        }
    }];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}


- (void)setContentView{
    
    
    UITableView *remindT = [[UITableView alloc]init];
    remindT.separatorStyle = UITableViewCellSeparatorStyleNone;

    remindT.delegate = self;
    remindT.dataSource = self;
    remindT.mj_header = [GLD_RefreshHeader headerWithRefreshingBlock:^{
        offset = 0;
        [_remindArrM removeAllObjects];
        [self getRemindMessageContent];
    }];
    remindT.mj_footer = [YXFooterRefresh footerWithRefreshingBlock:^{
        [self getRemindMessageContent];
    }];
    self.remindTable = remindT;

    [self.view addSubview:remindT];
    [remindT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.bottom.equalTo(self.view);
        
    }];
    
    
}


@end
