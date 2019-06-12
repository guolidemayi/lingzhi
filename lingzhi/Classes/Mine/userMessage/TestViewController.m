//
//  TestViewController.m
//  BRPickerViewDemo
//
//  Created by 任波 on 2017/8/11.
//  Copyright © 2017年 renb. All rights reserved.
//

#import "TestViewController.h"
#import "BRStringPickerView.h"
#import "BRTextField.h"
#import "BRDatePickerView.h"
#import "NSDate+BRAdd.h"
#import "GLD_WirteIntroController.h"
#import "GLD_ChooseIndustryControllr.h"
#import "AFHTTPSessionManager.h"

@interface TestViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;
/** 头像 */
@property (nonatomic, strong) BRTextField *iconTF;
/** 昵称 */
@property (nonatomic, strong) BRTextField *nicknameTF;
/** 性别 */
@property (nonatomic, strong) BRTextField *genderTF;
/** 出生年月 */
@property (nonatomic, strong) BRTextField *birthdayTF;
/** 所在省 */
@property (nonatomic, strong) BRTextField *locationTF;
/** 意向合作市 */
@property (nonatomic, strong) BRTextField *cityTF;
/** 意向合作区 */
@property (nonatomic, strong) BRTextField *areaTF;
/** 个人简介 */
@property (nonatomic, strong) BRTextField *personalIntroTF;//
/** 所属单位 */
//@property (nonatomic, strong) BRTextField *companyTF;
/** 职位名称 */
//@property (nonatomic, strong) BRTextField *positionTF;
@property (nonatomic, weak)UITableViewCell *industryCell;

@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSArray *secondTitleArr;
@property (nonatomic, strong)UIImageView *iconImgV;

@property (strong, nonatomic) UIImagePickerController* imagePicker;

@property (nonatomic, strong)GLD_NetworkAPIManager *NetManager;

@property (nonatomic, strong)AFURLSessionManager *AFNetManager;

@property (nonatomic, strong)NSString *updateImg;//上传图片返回连接


