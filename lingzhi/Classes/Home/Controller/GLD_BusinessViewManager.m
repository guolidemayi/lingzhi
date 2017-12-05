//
//  GLD_BusinessViewManager.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/4.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_BusinessViewManager.h"
#import "GLD_BusinessCell.h"

@implementation GLD_BusinessViewManager

- (void)setComponentCorner{
    [self.tableView registerClass:[GLD_BusinessCell class] forCellReuseIdentifier:GLD_BusinessCellIdentifier];
    self.tableView.rowHeight = W(100);
}
- (void)fetchMainData{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mainDataArrM.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self getBusinessCell:indexPath];
}
- (GLD_BusinessCell *)getBusinessCell:(NSIndexPath *)indexPath{
    GLD_BusinessCell *cell = [self.tableView dequeueReusableCellWithIdentifier:GLD_BusinessCellIdentifier];
    return cell;
}


@end
