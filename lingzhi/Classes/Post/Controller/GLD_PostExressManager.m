//
//  GLD_PostExressManager.m
//  lingzhi
//
//  Created by 锅里的 on 2019/5/15.
//  Copyright © 2019 com.lingzhi. All rights reserved.
//

#import "GLD_PostExressManager.h"
#import "GLD_ExpressModel.h"
#import "GLD_ExpressAdressController.h"
#import "GLD_PhotoView.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "AFHTTPSessionManager.h"

#define coustermFrame CGRectMake(DEVICE_WIDTH - 265, 7, 250, 21)
@interface GLD_PostExressManager ()<UITextViewDelegate,UITextFieldDelegate,UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate,GLD_PhotoViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITextField *priceTextField;
@property (nonatomic, strong) UITextField *sendPhoneTextField;
@property (nonatomic, strong) UITextField *recivedPersonTextField;
@property (nonatomic, strong) UITextField *recivedPhoneTextField;
@property (nonatomic, strong) UILabel *starLabel;
@property (nonatomic, strong) UILabel *ednLabel;
@property (nonatomic, strong) GLD_ExpressModel *expressModel;

@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) UITextView *textView;;
@property (nonatomic, strong) UIButton *picBut;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, weak)GLD_PhotoView *photoView;//图片选择视图
@property (strong, nonatomic) UIImagePickerController* imagepicker;
@property (strong, nonatomic) NSData* certificationImage;//图片二进制
@property (nonatomic, weak) UIViewController *viewC;
@end
@implementation GLD_PostExressManager

- (instancetype)initWith:(UITableView *)tableView andViewC:(UIViewController *)vc{
    if (self = [super init]) {
        self.tableView = tableView;
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        tableView.tableFooterView = self.footerView;
        self.viewC = vc;
        _photoView =  [GLD_PhotoView showPhotoViewInView:[AppDelegate shareDelegate].window];
        _photoView.delegate = self;
        [self reloadData];
    }
    return self;
}
- (void)reloadData{
    [self initData];
    [self.tableView reloadData];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    NSString *rangeStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == _priceTextField) {
        self.expressModel.price = rangeStr.integerValue;
    }else if(textField == _sendPhoneTextField){
        self.expressModel.phone = rangeStr;
    }else if(textField == _recivedPersonTextField){
        self.expressModel.receivedPerson = rangeStr;
    }else if(textField == _recivedPhoneTextField){
        self.expressModel.receivedPhone = rangeStr;
    }
    
    return YES;
}
- (void)picButClick{
    [self.photoView showPhotoView:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            
            WS(weakSelf);
            GLD_ExpressAdressController *expressVc = [GLD_ExpressAdressController initWithBlock:^(AMapPOI *location) {
                weakSelf.expressModel.latitude = location.location.latitude;
                weakSelf.expressModel.longitude = location.location.longitude;
                weakSelf.expressModel.city = location.city;
                weakSelf.starLabel.text = location.address;
            }];
            [self.tableView.navigationController pushViewController:expressVc animated:YES];
        }
            break;
        case 1:
        {
            
            WS(weakSelf);
            GLD_ExpressAdressController *expressVc = [GLD_ExpressAdressController initWithBlock:^(AMapPOI *location) {
                weakSelf.expressModel.toLatitude = location.location.latitude;
                weakSelf.expressModel.toLongitude = location.location.longitude;
                weakSelf.ednLabel.text = location.address;
            }];
            [self.tableView.navigationController pushViewController:expressVc animated:YES];
        }
            break;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    NSDictionary *dict = self.dataArr[indexPath.item];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text =dict[@"title"];
    [cell.contentView addSubview:dict[@"view"]];
    return cell;
}
- (UITextField *)getTextFieldAndPlaceHoder:(NSString *)placeH{
    UITextField *textField = [UITextField new];
    textField.returnKeyType = UIReturnKeyDone;
    textField.textAlignment = NSTextAlignmentRight;
    textField.placeholder = placeH;
    textField.frame = coustermFrame;
    textField.delegate = self;
    return textField;
}

#pragma photoViewDelegate
- (void)gld_PhotoView:(photoStats)stats{
    switch (stats) {
        case gld_photoViewPhoto:
        {
            self.imagepicker = [[UIImagePickerController alloc] init];
            self.imagepicker.delegate = self;
            [self photocamera];//拍照
        }
            break;
        case gld_photoViewAlbumPhoto:
        {
            self.imagepicker = [[UIImagePickerController alloc] init];
            self.imagepicker.delegate = self;
            [self photoalbumr];//图库相册
        }
            break;
        default:
            break;
    }
}
#pragma mark--- 拍照
-(void)photocamera{
    
    self.imagepicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self.viewC presentViewController:self.imagepicker animated:YES completion:nil];
}
-(void)photoalbumr{
    self.imagepicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagepicker.allowsEditing = NO;
    [self.viewC presentViewController:self.imagepicker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self setIma:[image copy]];
    
    [self.imagepicker dismissViewControllerAnimated:NO completion:^{
        _imagepicker = nil;
        
    }];
    
}
#pragma mark---自拍照

-(void)setIma:(UIImage *)ima {
    
    UIImage * image = [self thumbnailWithImageWithoutScale:ima size:CGSizeMake(640, 960)];
    //二进制文件图片
    _certificationImage  = UIImageJPEGRepresentation(image, 0.5);
    
    [self uploadImage:_certificationImage index:0];
}


