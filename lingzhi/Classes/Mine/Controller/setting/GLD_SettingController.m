//
//  GLD_SettingController.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/12.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_SettingController.h"
#import "GLD_ChangePhoneController.h"
#import "GLD_ChangePassWordController.h"
#import "GLD_AboutUsController.h"
@interface GLD_SettingController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong)UITableView *table_apply;
@property (nonatomic, strong) NSArray *titleArr;//
@property (nonatomic, strong)UILabel *applyLabel;

@property (nonatomic, strong)UIButton *applyBut;//现金
@property (nonatomic, strong) UILabel *tipLabel;
@end

@implementation GLD_SettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"系统设置";
    [self.view addSubview:self.table_apply];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.titleArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr =self.titleArr[section];
    
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"systemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    
    NSArray *arr = self.titleArr[indexPath.section];
    switch (indexPath.section) {
        case 0:{
            cell.textLabel.text = arr[indexPath.row];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }break;
        case 1:{
            cell.textLabel.text = arr[indexPath.row];
            [self setUpApplyLabel:cell];
            self.applyLabel.text = [NSString stringWithFormat:@"%.2fM", [self folderSizeAtPath:[self getCachesPath]]];

        }break;
        case 2:{
            cell.textLabel.text = arr[indexPath.row];
            if(indexPath.row){
                [cell.contentView addSubview:self.tipLabel];
            }
        }break;
               
    }
    
    return cell;
    
}
- (void)setUpApplyLabel:(UITableViewCell *)cell{
    if (!_applyLabel) {
        
        UILabel *label = [[UILabel alloc]init];
        [cell.contentView addSubview:label];
        _applyLabel = label;
        label.font = WTFont(12);
        
        label.textColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTnewGray];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView).offset(W(-15));
        }];
        
    }
}
- (float )folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];//从前向后枚举器／／／／//
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSLog(@"fileName ==== %@",fileName);
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        NSLog(@"fileAbsolutePath ==== %@",fileAbsolutePath);
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    NSLog(@"folderSize ==== %lld",folderSize);
    return folderSize/(1024.0*1024.0);
}
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    
    return 0;
}
- (void)clean{
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       NSString *cachPath = [self getCachesPath];
                       
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       for (NSString *p in files) {
                           NSError *error;
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                       }
                       
                   });
    self.applyLabel.text = @"0.00M";
}

//获取缓存文件路径
-(NSString *)getCachesPath{
    // 获取Caches目录路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    
    NSString *filePath = [cachesDir stringByAppendingPathComponent:[[NSBundle mainBundle] bundleIdentifier]];
    
    return filePath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 0) {
                //手机绑定
                GLD_ChangePhoneController *phone = [GLD_ChangePhoneController new];
                [self.navigationController pushViewController:phone animated:YES];
            }else{
                //修改密码
                GLD_ChangePassWordController *phone = [GLD_ChangePassWordController new];
                [self.navigationController pushViewController:phone animated:YES];
            }
        }break;
        case 1:{
//            清除缓存
            [self clean];
        }break;
        case 2:{
            if(indexPath.row){
                NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"4000318358"];

                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                return;
            }
            //关于我们
            GLD_AboutUsController *aboutVc = [GLD_AboutUsController new];
            [self.navigationController pushViewController:aboutVc animated:YES];
        }break;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UITableViewHeaderFooterView *header = [UITableViewHeaderFooterView new];
    [header.contentView addSubview:self.applyBut];
    [self.applyBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(header.contentView);
        make.width.equalTo(WIDTH(300));
        make.height.equalTo(WIDTH(44));
    }];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 2)
    return W(70);
    return 0.001;
}
- (UITableView *)table_apply{
    if (!_table_apply) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        self.table_apply = tableView;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        [tableView setSeparatorInset:UIEdgeInsetsMake(0, W(15), 0, W(15))];
        tableView.mj_insetB = W(50);
        //        [tableView registerClass:[GLD_MapDetailCell class] forCellReuseIdentifier:GLD_MapDetailCellIdentifier];
        //        tableView.rowHeight = 0;
        tableView.sectionFooterHeight = 0.001;
    }
    return _table_apply;
}
- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = @[@[@"手机绑定",@"密码修改"],@[@"清除缓存"],@[@"关于",@"客服电话"]];
    }
    return _titleArr;
}
- (UIButton *)applyBut{
    if (!_applyBut) {
        _applyBut = [[UIButton alloc]init];
        [_applyBut setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKyellow] forState:UIControlStateNormal];
        [_applyBut setTitle:@"退出登录" forState:UIControlStateNormal];
        _applyBut.titleLabel.font = WTFont(15);
        _applyBut.layer.cornerRadius = 3;
        _applyBut.layer.masksToBounds = YES;
        _applyBut.layer.borderColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKyellow].CGColor;
        _applyBut.layer.borderWidth = 1;
        [_applyBut addTarget:self action:@selector(applybutClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _applyBut;
}
- (void)applybutClick{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"退出登录" message:@"是否允退出登录" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:userHasLogin];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"loginToken"];
        [AppDelegate shareDelegate].userModel = nil;
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [UILabel new];
        _tipLabel.frame = CGRectMake(DEVICE_WIDTH - W(135), 10, W(120), 25);
        _tipLabel.textColor = [UIColor grayColor];
        _tipLabel.font = WTFont(12);
        _tipLabel.textAlignment = NSTextAlignmentRight;
        _tipLabel.text = @"4000318358";
    }
    return _tipLabel;
}
@end
