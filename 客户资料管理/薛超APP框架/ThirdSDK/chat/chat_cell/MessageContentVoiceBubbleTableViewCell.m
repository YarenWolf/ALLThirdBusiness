//
//  MessageContentVoiceBubbleTableViewCell.m
//  YunDong55like
//
//  Created by junseek on 15-6-30.
//  Copyright (c) 2015年 五五来客 lj. All rights reserved.
//

#import "MessageContentVoiceBubbleTableViewCell.h"
#import "UIImage+FSExtension.h"


@interface MessageContentVoiceBubbleTableViewCell ()<FSVoiceBubbleDelegate>{
    //
    NSIndexPath *tempIndexPath;
    NSDictionary *tempDic;
    
    
    UIImageView *userLogo;
    UILabel *lblDate;
    
    UILabel *lblName;
    
}


@end



@implementation MessageContentVoiceBubbleTableViewCell



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier

{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *BGV=[[UIView alloc]initWithFrame:self.bounds];
        [BGV setBackgroundColor:RGBCOLOR(255, 255, 255)];
        [self setBackgroundView: BGV];
        
        
        lblDate=[RHMethods labelWithFrame:CGRectMake(0, 5, kScreenWidth, 20) font:fontSmallTitle color:rgbTxtGray text:@"2015-06-30 12:12" textAlignment:NSTextAlignmentCenter];
        [self addSubview:lblDate];
        
        
        
        userLogo=[RHMethods imageviewWithFrame:CGRectMake(10, 10, 44,44) defaultimage:@""];
        userLogo.userInteractionEnabled=YES;
        userLogo.layer.masksToBounds = YES;
        userLogo.layer.cornerRadius =(W(userLogo))/2.0;
        userLogo.layer.borderWidth=0.1;
        userLogo.layer.borderColor =[[UIColor clearColor] CGColor];
        [self addSubview:userLogo];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(iconDidClick:)];
        [userLogo addGestureRecognizer:tap];
        
        
        UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressToDo:)];
        longPress.minimumPressDuration=1;
        [userLogo addGestureRecognizer:longPress];
        
        
        
        lblName=[RHMethods labelWithFrame:CGRectMake(XW(userLogo)+10, Y(userLogo), kScreenWidth-XW(userLogo)-20, 20) font:fontSmallTitle color:rgbTxtGray text:@""];
        [self addSubview:lblName];
        
        _voiceView=[[FSVoiceBubble alloc] init];
        _voiceView.waveInset=5;
        _voiceView.delegate=self;
        [self addSubview:_voiceView];
        //
  
        
    }
    return self;
}

//内容更新
-(void)setValueForDictionary:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath payIndexP:(NSIndexPath *)payIndex hiddenName:(BOOL)hiddenName{
    tempDic=dic;
    tempIndexPath=indexPath;
    if ([indexPath isEqual:payIndex]) {
        [_voiceView startAnimating];
    }else{
        [_voiceView stopAnimating];
    }
    float ft_y=0;
    
    lblName.hidden=YES;
    lblDate.hidden=YES;
    if (![[dic valueForJSONStrKey:@"boolDate"] isEqualToString:@"hidden"]) {
        ft_y +=20;
        lblDate.hidden=NO;
    }
    NSString *strTiem=[[[dic objectForJSONKey:@"content"] objectForJSONKey:@"voice"] valueForJSONStrKey:@"voiceLength"];
    strTiem=[strTiem notEmptyOrNull]?strTiem:@"0";
    [_voiceView setTextTime:strTiem];
    // "voice":{@"voiceUrl":http://xxxx,@"voiceLength":@"5"},	//语音消息内容
    _voiceView.contentURL=[[[dic objectForJSONKey:@"content"] objectForJSONKey:@"voice"] valueForJSONStrKey:@"voiceUrl"];
    if ([[dic valueForJSONStrKey:@"types"] isEqualToString:@"0"]) {
        //他人
        
        userLogo.frame=CGRectMake(10, 10+ft_y, 44,44);
        _voiceView.frame=CGRectMake(XW(userLogo)+8, Y(userLogo), 110, 44);
        if (!hiddenName) {//群
            lblName.frameY=Y(userLogo);
            lblName.hidden=hiddenName;
            lblName.text=[dic valueForJSONStrKey:@"name"];
            _voiceView.frameY=Y(userLogo)+25;
        }
        
        _voiceView.invert=NO;
        _voiceView.waveColor=rgbpublicColor;
        _voiceView.animatingWaveColor=RGBACOLOR(0 , 97,  167, 0.6);
        //可以根据图片形状绘制纯色图像
//        voiceView.bubbleImage=[[UIImage imageNamed:@"byqltbg010630"] imageWithOverlayColor:RGBACOLOR(255, 255, 255, 1)];
        _voiceView.bubbleImage=[UIImage imageNamed:@"byqltbg010630"] ;
        
    }else{
        //自己
        _voiceView.invert=YES;
        _voiceView.waveColor=rgbTitleColor;
        _voiceView.animatingWaveColor=[UIColor whiteColor];
        userLogo.frame=CGRectMake(kScreenWidth-54, 10+ft_y, 44,44);
        _voiceView.frame=CGRectMake(kScreenWidth-62-110, Y(userLogo), 110, 44);
        _voiceView.bubbleImage=[UIImage imageNamed:@"byqltbg020630"] ;
//        voiceView.bubbleImage=[[UIImage imageNamed:@"byqltbg010630"] imageWithOverlayColor:RGBACOLOR(29, 193, 236, 1)];
    }
    
    [userLogo imageWithURL:[dic valueForJSONStrKey:@"icon"] useProgress:NO useActivity:NO];
    lblDate.text = [[Utility Share] timeToTimestamp:[dic valueForJSONStrKey:@"createtime"]];
}

#pragma mark FSVoiceBubbleDelegate
-(void)voiceBubbleDidStartPlaying:(FSVoiceBubble *)voiceBubble{
    //开始播放
    if ([self.delegate respondsToSelector:@selector(MessageContentVoiceBubbleTableViewCell:PlaybackAudio:)]) {
        [self.delegate MessageContentVoiceBubbleTableViewCell:self PlaybackAudio:tempIndexPath];
    }
}
-(void)voiceBubbleDidStopPlaying:(FSVoiceBubble *)voiceBubble{
    if ([self.delegate respondsToSelector:@selector(MessageContentVoiceBubbleTableViewCellStopPlay:)]) {
        [self.delegate MessageContentVoiceBubbleTableViewCellStopPlay:self ];
    }
}

-(void)iconDidClick:(UIGestureRecognizer *)ges
{
    if ([self.delegate respondsToSelector:@selector(MessageContentVoiceBubbleTableViewCell:clickedUserLogo:)]) {
        [self.delegate MessageContentVoiceBubbleTableViewCell:self clickedUserLogo:tempDic];
    }
}

-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        if ([[tempDic valueForJSONStrKey:@"types"] isEqualToString:@"0"] && [self.delegate respondsToSelector:@selector(MessageContentVoiceBubbleTableViewCell:iconLongPress:)]) {
            [self.delegate MessageContentVoiceBubbleTableViewCell:self iconLongPress:tempDic];
        }
        
    }
}
-(void)dealloc{
    
    _voiceView.delegate=nil;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
