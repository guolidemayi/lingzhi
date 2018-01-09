//
//  GLD_SecondIndustryController.m
//  lingzhi
//
//  Created by yiyangkeji on 2018/1/9.
//  Copyright © 2018年 com.lingzhi. All rights reserved.
//

#import "GLD_SecondIndustryController.h"
#import "GLD_IndustryModel.h"

@interface GLD_SecondIndustryController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)UITableView *table_apply;
@property (nonatomic, strong) NSMutableArray *titleArr;//
@property (nonatomic, strong)GLD_NetworkAPIManager *NetManager;

@end
@implementation GLD_SecondIndustryController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view addSubview:self.table_apply];
    self.title = @"选择二级标题";
    self.NetManager = [GLD_NetworkAPIManager new];
    [self getSubCategory];
}
- (void)getSubCategory{
    WS(weakSelf);
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = @"api/main/getSubCategory";
    config.requestParameters = @{@"pid" : GetString(self.firstTitle)};
    
    [self.NetManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        
        GLD_IndustryListModel *industryListModel1 = [[GLD_IndustryListModel alloc] initWithDictionary:result error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
           
            for ( GLD_IndustryModel *model in industryListModel1.data) {
                [weakSelf.titleArr addObject:model.title];
            }
            
            [weakSelf.table_apply reloadData];
        });
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = WTFont(15);
    cell.textLabel.textColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKblackNew];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.titleArr[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return W(50);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.nameBlock) {
        self.nameBlock(self.titleArr[indexPath.row]);
        [self.navigationController popViewControllerAnimated:YES];
    }
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
        tableView.mj_insetB = W(50);
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
