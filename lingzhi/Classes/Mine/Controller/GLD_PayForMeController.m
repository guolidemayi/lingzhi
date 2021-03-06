//
//  GLD_PayForMeController.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/19.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_PayForMeController.h"
#import "SGQRCodeGenerateManager.h"
#import "GLD_BusnessModel.h"

#define appDownLoadUrl @"https://itunes.apple.com/cn/app/%E6%83%A0%E6%B1%87%E8%81%94%E7%9B%9F/id1332960714?mt=8"
@interface GLD_PayForMeController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *decLabel;
@property (weak, nonatomic) IBOutlet UIImageView *QRCImageV;

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@end

@implementation GLD_PayForMeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_BLUE_TABLE];
//    CGFloat imgW = CGRectGetWidth(self.QRCImageV.frame);
    CGFloat scale = 0.2;
    if (!self.model) {
         [self.iconImageV yy_setImageWithURL:[NSURL URLWithString:[AppDelegate shareDelegate].userModel.iconImage] placeholder:WTImage(@"默认头像")];
        
        self.QRCImageV.image = [SGQRCodeGenerateManager generateWithLogoQRCodeData:[NSString stringWithFormat:@"%@/%@",appDownLoadUrl,GetString([AppDelegate shareDelegate].userModel.userId)] logoImageName:@"WechatIMG43" logoScaleToSuperView:scale];
        self.nameLabel.text = [AppDelegate shareDelegate].userModel.name;
        self.decLabel.text = [AppDelegate shareDelegate].userModel.intro;
        self.tipLabel.hidden = YES;
    }else{
        self.tipLabel.hidden = NO;
        
        self.QRCImageV.image = [SGQRCodeGenerateManager generateWithLogoQRCodeData:[NSString stringWithFormat:@"http://www.hhlmcn.com:8080/pay/%@",GetString([AppDelegate shareDelegate].userModel.userId)] logoImageName:@"WechatIMG43" logoScaleToSuperView:scale];
        if([self.model.logo containsString:@","]){
            NSArray *arr = [self.model.logo componentsSeparatedByString:@","];
            [self.iconImageV yy_setImageWithURL:[NSURL URLWithString:arr.lastObject] placeholder:nil];
        }else{
            
            [self.iconImageV yy_setImageWithURL:[NSURL URLWithString:self.model.logo] placeholder:nil];
        }
         
        self.nameLabel.text = self.model.name;
        self.decLabel.text = self.model.desc;
    }
    
}
- (IBAction)saveQRCClick:(UIButton *)sender {
    [self loadImageFinished:self.QRCImageV.image];
}
- (void)loadImageFinished:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if(error){
        [CAToast showWithText:@"保存失败"];
    }else{
        [CAToast showWithText:@"保存成功"];
    }
    
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
