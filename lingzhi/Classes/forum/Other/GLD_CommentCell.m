//
//  GLD_CommentCell.m
//  yxvzb
//
//  Created by yiyangkeji on 17/1/13.
//  Copyright © 2017年 sendiyang. All rights reserved.
//

#import "GLD_CommentCell.h"
#import "YXLiveingHotModel.h"
#import "YXUniversal.h"
#import "GLD_Button.h"

@interface GLD_CommentCell (){
    UIImageView *_iconImgV;
    UILabel *_nameLabel;
    UILabel *_timeLabel;
    UILabel *_nickNameLable;
    UIButton *_recordBut;
    UIView *_recoverView;
    UILabel *_beNameLabel;
    UIButton *_beRecordBut;
    UILabel *_deleLabel;
//    UIButton *_replyBut;
    UILabel  *_coverLabel;
    UILabel  *_beCoverLabel;
    UIButton *_beReplyUserBut;
    UIImageView *_authImageV;
    
}

@end
@implementation GLD_CommentCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUI];
        [self layout];
        _likeBut.hidden = YES;
        
    }
    return self;
}





- (void)likeClick:(UIButton *)senser{
    
    if (self.commentBlock) {
        self.commentBlock(self.commentIndexPath ,senser.tag);
    }
    
}
- (void)userLike:(UITapGestureRecognizer *)regit{
    if (self.commentBlock) {
        self.commentBlock(self.commentIndexPath ,2021);
    }
}
- (void)setCommentModel:(YXCommentContent2Model *)commentModel{

    _commentModel = commentModel;
    
    if ([commentModel.replyUserId isEqualToString:[AppDelegate shareDelegate].userModel.userId]) {
        _likeBut.hidden = NO;
    }else{
        _likeBut.hidden = YES;
    }
    if(commentModel.replyUserNickName.length > 11)commentModel.replyUserNickName = [NSString stringWithFormat:@"%@...",[commentModel.replyUserNickName substringToIndex:8]];
    _nameLabel.text = commentModel.replyUserNickName;
    [_iconImgV yy_setImageWithURL:[NSURL URLWithString:commentModel.replyUserHeadPhoto] placeholder:[UIImage imageNamed:@"default"]];
    _timeLabel.text = commentModel.createTime;
   
    _authImageV.hidden = commentModel.replyIsAuth?NO:YES;
    //有回复
    if (commentModel.beReplyUserNickName) {
        _recoverView.hidden = NO;
        _nickNameLable.hidden = NO;
        if(commentModel.replyMediaId){
            _recordBut.hidden = NO;
            
           _nickNameLable.attributedText = [YXUniversal changeColorLabel:[NSString stringWithFormat:@"回复@%@:",commentModel.beReplyUserNickName] find:[NSString stringWithFormat:@"@%@",commentModel.beReplyUserNickName]  flMaxFont:15 flMinFont:15 maxColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTBLACK] minColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE]];
            CGFloat beW = [YXUniversal calculateLabelWidth:20 text:[NSString stringWithFormat:@"回复@%@:",commentModel.beReplyUserNickName] font:WTFont(15)];
            _nickNameLable.frame = CGRectMake(W(55), H(65), beW+W(15), H(20));
            _beReplyUserBut.hidden = NO;
            _beReplyUserBut.frame = CGRectMake(W(55), H(65), beW+W(15), H(20));
            _recordBut.frame = CGRectMake(beW + W(65), H(60), W(145), H(34));
            [_recordBut setTitle:[NSString stringWithFormat:@"                    %@",commentModel.replyVoiceTime] forState:UIControlStateNormal];
            
            
        }else{
            _recordBut.hidden = YES;
            
//            CGFloat labelH = [YXUniversal calculateCellHeight:0 width:270 text:[NSString stringWithFormat:@"回复@%@:%@",commentModel.beReplyUserNickName,commentModel.replyContent] font:15];
            CGFloat labelH = [GLD_CommentCell customLabelHeight:[NSString stringWithFormat:@"回复@%@:%@",commentModel.beReplyUserNickName,commentModel.replyContent] width:270 font:WTFont(15)];
        _nickNameLable.attributedText = [YXUniversal changeColorLabel:[NSString stringWithFormat:@"回复@%@:%@",commentModel.beReplyUserNickName,commentModel.replyContent] find:[NSString stringWithFormat:@"@%@",commentModel.beReplyUserNickName]  flMaxFont:15 flMinFont:15 maxColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTBLACK] minColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE]];
          _nickNameLable.frame = CGRectMake(W(55), H(65), W(275), labelH);
            _beReplyUserBut.frame = CGRectMake(W(55), H(65), W(125), H(20));
            _beReplyUserBut.hidden = NO;
        }
        
        
        if (commentModel.beReplyDelFlag == 1) {
            _recoverView.frame = CGRectMake(W(55), CGRectGetMaxY(_nickNameLable.frame) + H(15), W(275), H(40));
            [_deleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(_recoverView);
            }];
            _deleLabel.hidden = NO;
            _beNameLabel.hidden = YES;
            _beRecordBut.hidden = YES;
        }else{
            _deleLabel.hidden = YES;
            _beNameLabel.hidden = NO;
            if (commentModel.beReplyMediaId) {
                _beRecordBut.hidden = NO;
                _beNameLabel.attributedText = [YXUniversal changeColorLabel:[NSString stringWithFormat:@"@%@:",commentModel.beReplyUserNickName] find:[NSString stringWithFormat:@"@%@",commentModel.beReplyUserNickName]  flMaxFont:15 flMinFont:15 maxColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTnewGray] minColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE]];
               CGFloat beW = [YXUniversal calculateLabelWidth:20 text:[NSString stringWithFormat:@"@%@:",commentModel.beReplyUserNickName] font:WTFont(15)];
                _beNameLabel.frame = CGRectMake(W(10), H(10), W(beW+15), H(20));
                _beRecordBut.frame = CGRectMake(beW+W(25), H(5), W(145), H(34));
                [_beRecordBut setTitle:[NSString stringWithFormat:@"                    %@",commentModel.beReplyVoiceTime] forState:UIControlStateNormal];
            }else{
                _beRecordBut.hidden = YES;
//                CGFloat labelH = [YXUniversal calculateCellHeight:0 width:260 text:[NSString stringWithFormat:@"@%@ : %@",commentModel.beReplyUserNickName,commentModel.beReplyContent] font:15];
                CGFloat labelH = [GLD_CommentCell customLabelHeight:[NSString stringWithFormat:@"@%@ : %@",commentModel.beReplyUserNickName,commentModel.beReplyContent] width:260 font:WTFont(15)];
                _beNameLabel.attributedText = [YXUniversal changeColorLabel:[NSString stringWithFormat:@"@%@:%@",commentModel.beReplyUserNickName,commentModel.beReplyContent] find:[NSString stringWithFormat:@"@%@",commentModel.beReplyUserNickName]  flMaxFont:15 flMinFont:15 maxColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTnewGray] minColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE]];
                
                _beNameLabel.frame = CGRectMake(W(10), H(10), W(265), labelH);
                
            }
       _recoverView.frame = CGRectMake(W(55), CGRectGetMaxY(_nickNameLable.frame) + H(15), W(285), CGRectGetHeight(_beNameLabel.frame)+H(25));
        }
     
    }else{//没有回复
        _beReplyUserBut.hidden = YES;
        _recoverView.hidden = YES;
        if(commentModel.replyMediaId){
            _recordBut.hidden = NO;
            _nickNameLable.hidden = YES;
            _recordBut.frame = CGRectMake(W(55), H(60), W(145), H(34));
            
            [_recordBut setTitle:[NSString stringWithFormat:@"                    %@",commentModel.replyVoiceTime] forState:UIControlStateNormal];
            
        }else{
            _recordBut.hidden = YES;
            _nickNameLable.hidden = NO;
            CGFloat labelH = [GLD_CommentCell customLabelHeight:commentModel.replyContent width:270 font:WTFont(15)];
            _nickNameLable.text = commentModel.replyContent;
            _nickNameLable.frame = CGRectMake(W(55), H(60), W(275), labelH);
        }
        
        
    }

}

