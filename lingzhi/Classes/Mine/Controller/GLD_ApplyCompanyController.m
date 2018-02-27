//
//  GLD_ApplyCompanyController.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/11.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_ApplyCompanyController.h"
#import "NSDate+BRAdd.h"
#import "BRTextField.h"
#import "BRDatePickerView.h"
#import "BRStringPickerView.h"

@interface GLD_ApplyCompanyController ()<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong)UITableView *table_apply;
/** 公司名称 */
@property (nonatomic, strong) BRTextField *nameTF;

/** 负责人 */
@property (nonatomic, strong) BRTextField *PersonTF;
/** 联系电话 */
@property (nonatomic, strong) BRTextField *discountTF;

/** 预计投入资金 */
@property (nonatomic, strong) BRTextField *verificationTF;

/** 意向合作省份 */
@property (nonatomic, strong) BRTextField *industryTF;
/** 意向合作市 */
@property (nonatomic, strong) BRTextField *cityTF;
/** 意向合作区 */
@property (nonatomic, strong) BRTextField *areaTF;
/** 联系电话 */
@property (nonatomic, strong) BRTextField *businessTypeTF;

@property (nonatomic, strong) NSArray *titleArr;//
@property (nonatomic, strong) UIButton *nextBut;
@property (nonatomic, strong)GLD_NetworkAPIManager *netManager;

@property (nonatomic, assign)NSInteger areaIdex;//2 省 1 市 0区

@property (nonatomic, strong) NSArray *addressArr;//
@property (nonatomic, strong) NSMutableArray *provenceArr;//
@property (nonatomic, strong) NSMutableArray *cityArr;//
@property (nonatomic, strong) NSMutableArray *areaArr;//
@end

@implementation GLD_ApplyCompanyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.areaIdex = 2;//默认为省
    // Do any additional setup after loading the view.
    self.netManager = [GLD_NetworkAPIManager new];
    self.provenceArr = [NSMutableArray array];
    self.cityArr = [NSMutableArray array];
    self.areaArr = [NSMutableArray array];
    [self.view addSubview:self.table_apply];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *plistPath = [bundle pathForResource:@"address" ofType:@"plist"];
        self.addressArr = [[NSArray alloc] initWithContentsOfFile:plistPath];
        
        for (int i = 0; i < self.addressArr.count; i++) {
            NSDictionary *dict = self.addressArr[i];
            
            [self.provenceArr addObject:dict[@"name"]];
           
        }
    })
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArr.count- self.areaIdex;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"systemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    cell.textLabel.textColor = RGB_HEX(0x464646, 1.0f);
    cell.textLabel.text = self.titleArr[indexPath.row];
    switch (indexPath.row) {
        case 0:{
            [self setupNameTF:cell];
        }break;
        case 1:{
            [self setupPersonTF:cell];
        }break;
        case 2:{
            [self setupDiscountTF:cell];
        }break;
        case 3:{
            [self setupVerificationTF:cell];
        }break;
        case 4:{
            [self setupBusinessTypeTF:cell];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }break;
        case 5:{
            [self setupIndustryTF:cell];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }break;
        case 6:{
            [self setupCityTF:cell];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }break;
        case 7:{
            [self setupAreaTF:cell];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }break;
    }
    
    return cell;
}

