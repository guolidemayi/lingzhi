//
//  GLD_PickerView.m
//  yxvzb
//
//  Created by yiyangkeji on 2017/4/27.
//  Copyright © 2017年 sendiyang. All rights reserved.
//

#import "GLD_PickerView.h"
#import "GLD_TopicModel.h"

@interface GLD_PickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>{
    
    NSInteger _idex; //选择索引
}

@property (nonatomic, weak)UIPickerView *pickerView;

@property (nonatomic, weak)UIView *picker_View;

@property (nonatomic, strong)NSArray *contentArr;

@property (nonatomic, strong)NSArray *contentArr1;

@property (nonatomic, strong)NSDictionary *contentDict;

@property (nonatomic, copy)pickerViewBlock block;
@end
@implementation GLD_PickerView


+ (instancetype)gld_getPickerViewWithContent:(NSArray *)contentArr andDict:(NSDictionary *)dict andBlock:(pickerViewBlock)block{
    GLD_PickerView *pickerView = [[GLD_PickerView alloc]initWithFrame:[AppDelegate shareDelegate].window.bounds];
    [[AppDelegate shareDelegate].window addSubview:pickerView];
    
    pickerView.contentArr = contentArr;
    if (dict.count > 0) {
        pickerView.contentDict = dict;
        pickerView.contentArr1 = dict[contentArr.firstObject];
    }
    pickerView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    pickerView.hidden = YES;
    pickerView.block = block;
    [pickerView initView];
    return pickerView;
}



- (void)sureButClick{
    [self hiddenPickerView];
//    NSString *title;
    GLD_TopicModel *model;
    if (self.contentDict.count > 0) {
        model = self.contentArr1[_idex];
    }else{
//        title = self.contentArr[_idex];
    }
    if (self.block) {
        self.block(model);
    }
}
- (void)cancelButClick{
    
    [self hiddenPickerView];
}
- (void)showPickerVeiw{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.hidden = NO;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        [self.picker_View mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(HEIGHT(220));
        }];
        [self layoutIfNeeded];
        
    }];
}
- (void)hiddenPickerView{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.hidden = YES;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        [self.picker_View mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(HEIGHT(0.1));
        }];
        [self layoutIfNeeded];
    }];
}

#pragma mark -- PickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (self.contentDict.count > 0) {
        return 2;
    }
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
        if (component == 0) {
            
            return self.contentArr.count;
        }else{
            ;
//            NSArray *arr = self.contentDict[self.contentArr.firstObject];
            return self.contentArr1.count;
        }
   
    
}
//自定义视图
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.textColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTBLACK];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    // Fill the label text here
    if (component == 0) {
        
        pickerLabel.text = self.contentArr[row];
    }else if(component == 1){
        
        GLD_TopicModel *model = self.contentArr1[row];
        pickerLabel.text = model.categoryName;
    }
    pickerLabel.textAlignment = NSTextAlignmentCenter;
    pickerLabel.font =WTFont(15);
    return pickerLabel;
}
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (component == 0) {
        
        return self.contentArr[row];
    }else if(component == 1){
        
        GLD_TopicModel *model = self.contentArr1[row];
        return model.categoryName;
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
        
        if (component == 0) {
            NSString *key = self.contentArr[row];
            
            self.contentArr1 = self.contentDict[key];
             
            if (self.contentDict.count > 0) {
                _idex = 0;
            }else{
                _idex = row;
            }
            
            [pickerView reloadComponent:1];
            [pickerView selectRow:0 inComponent:1 animated:NO];
        }else{
            _idex = row;
            
            
        }
    
    
}


- (void)initView{
    //pickerView
    
    UIView *picV = [[UIView alloc]init];
    self.picker_View = picV;
    picV.backgroundColor = [UIColor whiteColor];
    UIPickerView *pickerView = [[UIPickerView alloc]init];
    pickerView.backgroundColor =[YXUniversal colorWithHexString:COLOR_YX_DRAKwirte];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    self.pickerView = pickerView;
    UIView *toolView = [[UIView alloc]init];
    toolView.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_tableFooter];
    UIButton *sureBut = [[UIButton alloc]init];
    sureBut.titleLabel.font = WTFont(15);
    [sureBut setTitle:@"确定" forState:UIControlStateNormal];
    [sureBut setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE] forState:UIControlStateNormal];
    [sureBut addTarget:self action:@selector(sureButClick) forControlEvents:UIControlEventTouchUpInside];
    UIButton *cencelBut = [[UIButton alloc]init];
    [cencelBut setTitle:@"取消" forState:UIControlStateNormal];
    [cencelBut setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE] forState:UIControlStateNormal];
    [cencelBut addTarget:self action:@selector(cancelButClick) forControlEvents:UIControlEventTouchUpInside];
    cencelBut.titleLabel.font = WTFont(15);
    
    [self addSubview:picV];
   
    [picV addSubview:pickerView];
    [picV addSubview:toolView];
    [toolView addSubview:cencelBut];
    [toolView addSubview:sureBut];
    
    
    
    __weak typeof(self) weakSelf = self;
    
    [picV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf);
        make.height.equalTo(HEIGHT(0.1));
    }];
    
    [toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(picV);
        make.left.right.equalTo(weakSelf);
        make.height.equalTo(HEIGHT(44));
    }];
    [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf);
        make.top.equalTo(toolView.mas_bottom);
        make.height.equalTo(HEIGHT(180));
    }];
    [sureBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(toolView);
        make.right.equalTo(toolView).offset(-15);
    }];
    [cencelBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(toolView);
        make.left.equalTo(toolView).offset(15);
    }];

}

@end
