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

@interface GLD_BusinessListController ()<PTLMenuButtonDelegate>

@property (nonatomic, strong)UITableView *business_table;
@property (nonatomic, strong)GLD_BusinessViewManager *businessManager;
@property (nonatomic, strong)GLD_NetworkAPIManager *NetManager;
@end

@implementation GLD_BusinessListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.business_table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.businessManager = [[GLD_BusinessViewManager alloc]initWithTableView:self.business_table];
    
}
- (void)searchForData{
    self.NetManager = [GLD_NetworkAPIManager new];
    WS(weakSelf);
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = @"api/main/searchShop";
    config.requestParameters = @{@"name" : self.cityName};
    
    [self.NetManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            PTLMenuButton *btn = [[PTLMenuButton alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, W(44)) menuTitles:@[@"科室",@"排序",@"全部"]];
            NSArray * listArr1 = @[@"全科",@"妇产科",@"儿科",@"内科",@"外科",@"中医科",@"口腔科",@"耳科",@"耳鼻喉科"];
            NSArray * listArr2 = @[@"百货商超",@"医药行业",@"餐饮酒店娱乐",@"房地产业",@"金融保险",@"汽车及汽车服务",@"文体教育"];
            NSArray * listArr3 = @[@"离我最近",@"最近开通",@"推荐"];
            btn.listTitles = @[listArr1, listArr2,listArr3];
            btn.delegate = self;
            [weakSelf.view addSubview:btn];
            [weakSelf.business_table mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(weakSelf.view);
                make.top.equalTo(btn.mas_bottom);
            }];
        });

    }];
}
- (void)fetchData:(NSString *)title{
    [self.businessManager fetchMainDataWithCondition:title];
}

#pragma mark - PTLMenuButtonDelegate
-(void)ptl_menuButton:(PTLMenuButton *)menuButton didSelectMenuButtonAtIndex:(NSInteger)index selectMenuButtonTitle:(NSString *)title listRow:(NSInteger)row rowTitle:(NSString *)rowTitle{
    NSLog(@"index: %zd, title:%@, listrow: %zd, rowTitle: %@", index, title, row, rowTitle);
    [self fetchData:title];
}

@end
