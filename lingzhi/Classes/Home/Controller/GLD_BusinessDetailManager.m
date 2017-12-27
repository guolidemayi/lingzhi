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

#import "GLD_BusnessModel.h"
@implementation GLD_BusinessDetailManager

- (void)fetchMainData{
    
}
- (void)reloadOrLoadMoreData{
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
}
- (void)setComponentCorner{
    [self.tableView registerClass:[GLD_DetailRankCell class] forCellReuseIdentifier:GLD_DetailRankCellIdentifier];
    [self.tableView registerClass:[GLD_DetaileCell class] forCellReuseIdentifier:GLD_DetaileCellIdentifier];
    [self.tableView registerClass:[GLD_DetaileBusiCell class] forCellReuseIdentifier:GLD_DetaileBusiCellIdentifier];
    [self.tableView registerClass:[GLD_DetailIntroCell class] forCellReuseIdentifier:GLD_DetailIntroCellIdentifier];
}

- (void)setBusnessModel:(GLD_BusnessModel *)busnessModel{
    _busnessModel = busnessModel;
    [self.tableView reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            return [self getDetailIntroCell:indexPath];
        }break;
        case 1:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            cell.textLabel.textColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE];
            cell.textLabel.text = self.busnessModel.busnessType;
            cell.imageView.image = WTImage(@"体验店图标");
            return cell;
        }break;
        case 2:{
            return  [self getDetailCell:indexPath];
            
        }break;
        case 3:{
            return [self getDetailRankCell:indexPath];
        }break;
    }
    return [UITableViewCell new];
}

- (GLD_DetailIntroCell *)getDetailIntroCell:(NSIndexPath *)indexPath{
    GLD_DetailIntroCell *cell = [self.tableView dequeueReusableCellWithIdentifier:GLD_DetailIntroCellIdentifier];
    cell.busnessModel = self.busnessModel;
    return cell;
}
- (GLD_DetaileCell *)getDetailCell:(NSIndexPath *)indexPath{
    GLD_DetaileCell *cell = [self.tableView dequeueReusableCellWithIdentifier:GLD_DetaileCellIdentifier];
    cell.instroStr = self.busnessModel.desc;
    return cell;
}
- (GLD_DetailRankCell *)getDetailRankCell:(NSIndexPath *)indexPath{
    GLD_DetailRankCell *cell = [self.tableView dequeueReusableCellWithIdentifier:GLD_DetailRankCellIdentifier];
    cell.starCont = [self.busnessModel.evaluateScore integerValue];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            return W(120);
        } break;
        case 1:{
            return W(50);
        } break;
        case 2:{
            CGFloat height = [YXUniversal calculateCellHeight:0 width:300 text:self.busnessModel.desc font:14];
            
            return W(50)+height;
        } break;
        case 3:{
            return W(50);
        } break;
    }
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section != 0) return [UIView new];
    UITableViewHeaderFooterView *headerView = [[UITableViewHeaderFooterView alloc]init];
    UIImageView * imgV = [[UIImageView alloc]init];
    [imgV yy_setImageWithURL:[NSURL URLWithString:self.busnessModel.logo] placeholder:nil];
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
