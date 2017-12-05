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
@end

@implementation GLD_BusinessListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.business_table = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.businessManager = [[GLD_BusinessViewManager alloc]initWithTableView:self.business_table];
    PTLMenuButton *btn = [[PTLMenuButton alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40) menuTitles:@[@"科室",@"排序",@"全部"]];
    NSArray * listArr1 = @[@"全科",@"妇产科",@"儿科",@"内科",@"外科",@"中医科",@"口腔科",@"耳科",@"耳鼻喉科"];
    NSArray * listArr2 = @[@"综合排序",@"评分",@"问诊量",@"价格"];
    NSArray * listArr3 = @[@"综合排序",@"评分",@"问诊量",@"价格"];
    btn.listTitles = @[listArr1, listArr2,listArr3];
    btn.delegate = self;
    [self.view addSubview:btn];
}

- (void)fetchData{
    [self.businessManager fetchMainData];
}

#pragma mark - PTLMenuButtonDelegate
-(void)ptl_menuButton:(PTLMenuButton *)menuButton didSelectMenuButtonAtIndex:(NSInteger)index selectMenuButtonTitle:(NSString *)title listRow:(NSInteger)row rowTitle:(NSString *)rowTitle{
    NSLog(@"index: %zd, title:%@, listrow: %zd, rowTitle: %@", index, title, row, rowTitle);
}

@end
