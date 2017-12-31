//
//  GLD_PostController.m
//  yxvzb
//
//  Created by yiyangkeji on 2017/4/26.
//  Copyright © 2017年 sendiyang. All rights reserved.
//

#import "GLD_PostController.h"
#import "GLD_PhotoView.h"
#import "YXRecordButton.h"
#import "GLD_topicCell.h"
#import "GLD_PickerView.h"
#import "GLD_PictureCell.h"



#import "GLD_TopicModel.h"
#import "YXRecordButton.h"

@interface GLD_PostController ()<UICollectionViewDelegate, UICollectionViewDataSource,UITextViewDelegate,GLD_topicCellDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,GLD_PhotoViewDelegate,GLD_PictureCellDelegate,UITextFieldDelegate>
{
//    NSMutableArray *topicArrM;
    NSMutableDictionary *topicDict;
    NSMutableArray *pictureArrM;
    
    NSMutableArray *imgArrM; //   保存选取图片的数组
}
@property (nonatomic, weak)UIScrollView *scrollView;

@property (nonatomic , weak)UITextField *textField;

@property (nonatomic , weak)UITextView *textView;
@property (nonatomic , strong)UICollectionView *picCollectionView;
@property (nonatomic , strong)UICollectionView *topicCollectionView;
@property (nonatomic , weak)YXRecordButton *commitBut;
@property (nonatomic , weak)UILabel *placeholderLabel;
@property (strong, nonatomic) UIImagePickerController* imagepicker;

@property (nonatomic, weak)GLD_PickerView *pickerView;

@property (nonatomic, weak)GLD_PhotoView *photoView;//图片选择视图

@property (strong, nonatomic) NSData* certificationImage;//图片二进制

@property (nonatomic,assign) NSInteger imageIndex;//记录增加图片的位置。方便删除

@property (nonatomic, weak)GLD_PictureCell *selectCell;
@property (nonatomic, strong)NSMutableArray *topicArrM;
@property (nonatomic, copy)void(^postReloadBlock)(void);
@end

@implementation GLD_PostController
+(instancetype)instancePost:(void (^)(void))postReloadBlock{
    GLD_PostController *postVc = [[GLD_PostController alloc]initWith:postReloadBlock];
    return postVc;
}
- (instancetype)initWith:(void (^)(void))postReloadBlock{
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
    [self setBackbut];
    _photoView =  [GLD_PhotoView showPhotoViewInView:[AppDelegate shareDelegate].window];
    _photoView.delegate = self;
 
    [self initKeywordRequest];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
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
    
    topicDict = @{}.mutableCopy;
    _topicArrM = [NSMutableArray array];
    pictureArrM = [NSMutableArray array];
    imgArrM = [NSMutableArray array];
    
   
}
- (void)reLoadMainData{
    [self initKeywordRequest];
}
- (void)initKeywordRequest{
  WS(weakSelf);
//    GLD_TopicTypeListRequest *request = [GLD_TopicTypeListRequest shareManager];
//    [request httpPost:@"" parameters:nil block:^(WTBaseRequest *request, NSError *error) {
//
//        if (error) {
//            [weakSelf showNoDataViewOrLoadView:error];
//        }else{
//            [weakSelf hiddenNoDataView];
//            NSDictionary *dict = request.resultData[@"data"];
//            dict = dict[@"categoryMap"];
//
//            for (NSString *key in dict.allKeys) {
//
//                NSArray *topicArr = dict[key];
//                NSMutableArray *topicListArrM = [NSMutableArray arrayWithCapacity:0];
//                for (NSDictionary *dd in topicArr) {
//                    GLD_TopicModel *model = [[GLD_TopicModel alloc]init];
//                    model.categoryId = dd[@"categoryId"];
//                    model.categoryName = dd[@"categoryName"];
//                    [topicListArrM addObject:model];
//                }
//                [topicDict addEntriesFromDictionary:@{key : topicListArrM}];
//
//            }
//
//            WS(weakSeaf);
//            weakSelf.pickerView = [GLD_PickerView gld_getPickerViewWithContent:dict.allKeys andDict:topicDict andBlock:^(GLD_TopicModel *model) {
//                NSLog(@"name = %@",model);
//                for (GLD_TopicModel *topicModel in weakSeaf.topicArrM) {
//                    if ([topicModel.categoryName isEqualToString:model.categoryName]) {
//                        [CAToast showWithText:@"已经增加过此话题"];
//                        return;
//                    }
//                }
//                [weakSeaf.topicArrM addObject:model];
//                [weakSelf.topicCollectionView reloadData];
//
//            }];
//
//        }
//    }];
//
}

