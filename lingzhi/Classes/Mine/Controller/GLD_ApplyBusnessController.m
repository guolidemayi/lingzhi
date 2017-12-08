//
//  GLD_ApplyBusnessController.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/6.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_ApplyBusnessController.h"
#import "KeyboardManager.h"
#import "BRStringPickerView.h"
#import "BRTextField.h"
#import "BRDatePickerView.h"
#import "NSDate+BRAdd.h"
#import "GLD_MapDetailCell.h"

@interface GLD_ApplyBusnessController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>
@property (nonatomic, strong)UITableView *table_apply;

/** 门店名称 */
@property (nonatomic, strong) BRTextField *nameTF;

/** 负责人 */
@property (nonatomic, strong) BRTextField *PersonTF;
/** 折扣 */
@property (nonatomic, strong) BRTextField *discountTF;

/** 验证码 */
@property (nonatomic, strong) BRTextField *verificationTF;

/** 所在行业 */
@property (nonatomic, strong) BRTextField *industryTF;

/** 所在地区 */
@property (nonatomic, strong) BRTextField *addressTF;

/** 详细地址 */
@property (nonatomic, strong) BRTextField *detailAddressTF;

/** 门店电话 */
@property (nonatomic, strong) BRTextField *phoneTF;
/** 门店描述 */
@property (nonatomic, strong) UITextView *describeTF;
/** 邀请码 */
@property (nonatomic, strong) BRTextField *invitationTF;

@property (nonatomic, strong) NSArray *titleArr;//

@property (nonatomic, strong)UIImageView *generalRankImgV;//普通商家
@property (nonatomic, strong)UIImageView *superRankImgV;//高级商家商家

@property (nonatomic, strong)UIImageView *iconImgV;

@property (strong, nonatomic) UIImagePickerController* imagePicker;

@property (nonatomic, strong)NSMutableDictionary *cellsDictM;
//验证码定时器
@property (nonatomic, strong)NSTimer *verificationTimer;
@property (nonatomic, weak)UIButton *verificationBut;

@property (nonatomic, weak)UILabel *introduceLabel;//高低级商家介绍
@property (nonatomic, assign)CGFloat introHeight;
@end

@implementation GLD_ApplyBusnessController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.introHeight = W(80);
    [self.view addSubview:self.table_apply];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
            
        case 1:{
            
            if (indexPath.row == 0) {
                self.superRankImgV.hidden = YES;
                self.introHeight = W(80);
                self.generalRankImgV.hidden = NO;
            }else{
            self.introHeight = W(100);
                self.superRankImgV.hidden = NO;
                self.generalRankImgV.hidden = YES;
            }
            [tableView reloadData];
        }break;
            
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 1:{
            UITableViewHeaderFooterView *headView = [UITableViewHeaderFooterView new];
            UILabel *title = [[UILabel alloc]init];
            
            title.text = @"门店类型";
            self.introduceLabel.text = @"门店类型:\n2、门店类型\n3、门店类型\n3、门店类型";
            [headView.contentView addSubview:title];
            [title mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(headView.contentView);
            }];
            return headView;
        }break;
         
    }
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UITableViewHeaderFooterView *headView = [UITableViewHeaderFooterView new];
    switch (section) {
        case 1:{
            UILabel *title = [[UILabel alloc]init];
            title.numberOfLines = 0;
            self.introduceLabel = title;
            title.text = @"门店类型:\n1、门店类型\n1、门店类型\n1、门店类型";
            [headView.contentView addSubview:title];
            [title mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(headView.contentView);
            }];
            return headView;
        }break;
        case 5:{
            UIButton *nextBut = [[UIButton alloc]init];
            [headView.contentView addSubview:nextBut];
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
            return headView;
        }break;
            
    }
    return [UIView new];
}

