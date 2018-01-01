//
//  GLD_MineManager.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/5.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_MineManager.h"
#import "GLD_MinePersonalCell.h"
#import "GLD_MineWalletCell.h"
#import "GLD_MineSettingCell.h"
#import "TestViewController.h"
#import "GLD_ApplyBusnessController.h"
#import "GLD_ApplyCooperatController.h"
#import "GLD_VerificationController.h"
#import "GLD_SettingController.h"
#import "GLD_MyWalletController.h"
#import "GLD_LoginController.h"
#import "GLD_PerfectUserMController.h"
#import "GLD_MyStoreCell.h"
#import "GLD_ManagerStoreController.h"
#import "GLD_UserMessageModel.h"

@interface GLD_MineManager ()

@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong)UIView *hasLoginHeadView;

@property (nonatomic, weak) UIImageView *iconImgV;

@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel*codeLabel;
@property (nonatomic, strong)NSArray *dataArr;
@end
@implementation GLD_MineManager


- (void)setComponentCorner{
    [self.tableView registerClass:[GLD_MinePersonalCell class] forCellReuseIdentifier:GLD_MinePersonalCellIdentifier];
    [self.tableView registerClass:[GLD_MineWalletCell class] forCellReuseIdentifier:GLD_MineWalletCellIdentifier];
    [self.tableView registerClass:[GLD_MineSettingCell class] forCellReuseIdentifier:GLD_MineSettingCellIdentifier];
    [self.tableView registerClass:[GLD_MyStoreCell class] forCellReuseIdentifier:GLD_MyStoreCellIdentifier];
}
- (void)fetchMainData{
//    self.tableView.tableHeaderView = self.hasLoginHeadView;
    WS(weakSelf);
    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"loginToken"];
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = @"api/user/getUserInfo";
    config.requestParameters = @{@"loginToken":GetString(str)};
    [super dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        
        if (!error) {
            
            GLD_UserModel *model = [[GLD_UserModel alloc] initWithDictionary:result error:nil];
            
            [AppDelegate shareDelegate].userModel = model.data;
            [weakSelf.tableView reloadData];
        }
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}
- (void)reloadOrLoadMoreData{
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
}
- (void)loginButClick{
    NSLog(@"登陆");
    UIStoryboard *liveBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    GLD_LoginController *loginRegisterGuideVC = [liveBoard instantiateViewControllerWithIdentifier:@"GLD_LoginController"];
    GLD_BaseNavController *navUser = [[GLD_BaseNavController alloc]initWithRootViewController:loginRegisterGuideVC background:[YXUniversal createImageWithColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE]] font:WTFont(16) textColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKwirte] shadowColor:nil];
    [self.tableView.navigationController presentViewController:navUser animated:YES completion:^{
        
    }];
}
- (void)registerButClick{
    NSLog(@"注册");
    GLD_PerfectUserMController *UserVc = [[GLD_PerfectUserMController alloc]init];
    GLD_BaseNavController *navUser = [[GLD_BaseNavController alloc]initWithRootViewController:UserVc background:[YXUniversal createImageWithColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE]] font:WTFont(16) textColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKwirte] shadowColor:nil];
    [self.tableView.navigationController presentViewController:navUser animated:YES completion:^{
        
    }];
}

- (void)iconImgVClick{
    NSLog(@"头像");
}
- (void)editUserMessageClick:(UITapGestureRecognizer *)tap{
     NSLog(@"个人信息");
    TestViewController *userMessageVc = [[TestViewController alloc]init];
    userMessageVc.type = 2;
    [self.tableView.navigationController pushViewController:userMessageVc animated:YES];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            
            break;
            
        case 1:{
            //我的钱包
            GLD_MyWalletController *applyVc = [GLD_MyWalletController new];
            [self.tableView.navigationController pushViewController:applyVc animated:YES];
        }break;
        case 2:{
            if (hasLogin && [AppDelegate shareDelegate].userModel.isHasBusness) {
                //门店管理
                GLD_ManagerStoreController *mangeVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GLD_ManagerStoreController"];
                
                [self.tableView.navigationController pushViewController:mangeVc animated:YES];
                return;
            }
            GLD_ApplyBusnessController *applyVc = [GLD_ApplyBusnessController new];
            [self.tableView.navigationController pushViewController:applyVc animated:YES];
        }break;
        case 3:{
            //合作申请
            GLD_ApplyCooperatController *applyVc = [GLD_ApplyCooperatController new];
            [self.tableView.navigationController pushViewController:applyVc animated:YES];
        }break;
        case 4:{
            //实名认证
            GLD_VerificationController *applyVc = [GLD_VerificationController new];
            [self.tableView.navigationController pushViewController:applyVc animated:YES];
        }break;
        case 5:{
            //设置
            GLD_SettingController *applyVc = [GLD_SettingController new];
            [self.tableView.navigationController pushViewController:applyVc animated:YES];
        }break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        if (hasLogin) {
            self.nameLabel.text = [AppDelegate shareDelegate].userModel.name;
            self.codeLabel.text = [NSString stringWithFormat:@"编号  %@", [AppDelegate shareDelegate].userModel.code];
            [self.iconImgV yy_setImageWithURL:[NSURL URLWithString:[AppDelegate shareDelegate].userModel.iconImage] placeholder:WTImage(@"默认头像")];
            return self.hasLoginHeadView;
        }
        return self.headView;
    }
    UIView *v = [UIView new];
    v.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTTopLine];
    return v;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0)
    return W(120);
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return W(100);
            break;
            
        case 1:
            return hasLogin ? W(130) : W(40);
            break;
        case 2:
            return (hasLogin && [AppDelegate shareDelegate].userModel.isHasBusness) ? W(130) : W(40);
            break;
        case 3:
        case 4:
        case 5:
            return W(50);
            break;
    }
    return 0.0001;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3 + self.dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return [self getMinePerconalCell:indexPath];
            break;
        case 1:
            return [self getMineWalletCell:indexPath];            
            break;
        case 2:
            return [self getMyStoreCell:indexPath];
            break;
        case 3:
        case 4:
        case 5:
            return [self getMineSettingCell:indexPath];
            break;
    }
    
    return [UITableViewCell new];
}