@property (nonatomic, strong) NSArray *addressArr;//
@property (nonatomic, strong) NSArray *secondAddressArr;//
@property (nonatomic, strong) NSMutableArray *provenceArr;//
@property (nonatomic, strong) NSMutableArray *cityArr;//
@property (nonatomic, copy) NSMutableArray *areaArr;//
@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"信息";
//    self.updateImg = @"";
    self.tableView.hidden = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(clickSaveBtn)];
    self.NetManager = [GLD_NetworkAPIManager shareNetManager];
    self.provenceArr = [NSMutableArray array];
    self.cityArr = [NSMutableArray array];
    self.areaArr = [NSMutableArray array];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *plistPath = [bundle pathForResource:@"address" ofType:@"plist"];
        
        NSDictionary *dict = [[NSDictionary alloc]initWithContentsOfFile:plistPath];
        self.addressArr = [NSArray arrayWithArray:dict[@"address"]];
        for (int i = 0; i < self.addressArr.count; i++) {
            NSDictionary *dict = self.addressArr[i];
            
            [self.provenceArr addObjectsFromArray:dict.allKeys];
            
        }
        WS(weakSelf);
        if (IsExist_String([AppDelegate shareDelegate].userModel.address)) {
            for (int i = 0; i < weakSelf.addressArr.count; i++) {
                NSDictionary *dict = weakSelf.addressArr[i];
                if ([dict.allKeys.firstObject isEqualToString:[AppDelegate shareDelegate].userModel.address]) {
                    weakSelf.secondAddressArr = [[NSArray alloc]initWithArray:dict[[AppDelegate shareDelegate].userModel.address]];
                    for (int j = 0; j < weakSelf.secondAddressArr.count; j++) {
                        NSDictionary *dict1 = weakSelf.secondAddressArr[j];
                        [weakSelf.cityArr addObjectsFromArray:dict1.allKeys];
                    }
                }
            }
        }
        
        if (IsExist_String([AppDelegate shareDelegate].userModel.city)) {
    
            for (int i = 0; i < weakSelf.secondAddressArr.count; i++) {
                NSDictionary *dict = weakSelf.secondAddressArr[i];
                if ([dict.allKeys.firstObject isEqualToString:[AppDelegate shareDelegate].userModel.city]) {
                    weakSelf.areaArr = dict[[AppDelegate shareDelegate].userModel.city];
                }
            }
        }
    });
}
- (void)viewWillAppear:(BOOL)animated{
    if (IsExist_String(self.dec)) {
        _personalIntroTF.text = self.dec;
    }
}
- (void)clickSaveBtn {
    NSLog(@"保存");
    [self getSave];
    
}
- (void)getSave{
    WS(weakSelf);

    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    if(self.type == 1){
        config.urlPath = @"api/user/regUser";
    }else{
        config.urlPath = @"api/user/updateUser";
    }
    config.requestParameters = @{@"phone" : GetString([AppDelegate shareDelegate].userModel.phone),

                                 @"intro" : IsExist_String(self.personalIntroTF.text) ? self.personalIntroTF.text : GetString([AppDelegate shareDelegate].userModel.intro),
                                 @"address" : IsExist_String(self.locationTF.text) ? self.locationTF.text : GetString([AppDelegate shareDelegate].userModel.address),
                                 @"inviteCode" : GetString([AppDelegate shareDelegate].userModel.inviteCode),
                                 @"password" : GetString([AppDelegate shareDelegate].userModel.password),
                                 @"sex" : IsExist_String(self.genderTF.text) ? self.genderTF.text : GetString([AppDelegate shareDelegate].userModel.sex),
                                 @"name" : IsExist_String(self.nicknameTF.text) ? self.nicknameTF.text : GetString([AppDelegate shareDelegate].userModel.name),
                                 @"birthDay" : IsExist_String(self.birthdayTF.text) ? self.birthdayTF.text : GetString([AppDelegate shareDelegate].userModel.birthDay),
                                 @"iconImage" : GetString(self.updateImg),
//                                 @"duty" : IsExist_String(self.positionTF.text) ? self.positionTF.text : [AppDelegate shareDelegate].userModel.duty,
                                 @"city":IsExist_String(self.cityTF.text) ? self.cityTF.text : GetString([AppDelegate shareDelegate].userModel.city),
                                 @"area":IsExist_String(self.areaTF.text) ? self.areaTF.text : GetString([AppDelegate shareDelegate].userModel.area),
                                 };
    
    [self.NetManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        if (!error) {
            if ([result[@"code"] integerValue] != 200) {
                [CAToast showWithText:result[@"msg"]];
                return ;
            }
            if (weakSelf.type == 1) {
                
                GLD_UserModel *model = [[GLD_UserModel alloc] initWithDictionary:result error:&error];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [AppDelegate shareDelegate].userModel = model.data;
                    if (IsExist_String(model.data.loginToken)) {
                        [[NSUserDefaults standardUserDefaults] setObject:model.data.loginToken forKey:@"loginToken"];
                    }
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:userHasLogin];
                    BOOL isFromd = [[NSUserDefaults standardUserDefaults]boolForKey:@"weixinLogin"];
                    if (isFromd) {
                        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"weixinLogin"];
                        [[AppDelegate shareDelegate] initMainPageBody];
                    }else{
                        
                        [weakSelf dismissViewControllerAnimated:YES completion:nil];
                    }
                });
            }else{
                GLD_UserModel *model = [[GLD_UserModel alloc] initWithDictionary:result error:&error];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [AppDelegate shareDelegate].userModel = model.data;
                    if (IsExist_String(model.data.loginToken)) {
                        [[NSUserDefaults standardUserDefaults] setObject:model.data.loginToken forKey:@"loginToken"];
                    }
                    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"loginToken"];
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:userHasLogin];
                    
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
            }
            
        }else{
            [CAToast showWithText:@"请求错误"];
        }
    }];
}
- (void)iconImgVClick{
    NSLog(@"头像");
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //self.isCamera =YES;
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        [self photocamera];//拍照
    }]];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //self.isCamera =NO;
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        [self photoalbumr];//图库相册
        
    }]];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"点击取消");
        
    }]];
    [self presentViewController:alertVc animated:YES completion:nil];
}

-(void)photocamera{
    //拍照
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:self.imagePicker animated:NO completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.imagePicker dismissViewControllerAnimated:NO completion:^{
        _imagePicker = nil;
    }];
    
}

