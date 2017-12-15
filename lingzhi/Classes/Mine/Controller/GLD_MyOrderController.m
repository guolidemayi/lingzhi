//
//  GLD_MyOrderController.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/12.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_MyOrderController.h"

@interface GLD_MyOrderController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *table_apply;
@property (nonatomic, strong)NSArray *dataArr;
@property (nonatomic, strong)UIView *topView;
@property (nonatomic, strong)UIView *blueLineView;//选择列表蓝条
@end

@implementation GLD_MyOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.topView];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.table_apply];
    self.topView.frame = CGRectMake(0, 0, DEVICE_WIDTH, W(44));
    [self.table_apply mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self.view);
        make.top.equalTo(self.topView.mas_bottom);
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [UITableViewCell new];
}
- (void)businessListClick:(UIButton *)senser{
    [UIView animateWithDuration:.3 animations:^{
        self.blueLineView.mj_x = senser.mj_x;
    }];
}
- (UIView *)topView{
    if (!_topView) {
        _topView = [UIView new];
        NSArray *titleArr = @[@"全部",@"已确认",@"未确认"];
        
        for (int i = 0; i < titleArr.count; i++) {
            UIButton * button = [UIButton new];
            [button addTarget:self action:@selector(businessListClick:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTBLACK] forState:UIControlStateNormal];
            button.frame = CGRectMake(DEVICE_WIDTH / 3 * i, 0, DEVICE_WIDTH / 3, W(43));
            [button setTitle:titleArr[i] forState:UIControlStateNormal];
            [_topView addSubview:button];
        }
        [_topView addSubview:self.blueLineView];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, W(43), DEVICE_WIDTH, 1)];
        lineView.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTline2Gray];
        [_topView addSubview:lineView];
        self.blueLineView.frame = CGRectMake(DEVICE_WIDTH / 3 , W(42), DEVICE_WIDTH / 3, 2);
    }
    return _topView;
}
- (UIView *)blueLineView{
    if (!_blueLineView) {
        _blueLineView = [UIView new];
        _blueLineView.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE];
    }
    return _blueLineView;
}
- (UITableView *)table_apply{
    if (!_table_apply) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        self.table_apply = tableView;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        [tableView setSeparatorInset:UIEdgeInsetsMake(0, W(15), 0, W(15))];
        tableView.rowHeight = W(60);
//        [tableView registerClass:[GLD_CooperatCell class] forCellReuseIdentifier:GLD_CooperatCellIdentifier];
        //        tableView.rowHeight = 0;
        tableView.sectionFooterHeight = 0.001;
    }
    return _table_apply;
}
@end