- (GLD_MyStoreCell *)getMyStoreCell:(NSIndexPath *)indexPath{
    GLD_MyStoreCell *cell = [self.tableView dequeueReusableCellWithIdentifier:GLD_MyStoreCellIdentifier];
    cell.height = (hasLogin && [AppDelegate shareDelegate].userModel.isHasBusness) ? W(80) : 0;
    return cell;

}
- (GLD_MinePersonalCell *)getMinePerconalCell:(NSIndexPath *)indexPath{
    GLD_MinePersonalCell *cell = [self.tableView dequeueReusableCellWithIdentifier:GLD_MinePersonalCellIdentifier];
    return cell;
}

- (GLD_MineWalletCell *)getMineWalletCell:(NSIndexPath *)indexPath{
    GLD_MineWalletCell *cell = [self.tableView dequeueReusableCellWithIdentifier:GLD_MineWalletCellIdentifier];
    cell.height = hasLogin ? W(80) : 0;
    return cell;
}
- (GLD_MineSettingCell *)getMineSettingCell:(NSIndexPath *)indexPath{
    GLD_MineSettingCell *cell = [self.tableView dequeueReusableCellWithIdentifier:GLD_MineSettingCellIdentifier];
    cell.dict = self.dataArr[indexPath.section - 2];
    return cell;
}
- (UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, W(120))];
        _headView.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKyellow];
        
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = [UIColor whiteColor];
        [_headView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_headView);
            make.width.equalTo(@(2));
            make.height.equalTo(WIDTH(20));
        }];
        
        UIButton *loginBut = [[UIButton alloc]init];
        loginBut.titleLabel.font = WTFont(15);
        [loginBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loginBut setTitle:@"登陆" forState:UIControlStateNormal];
        [loginBut addTarget:self action:@selector(loginButClick) forControlEvents:UIControlEventTouchUpInside];
        [_headView addSubview:loginBut];
        [loginBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(lineView.mas_left).offset(W(-15));
            make.centerY.equalTo(lineView);
        }];
        
        
        
        UIButton *registerBut = [[UIButton alloc]init];
        registerBut.titleLabel.font = WTFont(15);
        [registerBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [registerBut setTitle:@"注册" forState:UIControlStateNormal];
        [registerBut addTarget:self action:@selector(registerButClick) forControlEvents:UIControlEventTouchUpInside];
        [_headView addSubview:registerBut];
        [registerBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lineView.mas_right).offset(W(15));
            make.centerY.equalTo(lineView);
        }];
    }
    return _headView;
}

- (UIView *)hasLoginHeadView{
    if (!_hasLoginHeadView) {
        _hasLoginHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, W(120))];
        _hasLoginHeadView.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKyellow];
        _hasLoginHeadView.userInteractionEnabled = YES;
        [_hasLoginHeadView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editUserMessageClick:)]];
        UIImageView *iconImgV = [[UIImageView alloc]init];
        iconImgV.layer.borderColor = [UIColor whiteColor].CGColor;
        iconImgV.layer.borderWidth = 1;
        iconImgV.layer.cornerRadius = W(25);
        iconImgV.layer.masksToBounds = YES;
        iconImgV.image = WTImage(@"默认头像");
        iconImgV.userInteractionEnabled = YES;
        [iconImgV addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(iconImgVClick)]];
        self.iconImgV = iconImgV;
        [_hasLoginHeadView addSubview:iconImgV];
        [iconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_hasLoginHeadView);
            make.width.height.equalTo(WIDTH(50));
            make.left.equalTo(_hasLoginHeadView).offset(W(15));
        }];
        
        
        UILabel *userNameLabel = [[UILabel alloc]init];
        userNameLabel.font = WTFont(15);
        userNameLabel.textColor = [UIColor whiteColor];
        self.nameLabel = userNameLabel;
        userNameLabel.text = @"用户";
        [_hasLoginHeadView addSubview:userNameLabel];
        [userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iconImgV).offset(W(5));
            make.left.equalTo(iconImgV.mas_right).offset(W(15));
            make.right.equalTo(_hasLoginHeadView).offset(W(-15));
        }];
        UILabel *numberLabel = [[UILabel alloc]init];
        numberLabel.font = WTFont(12);
        self.codeLabel = numberLabel;
        numberLabel.textColor = [UIColor whiteColor];
        numberLabel.text = @"编号  123456";
        [_hasLoginHeadView addSubview:numberLabel];
        [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(userNameLabel.mas_bottom).offset(W(8));
            make.left.right.equalTo(userNameLabel);
        }];
        
    }
    return _hasLoginHeadView;
}

- (NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr = @[@{@"title":@"我的联盟门店",
                       @"detailTitle":@"未开启门店",
                       },
                     @{@"title":@"合作申请",
                       @"detailTitle":@"联盟门店、渠道商申请",
                       },
                     @{@"title":@"实名认证",
                       @"detailTitle":@"",
                       },
                     @{@"title":@"系统设置",
                       @"detailTitle":@"",
                       }
                     ];
    }
    return _dataArr;
}
@end
