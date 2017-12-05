//
//  GLD_BusinessDetailManager.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/4.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_BusinessDetailManager.h"
#import "GLD_DetailRankCell.h"
#import "GLD_DetaileCell.h"
#import "GLD_DetaileBusiCell.h"
#import "GLD_DetailIntroCell.h"
@implementation GLD_BusinessDetailManager

- (void)fetchMainData{
    
}

- (void)setComponentCorner{
    [self.tableView registerClass:[GLD_DetailRankCell class] forCellReuseIdentifier:GLD_DetailRankCellIdentifier];
    [self.tableView registerClass:[GLD_DetaileCell class] forCellReuseIdentifier:GLD_DetaileCellIdentifier];
    [self.tableView registerClass:[GLD_DetaileBusiCell class] forCellReuseIdentifier:GLD_DetaileBusiCellIdentifier];
    [self.tableView registerClass:[GLD_DetailIntroCell class] forCellReuseIdentifier:GLD_DetailIntroCellIdentifier];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [UITableViewCell new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            
        } break;
        case 1:{
            
        } break;
        case 2:{
            
        } break;
        case 3:{
            
        } break;
    }
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section != 0) return [UIView new];
    UITableViewHeaderFooterView *headerView = [[UITableViewHeaderFooterView alloc]init];
    UIImageView * imgV = [[UIImageView alloc]init];
    [imgV yy_setImageWithURL:[NSURL URLWithString:@""] placeholder:nil];
    [headerView.contentView addSubview:imgV];
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(headerView.contentView);
    }];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) return W(180);
    return 5;
}
@end
