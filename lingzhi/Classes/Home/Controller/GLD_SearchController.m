//
//  GLD_SearchController.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/13.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_SearchController.h"
#import "GLD_CustomBut.h"
#import "GLD_BusinessCell.h"
#import "GLD_BusnessModel.h"
#import "GLD_BusinessDetailController.h"

@interface GLD_SearchController ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong)UITableView *table_apply;
@property (nonatomic, strong)NSArray *dataArr;
@property (nonatomic, strong)GLD_NetworkAPIManager *NetManager;
@property (nonatomic, strong)GLD_BusnessLisModel *busnessListModel;
@property (nonatomic, strong)UITextField *searchBar;
@end

@implementation GLD_SearchController

- (void)viewDidLoad {
    [super viewDidLoad];
       self.NetManager = [GLD_NetworkAPIManager new];
    [self setupSearchView];
    self.navigationItem.titleView = self.searchBar;;
    [self setUpNav];
    
    [self.view addSubview:self.table_apply];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.searchBar resignFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated{
    [self.searchBar becomeFirstResponder];
}
- (void)setupSearchView{
    
    
    GLD_CustomBut *rightBut = [[GLD_CustomBut alloc]init];;
    [rightBut addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    rightBut.frame = CGRectMake(0, 0, W(50), W(30));
    [rightBut title:@"搜索"];
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:rightBut];
    self.navigationItem.rightBarButtonItem = item1;
    
}
- (void)setUpNav
{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"header_back_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    self.navigationItem.leftBarButtonItem = backItem;
    
}

- (void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}
//搜索
- (void)searchClick{
    [self searchForData:self.searchBar.text];
    [self.searchBar resignFirstResponder];
}
- (void)searchForData:(NSString *)str{

    WS(weakSelf);
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = @"api/main/searchShop";
    config.requestParameters = @{@"keyword" : str};

    [self.NetManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {

        weakSelf.busnessListModel = [[GLD_BusnessLisModel alloc] initWithDictionary:result error:nil];
        [weakSelf.table_apply reloadData];
    }];
}
//限制输入长度
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self searchForData:textField.text];
    return YES;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLD_BusinessDetailController *detaileVc = [GLD_BusinessDetailController new];
    detaileVc.busnessModel = self.busnessListModel.data[indexPath.row];
    [self.navigationController pushViewController:detaileVc animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.busnessListModel.data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self getBusinessCell:indexPath];
}
- (GLD_BusinessCell *)getBusinessCell:(NSIndexPath *)indexPath{
    GLD_BusinessCell *cell = [self.table_apply dequeueReusableCellWithIdentifier:GLD_BusinessCellIdentifier];
    cell.model = self.busnessListModel.data[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return W(100);
     
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
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
        tableView.mj_insetB = W(80);
        [tableView registerClass:[GLD_BusinessCell class] forCellReuseIdentifier:GLD_BusinessCellIdentifier];
        //        tableView.rowHeight = 0;
        tableView.sectionFooterHeight = 0.001;
    }
    return _table_apply;
}


- (UITextField *)searchBar{
    if (!_searchBar) {
        
        UITextField *searBar = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, W(250), W(30))];
        _searchBar = searBar;
        searBar.backgroundColor = [UIColor whiteColor];
        _searchBar.delegate = self;
        _searchBar.borderStyle = UITextBorderStyleRoundedRect;
        _searchBar.placeholder = @"请输入商家名称";
        
    }
    return _searchBar;
}
@end