-(void)uploadImage:(NSData *)data index:(NSInteger)index
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
        
        if (responseObject[@"data"] && ![responseObject[@"data"] isKindOfClass:[NSNull class]])
        weakSelf.expressModel.goodsPic = responseObject[@"data"];
        [weakSelf.picBut setBackgroundImage:[UIImage imageWithData:weakSelf.certificationImage] forState:UIControlStateNormal];
        //请求成功
        weakSelf.certificationImage = nil;
        NSLog(@"请求成功：%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //请求失败
        NSLog(@"请求失败：%@",error);
        [CAToast showWithText:@"上传失败"];
        
    }];
    
}

- (UITextField *)priceTextField{
    if (!_priceTextField) {
        _priceTextField = [self getTextFieldAndPlaceHoder:@"请输入价格"];
        _priceTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _priceTextField;
    
}
- (UITextField *)sendPhoneTextField{
    if (!_sendPhoneTextField) {
        _sendPhoneTextField = [self getTextFieldAndPlaceHoder:@"请输入手机号"];
        
    }
    return _sendPhoneTextField;
    
}
- (UITextField *)recivedPhoneTextField{
    if (!_recivedPhoneTextField) {
        _recivedPhoneTextField = [self getTextFieldAndPlaceHoder:@"请输入收件人手机号"];
        
    }
    return _recivedPhoneTextField;
    
}

- (UITextField *)recivedPersonTextField{
    if (!_recivedPersonTextField) {
        _recivedPersonTextField = [self getTextFieldAndPlaceHoder:@"请输入收件人姓名"];
        
    }
    return _recivedPersonTextField;
    
}
- (GLD_ExpressModel *)expressModel{
    if (!_expressModel) {
        _expressModel = [[GLD_ExpressModel alloc]init];
        _expressModel.type = @(1);
    }
    return _expressModel;
    
}
- (void)initData{
    switch (self.expressModel.type.integerValue) {//1跑腿 2 帮办  3代买
        case 1:
            {
                self.dataArr = @[@{@"title":@"选择出发地点:",@"view":self.starLabel},
                                 @{@"title":@"选择结束地点:",@"view":self.ednLabel},
                                 @{@"title":@"价格:",@"view":self.priceTextField},
                                 @{@"title":@"手机号:",@"view":self.sendPhoneTextField},
                                 @{@"title":@"收件人:",@"view":self.recivedPersonTextField},
                                 @{@"title":@"手机号:",@"view":self.recivedPhoneTextField},];
            }
            break;
        case 2:
        {
            self.dataArr = @[@{@"title":@"选择出发地点",@"view":self.starLabel},
                             @{@"title":@"价格",@"view":self.priceTextField},
                             @{@"title":@"手机号",@"view":self.sendPhoneTextField}];
        }
            break;
        case 3:
        {
            self.dataArr = @[@{@"title":@"选择出发地点",@"view":self.starLabel},
                             @{@"title":@"选择结束地点",@"view":self.ednLabel},
                             @{@"title":@"价格",@"view":self.priceTextField},
                             @{@"title":@"手机号",@"view":self.sendPhoneTextField},
                             @{@"title":@"收件人",@"view":self.recivedPersonTextField},
                             @{@"title":@"手机号",@"view":self.recivedPhoneTextField},];
        }
            break;
            
        default:
            break;
    }
}
- (UILabel *)starLabel{
    if (!_starLabel) {
        _starLabel = [UILabel creatLableWithText:@"" andFont:WTFont(12) textAlignment:NSTextAlignmentRight textColor:[YXUniversal colorWithHexString:COLOR_YX_blackLabelColor]];
        _starLabel.frame = coustermFrame;
        
    }
    return _starLabel;

}
- (UILabel *)ednLabel{
    if (!_ednLabel) {
        _ednLabel = [UILabel creatLableWithText:@"" andFont:WTFont(12) textAlignment:NSTextAlignmentRight textColor:[YXUniversal colorWithHexString:COLOR_YX_blackLabelColor]];
        _ednLabel.frame = coustermFrame;
    }
    return _ednLabel;
    
}

- (UIView *)footerView{
    if (!_footerView) {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 150)];
        [_footerView addSubview:self.picBut];
        [_footerView addSubview:self.textView];
        UILabel *label = [UILabel creatLableWithText:@"请输入配件物品或备注" andFont:WTFont(15) textAlignment:NSTextAlignmentLeft textColor:[YXUniversal colorWithHexString:COLOR_YX_blackLabelColor]];
        [_footerView addSubview:label];
        label.frame = CGRectMake(10, 5, 200, 20);
        self.textView.frame = CGRectMake(15, 30, 230, 100);
        
        self.picBut.frame = CGRectMake(DEVICE_WIDTH - 135, 30, 120, 100);
        
    }
    return _footerView;

}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    NSString *rangeStr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    self.expressModel.title = rangeStr;
    return YES;
}
- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.delegate = self;
        _textView.layer.cornerRadius = 3;
        _textView.layer.borderColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKgray2].CGColor;
        _textView.layer.borderWidth = 1;
        
    }
    return _textView;
}
- (UIButton *)picBut{
    if (!_picBut) {
        _picBut = [[UIButton alloc]init];
        [_picBut setBackgroundImage:WTImage(@"WechatIMG812") forState:UIControlStateNormal];
        [_picBut addTarget:self action:@selector(picButClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _picBut;
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

@end