#pragma mark - 渠道类型
- (void)setupBusinessTypeTF:(UITableViewCell *)cell {
    if (!_businessTypeTF) {
        _businessTypeTF = [self getTextField:cell];
        _businessTypeTF.placeholder = @"请选择渠道商";
        __weak typeof(self) weakSelf = self;
        _businessTypeTF.tapAcitonBlock = ^{
            //跳转地区
            [BRStringPickerView showStringPickerWithTitle:@"选择代理商" dataSource:@[@"省代理商", @"市代理商", @"区代理商"] defaultSelValue:@"省代理商" isAutoSelect:YES resultBlock:^(id selectValue) {
                if([selectValue isEqualToString:@"省代理商"]){
                    weakSelf.areaIdex = 2;
                }else if([selectValue isEqualToString:@"市代理商"]){
                    weakSelf.areaIdex = 1;
                }else{
                    weakSelf.areaIdex = 0;
                }
                weakSelf.businessTypeTF.text = selectValue;
                [weakSelf.table_apply reloadData];
            }];

        };
    }
}
- (BRTextField *)getTextField:(UITableViewCell *)cell {
    BRTextField *textField = [[BRTextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - W(230), 0, W(200), W(50))];
    textField.backgroundColor = [UIColor clearColor];
    textField.font = [UIFont systemFontOfSize:16.0f];
    textField.textAlignment = NSTextAlignmentRight;
    textField.textColor = RGB_HEX(0x666666, 1.0);
    textField.delegate = self;
    [cell.contentView addSubview:textField];
    return textField;
}
#pragma mark - 门店名称
- (void)setupNameTF:(UITableViewCell *)cell{
    if (!_nameTF) {
        _nameTF = [self getTextField:cell];
        _nameTF.placeholder = @"请输入";
        _nameTF.returnKeyType = UIReturnKeyDone;
        _nameTF.tag = 0;
    }
}
#pragma mark - 负责人
- (void)setupPersonTF:(UITableViewCell *)cell{
    if (!_PersonTF) {
        _PersonTF = [self getTextField:cell];
        _PersonTF.placeholder = @"请输入";
        _PersonTF.returnKeyType = UIReturnKeyDone;
        _PersonTF.tag = 1;
    }
}
#pragma mark - 电话
- (void)setupDiscountTF:(UITableViewCell *)cell{
    if (!_discountTF) {
        _discountTF = [self getTextField:cell];
        _discountTF.placeholder = @"请输入";
        _discountTF.returnKeyType = UIReturnKeyDone;
        _discountTF.tag = 2;
    }
}
#pragma mark - 负责人
- (void)setupVerificationTF:(UITableViewCell *)cell{
    if (!_verificationTF) {
        _verificationTF = [self getTextField:cell];
        _verificationTF.placeholder = @"请输入(选填，省代理不用填写)";
        _verificationTF.returnKeyType = UIReturnKeyDone;
        _verificationTF.tag = 3;
    }
}
#pragma mark - 所属行业
- (void)setupIndustryTF:(UITableViewCell *)cell {
    if (!_industryTF) {
        _industryTF = [self getTextField:cell];
        _industryTF.placeholder = @"请选择合作省份";
        __weak typeof(self) weakSelf = self;
        _industryTF.tapAcitonBlock = ^{
            //跳转地区
           
            [BRStringPickerView showStringPickerWithTitle:@"地区" dataSource:@[@"北京市", @"上海市", @"天津市",@"重庆市",@"河北省",@"山西省",@"台湾省",@"辽宁省",@"吉林省",@"黑龙江省",@"江苏省",@"浙江省",@"安徽省",@"福建省",@"江西省",@"山东省",@"河南省",@"湖北省",@"湖南省",@"广东省",@"甘肃省",@"四川省",@"贵州省",@"海南省",@"云南省",@"青海省",@"陕西省",@"广西壮族自治区",@"西藏自治区",@"宁夏回族自治区",@"新疆维吾尔自治区",@"内蒙古自治区",@"澳门特别行政区",@"香港特别行政区"] defaultSelValue:@"北京市" isAutoSelect:YES resultBlock:^(id selectValue) {
                weakSelf.industryTF.text = selectValue;
            }];
        };
    }
}
#pragma mark - 市
- (void)setupCityTF:(UITableViewCell *)cell {
    if (!_cityTF) {
        _cityTF = [self getTextField:cell];
        _cityTF.placeholder = @"请选择合作城市";
        __weak typeof(self) weakSelf = self;
        _cityTF.tapAcitonBlock = ^{
            //跳转地区
            
            [BRStringPickerView showStringPickerWithTitle:@"地区" dataSource:@[@"北京市", @"上海市", @"天津市",@"重庆市",@"河北省",@"山西省",@"台湾省",@"辽宁省",@"吉林省",@"黑龙江省",@"江苏省",@"浙江省",@"安徽省",@"福建省",@"江西省",@"山东省",@"河南省",@"湖北省",@"湖南省",@"广东省",@"甘肃省",@"四川省",@"贵州省",@"海南省",@"云南省",@"青海省",@"陕西省",@"广西壮族自治区",@"西藏自治区",@"宁夏回族自治区",@"新疆维吾尔自治区",@"内蒙古自治区",@"澳门特别行政区",@"香港特别行政区"] defaultSelValue:@"北京市" isAutoSelect:YES resultBlock:^(id selectValue) {
                weakSelf.industryTF.text = selectValue;
            }];
        };
    }
}
#pragma mark - 区
- (void)setupAreaTF:(UITableViewCell *)cell {
    if (!_areaTF) {
        _areaTF = [self getTextField:cell];
        _areaTF.placeholder = @"请选择合作区域";
        __weak typeof(self) weakSelf = self;
        _areaTF.tapAcitonBlock = ^{
            //跳转地区
            
            [BRStringPickerView showStringPickerWithTitle:@"地区" dataSource:@[@"北京市", @"上海市", @"天津市",@"重庆市",@"河北省",@"山西省",@"台湾省",@"辽宁省",@"吉林省",@"黑龙江省",@"江苏省",@"浙江省",@"安徽省",@"福建省",@"江西省",@"山东省",@"河南省",@"湖北省",@"湖南省",@"广东省",@"甘肃省",@"四川省",@"贵州省",@"海南省",@"云南省",@"青海省",@"陕西省",@"广西壮族自治区",@"西藏自治区",@"宁夏回族自治区",@"新疆维吾尔自治区",@"内蒙古自治区",@"澳门特别行政区",@"香港特别行政区"] defaultSelValue:@"北京市" isAutoSelect:YES resultBlock:^(id selectValue) {
                weakSelf.industryTF.text = selectValue;
            }];
        };
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
        _titleArr = @[@"公司名称",@"办事处",@"联系电话",@"邀请码",@"代理商类型",@"意向合作省份",@"意向合作城市",@"意向合作区域"];
    }
    return _titleArr;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return W(60);
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *headView = [UIView new];
    [self canSetNextBut:headView];
    return headView;
}
- (void)canSetNextBut:(UIView *)headView{
    if (!_nextBut) {
        UIButton *nextBut = [[UIButton alloc]init];
        [headView addSubview:nextBut];
        nextBut.titleLabel.font = WTFont(16);
        [nextBut setTitle:@"下一步" forState:UIControlStateNormal];
        [nextBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        nextBut.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_BLUE];
        [nextBut addTarget:self action:@selector(nextButClick) forControlEvents:UIControlEventTouchUpInside];
        [nextBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(headView).offset(-W(10));
            make.right.equalTo(headView).offset(-W(15));
            make.left.equalTo(headView).offset(W(15));
            make.height.equalTo(WIDTH(40));
        }];
        
    }
}
- (void)nextButClick{
    WS(weakSelf);
    
    if(!IsExist_String(self.nameTF.text)){
        [CAToast showWithText:@"请输入公司名称"];
        return;
    }
    if(!IsExist_String(self.PersonTF.text)){
        [CAToast showWithText:@"请输入办事处名称"];
        return;
    }
    if(!IsExist_String(self.discountTF.text)){
        [CAToast showWithText:@"请输入电话"];
        return;
    }
//    if(!IsExist_String(self.verificationTF.text)){
//        [CAToast showWithText:@"请输入预计投入资金"];
//        return;
//    }
    if(!IsExist_String(self.businessTypeTF.text)){
        [CAToast showWithText:@"请选择渠道商"];
        return;
    }
    switch (self.areaIdex) {
        case 0:{
            if(!IsExist_String(self.industryTF.text)){
                [CAToast showWithText:@"请输入意向合作省份"];
                return;
            }
            if(!IsExist_String(self.cityTF.text)){
                [CAToast showWithText:@"请输入意向合作城市"];
                return;
            }
            if(!IsExist_String(self.areaTF.text)){
                [CAToast showWithText:@"请输入意向合作区域"];
                return;
            }
        }break;
        case 1:{
            if(!IsExist_String(self.industryTF.text)){
                [CAToast showWithText:@"请输入意向合作省份"];
                return;
            }
            if(!IsExist_String(self.cityTF.text)){
                [CAToast showWithText:@"请输入意向合作城市"];
                return;
            }
        }break;
        case 2:{
            if(!IsExist_String(self.industryTF.text)){
                [CAToast showWithText:@"请输入意向合作省份"];
                return;
            }
        }break;
    }
    
 
    NSString *area = [NSString stringWithFormat:@"%@%@%@",GetString(self.industryTF.text),GetString(self.cityTF.text),GetString(self.areaTF.text)];
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = @"api/user/adagentUser";
    config.requestParameters = @{@"agentType" : GetString(self.businessTypeTF.text),
                                 @"phone" : GetString(self.discountTF.text),
                                 @"company" : GetString(self.PersonTF.text),//描述
                                 @"inviteCode" : GetString(self.verificationTF.text),
                                 @"area" : area,
                                 @"officeName" : GetString(self.PersonTF.text),
                                 @"userId" : GetString([AppDelegate shareDelegate].userModel.userId),
                                 };
    
    [self.netManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        if (!error) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [CAToast showWithText:@"申请成功,请耐心等待"];
        }else{
            [CAToast showWithText:@"申请失败,请重试"];
        }
    }];
}
@end
