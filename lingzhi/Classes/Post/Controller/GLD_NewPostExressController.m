//
//  GLD_NewPostExressController.m
//  lingzhi
//
//  Created by 锅里的 on 2019/5/15.
//  Copyright © 2019 com.lingzhi. All rights reserved.
//

#import "GLD_NewPostExressController.h"
#import "GLD_ExpressModel.h"
#import "GLD_PostExressManager.h"
#import "GLD_PostTypeManager.h"

@interface GLD_NewPostExressController ()<GLD_PostTypeManagerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GLD_PostTypeManager *postTypeManager;
@property (nonatomic, strong) GLD_PostExressManager *postManager;
@property (nonatomic, strong) UIButton *postBut;
@end

@implementation GLD_NewPostExressController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.postManager = [[GLD_PostExressManager alloc]initWith:self.tableView andViewC:self];
    self.postTypeManager = [[GLD_PostTypeManager alloc]initWithDelegate:self];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
}
- (void)didSeletedPoseType:(NSInteger)type{
    self.postManager.expressModel.type = @(type);
    [self.postManager reloadData];
}
- (void)postClick{
    
}
- (void)setupUI{
    [self.view addSubview:self.postTypeManager.collectionView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.postBut];
    
    [self.postTypeManager.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.equalTo(@(44));
        
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.view);
        make.top.equalTo(self.postTypeManager.collectionView.mas_bottom);
        make.bottom.equalTo(self.postBut.mas_top);
    }];
    [self.postBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-20);
        make.centerX.equalTo(self.view);
        make.height.equalTo(@(44));
        make.width.equalTo(@(345));
    }];
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, DEVICE_WIDTH, DEVICE_HEIGHT-60) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.scrollEnabled = NO;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.sectionIndexBackgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0];
        _tableView.sectionIndexColor = [UIColor blueColor];
        
    }
    return _tableView;
}
- (UIButton *)postBut{
    if (!_postBut) {
        _postBut = [[UIButton alloc]init];
        [_postBut setTitle:@"提交" forState:UIControlStateNormal];
        _postBut.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE];
        _postBut.layer.cornerRadius = 5;
        [_postBut addTarget:self action:@selector(postClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _postBut;
}
@end
