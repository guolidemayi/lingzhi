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

@interface GLD_SearchController ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong)UITableView *table_apply;
@property (nonatomic, strong)NSArray *dataArr;
@property (nonatomic, weak)UITextField *textFeild;
@property (nonatomic, strong)GLD_NetworkAPIManager *NetManager;
@property (nonatomic, strong)GLD_BusnessLisModel *busnessListModel;

@end

@implementation GLD_SearchController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setupSearchView];
    [self.view addSubview:self.table_apply];
}

- (void)setupSearchView{
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, W(150), W(36))];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = W(18);
    bgView.layer.masksToBounds = YES;
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(WIDTH(36));
        make.width.equalTo(WIDTH(180));
    }];
    
    UIImageView *imgV = [UIImageView new];
    imgV.image = WTImage(@"搜索-搜索");
    [bgView addSubview:imgV];
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgView);
        make.left.equalTo(bgView).offset(W(15));
        make.height.width.equalTo(WIDTH(20));
    }];
    
    UITextField *textFeild = [[UITextField alloc]init];
    textFeild.placeholder = @"请输入商家名称";
    textFeild.delegate = self;
    self.textFeild = textFeild;
    [bgView addSubview:textFeild];
    [textFeild mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgV.mas_right);
        make.centerY.equalTo(bgView);
        make.height.equalTo(WIDTH(30));
        make.right.equalTo(bgView);
    }];
    [textFeild becomeFirstResponder];
    self.navigationItem.titleView = bgView;
    
    GLD_CustomBut *rightBut = [[GLD_CustomBut alloc]init];;
    [rightBut addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    rightBut.frame = CGRectMake(0, 0, W(50), W(44));
    [rightBut title:@"搜索"];
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:rightBut];
    self.navigationItem.rightBarButtonItem = item1;
    
}
//搜索
- (void)searchClick{
    [self searchForData:self.textFeild.text];
    [self.textFeild resignFirstResponder];
}
- (void)searchForData:(NSString *)str{
    self.NetManager = [GLD_NetworkAPIManager new];
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

@end
