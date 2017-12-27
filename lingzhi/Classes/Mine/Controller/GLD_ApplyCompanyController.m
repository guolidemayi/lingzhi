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

@property (nonatomic, strong) NSArray *titleArr;//
@property (nonatomic, strong) UIButton *nextBut;
@end

@implementation GLD_ApplyCompanyController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.table_apply];
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
            [self setupIndustryTF:cell];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }break;
    }
    
    return cell;
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
        _verificationTF.placeholder = @"请输入";
        _verificationTF.returnKeyType = UIReturnKeyDone;
        _verificationTF.tag = 3;
    }
}
#pragma mark - 所属行业
- (void)setupIndustryTF:(UITableViewCell *)cell {
    if (!_industryTF) {
        _industryTF = [self getTextField:cell];
        _industryTF.placeholder = @"请选择所属行业";
        __weak typeof(self) weakSelf = self;
        _industryTF.tapAcitonBlock = ^{
            //跳转地区
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
        _titleArr = @[@"公司名称",@"办事处",@"联系电话",@"预计投入资金",@"意向合作省份"];
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
@end
