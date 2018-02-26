//
//  GLD_ApplyCooperatController.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/11.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_ApplyCooperatController.h"
#import "GLD_CooperatCell.h"
#import "GLD_ApplyBusnessController.h"
#import "GLD_ApplyCompanyController.h"
#import "GLD_ApplyUnionController.h"

@interface GLD_ApplyCooperatController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *table_apply;
@property (nonatomic, strong)NSArray *dataArr;
@end

@implementation GLD_ApplyCooperatController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.table_apply];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self getCooperatCell:indexPath];
}
- (GLD_CooperatCell *)getCooperatCell:(NSIndexPath *)indexPath{
    GLD_CooperatCell *cell = [self.table_apply dequeueReusableCellWithIdentifier:GLD_CooperatCellIdentifier];
    cell.dict = self.dataArr[indexPath.row];
    WS(weakSelf);
    cell.cooperatBlock = ^(cooperatType type) {
        switch (type) {
            case 1:{
                GLD_ApplyCompanyController *appleVc = [GLD_ApplyCompanyController new];
                [weakSelf.navigationController pushViewController:appleVc animated:YES];
            }break;
                
            case 2:{
                if([AppDelegate shareDelegate].userModel.isHasBusness){
                    [CAToast showWithText:@"不能重复申请门店"];
                    return ;
                }
                GLD_ApplyBusnessController *applyVc = [GLD_ApplyBusnessController new];
                [weakSelf.navigationController pushViewController:applyVc animated:YES];
            }break;
            case 3:{
                
                GLD_ApplyUnionController *applyVc = [GLD_ApplyUnionController new];
                [weakSelf.navigationController pushViewController:applyVc animated:YES];
            }break;
        }
    };
    return cell;
}
- (NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr = @[@{@"title":@"办事处/子公司加盟",@"tip":@"加盟灵指，收益加倍",@"type":@"1"},
                     @{@"title":@"商圈联盟门店",@"tip":@"商加盟商圈联盟，拓展新市场",@"type":@"2"},
                     @{@"title":@"商圈渠道商",@"tip":@"成为渠道商，拓展新市场",@"type":@"3"}];
    }
    return _dataArr;
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
        tableView.rowHeight = W(60);
        [tableView registerClass:[GLD_CooperatCell class] forCellReuseIdentifier:GLD_CooperatCellIdentifier];
        //        tableView.rowHeight = 0;
        tableView.sectionFooterHeight = 0.001;
    }
    return _table_apply;
}
@end
