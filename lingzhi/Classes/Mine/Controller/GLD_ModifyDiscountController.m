//
//  GLD_ModifyDiscountController.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/19.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_ModifyDiscountController.h"
#import "BRTextField.h"
#import "BRDatePickerView.h"
#import "NSDate+BRAdd.h"
#import "GLD_BusnessModel.h"

@interface GLD_ModifyDiscountController ()<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate>


@property (nonatomic, strong)UITableView *table_apply;
@property (nonatomic, strong)UIButton *applyBut;//升级
/** 折扣 */
@property (nonatomic, strong) BRTextField *discountTF;
@property (nonatomic, strong)GLD_NetworkAPIManager *NetManager;
@end

@implementation GLD_ModifyDiscountController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.table_apply];
    self.NetManager = [GLD_NetworkAPIManager new];
}


- (void)checkDiscountClick{
    
    UIAlertController *alerVc = [UIAlertController alertControllerWithTitle:@"折扣说明" message:@"您输入8，代表为8折（注意：不能为0）" preferredStyle:UIAlertControllerStyleAlert];
    [alerVc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"点击取消");
        
    }]];
    [self presentViewController:alerVc animated:YES completion:nil];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        
    }
    
    switch (indexPath.row) {
        case 0:{
            cell.textLabel.textColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTnewGray];
            cell.textLabel.text = @"门店名称";
            cell.detailTextLabel.textColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTnewGray];
            cell.textLabel.font = WTFont(15);
            cell.detailTextLabel.font = WTFont(12);
            cell.detailTextLabel.text = self.model.name;
        }break;
        case 1:{
            cell.textLabel.textColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTnewGray];
            cell.textLabel.text = @"门店电话";
            cell.detailTextLabel.textColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTnewGray];
            cell.textLabel.font = WTFont(15);
            cell.detailTextLabel.font = WTFont(12);
            cell.detailTextLabel.text = self.model.cellphone;
        }break;
        case 2:{
            cell.textLabel.textColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTBLACK];
            cell.textLabel.font = WTFont(15);
            cell.textLabel.text = @"折扣比例";
            [self setupDiscountTF:cell];
        }break;
    }
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UITableViewHeaderFooterView *footerView = [UITableViewHeaderFooterView new];
    [footerView.contentView addSubview:self.applyBut];
    [self.applyBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(WIDTH(44));
        make.right.bottom.equalTo(footerView.contentView).offset(W(-15));
        make.left.equalTo(footerView.contentView).offset(W(15));
    }];
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return W(70);
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
#pragma mark - 折扣比例
- (void)setupDiscountTF:(UITableViewCell *)cell{
    if (!_discountTF) {
        _discountTF = [self getTextField:cell];
//        _discountTF.placeholder = @"请输入";
        _discountTF.text = self.model.discount;
        _discountTF.returnKeyType = UIReturnKeyDone;
        _discountTF.tag = 2;
        UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - W(95), 0, W(80), W(50))];
        but.titleLabel.font = WTFont(12);
        _discountTF.frame = CGRectMake(SCREEN_WIDTH - W(200), 0, W(100), W(50));
        [cell.contentView addSubview:but];
        [but setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTRED] forState:UIControlStateNormal];
        [but setTitle:@"查看折扣说明" forState:UIControlStateNormal];
        [but addTarget:self action:@selector(checkDiscountClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
}
- (void)applybutClick{
    NSLog(@"确认");
    
    if (!IsExist_String(self.discountTF.text)) {
        [CAToast showWithText:@"请设置折扣"];
        return;
    }
    if(self.discountTF.text.integerValue > 10){
        [CAToast showWithText:@"请输入正确的折扣"];
        return;
    }
    WS(weakSelf);
    
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = @"api/user/resetDiscount";
    config.requestParameters = @{@"userId" : GetString([AppDelegate shareDelegate].userModel.userId),
                                 @"discount" : GetString(self.discountTF.text)};
    
    [self.NetManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
//        weakSelf.model = [[GLD_BusnessModel alloc] initWithDictionary:result error:&error];
        
        if (!error) {
            [CAToast showWithText:@"设置折扣成功"];
        }else{
            [CAToast showWithText:@"请设置折扣失败"];
        }
        //        weakSelf.phoneCode = @"1111";
    }];
    
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
- (UIButton *)applyBut{
    if (!_applyBut) {
        _applyBut = [[UIButton alloc]init];
        [_applyBut setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKyellow] forState:UIControlStateNormal];
        [_applyBut setTitle:@"提交" forState:UIControlStateNormal];
        _applyBut.titleLabel.font = WTFont(15);
        _applyBut.layer.cornerRadius = 3;
        _applyBut.layer.masksToBounds = YES;
        _applyBut.layer.borderColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKyellow].CGColor;
        _applyBut.layer.borderWidth = 1;
        [_applyBut addTarget:self action:@selector(applybutClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _applyBut;
}
@end
