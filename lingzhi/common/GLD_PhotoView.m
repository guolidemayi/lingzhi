//
//  GLD_PhotoView.m
//  yxvzb
//
//  Created by yiyangkeji on 2017/4/10.
//  Copyright © 2017年 sendiyang. All rights reserved.
//

#import "GLD_PhotoView.h"
#import "YXRecordButton.h"
#import <Photos/Photos.h> 

@interface GLD_PhotoView (){
    UIImageView *_tipImgV;
    
    
}

@property (nonatomic, weak)UIView *bottomView;

@end

@implementation GLD_PhotoView

+ (instancetype)showPhotoViewInView:(UIView *)view{
    
    GLD_PhotoView *photoView = [[GLD_PhotoView alloc]initWithFrame:view.bounds];
    [view addSubview:photoView];
    photoView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    photoView.hidden = YES;
    [photoView setupUI];
    return photoView;
}

- (void)setupUI{
 
    _tipImgV = [[UIImageView alloc]initWithImage:WTImage(@"")];
    [_tipImgV addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissPhotoView)]];
    _tipImgV.userInteractionEnabled = YES;
    [self addSubview:_tipImgV];
    [_tipImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(-1);
        make.right.equalTo(self).offset(1);
        make.top.equalTo(self).offset(-1);
        make.bottom.equalTo(self).offset(1);
    }];
    [self bottomView];
}


- (void)showPhotoView:(NSString *)imgStr{
    
    [UIView animateWithDuration:0.3 animations:^{
        _tipImgV.image = [UIImage imageNamed:imgStr];
        _tipImgV.alpha = 1;
        self.hidden = NO;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
        }];
        [self layoutIfNeeded];
    }];
}


- (void)dismissPhotoView{
    [UIView animateWithDuration:0.3 animations:^{
        self.hidden = YES;
        _tipImgV.alpha = 0;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(H(115));
        }];
        [self layoutIfNeeded];
    }];
    
}

- (void)photoButClick:(YXRecordButton *)senser{
    [self dismissPhotoView];
    if ([self isCameraAvailable]) {
        if (![UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
            senser.tag = 1008;
            [self photoAlumButClick:senser];
            return;
        }
        [self photoCallBack:senser.tag];
    }
}
- (void)photoAlumButClick:(YXRecordButton *)senser{
    [self dismissPhotoView];
    if ([self isCameraAlbumAvailable]) {
        
        [self photoCallBack:senser.tag];
    }
}
- (BOOL)isCameraAlbumAvailable{
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        //无权限
        NSString *errorStr = @"应用相册权限受限,请在设置中启用";
        [CAToast showWithText:errorStr];
        return NO;
    }
    return YES;
}

- (BOOL)isCameraAvailable{
    
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        NSString *errorStr = @"应用相机权限受限,请在设置中启用";
        [CAToast showWithText:errorStr];
        return NO;
    }
    
    
    return YES;
}

- (void)cancleButClick{
    [self dismissPhotoView];
}
- (void)photoCallBack:(photoStats)stats{
    if([self.delegate respondsToSelector:@selector(gld_PhotoView:)]){
        [self.delegate gld_PhotoView:stats];
    }
}
- (UIView *)bottomView{
    
    if (_bottomView == nil) {
        UIView *bottom = [[UIView alloc]init];
        bottom.backgroundColor = [UIColor clearColor];
        
        _bottomView = bottom;
        [self addSubview:bottom];
        [bottom mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(H(115));
            make.width.equalTo(self);
            make.centerX.equalTo(self);
            make.height.equalTo(HEIGHT(156));
        }];
        YXRecordButton *photoBut = [YXRecordButton creatButWithTitle:@"拍照" andImageStr:nil andFont:15 andTextColorStr:COLOR_YX_DRAKblack];
        photoBut.tag = 1007;
        [photoBut addTarget:self action:@selector(photoButClick:) forControlEvents:UIControlEventTouchUpInside];
        photoBut.backgroundColor = [UIColor whiteColor];
        [bottom addSubview:photoBut];
        [photoBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.centerX.equalTo(bottom);
            make.top.equalTo(bottom);
            make.height.equalTo(HEIGHT(50));
        }];
        YXRecordButton *albumPhotoBut = [YXRecordButton creatButWithTitle:@"从手机相册选择" andImageStr:nil andFont:15 andTextColorStr:COLOR_YX_DRAKblack];
        albumPhotoBut.tag = 1008;
        [bottom addSubview:albumPhotoBut];
        [albumPhotoBut addTarget:self action:@selector(photoAlumButClick:) forControlEvents:UIControlEventTouchUpInside];
         albumPhotoBut.backgroundColor = [UIColor whiteColor];
        [albumPhotoBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.centerX.equalTo(bottom);
            make.top.equalTo(photoBut.mas_bottom).offset(0.5);
            make.height.equalTo(HEIGHT(50));
        }];
        YXRecordButton *cancleBut = [YXRecordButton creatButWithTitle:@"取消" andImageStr:nil andFont:15 andTextColorStr:COLOR_YX_DRAKblack];
        [bottom addSubview:cancleBut];
        [cancleBut addTarget:self action:@selector(cancleButClick) forControlEvents:UIControlEventTouchUpInside];
         cancleBut.backgroundColor = [UIColor whiteColor];
        [cancleBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.centerX.equalTo(bottom);
            make.top.equalTo(albumPhotoBut.mas_bottom).offset(H(6));
            make.height.equalTo(HEIGHT(50));
        }];
        
        
    }
    return _bottomView;
}

@end
