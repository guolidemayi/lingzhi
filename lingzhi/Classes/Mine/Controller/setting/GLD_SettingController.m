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
@interface GLD_SettingController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong)UITableView *table_apply;
@property (nonatomic, strong) NSArray *titleArr;//
@property (nonatomic, strong)UILabel *applyLabel;

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
            //关于我们
        }break;
    }
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
        _titleArr = @[@[@"手机绑定",@"密码修改"],@[@"清除缓存"],@[@"关于"]];
    }
    return _titleArr;
}

@end
