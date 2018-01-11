//
//  GLD_ForgetPassControllor.m
//  lingzhi
//
//  Created by rabbit on 2017/12/31.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_ForgetPassControllor.h"
#import "BRTextField.h"
#import "NSDate+BRAdd.h"

@interface GLD_ForgetPassControllor ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong)UITableView *table_apply;

/** 新密码 */
@property (nonatomic, strong) BRTextField *newsWordTF;
/** 在输入 */
@property (nonatomic, strong) BRTextField *aginTF;

@property (nonatomic, strong) NSArray *titleArr;//

@property (nonatomic, strong)GLD_NetworkAPIManager *NetManager;
@end

@implementation GLD_ForgetPassControllor

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *rightBut = [[UIButton alloc]init];;
    
    rightBut.frame = CGRectMake(0, 0, W(50), 44);
    [rightBut setImage:WTImage(@"") forState:UIControlStateNormal];
    [rightBut addTarget:self action:@selector(rightButClick) forControlEvents:UIControlEventTouchUpInside];
    rightBut.titleLabel.font = WTFont(15);
    [rightBut setTitle:@"保存" forState:UIControlStateNormal];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:rightBut];
    self.navigationItem.rightBarButtonItem = item1;
    [self.view addSubview:self.table_apply];
    
    self.NetManager = [GLD_NetworkAPIManager new];
}

- (void)rightButClick{
    
    [self.view endEditing:YES];
    if (!IsExist_String(self.newsWordTF.text)) {
        [CAToast showWithText:@"请输入新密码"];
        return;
    }
    
    if (![self.newsWordTF.text isEqualToString:self.aginTF.text]) {
        [CAToast showWithText:@"不一致"];
        return;
    }
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = @"api/user/missPassword";
    config.requestParameters = @{@"phone" : GetString(self.phone),
                                 @"password" : GetString(self.newsWordTF.text)
                                 };
    
    [self.NetManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        if (!error) {
            
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isMemberOfClass:NSClassFromString(@"GLD_LoginController")]) {
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
            [CAToast showWithText:@"修改成功"];
        }
        //        weakSelf.phoneCode = @"1111";
        
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"systemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    cell.textLabel.textColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTBLACK];
    cell.textLabel.text = self.titleArr[indexPath.row];
    switch (indexPath.row) {
        case 0:{
            [self setupNewsWordTF:cell];
        }break;
        case 1:{
            [self setupAginTF:cell];
        }break;
    }
    
    return cell;
}
- (BRTextField *)getTextField:(UITableViewCell *)cell {
    BRTextField *textField = [[BRTextField alloc]initWithFrame:CGRectMake(DEVICE_WIDTH - W(230), 0, W(200), W(50))];
    textField.backgroundColor = [UIColor clearColor];
    textField.font = [UIFont systemFontOfSize:16.0f];
    textField.textAlignment = NSTextAlignmentRight;
    textField.textColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTnewGray];
    textField.delegate = self;
    [cell.contentView addSubview:textField];
    return textField;
}

#pragma mark - 新密码
- (void)setupNewsWordTF:(UITableViewCell *)cell{
    if (!_newsWordTF) {
        _newsWordTF = [self getTextField:cell];
        _newsWordTF.placeholder = @"请输入";
        _newsWordTF.returnKeyType = UIReturnKeyDone;
        _newsWordTF.tag = 1;
    }
}
#pragma mark - 再次输入
- (void)setupAginTF:(UITableViewCell *)cell{
    if (!_aginTF) {
        _aginTF = [self getTextField:cell];
        _aginTF.placeholder = @"请输入";
        _aginTF.returnKeyType = UIReturnKeyDone;
        _aginTF.tag = 2;
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
        _titleArr = @[@"新密码",@"再次输入"];
    }
    return _titleArr;
}
@end
