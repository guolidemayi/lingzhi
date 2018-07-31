//
//  GLD_ExpressAdressController.m
//  lingzhi
//
//  Created by yiyangkeji on 2018/7/31.
//  Copyright © 2018年 com.lingzhi. All rights reserved.
//

#import "GLD_ExpressAdressController.h"
#import "GLD_MapDetailCell.h"

@interface GLD_ExpressAdressController ()<GLD_MapDetailCellDelegate>
@property (nonatomic, copy)void(^block)(AMapPOI *location);
@end

@implementation GLD_ExpressAdressController
+ (instancetype)initWithBlock:(void (^)(AMapPOI *location))block{
    GLD_ExpressAdressController *vc = [GLD_ExpressAdressController new];
    vc.block = block;
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    GLD_MapDetailCell *cell = [[GLD_MapDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GLD_MapDetailCell"];
    
    [self.view addSubview:cell.contentView];
    [cell.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}


- (void)selectLocation:(AMapPOI *)location{
    if (self.block) {
        self.block(location);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
