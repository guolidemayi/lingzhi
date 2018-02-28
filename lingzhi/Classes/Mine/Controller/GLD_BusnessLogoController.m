//
//  GLD_BusnessLogoController.m
//  lingzhi
//
//  Created by yiyangkeji on 2018/2/28.
//  Copyright © 2018年 com.lingzhi. All rights reserved.
//

#import "GLD_BusnessLogoController.h"
#import "GLD_PhotoView.h"
#import "YXRecordButton.h"
#import "GLD_PictureCell.h"
#import "AFHTTPSessionManager.h"

@interface GLD_BusnessLogoController ()<GLD_PhotoViewDelegate,GLD_PictureCellDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    
    NSMutableArray *pictureArrM;
    
    NSMutableArray *imgArrM; //   保存选取图片的数组
}


@property (nonatomic , strong)UICollectionView *picCollectionView;

@property (nonatomic , weak)YXRecordButton *commitBut;

@property (strong, nonatomic) UIImagePickerController* imagepicker;



@property (nonatomic, weak)GLD_PhotoView *photoView;//图片选择视图

@property (strong, nonatomic) NSData* certificationImage;//图片二进制

@property (nonatomic,assign) NSInteger imageIndex;//记录增加图片的位置。方便删除

@property (nonatomic, weak)GLD_PictureCell *selectCell;
@property (nonatomic, strong)NSMutableArray *topicArrM;
@property (nonatomic, copy)void(^postReloadBlock)(NSData *data, NSString *jsonStr);
@property (nonatomic, strong)GLD_NetworkAPIManager *NetManager;

@end

@implementation GLD_BusnessLogoController
+(instancetype)instancePost:(void (^)(NSData *data, NSString *jsonStr))postReloadBlock{
    GLD_BusnessLogoController *postVc = [[GLD_BusnessLogoController alloc]initWith:postReloadBlock];
    return postVc;
}
- (instancetype)initWith:(void (^)(NSData *data, NSString *jsonStr))postReloadBlock{
    self = [super init];
    if (self) {
        self.postReloadBlock = postReloadBlock;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUP];
    [self initData];
    //    [self setBackbut];
    self.NetManager = [GLD_NetworkAPIManager new];
    _photoView =  [GLD_PhotoView showPhotoViewInView:[AppDelegate shareDelegate].window];
    _photoView.delegate = self;
    self.title = @"上传店面图片";
    
}

- (void)setBackbut{
    YXRecordButton *backBut = [YXRecordButton creatButWithTitle:@" 放弃" andImageStr:@"返回1" andFont:17 andTextColorStr:COLOR_YX_DRAKBLUE];
    [backBut addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    backBut.frame = CGRectMake(0, 0, W(60), W(26));
    backBut.imageEdgeInsets = UIEdgeInsetsMake(0, W(-16), 0, 0);
    backBut.titleEdgeInsets = UIEdgeInsetsMake(0, W(-16), 0, 0);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBut];
    
}
- (void)backClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)initData{
    pictureArrM = [NSMutableArray array];
    imgArrM = [NSMutableArray array];
    
    
}

