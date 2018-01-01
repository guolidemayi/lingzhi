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
/** 所在地 */
@property (nonatomic, strong) BRTextField *locationTF;
/** 个人简介 */
@property (nonatomic, strong) BRTextField *personalIntroTF;//
/** 所属单位 */
@property (nonatomic, strong) BRTextField *companyTF;
/** 职位名称 */
@property (nonatomic, strong) BRTextField *positionTF;
@property (nonatomic, weak)UITableViewCell *industryCell;

@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSArray *secondTitleArr;
@property (nonatomic, strong)UIImageView *iconImgV;

@property (strong, nonatomic) UIImagePickerController* imagePicker;

@property (nonatomic, strong)GLD_NetworkAPIManager *NetManager;

@property (nonatomic, strong)AFURLSessionManager *AFNetManager;

@property (nonatomic, strong)NSString *updateImg;//上传图片返回连接
@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"信息";
    self.tableView.hidden = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(clickSaveBtn)];
    self.NetManager = [GLD_NetworkAPIManager new];
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
    
    if (!IsExist_String(self.updateImg)) {
        [CAToast showWithText:@"请上传头像"];
        return;

    }
    if (!IsExist_String(self.nicknameTF.text)) {
        [CAToast showWithText:@"请输入昵称"];
        return;
    }
    if (!IsExist_String(self.genderTF.text)) {
        [CAToast showWithText:@"请选择性别"];
        return;
    }
    if (!IsExist_String(self.birthdayTF.text)) {
        [CAToast showWithText:@"请选择出生日期"];
        return;
    }
    if (!IsExist_String(self.locationTF.text)) {
        [CAToast showWithText:@"请选择所在地区"];
        return;
    }
    if (!IsExist_String(self.personalIntroTF.text)) {
        [CAToast showWithText:@"请填写个人简介"];
        return;
    }
    if (!IsExist_String(self.industryCell.detailTextLabel.text)) {
        [CAToast showWithText:@"请选择从事行业"];
        return;
    }
    if (!IsExist_String(self.companyTF.text)) {
        [CAToast showWithText:@"请填写所属单位"];
        return;
    }
    if (!IsExist_String(self.positionTF.text)) {
        [CAToast showWithText:@"请填写职位"];
        return;
    }
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = @"api/user/regUser";
    config.requestParameters = @{@"phone" : GetString([AppDelegate shareDelegate].userModel.phone),
                                 @"company" : GetString(self.companyTF.text),
                                 @"industry" : GetString(self.industryCell.detailTextLabel.text),
                                 @"intro" : GetString(self.personalIntroTF.text),
                                 @"address" : GetString(self.locationTF.text),
                                 @"inviteCode" : GetString([AppDelegate shareDelegate].userModel.inviteCode),
                                 @"password" : GetString([AppDelegate shareDelegate].userModel.password),
                                 @"sex" : GetString(self.genderTF.text),
                                 @"name" : GetString(self.nicknameTF.text),
                                 @"birthDay" : GetString(self.birthdayTF.text),
                                 @"icon" : GetString(self.updateImg),
                                 @"duty" : GetString(self.positionTF.text)
                                 };
    
    [self.NetManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        if (!error) {
            if (weakSelf.type == 1) {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:userHasLogin];
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }else{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
            
        }else{
            [CAToast showWithText:@""];
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
    //    [[self.contentArray objectAtIndex:0] setValue:photoImage forKey:@"content"];
    //
    //    [self.tableV_peronalInfo reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0],nil] withRowAnimation:UITableViewRowAnimationNone];
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
    return 2;
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
            }break;
            case 1:{
            cell.accessoryType = UITableViewCellAccessoryNone;
                [self setupCompanyTF:cell];
            }break;
            case 2:{
                cell.accessoryType = UITableViewCellAccessoryNone;
                [self setupPositionTF:cell];
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
#pragma mark - 性别 textField
- (void)setupPersonalIntroTF:(UITableViewCell *)cell {
    if (!_personalIntroTF) {
        _personalIntroTF = [self getTextField:cell];
        
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
        __weak typeof(self) weakSelf = self;
        _birthdayTF.tapAcitonBlock = ^{
            [BRDatePickerView showDatePickerWithTitle:@"出生年月" dateType:UIDatePickerModeDate defaultSelValue:weakSelf.birthdayTF.text minDateStr:@"" maxDateStr:[NSDate currentDateString] isAutoSelect:YES resultBlock:^(NSString *selectValue) {
                weakSelf.birthdayTF.text = selectValue;
            }];
        };
    }
}



#pragma mark - 所属单位 textField
- (void)setupCompanyTF:(UITableViewCell *)cell {
    if (!_companyTF) {
        _companyTF = [self getTextField:cell];
        _companyTF.placeholder = @"请输入你的所属单位";
        _companyTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _companyTF.returnKeyType = UIReturnKeyDone;
        _companyTF.tag = 4;
    }
}

#pragma mark - 地址 textField
- (void)setupLocationTF:(UITableViewCell *)cell {
    if (!_locationTF) {
        _locationTF = [self getTextField:cell];
        _locationTF.placeholder = @"请选择";
        __weak typeof(self) weakSelf = self;
        
        _locationTF.tapAcitonBlock = ^{
            [BRStringPickerView showStringPickerWithTitle:@"地区" dataSource:@[@"北京市", @"上海市", @"天津市",@"重庆市",@"河北省",@"山西省",@"台湾省",@"辽宁省",@"吉林省",@"黑龙江省",@"江苏省",@"浙江省",@"安徽省",@"福建省",@"江西省",@"山东省",@"河南省",@"湖北省",@"湖南省",@"广东省",@"甘肃省",@"四川省",@"贵州省",@"海南省",@"云南省",@"青海省",@"陕西省",@"广西壮族自治区",@"西藏自治区",@"宁夏回族自治区",@"新疆维吾尔自治区",@"内蒙古自治区",@"澳门特别行政区",@"香港特别行政区"] defaultSelValue:@"北京市" isAutoSelect:YES resultBlock:^(id selectValue) {
                weakSelf.locationTF.text = selectValue;
            }];
        };
    }
}



#pragma mark - 职位名称 textField
- (void)setupPositionTF:(UITableViewCell *)cell {
    if (!_positionTF) {
        _positionTF = [self getTextField:cell];
        _positionTF.placeholder = @"请输入您的职位名称";
        _positionTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _positionTF.returnKeyType = UIReturnKeyDone;
        _positionTF.tag = 5;
    }
}
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
        _titleArr = @[@"编辑头像", @"昵称",@"性别", @"出生年月", @"所在地区", @"个人简介"];
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
        _iconImgV.image = WTImage(@"默认头像");
    }
    return _iconImgV;
}
@end