- (void)sendTieZiContentRequest{
    
    NSString *temp2 = [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(temp2.length ==0)
    {
//        [self toastInfo:@"请输入问题标题"];
        return;
    }
    NSString *temp = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(temp.length ==0)
    {
//        [self toastInfo:@"请输入问题内容"];
        return;
    }
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    for (GLD_TopicModel *model in _topicArrM) {
        [arr addObject:model.categoryId];
    }
    NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithCapacity:0];
    
   
    NSString *jsonString = [self arrayToJson:pictureArrM];
    
    NSString *jsonString1 = [self arrayToJson:arr];
    
//    [dictM addEntriesFromDictionary:@{@"userId":[AppDelegate shareDelegate].userDataModel.id,@"title":self.textField.text ,@"content":self.textView.text,@"images":jsonString,@"categorys":jsonString1}];
//    WS(weakSelf);
//    GLD_TopicAddBbsV2Request *request = [GLD_TopicAddBbsV2Request shareManager];
//    [request httpPost:@"" parameters:dictM block:^(WTBaseRequest *request, NSError *error) {
//
//        if (error) {
//            [weakSelf toastInfo:error.localizedDescription];
////            [weakSelf showNoDataViewOrLoadView:error];
//        }else{
//            [CAToast showWithText:@"发布成功"];
//            [weakSelf hiddenNoDataView];
//            if(weakSelf.postReloadBlock)weakSelf.postReloadBlock();
//            [weakSelf.navigationController popViewControllerAnimated:YES];
//        }
//
//    }];
//
}