-(void)photoalbumr{
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.allowsEditing = NO;
    [self presentViewController:self.imagePicker animated:NO completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self setImage:[image copy]];
    
    [self.imagePicker dismissViewControllerAnimated:NO completion:^{
        _imagePicker = nil;
    }];
    
    
}

- (void)setImage:(UIImage *)img {
    
    UIImage * image = [self thumbnailWithImageWithoutScale:img size:CGSizeMake(640, 960)];
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    
    UIImage *photoImage = [UIImage imageWithData:data];
    
    [self uploadImage:data];
    self.iconImgV.image = photoImage;
    
}
-(void)uploadImage:(NSData *)data
{
    WS(weakSelf);
    //1.创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@",WEB_SERVICE_REQUESTBASEURL,@"api/other/uploadImg"];
    //2.上传文件
   
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //上传文件参数
//        [formData appendPartWithFileData:data name:@"" fileName:@"" mimeType:@"image/jpg"];
        [formData appendPartWithFormData:data name:@"image/jpg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //打印上传进度
        CGFloat progress = 100.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        NSLog(@"%.2lf%%", progress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [CAToast showWithText:@"上传成功"];
        if ([responseObject[@"code"] integerValue] != 200 ) {
            [CAToast showWithText:responseObject[@"msg"]];
            weakSelf.updateImg = @"ddddd";
            return ;
        }
        //请求成功
        weakSelf.updateImg = responseObject[@"data"];
        NSLog(@"请求成功：%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //请求失败
        NSLog(@"请求失败：%@",error);
        [CAToast showWithText:@"上传失败"];
        
    }];
}
-(UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else
    {
        int h = image.size.height;
        int w = image.size.width;
        if(h <= asize.height && w <= asize.width)
        {
            newimage = image;
        }
        else
        {
            float b = (float)asize.width/w < (float)asize.height/h ? (float)asize.width/w : (float)asize.height/h;
            CGSize itemSize = CGSizeMake(b*w, b*h);
            UIGraphicsBeginImageContext(itemSize);
            CGRect imageRect = CGRectMake(0, 0, b*w, b*h);
            [image drawInRect:imageRect];
            newimage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
    }
    
    return newimage;
    
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [[UIView alloc]init];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0)
    return self.titleArr.count;
    return self.secondTitleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"systemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    cell.textLabel.textColor = RGB_HEX(0x464646, 1.0f);
    
    if (indexPath.section == 0) {
        cell.textLabel.text = [self.titleArr objectAtIndex:indexPath.row];
        
        switch (indexPath.row) {
            case 0:
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
                [cell.contentView addSubview:self.iconImgV];
                [self.iconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(cell.contentView);
                    make.height.equalTo(WIDTH(35));
                    make.width.equalTo(WIDTH(35));
                    make.right.equalTo(cell.contentView).offset(W(-15));
                }];
            }
                break;
            case 1:
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
                [self setupNicknameTF:cell];
            }
                break;
            case 2:
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [self setupGenderTF:cell];
            }
                break;
            case 3:
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [self setupBirthdayTF:cell];
            }
                break;
            case 4:
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [self setupLocationTF:cell];
            }
                break;
            case 5:
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [self setupCityTF:cell];
            }
                break;
            case 6:
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [self setupAreaTF:cell];
            }
                break;
            case 7:
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [self setupPersonalIntroTF:cell];
            }
                break;
 
        }
        
    }else{
        cell.textLabel.text = [self.secondTitleArr objectAtIndex:indexPath.row];
        switch (indexPath.row) {
            case 0:{
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                self.industryCell = cell;
                if (IsExist_String([AppDelegate shareDelegate].userModel.industry)) {
                    cell.detailTextLabel.text = [AppDelegate shareDelegate].userModel.industry;
                }
            }break;
            case 1:{
            cell.accessoryType = UITableViewCellAccessoryNone;
//                [self setupCompanyTF:cell];
            }break;
            case 2:{
                cell.accessoryType = UITableViewCellAccessoryNone;
//                [self setupPositionTF:cell];
            }break;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return W(50);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 5:{
                
            }break;
        }
    }else{
        if (indexPath.row == 0) {
            WS(weakSelf);
            GLD_ChooseIndustryControllr *chooseVc = [GLD_ChooseIndustryControllr new];
            chooseVc.nameBlock = ^(NSString *name) {
                weakSelf.industryCell.detailTextLabel.text = name;
            };
            [self.navigationController pushViewController:chooseVc animated:YES];
        }
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

#pragma mark - 姓名 textField
- (void)setupNicknameTF:(UITableViewCell *)cell{
    if (!_nicknameTF) {
        _nicknameTF = [self getTextField:cell];
        _nicknameTF.placeholder = @"请输入";
        if (IsExist_String([AppDelegate shareDelegate].userModel.name)) {
            _nicknameTF.text = [AppDelegate shareDelegate].userModel.name;
        }
        _nicknameTF.returnKeyType = UIReturnKeyDone;
        _nicknameTF.tag = 0;
    }
}

#pragma mark - 性别 textField
- (void)setupGenderTF:(UITableViewCell *)cell {
    if (!_genderTF) {
        _genderTF = [self getTextField:cell];
        _genderTF.placeholder = @"请选择";
        if (IsExist_String([AppDelegate shareDelegate].userModel.sex)) {
            _genderTF.text = [AppDelegate shareDelegate].userModel.sex;
        }
        __weak typeof(self) weakSelf = self;
        _genderTF.tapAcitonBlock = ^{
            [BRStringPickerView showStringPickerWithTitle:@"性别" dataSource:@[@"男", @"女"] defaultSelValue:@"男" isAutoSelect:YES resultBlock:^(id selectValue) {
                weakSelf.genderTF.text = selectValue;
            }];
        };
    }
}
#pragma mark - 简介 textField
- (void)setupPersonalIntroTF:(UITableViewCell *)cell {
    if (!_personalIntroTF) {
        _personalIntroTF = [self getTextField:cell];
        if (IsExist_String([AppDelegate shareDelegate].userModel.intro)) {
            _personalIntroTF.text = [AppDelegate shareDelegate].userModel.intro;
        }
        __weak typeof(self) weakSelf = self;
        _personalIntroTF.tapAcitonBlock = ^{
            GLD_WirteIntroController *wirteVc = [GLD_WirteIntroController new];
            [weakSelf.navigationController pushViewController:wirteVc animated:YES];
        };
    }
}
#pragma mark - 出生日期 textField
- (void)setupBirthdayTF:(UITableViewCell *)cell {
    if (!_birthdayTF) {
        _birthdayTF = [self getTextField:cell];
        _birthdayTF.placeholder = @"请选择";
        if (IsExist_String([AppDelegate shareDelegate].userModel.birthDay)) {
            _birthdayTF.text = [AppDelegate shareDelegate].userModel.birthDay;
        }
        __weak typeof(self) weakSelf = self;
        _birthdayTF.tapAcitonBlock = ^{
            [BRDatePickerView showDatePickerWithTitle:@"出生年月" dateType:UIDatePickerModeDate defaultSelValue:weakSelf.birthdayTF.text minDateStr:@"" maxDateStr:[NSDate currentDateString] isAutoSelect:YES resultBlock:^(NSString *selectValue) {
                weakSelf.birthdayTF.text = selectValue;
            }];
        };
    }
}


#pragma mark - 地址 textField
- (void)setupLocationTF:(UITableViewCell *)cell {
    if (!_locationTF) {
        _locationTF = [self getTextField:cell];
        _locationTF.placeholder = @"请选择";
        if (IsExist_String([AppDelegate shareDelegate].userModel.address)) {
            _locationTF.text = [AppDelegate shareDelegate].userModel.address;
        }
        __weak typeof(self) weakSelf = self;
        
        _locationTF.tapAcitonBlock = ^{
            [BRStringPickerView showStringPickerWithTitle:@"地区" dataSource:weakSelf.provenceArr defaultSelValue:@"北京" isAutoSelect:YES resultBlock:^(id selectValue) {
                
                [weakSelf.cityArr removeAllObjects];
                for (int i = 0; i < weakSelf.addressArr.count; i++) {
                    NSDictionary *dict = weakSelf.addressArr[i];
                    if ([dict.allKeys.firstObject isEqualToString:selectValue]) {
                        weakSelf.secondAddressArr = [[NSArray alloc]initWithArray:dict[selectValue]];
                        for (int j = 0; j < weakSelf.secondAddressArr.count; j++) {
                            NSDictionary *dict1 = weakSelf.secondAddressArr[j];
                            [weakSelf.cityArr addObjectsFromArray:dict1.allKeys];
                        }
                    }
                }
                weakSelf.locationTF.text = selectValue;
            }];
        };
    }
}

#pragma mark - 市
- (void)setupCityTF:(UITableViewCell *)cell {
    if (!_cityTF) {
        _cityTF = [self getTextField:cell];
        _cityTF.placeholder = @"请选择合作城市";
        if (IsExist_String([AppDelegate shareDelegate].userModel.city)) {
            _cityTF.text = [AppDelegate shareDelegate].userModel.city;
        }
        __weak typeof(self) weakSelf = self;
        _cityTF.tapAcitonBlock = ^{
            //跳转地区
            if (!IsExist_Array(weakSelf.cityArr)) {
                [CAToast showWithText:@"请选择合作省份"];
            }
            [BRStringPickerView showStringPickerWithTitle:@"地区" dataSource:weakSelf.cityArr defaultSelValue:@"北京市" isAutoSelect:YES resultBlock:^(id selectValue) {
                //                [weakSelf.areaArr removeAllObjects];
                
                for (int i = 0; i < weakSelf.secondAddressArr.count; i++) {
                    NSDictionary *dict = weakSelf.secondAddressArr[i];
                    if ([dict.allKeys.firstObject isEqualToString:selectValue]) {
                        weakSelf.areaArr = dict[selectValue];
                    }
                }
                weakSelf.cityTF.text = selectValue;
            }];
        };
    }
}
#pragma mark - 区
- (void)setupAreaTF:(UITableViewCell *)cell {
    if (!_areaTF) {
        _areaTF = [self getTextField:cell];
        _areaTF.placeholder = @"请选择合作区域";
        if (IsExist_String([AppDelegate shareDelegate].userModel.area)) {
            _areaTF.text = [AppDelegate shareDelegate].userModel.area;
        }
        __weak typeof(self) weakSelf = self;
        _areaTF.tapAcitonBlock = ^{
            //跳转地区
            if (!IsExist_Array(weakSelf.areaArr)) {
                [CAToast showWithText:@"请选择合作城市"];
            }
            [BRStringPickerView showStringPickerWithTitle:@"地区" dataSource:weakSelf.areaArr defaultSelValue:@"东城区" isAutoSelect:YES resultBlock:^(id selectValue) {
                
                weakSelf.areaTF.text = selectValue;
            }];
        };
    }
}

#pragma mark - 职位名称 textField
//- (void)setupPositionTF:(UITableViewCell *)cell {
//    if (!_positionTF) {
//        _positionTF = [self getTextField:cell];
//        _positionTF.placeholder = @"请输入您的职位名称";
//        _positionTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
//        _positionTF.returnKeyType = UIReturnKeyDone;
//        if (IsExist_String([AppDelegate shareDelegate].userModel.duty)) {
//            _positionTF.text = [AppDelegate shareDelegate].userModel.duty;
//        }
//        _positionTF.tag = 5;
//    }
//}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = @[@"编辑头像", @"昵称",@"性别", @"出生年月", @"所在省份", @"所在城市",@"所在区域",@"个人简介"];
    }
    return _titleArr;
}

- (NSArray *)secondTitleArr{
    if (!_secondTitleArr) {
        _secondTitleArr = @[@"从事行业",@"所属单位",@"职位名称"];
    }
    return _secondTitleArr;
}
- (UIImageView *)iconImgV{
    if (!_iconImgV) {
        _iconImgV = [UIImageView new];
        _iconImgV.userInteractionEnabled = YES;
        [_iconImgV addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(iconImgVClick)]];
        _iconImgV.layer.cornerRadius = W(17);
        _iconImgV.layer.masksToBounds = YES;
       [ _iconImgV yy_setImageWithURL:[NSURL URLWithString:[AppDelegate shareDelegate].userModel.iconImage] placeholder:WTImage(@"默认头像")];
        
    }
    return _iconImgV;
}
@end