- (NSString *)arrayToJson:(NSArray *)arr{
    if (!IsExist_Array(arr)) {
        return @"";
    }
    NSMutableString *jsonString = [NSMutableString string];
    for (NSString *img in arr) {
        [jsonString appendString:img];
        [jsonString appendString:@","];
    }
    
    return jsonString;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
        return pictureArrM.count +1;
    
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   
        GLD_PictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GLD_PictureCell" forIndexPath:indexPath];
        if (indexPath.row == imgArrM.count) {
            cell.deleteBut.hidden = YES;
            cell.picImageV.image = WTImage(@"添加 copy 2");
        } else {
            cell.picImageV.image = [UIImage imageWithData:imgArrM[indexPath.row]];
            cell.deleteBut.hidden = NO;
            cell.tag = indexPath.row;
            cell.delegate = self;
        }
        return cell;
    
}
#pragma gldPictureCellDelegate
- (void)deletePicture:(NSInteger)index{
    [imgArrM removeObjectAtIndex:index];
    [pictureArrM removeObjectAtIndex:index];
    
    if (pictureArrM.count <= 3) {
        [self.picCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(HEIGHT(112));
        }];
    }
    
    [self.picCollectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        [self.picCollectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [self.picCollectionView reloadData];
    }];
    
    //    [self.picCollectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([collectionView isEqual:self.picCollectionView]) {
        
        if (indexPath.row == pictureArrM.count) {
            self.imageIndex = indexPath.row;
            self.selectCell = (GLD_PictureCell *)[collectionView cellForItemAtIndexPath:indexPath];
            [self.photoView showPhotoView:nil];
            //弹出图片选择器
        }
    }
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
    
    [self presentViewController:self.imagepicker animated:YES completion:nil];
}
-(void)photoalbumr{
    self.imagepicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagepicker.allowsEditing = NO;
    [self presentViewController:self.imagepicker animated:YES completion:nil];
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
    
    [self uploadImage:_certificationImage index:self.imageIndex];
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

-(void)uploadImage:(NSData *)data index:(NSInteger)index
{
  
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
        
        //更新高度
        if (index == 2)
            [self.picCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(HEIGHT(225));
            }];
        if (responseObject[@"data"])
            [pictureArrM addObject:responseObject[@"data"]];
        //请求成功
        [imgArrM addObject:_certificationImage];
        _certificationImage = nil;
        [self.picCollectionView reloadData];
        NSLog(@"请求成功：%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //请求失败
        NSLog(@"请求失败：%@",error);
        [CAToast showWithText:@"上传失败"];
        
    }];
    
}


- (void)dealloc{
    [_photoView removeFromSuperview];
    
    NSLog(@"-------------");
}

- (void)setUP{
    
    
    UILabel *addPicLabel = [UILabel creatLableWithText:@"" andFont:WTFont(17) textAlignment:NSTextAlignmentLeft textColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTBLACK]];
    addPicLabel.attributedText = [YXUniversal changeColorLabel:@"添加图片（最多添加6张）" find:@"（最多添加6张）"  flMaxFont:17 flMinFont:12 maxColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTBLACK] minColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTBLACK]];
    [self.view addSubview:addPicLabel];
    [addPicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(W(15));
        make.top.equalTo(self.view).offset(H(15));
        
    }];
    
    [self.view addSubview:self.picCollectionView];
    
    [self.picCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addPicLabel);
        make.top.equalTo(addPicLabel.mas_bottom).offset(H(30));
        make.width.equalTo(WIDTH(345));
        make.height.equalTo(HEIGHT(112));
        
    }];
    
    
    
    
    
    
    
    YXRecordButton *commitBut = [YXRecordButton creatButWithTitle:@"发布" andImageStr:nil andFont:15 andTextColorStr:COLOR_YX_DRAKwirte];;
    [commitBut setBackgroundImage:WTImage(@"可点击登陆") forState:UIControlStateNormal];
    [self.view addSubview:commitBut];
    [commitBut addTarget:self action:@selector(sendTieZiContentRequest) forControlEvents:UIControlEventTouchUpInside];
    [commitBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.picCollectionView);
        make.bottom.equalTo(self.view.mas_bottom).offset(H(-60));
        make.height.equalTo(HEIGHT(44));
        make.width.equalTo(WIDTH(345));
        
    }];
    
}

- (void)sendTieZiContentRequest{
    if (!IsExist_Array(imgArrM)) {
        [CAToast showWithText:@"请上传图片"];
        return;
    }
    if(self.postReloadBlock){
        self.postReloadBlock(imgArrM.lastObject, [self arrayToJson:pictureArrM]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (UICollectionView *)picCollectionView{
    if (!_picCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.itemSize = CGSizeMake(W(105), W(105));
        layout.minimumInteritemSpacing = 4;
        layout.minimumLineSpacing = 4;
        
        
        _picCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 409, DEVICE_WIDTH, DEVICE_WIDTH - 409) collectionViewLayout:layout];
        
        _picCollectionView.backgroundColor = [UIColor whiteColor];
        _picCollectionView.alwaysBounceVertical = YES;
        
        _picCollectionView.contentInset = UIEdgeInsetsMake(4, 0, 4, 0);
        _picCollectionView.dataSource = self;
        _picCollectionView.delegate = self;
        _picCollectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _picCollectionView.scrollEnabled = NO;
        [_picCollectionView registerClass:[GLD_PictureCell class] forCellWithReuseIdentifier:@"GLD_PictureCell"];
    }
    return _picCollectionView;
}

@end