- (void)nextButClick{
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 1:{
            return W(35);
        }break;
        case 3:{
            return W(10);
        }break;
        case 4:{
            return W(10);
        }break;
        case 5:{
            return W(10);
        }break;
    }
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    switch (section) {
        case 1:{
            return self.introHeight;
        }break;
        case 5:{
            return W(60);
        }break;
    }
    return 0.001;
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSString *cellID = [NSString stringWithFormat:@"%zd-%zd", indexPath.section, indexPath.row];
    
    UITableViewCell *cell = [self.cellsDictM objectForKey:cellID];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        [self.cellsDictM setObject:cell forKey:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = WTFont(16);
        cell.textLabel.textColor = RGB_HEX(0x464646, 1.0f);
    }
    
    NSArray *titles = self.titleArr[indexPath.section];
    switch (indexPath.section) {
        case 0:{
            cell.textLabel.text = titles[indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryNone;
            switch (indexPath.row) {
                case 0:{
                    [self setupNameTF:cell];
                }break;
                case 1:{
                    [self setupPersonTF:cell];
                }break;
                case 2:{
                    cell.textLabel.textColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTnewGray];
//                    [self setupPhoneTF:cell];
                }break;
                case 3:{
                    [self setupDiscountTF:cell];
                }break;
                case 4:{
                    [self setupVerificationTF:cell];
                }break;
            }
            return cell;
        }break;
        case 1:{
            cell.textLabel.text = titles[indexPath.row];
            switch (indexPath.row) {
                case 0:{
                    [cell.contentView addSubview:self.generalRankImgV];
                }break;
                case 1:{
                    [cell.contentView addSubview:self.superRankImgV];
                }break;
            }
            return cell;
        }break;
        case 2:{
            cell.textLabel.text = titles[indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            switch (indexPath.row) {
                case 0:{
                    [self setupIndustryTF:cell];
                }break;
                case 1:{
                    [self setupAddressTF:cell];
                }break;
                case 2:{
                    GLD_MapDetailCell *cell1 = [tableView dequeueReusableCellWithIdentifier:GLD_MapDetailCellIdentifier];
                    return cell1;
                }break;
            }
            return cell;
        }break;
        case 3:{
            cell.textLabel.text = titles[indexPath.row];
            switch (indexPath.row) {
                case 0:{
                    [self setupPhoneTF:cell];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }break;
                case 1:{
                    [cell.contentView addSubview:self.iconImgV];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }break;
            }
            return cell;
        }break;
        case 4:{
            
            [self setupDescribeTF:cell];
            return cell;
        }break;
        case 5:{
            cell.textLabel.text = titles[indexPath.row];
            [self setupInvitationTF:cell];
            return cell;
        }break;
    }
    
    return [UITableViewCell new];
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
#pragma mark - 联系电话

#pragma mark - 折扣比例
- (void)setupDiscountTF:(UITableViewCell *)cell{
    if (!_discountTF) {
        _discountTF = [self getTextField:cell];
        _discountTF.placeholder = @"请输入";
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
- (void)checkDiscountClick{
    
    UIAlertController *alerVc = [UIAlertController alertControllerWithTitle:@"折扣说明" message:@"您输入8，代表为8折（注意：不能为0）" preferredStyle:UIAlertControllerStyleAlert];
    [alerVc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"点击取消");
        
    }]];
    [self presentViewController:alerVc animated:YES completion:nil];
    
}
- (void)sendVerificationClick:(UIButton *)senser{
    //验证码
    senser.enabled = NO;
    [senser setTitle:@"59" forState:UIControlStateNormal];
    self.verificationTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                              target:self
                                                            selector:@selector(timerAction:)
                                                            userInfo:nil
                                                             repeats:YES];

    
}
- (void)timerAction:(NSTimer *)timer{
    

    NSInteger time = [self.verificationBut.titleLabel.text integerValue];
    [self.verificationBut setTitle:[NSString stringWithFormat:@"%zd",--time] forState:UIControlStateNormal];
    if(time == 0){
        self.verificationBut.selected = NO;
        [self.verificationBut setTitle:@"重新获取" forState:UIControlStateNormal];
        [self.verificationTimer invalidate];
        self.verificationTimer = nil;
    }
}


- (void)dealloc{
    [self.verificationTimer invalidate];
    self.verificationTimer = nil;
}
#pragma mark - 验证码
- (void)setupVerificationTF:(UITableViewCell *)cell{
    if (!_verificationTF) {
        _verificationTF = [self getTextField:cell];
        _verificationTF.placeholder = @"请输入验证码";
        _verificationTF.returnKeyType = UIReturnKeyDone;
        _verificationTF.tag = 3;
        UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - W(130), W(5), W(100), W(40))];
        but.titleLabel.font = WTFont(15);
        _verificationTF.frame = CGRectMake(SCREEN_WIDTH - W(260), 0, W(100), W(50));
        [cell.contentView addSubview:but];
        [but setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE] forState:UIControlStateNormal];
        but.layer.cornerRadius = 3;
        but.layer.masksToBounds = YES;
        but.layer.borderColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE].CGColor;
        but.layer.borderWidth = 1;
        self.verificationBut = but;
        [but setTitle:@"获取验证码" forState:UIControlStateNormal];
        [but addTarget:self action:@selector(sendVerificationClick:) forControlEvents:UIControlEventTouchUpInside];
        
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
#pragma mark - 所在地区
- (void)setupAddressTF:(UITableViewCell *)cell {
    if (!_addressTF) {
        _addressTF = [self getTextField:cell];
        _addressTF.placeholder = @"请选择所在地区";
        __weak typeof(self) weakSelf = self;
        _addressTF.tapAcitonBlock = ^{
            //跳转地区
        };
    }
}

