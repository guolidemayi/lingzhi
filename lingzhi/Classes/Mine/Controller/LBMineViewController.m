//
//  LBMineViewController.m
//  XianYu
//
//  Created by li  bo on 16/5/28.
//  Copyright © 2016年 li  bo. All rights reserved.
//

#import "LBMineViewController.h"
#import "GLD_MineManager.h"
#import "GLD_CustomBut.h"
#import "TestViewController.h"
#import "GLD_PayForMeController.h"

@interface LBMineViewController ()

@property (nonatomic, strong)UITableView *table_mine;
@property (nonatomic, strong)GLD_MineManager *mineManager;

@property (nonatomic, weak) GLD_CustomBut *mineCodeBut;
@end

@implementation LBMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    
    GLD_CustomBut *rightBut = [[GLD_CustomBut alloc]init];;
    
    rightBut.frame = CGRectMake(0, 0, 50, 44);
    [rightBut image:@"编辑资料"];
    [rightBut addTarget:self action:@selector(rightButClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:rightBut];
    self.navigationItem.leftBarButtonItem = item1;
    
    
    GLD_CustomBut *rBut = [[GLD_CustomBut alloc]init];;
    self.mineCodeBut = rBut;
    rBut.hidden = YES;
    rBut.frame = CGRectMake(0, 0, 50, 44);
    [rBut image:@"编辑资料"];
    [rBut addTarget:self action:@selector(mineCodeButClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:rBut];
    self.navigationItem.rightBarButtonItem = item;
    [self setupUI];
}

- (void)mineCodeButClick{
    GLD_PayForMeController *payforVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GLD_PayForMeController"];
    [self.navigationController pushViewController:payforVc animated:YES];
}
- (void)setupUI{
    self.table_mine = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.table_mine];
    self.mineManager = [[GLD_MineManager alloc]initWithTableView:self.table_mine];
}
- (void)rightButClick {
    TestViewController *userMessageVc = [[TestViewController alloc]init];
    userMessageVc.type = 2;
    [self.navigationController pushViewController:userMessageVc animated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.fd_interactivePopDisabled = YES;
    //请求数据
    [self.mineManager fetchMainData];
    if (hasLogin) {
        self.mineCodeBut.hidden = NO;
    }else{
        self.mineCodeBut.hidden = YES;
    }
}

@end
