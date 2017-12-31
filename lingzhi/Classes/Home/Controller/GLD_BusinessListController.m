//
//  GLD_BusinessListController.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/4.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_BusinessListController.h"
#import "PTLMenuButton.h"
#import "GLD_BusinessViewManager.h"
#import "GLD_IndustryModel.h"

@interface GLD_BusinessListController ()<PTLMenuButtonDelegate>

@property (nonatomic, strong)UITableView *business_table;
@property (nonatomic, strong)GLD_BusinessViewManager *businessManager;
@property (nonatomic, strong)GLD_NetworkAPIManager *NetManager;
@property (nonatomic, strong)GLD_IndustryListModel *industryListModel;
@property (nonatomic, strong)GLD_IndustryListModel *industryListModel1;//二级
@end

@implementation GLD_BusinessListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.business_table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.businessManager = [[GLD_BusinessViewManager alloc]initWithTableView:self.business_table];
    [self.view addSubview:self.business_table];
    [self searchForData];
    [self getParentCategory];
    
    [self fetchData:self.cityName?self.cityName : @"北京"];
}
//区
- (void)getDistrictList{
    WS(weakSelf);
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = @"api/main/getDistrictList";
    config.requestParameters = @{@"city" : self.cityName?self.cityName : @"北京"};
    
    [self.NetManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            PTLMenuButton *btn = [[PTLMenuButton alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, W(44)) menuTitles:@[@"全城",self.model.title,@"筛选"]];
//            NSArray * listArr1 = @[@"全科",@"妇产科",@"儿科",@"内科",@"外科",@"中医科",@"口腔科",@"耳科",@"耳鼻喉科"];
            NSArray * list = result[@"district"];
            NSMutableArray *listArr1 = [NSMutableArray array];
            for (NSDictionary *dict in list) {
                [listArr1 addObject:dict[@"title"]];
            }
            NSMutableArray *arrM2 = [NSMutableArray array];
            for ( GLD_IndustryModel *model in weakSelf.industryListModel.data) {
                [arrM2 addObject:model.title];
            }
            NSArray * listArr3 = @[@"离我最近",@"最近开通",@"推荐"];
            btn.listTitles = @[listArr1, arrM2.copy,listArr3];
            btn.delegate = self;
            [weakSelf.view addSubview:btn];
            [weakSelf.business_table mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(weakSelf.view);
                make.top.equalTo(btn.mas_bottom);
            }];
        });
//        weakSelf.industryListModel1 = [[GLD_IndustryListModel alloc] initWithDictionary:result error:nil];
    }];
}
- (void)getSubCategory:(NSString *)pid{
    WS(weakSelf);
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = @"api/main/getSubCategory";
    config.requestParameters = @{@"pid" : GetString(pid)};
    
    [self.NetManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        
        weakSelf.industryListModel1 = [[GLD_IndustryListModel alloc] initWithDictionary:result error:nil];
    }];
}
- (void)getParentCategory{
    WS(weakSelf);
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = @"api/main/getParentCategory";
    
    [self.NetManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        weakSelf.industryListModel = [[GLD_IndustryListModel alloc] initWithDictionary:result error:nil];
        [weakSelf getDistrictList];
        NSLog(@"");
    }];
}
- (void)searchForData{
    self.NetManager = [GLD_NetworkAPIManager new];
    WS(weakSelf);
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = @"api/main/categoryShop";
    config.requestParameters = @{@"category" : GetString(self.model.title)};
    
    [self.NetManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
     

    }];
}
- (void)fetchData:(NSString *)title{
    [self.businessManager fetchMainDataWithCondition:title];
}

#pragma mark - PTLMenuButtonDelegate
-(void)ptl_menuButton:(PTLMenuButton *)menuButton didSelectMenuButtonAtIndex:(NSInteger)index selectMenuButtonTitle:(NSString *)title listRow:(NSInteger)row rowTitle:(NSString *)rowTitle{
    NSLog(@"index: %zd, title:%@, listrow: %zd, rowTitle: %@", index, title, row, rowTitle);
   GLD_IndustryModel *model = self.industryListModel.data[index];
    
    [self getSubCategory:model.pid];
}

@end
