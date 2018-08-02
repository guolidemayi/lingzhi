//
//  GLD_PostExpressController.m
//  lingzhi
//
//  Created by yiyangkeji on 2018/7/31.
//  Copyright © 2018年 com.lingzhi. All rights reserved.
//

#import "GLD_PostExpressController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "GLD_ExpressAdressController.h"

@interface GLD_PostExpressController ()
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *toLabel;
@property (weak, nonatomic) IBOutlet UITextField *priceTextFeild;
@property (weak, nonatomic) IBOutlet UITextView *expressTipTextView;
@property (weak, nonatomic) IBOutlet UIButton *sendBut;

@property (nonatomic, strong)AMapPOI *fromLoca;
@property (nonatomic, strong)AMapPOI *toLoca;
@end

@implementation GLD_PostExpressController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setComponent];
}

- (void)setComponent{
    self.toLabel.userInteractionEnabled = YES;
    [self.toLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toLabelClick)]];
    self.fromLabel.userInteractionEnabled = YES;
    [self.fromLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fromLabelClick)]];
    self.sendBut.layer.cornerRadius = 5;
    self.sendBut.layer.masksToBounds = YES;
}
- (void)fromLabelClick{
    WS(weakSelf);
    GLD_ExpressAdressController *expressVc = [GLD_ExpressAdressController initWithBlock:^(AMapPOI *location) {
        weakSelf.fromLoca = location;
        weakSelf.fromLabel.text = location.address;
    }];
    [self.navigationController pushViewController:expressVc animated:YES];
}

- (void)toLabelClick{
    WS(weakSelf);
    GLD_ExpressAdressController *expressVc = [GLD_ExpressAdressController initWithBlock:^(AMapPOI *location) {
        weakSelf.toLoca = location;
        weakSelf.toLabel.text = location.address;
    }];
    [self.navigationController pushViewController:expressVc animated:YES];
}
- (IBAction)sendButClick:(UIButton *)sender {
    
    if(!IsExist_String(self.fromLabel.text)){
        [CAToast showWithText:@"请选择出发地点"];
        return;
    }
    if(!IsExist_String(self.toLabel.text)){
        [CAToast showWithText:@"请选择配送地点"];
        return;
    }
    if(!IsExist_String(self.priceTextFeild.text)){
        [CAToast showWithText:@"请输入价格"];
        return;
    }
    if(!IsExist_String(self.expressTipTextView.text)){
        [CAToast showWithText:@"请输入商品描述及备注"];
        return;
    }
   
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = sendExpressRequest;
    config.requestParameters = @{@"toAddress":self.toLoca.address,
                                 @"fromAddress":self.fromLoca.address,
                                 @"price":self.priceTextFeild.text,
                                 @"tip":self.expressTipTextView.text,
                                 @"latitude":@(self.toLoca.location.latitude),
                                 @"longitude":@(self.toLoca.location.longitude),
                                 @"userId":GetString([AppDelegate shareDelegate].userModel.userId)
                                 };
    [self.NetManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        if (!error) {
            [CAToast showWithText:@"发布成功"];
        }else{
            [CAToast showWithText:@"网络错误"];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