+ (CGFloat)customLabelHeight:(NSString *)labelStr width:(CGFloat)width font:(UIFont *)font {
    
    CGRect rect = [labelStr boundingRectWithSize:CGSizeMake(W(width), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil];
    CGFloat height = rect.size.height;
//    if (iPhone6Plus) {
//        if (height > 200) {
//            height -= 20;
//        }
//    }else if (iPhone5){
//        height += 25;
//        if(height > 200){
//            height += 5;
//        }
//    }else if (iPhone4){
//        height += 15;
//    }
    
    return height;
}


- (void)_beReplyUserButClick{
    if (self.commentBlock) {
        self.commentBlock(self.commentIndexPath ,2022);
    }
}
- (void)setUI{
    _nameLabel = [UILabel creatLableWithText:@"" andFont:WTFont(12) textAlignment:NSTextAlignmentLeft textColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTnewGray]];
    _nameLabel.userInteractionEnabled = YES;
    _nameLabel.textColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE];
    [_nameLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userLike:)]];
    
    
    _iconImgV = [[UIImageView alloc]init];
    _iconImgV.layer.cornerRadius =  14;
    _iconImgV.userInteractionEnabled = YES;
    
    _iconImgV.layer.masksToBounds = YES;
    [_iconImgV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userLike:)]];
    _timeLabel  = [UILabel creatLableWithText:@"11:11" andFont:WTFont(12) textAlignment:NSTextAlignmentLeft textColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTnewGray]];
    _nickNameLable = [UILabel creatLableWithText:@"" andFont:WTFont(15) textAlignment:NSTextAlignmentLeft textColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTBLACK]];
    _nickNameLable.numberOfLines = 0;
    _likeBut  = [[GLD_Button alloc]init];
    _likeBut.titleLabel.font = WTFont(15);
    
    _likeBut.tag = 2019;
    [_likeBut setTitle:@"删除" forState:UIControlStateNormal];
    [_likeBut setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_RED_TEXT] forState:UIControlStateNormal];
    [_likeBut addTarget:self action:@selector(likeClick:) forControlEvents:UIControlEventTouchUpInside];
    _recordBut = [[UIButton alloc]init];

    _recoverView = [[UIView alloc]init];
    _recoverView.layer.cornerRadius = 5;
    _recoverView.layer.masksToBounds = YES;
    _recoverView.layer.borderColor =[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTlineGray].CGColor;
    _recoverView.layer.borderWidth = 0.5;
    _recoverView.userInteractionEnabled = NO;
    _beNameLabel = [UILabel creatLableWithText:@"" andFont:WTFont(15) textAlignment:NSTextAlignmentLeft textColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTnewGray]];
    _beNameLabel.numberOfLines = 0;
    
    _beRecordBut = [[UIButton alloc]init];
    _beRecordBut.titleLabel.font = WTFont(15);
    [_beRecordBut setBackgroundImage:[UIImage imageNamed:@"语音di"] forState:UIControlStateNormal];
    [_beRecordBut setImage:[UIImage imageNamed:@"播放语音3"] forState:UIControlStateNormal];
    
    _deleLabel = [UILabel creatLableWithText:@"该评论已删除!" andFont:WTFont(15) textAlignment:NSTextAlignmentCenter textColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTred]];
    _deleLabel.hidden = YES;
    

    
    _coverLabel = [UILabel creatLableWithText:@"" andFont:WTFont(15) textAlignment:NSTextAlignmentLeft textColor:[UIColor clearColor]];
    _beCoverLabel = [UILabel creatLableWithText:@"" andFont:WTFont(15) textAlignment:NSTextAlignmentLeft textColor:[UIColor clearColor]];
    
    _beReplyUserBut = [[UIButton alloc]init];
    _beReplyUserBut.hidden = YES;
    [_beReplyUserBut addTarget:self action:@selector(_beReplyUserButClick) forControlEvents:UIControlEventTouchUpInside];
    _authImageV = [[UIImageView alloc]initWithImage:WTImage(@"用户名后的")];
    
    
    [self.contentView addSubview:_nameLabel];

    [self.contentView addSubview:_iconImgV];
    [self.contentView addSubview:_timeLabel];
    [self.contentView addSubview:_nickNameLable];
    [self.contentView addSubview:_likeBut];
    [self.contentView addSubview:_recordBut];
    [self.contentView addSubview:_recoverView];
    [self.contentView addSubview:_coverLabel];
    [self.contentView addSubview:_beReplyUserBut];
    [self.contentView addSubview:_authImageV];
    [_recoverView addSubview:_beNameLabel];
    [_recoverView addSubview:_beRecordBut];
    [_recoverView addSubview:_deleLabel];
    [_recoverView addSubview:_beCoverLabel];
}

- (void)layout{
    [_iconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(15);
        make.height.equalTo(@(28));
        make.width.equalTo(@(28));
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImgV);
        make.left.equalTo(_iconImgV.mas_right).offset(W(15));
//        make.width.equalTo(WIDTH(120));
        
    }];
    [_authImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel.mas_right).offset(5);
        make.centerY.equalTo(_nameLabel);
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel);
        make.top.equalTo(_nameLabel.mas_bottom).offset(5);
    }];
    [_likeBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_iconImgV);
        make.right.equalTo(self.contentView).offset(-20);
        make.width.equalTo(@(35));
        
    }];
    
}
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

@end