#pragma mark - 门店电话
- (void)setupPhoneTF:(UITableViewCell *)cell{
    if (!_phoneTF) {
        _phoneTF = [self getTextField:cell];
        _phoneTF.placeholder = @"请输入";
        _phoneTF.returnKeyType = UIReturnKeyDone;
        _phoneTF.tag = 4;
    }
}
#pragma mark - 描述
- (void)setupDescribeTF:(UITableViewCell *)cell{
    if (!_describeTF) {
        UILabel *label = [[UILabel alloc]init];
        [cell addSubview:label];
        label.textColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTBLACK];
        label.text = @"门店描述";
        label.frame = CGRectMake(W(15), W(10), DEVICE_WIDTH, W(20));
        _describeTF = [[UITextView alloc]init];;
        _describeTF.text = @"请输入";
        _describeTF.returnKeyType = UIReturnKeyDone;
        _describeTF.frame = CGRectMake(W(15), W(30), DEVICE_WIDTH- W(30), W(80));
        _describeTF.layer.borderWidth = 1;
        _describeTF.textAlignment = NSTextAlignmentLeft;
        _describeTF.textColor= [UIColor lightGrayColor];
        _describeTF.delegate =self;
//        _describeTF.
        _describeTF.layer.borderColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTnewGray].CGColor;
        _describeTF.tag = 5;
        [cell.contentView addSubview:_describeTF];
    }
}
- (void)textViewDidBeginEditing:(UITextView*)textView {
    
    if([textView.text isEqualToString:@"请输入"]) {
        
        textView.text=@"";
        
        textView.textColor= [UIColor blackColor];
        
    }
    
}


- (void)textViewDidEndEditing:(UITextView*)textView {
    
    if(textView.text.length<1) {
        
        textView.text=@"请输入";
        
        textView.textColor= [UIColor lightGrayColor];
    }
}

#pragma mark - 邀请码
- (void)setupInvitationTF:(UITableViewCell *)cell{
    if (!_invitationTF) {
        _invitationTF = [self getTextField:cell];
        _invitationTF.placeholder = @"请输入邀请码";
        _invitationTF.returnKeyType = UIReturnKeyDone;
        _invitationTF.tag = 3;
        UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - W(130), 0, W(100), W(50))];
        _invitationTF.frame = CGRectMake(SCREEN_WIDTH - W(260), 0, W(100), W(50));
        [cell.contentView addSubview:but];
        [but setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE] forState:UIControlStateNormal];
        but.layer.cornerRadius = 3;
         but.titleLabel.font = WTFont(15);
        but.layer.masksToBounds = YES;
        but.layer.borderColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE].CGColor;

        [but setTitle:@"验证" forState:UIControlStateNormal];
        [but addTarget:self action:@selector(checkDiscountClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == 0 || textField.tag == 4) {
        [textField resignFirstResponder];
    }
    return YES;
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 5;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 3;
            break;
        case 3:
            return 2;
            break;
        case 4:
            return 1;
            break;
        case 5:
            return 1;
            break;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            
            return W(50);
        }break;
        case 1:{
            return W(50);
        }break;
        case 2:{
            if (indexPath.row == 2) {
                return W(200);
            }
            return W(50);
        }break;
        case 3:{
            return W(50);
        }break;
        case 4:{
            return W(120);
        }break;
        case 5:{
            return W(50);
        }break;
    }
    
    return 0;
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
        tableView.mj_insetB = W(80);
        [tableView registerClass:[GLD_MapDetailCell class] forCellReuseIdentifier:GLD_MapDetailCellIdentifier];
//        tableView.rowHeight = 0;
        tableView.sectionFooterHeight = 0.001;
    }
    return _table_apply;
}
- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = @[@[@"门店名称",@"负责人",@"联系电话",@"折扣比例",@"验证码"],
                      @[@"普通联盟商家",@"高级联盟商家"],
                      @[@"所属行业",@"所在地区",@""],
                      @[@"门店电话",@"门店图标"],
                      @[@""],
                      @[@"渠道商邀请码"]];
    }
    return _titleArr;
}
- (UIImageView *)generalRankImgV{
    if (!_generalRankImgV) {
        _generalRankImgV = [[UIImageView alloc]initWithImage:WTImage(@"粗勾")];
        _generalRankImgV.frame = CGRectMake( W(340), W(10), W(20), H(20));
    }
    return _generalRankImgV;
}
- (UIImageView *)superRankImgV{
    if (!_superRankImgV) {
        _superRankImgV = [[UIImageView alloc]initWithImage:WTImage(@"粗勾")];
        _superRankImgV.frame = CGRectMake( W(340), W(10), W(20), H(20));
        _superRankImgV.hidden = YES;
    }
    return _superRankImgV;
}
- (UIImageView *)iconImgV{
    if (!_iconImgV) {
        _iconImgV = [UIImageView new];
        _iconImgV.userInteractionEnabled = YES;
        [_iconImgV addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(iconImgVClick)]];
        _iconImgV.layer.cornerRadius = W(10);
        _iconImgV.layer.masksToBounds = YES;
        _iconImgV.frame = CGRectMake(DEVICE_WIDTH - W(50), W(15), W(20), H(20));
        _iconImgV.image = WTImage(@"默认头像");
    }
    return _iconImgV;
}
- (NSMutableDictionary *)cellsDictM{
    if (_cellsDictM == nil) {
        _cellsDictM = [NSMutableDictionary dictionary];
    }
    return _cellsDictM;
}
@end