- (NSString *)arrayToJson:(NSArray *)arr{
    if (!IsExist_Array(arr)) {
        return @"";
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@" " withString:@""];
    return jsonString;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([collectionView isEqual:self.topicCollectionView]) {
        
        return _topicArrM.count + 1;
    }else if([collectionView isEqual:self.picCollectionView]){
        return pictureArrM.count +1;
    }
    return 0;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([collectionView isEqual:self.topicCollectionView]) {
        GLD_topicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GLD_topicCell" forIndexPath:indexPath];
        if (indexPath.item < _topicArrM.count) {
            GLD_TopicModel *model = _topicArrM[indexPath.row];
            cell.topicModel = model;
            cell.topicName = [NSString stringWithFormat:@"# %@",model.categoryName];
        } else {
            cell.topicModel = nil;
            cell.topicName = @"┼";
        }
        cell.delegate = self;
        return cell;
    } else {
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
- (void)deleteOraddTopicCallBack:(NSString *)topic andCell:(GLD_topicCell *)cell isDelete:(BOOL)del{
    if (del) {
        [_topicArrM removeObject:cell.topicModel];
        [self.topicCollectionView reloadData];
    }else{
        if (![topic isEqualToString:@"┼"])return;
        [self.pickerView showPickerVeiw];
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
    NSString *time = [YXUniversal getTimeStap];
//    NSString *token = [SDKTool HMACWithSecret:YX_HMACMD5_KEY string:[NSString stringWithFormat:@"%@__%@",time,YX_UPLOAD_KEY]];
//    YXUploadImageRequest *request = [[YXUploadImageRequest alloc] init];
    
    
    
}

- (void)textViewDidChange:(UITextView *)textView{
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    
    if (textView.text.length > 0) {
        self.placeholderLabel.hidden = YES;
    }else{
        self.placeholderLabel.hidden = NO;
    }
    
    size.height = MAX(80, size.height);
    if (size.height > 80) {
        self.scrollView.contentSize = CGSizeMake(0, H(800 + size.height - 50));
    }
   [textView mas_updateConstraints:^(MASConstraintMaker *make) {
       make.height.equalTo(@(size.height));
   }];
    [self.view layoutIfNeeded];
//    textView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([textField isEqual:self.textField]) {
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
            if (proposedNewLength > 20) {
                return NO;//限制长度
            }
    }
    return YES;
}
- (void)dealloc{
    [_photoView removeFromSuperview];
    [self.pickerView removeFromSuperview];//从window上移除
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

- (void)setUP{
    
    UILabel *titleLabel = [UILabel creatLableWithText:@"" andFont:WTFont(17) textAlignment:NSTextAlignmentLeft textColor:[YXUniversal colorWithHexString:COLOR_YX_BLUE_TABLE]];
    
    titleLabel.attributedText = [YXUniversal changeColorLabel:@"标题 *" find:@"*"  flMaxFont:17 flMinFont:17 maxColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTBLACK] minColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTRED]];
    
    [self.scrollView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView).offset(W(15));
        make.top.equalTo(self.scrollView).offset(W(15));
        
    }];
    
    
    UITextField *textField = [[UITextField alloc]init];
    textField.placeholder = @"不超过20字";
    textField.delegate = self;
    self.textField  = textField;
    [self.scrollView addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(titleLabel.mas_bottom).offset(H(20));
        make.width.equalTo(WIDTH(345));
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTlineGray];
    [self.scrollView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(textField.mas_bottom).offset(10);
        make.width.equalTo(textField);
        make.height.equalTo(HEIGHT(0.5));
        
    }];
    
    UILabel *contentL = [UILabel creatLableWithText:@"" andFont:WTFont(15) textAlignment:NSTextAlignmentLeft textColor:[YXUniversal colorWithHexString:COLOR_YX_BLUE_TABLE]];
    [self.scrollView addSubview:contentL];
    contentL.attributedText = [YXUniversal changeColorLabel:@"内容 *" find:@"*"  flMaxFont:17 flMinFont:17 maxColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTBLACK] minColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTRED]];
    [contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(lineView.mas_bottom).offset(H(15));
    }];
    
    
    
    UITextView *textView = [[UITextView alloc]init];
    self.textView = textView;
    textView.font = WTFont(15);
    textView.delegate = self;
    textView.scrollEnabled = NO;
    [self.scrollView addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.width.equalTo(textField);
        make.height.equalTo(HEIGHT(80));
        make.top.equalTo(contentL.mas_bottom).offset(H(20));
        
    }];
    
    UILabel *textViewPlaceholderLabel = [UILabel creatLableWithText:@"写下想要与同行分享或探讨的问题吧" andFont:WTFont(15) textAlignment:NSTextAlignmentLeft textColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTlineGray]];
    [self.scrollView addSubview:textViewPlaceholderLabel];
    [textViewPlaceholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textView).offset(W(5));
        make.top.equalTo(textView).offset(9);
    }];
    self.placeholderLabel = textViewPlaceholderLabel;
    UIView *lineView1 = [[UIView alloc]init];
    lineView1.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTlineGray];
    [self.scrollView addSubview:lineView1];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(textView.mas_bottom);
        make.width.equalTo(textField);
        make.height.equalTo(HEIGHT(0.5));
        
    }];
    
    
    UILabel *addPicLabel = [UILabel creatLableWithText:@"" andFont:WTFont(17) textAlignment:NSTextAlignmentLeft textColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTBLACK]];
    addPicLabel.attributedText = [YXUniversal changeColorLabel:@"添加图片（最多添加6张）" find:@"（最多添加6张）"  flMaxFont:17 flMinFont:12 maxColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTBLACK] minColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTBLACK]];
    [self.scrollView addSubview:addPicLabel];
    [addPicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(lineView1).offset(H(15));
        
    }];
    
    [self.scrollView addSubview:self.picCollectionView];
    
    [self.picCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(addPicLabel.mas_bottom).offset(H(30));
        make.width.equalTo(textView);
        make.height.equalTo(HEIGHT(112));
        
    }];
    
    UILabel *topicLabel = [UILabel creatLableWithText:@"" andFont:WTFont(15) textAlignment:NSTextAlignmentLeft textColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTBLACK]];
    [self.scrollView addSubview:topicLabel];
    topicLabel.attributedText = [YXUniversal changeColorLabel:@"所属话题（最多3个）" find:@"（最多3个）"  flMaxFont:17 flMinFont:12 maxColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTBLACK] minColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTBLACK]];
    [topicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(self.picCollectionView.mas_bottom).offset(H(15));
        
    }];
    
    
    
    [self.scrollView addSubview:self.topicCollectionView];
    [self.topicCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(topicLabel.mas_bottom).offset(W(15));
        make.width.equalTo(textView);
        make.height.equalTo(WIDTH(40));
    }];
    
    
    YXRecordButton *commitBut = [YXRecordButton creatButWithTitle:@"发布" andImageStr:nil andFont:15 andTextColorStr:COLOR_YX_DRAKwirte];;
    [commitBut setBackgroundImage:WTImage(@"登录可点击") forState:UIControlStateNormal];
    [self.scrollView addSubview:commitBut];
    [commitBut addTarget:self action:@selector(sendTieZiContentRequest) forControlEvents:UIControlEventTouchUpInside];
    [commitBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topicCollectionView);
        make.top.equalTo(self.topicCollectionView.mas_bottom).offset(H(30));
        make.height.equalTo(HEIGHT(44));
        make.width.equalTo(textField);
        
    }];
    
    NSLog(@" %@", commitBut);
   
    self.scrollView.contentSize = CGSizeMake(0, H(800));
        
    

}

- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        _scrollView = scrollView;
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
//        [_scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrollViewTapClick)]];
        [self.view addSubview:scrollView];
        
        
    }
    return _scrollView;
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

- (UICollectionView *)topicCollectionView{
    if (!_topicCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(W(85), W(35));
        layout.minimumInteritemSpacing = W(15);
        layout.minimumLineSpacing = W(15);
        _topicCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        CGFloat rgb = 244 / 255.0;
        
        _topicCollectionView.alwaysBounceVertical = YES;
        _topicCollectionView.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
        _topicCollectionView.contentInset = UIEdgeInsetsMake(4, 0, 4, 0);
        _topicCollectionView.dataSource = self;
        _topicCollectionView.delegate = self;
        _topicCollectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _topicCollectionView.scrollEnabled = NO;
        _topicCollectionView.backgroundColor = [UIColor whiteColor];
        [_topicCollectionView registerClass:[GLD_topicCell class] forCellWithReuseIdentifier:@"GLD_topicCell"];
    }
    return _topicCollectionView;
}

@end