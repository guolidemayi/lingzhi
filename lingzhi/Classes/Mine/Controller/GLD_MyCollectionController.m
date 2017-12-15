//
//  GLD_MyCollectionController.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/11.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_MyCollectionController.h"
#import "GLD_MycollectionManager.h"

@interface GLD_MyCollectionController ()

@property (nonatomic, strong)UITableView *table_collection;
@property (nonatomic, strong)GLD_MycollectionManager *collectionManager;
@end

@implementation GLD_MyCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.table_collection = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.collectionManager = [[GLD_MycollectionManager alloc]initWithTableView:self.table_collection];
    [self.collectionManager fetchMainData];
    self.title = @"我的收藏";
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
