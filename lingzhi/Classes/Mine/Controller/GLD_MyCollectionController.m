//
//  GLD_MyCollectionController.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/11.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_MyCollectionController.h"
#import "GLD_MycollectionManager.h"

@interface GLD_MyCollectionController ()<GLD_MycollectionManagerdelegate>

@property (nonatomic, strong)UITableView *table_collection;
@property (nonatomic, strong)GLD_MycollectionManager *collectionManager;
@end

@implementation GLD_MyCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.table_collection = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.table_collection];
    self.collectionManager = [[GLD_MycollectionManager alloc]initWithTableView:self.table_collection];
    self.collectionManager.mycollecDeleagte = self;
    [self.collectionManager fetchMainData];
    self.title = @"我的收藏";
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

- (void)complate:(id)data{
    NSArray *arr = data[@"data"];
    if (arr.count == 0) {
        self.noDataLabel.text = @"暂无收藏内容";
        self.noDataLabel.hidden = NO;
        [self.view bringSubviewToFront:self.noDataLabel];
    }else{
        self.noDataLabel.hidden = YES;
    }
}
@end
