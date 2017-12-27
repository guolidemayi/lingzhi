//
//  GLD_wanShanUserMController.m
//  lingzhi
//
//  Created by rabbit on 2017/12/28.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_wanShanUserMController.h"
#import "BRTextField.h"
#import "BRDatePickerView.h"
#import "NSDate+BRAdd.h"
#import "GLD_CustomBut.h"
#import "BRStringPickerView.h"

@interface GLD_wanShanUserMController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong)UITableView *table_apply;
/** 姓名 */
@property (nonatomic, strong) BRTextField *nicknameTF;
/** 性别 */
@property (nonatomic, strong) BRTextField *genderTF;
/** 所在地 */
@property (nonatomic, strong) BRTextField *locationTF;

/** 补贴对象 */
@property (nonatomic, strong) BRTextField *personalTypeTF;
@end

@implementation GLD_wanShanUserMController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

#pragma mark - 姓名 textField
- (void)setupNicknameTF:(UITableViewCell *)cell{
    if (!_nicknameTF) {
        _nicknameTF = [self getTextField:cell];
        _nicknameTF.placeholder = @"请输入";
        _nicknameTF.returnKeyType = UIReturnKeyDone;
        _nicknameTF.tag = 0;
    }
}

#pragma mark - 性别 textField
- (void)setupGenderTF:(UITableViewCell *)cell {
    if (!_genderTF) {
        _genderTF = [self getTextField:cell];
        _genderTF.placeholder = @"请选择";
        __weak typeof(self) weakSelf = self;
        _genderTF.tapAcitonBlock = ^{
            [BRStringPickerView showStringPickerWithTitle:@"宝宝性别" dataSource:@[@"男", @"女", @"其他"] defaultSelValue:@"男" isAutoSelect:YES resultBlock:^(id selectValue) {
                weakSelf.genderTF.text = selectValue;
            }];
        };
    }
}

#pragma mark - 地区 textField
- (void)setupLocationTF:(UITableViewCell *)cell {
    if (!_locationTF) {
        _locationTF = [self getTextField:cell];
        _locationTF.placeholder = @"请选择";
        __weak typeof(self) weakSelf = self;
        _locationTF.tapAcitonBlock = ^{
            [BRStringPickerView showStringPickerWithTitle:@"宝宝性别" dataSource:@[@"男", @"女", @"其他"] defaultSelValue:@"男" isAutoSelect:YES resultBlock:^(id selectValue) {
                weakSelf.genderTF.text = selectValue;
            }];
        };
    }
}
#pragma mark - 补贴 textField
- (void)setupPersonalTypeTF:(UITableViewCell *)cell {
    if (!_personalTypeTF) {
        _personalTypeTF = [self getTextField:cell];
        _personalTypeTF.placeholder = @"请选择";
        __weak typeof(self) weakSelf = self;
        _personalTypeTF.tapAcitonBlock = ^{
            
        };
    }
}
@end
