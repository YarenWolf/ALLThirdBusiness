//
//  MessageContentTxtTableViewCell.m
//  YunDong55like
//
//  Created by junseek on 15-6-17.
//  Copyright (c) 2015年 五五来客 lj. All rights reserved.
//

#import "MessageContentTxtTableViewCell.h"
//#import "SelectWebUrlViewController.h"
#import "MLEmojiLabel.h"
//#import "myLabelCategory.h"


@interface MessageContentTxtTableViewCell ()<MLEmojiLabelDelegate>{
    //
    NSIndexPath *tempIndexPath;
    NSDictionary *tempDic;
    BaseViewController *superBaseVC;
    
    UIImageView *userLogo;
    
    
    UIImageView *imageVBG;
    MLEmojiLabel *emojiLabel;
    UILabel *lblDate;
    UILabel *lblName;
    
}


@end
@implementation MessageContentTxtTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier

{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *BGV=[[UIView alloc]initWithFrame:self.bounds];
        [BGV setBackgroundColor:RGBCOLOR(255, 255, 255)];
        [self setBackgroundView: BGV];
        
        
        
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
        
        
        
        imageVBG=[RHMethods imageviewWithFrame:CGRectMake(60, X(userLogo), 48, 44) defaultimage:@"dh_box01"];
        imageVBG.contentMode=UIViewContentModeScaleToFill;
        [self addSubview:imageVBG];
        
        //
        
        lblName=[RHMethods labelWithFrame:CGRectMake(XW(userLogo)+10, Y(userLogo), kScreenWidth-XW(userLogo)-20, 20) font:fontSmallTitle color:rgbTxtGray text:@""];
        [self addSubview:lblName];
        
        emojiLabel = [[MLEmojiLabel alloc]init];
        emojiLabel.numberOfLines = 0;
        emojiLabel.font =fontSmallTitle;// [UIFont systemFontOfSize:14.0f];
//        NSLog(@"%f",emojiLabel.font.lineHeight);
        emojiLabel.emojiDelegate = self;
        //        _emojiLabel.textAlignment = NSTextAlignmentCenter;
        emojiLabel.backgroundColor = [UIColor clearColor];
        emojiLabel.lineBreakMode = NSLineBreakByCharWrapping;
//        emojiLabel.isNeedAtAndPoundSign = YES;
        [self addSubview:emojiLabel];
        emojiLabel.disablePhone=YES;
        emojiLabel.disableEmail=YES;
        
        emojiLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        emojiLabel.customEmojiPlistName = @"expressionImage_custom.plist";
//        [emojiLabel lableCopy];
        
        lblDate=[RHMethods labelWithFrame:CGRectMake(0, 5, kScreenWidth, 20) font:fontSmallTitle color:rgbTxtGray text:@"2015-06-30 12:12" textAlignment:NSTextAlignmentCenter];
        [self addSubview:lblDate];
        
        
    }
    return self;
}



//内容更新
-(void)setValueForDictionary:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath superViewController:(BaseViewController *)baseV hiddenName:(BOOL)hiddenName{
    tempDic=dic;
    tempIndexPath=indexPath;
    superBaseVC=baseV;
    //        //                [_emojiLabel setEmojiText:@"微笑[微笑][白眼][白眼][白眼][白眼]微笑[愉快]---[冷汗][投降][抓狂][害羞]"];
    [emojiLabel setEmojiText:[[dic objectForJSONKey:@"content"] valueForJSONStrKey:@"content"]];
    lblName.hidden=YES;
    
    
    CGFloat ft_y = 0;
    lblDate.hidden=YES;
    if (![[dic valueForJSONStrKey:@"boolDate"] isEqualToString:@"hidden"]) {
        lblDate.hidden=NO;
        ft_y  = 20;
    }
    if ([[dic valueForJSONStrKey:@"types"] isEqualToString:@"0"]) {//别人
        userLogo.frame=CGRectMake(10, 10+ft_y, 44,44);
        if (!hiddenName) {//群聊
            lblName.frameY=Y(userLogo);
            lblName.hidden=hiddenName;
            lblName.text=[dic valueForJSONStrKey:@"name"];
            ft_y+=25;
        }
        
        //他人
        emojiLabel.frame = CGRectMake(80,20+ft_y, kScreenWidth-120, 20);
        [emojiLabel sizeToFit];
        if (H(emojiLabel)<20) {
            emojiLabel.frame = CGRectMake(X(emojiLabel), Y(emojiLabel), W(emojiLabel), 20);
        }
        CGRect backFrame = emojiLabel.frame;
        backFrame.origin.x -= 18;
        backFrame.size.width += 18+10;
        backFrame.origin.y -= 10;
        backFrame.size.height += 10+10;
        imageVBG.frame = backFrame;
        imageVBG.image=[[UIImage imageNamed:@"dh_box01"] stretchableImageWithLeftCapWidth:20 topCapHeight:35];
    }else{
        userLogo.frame=CGRectMake(kScreenWidth-54, 10+ft_y, 44,44);
        emojiLabel.frame = CGRectMake(40, 20+ft_y, kScreenWidth-120, 20);
        [emojiLabel sizeToFit];
        
        if (W(emojiLabel)<kScreenWidth-120) {
            emojiLabel.frame = CGRectMake(40 + (kScreenWidth-120 -W(emojiLabel)), Y(emojiLabel), W(emojiLabel), H(emojiLabel));
        }
        if (H(emojiLabel)<20) {
            emojiLabel.frame = CGRectMake(X(emojiLabel), Y(emojiLabel), W(emojiLabel), 20);
        }
        CGRect backFrame = emojiLabel.frame;
        backFrame.origin.x -= 10;
        backFrame.size.width += 18+10;
        backFrame.origin.y -= 10;
        backFrame.size.height += 10+10;
        imageVBG.frame = backFrame;
        imageVBG.image=[[UIImage imageNamed:@"dh_box02"] stretchableImageWithLeftCapWidth:20 topCapHeight:35];
        
        
    }
    
    [userLogo imageWithURL:[dic valueForJSONStrKey:@"icon"] useProgress:NO useActivity:NO];
    lblDate.text = [[Utility Share] timeToTimestamp:[dic valueForJSONStrKey:@"createtime"]];
    

    
}

- (void)mlEmojiLabel:(MLEmojiLabel*)emojiLabel didSelectLink:(NSString*)link withType:(MLEmojiLabelLinkType)type
{
    switch(type){
        case MLEmojiLabelLinkTypeURL:
//            [superBaseVC pushController:[SelectWebUrlViewController class] withInfo:@"" withTitle:@"链接" withOther:link];
//            [SVProgressHUD showImage:nil status:[NSString stringWithFormat:@"点击了链接%@",link]];
            NSLog(@"点击了链接%@",link);
            break;
        case MLEmojiLabelLinkTypePhoneNumber:
            [SVProgressHUD showImage:nil status:[NSString stringWithFormat:@"点击了电话%@",link]];
            NSLog(@"点击了电话%@",link);
            break;
        case MLEmojiLabelLinkTypeEmail:
            [SVProgressHUD showImage:nil status:[NSString stringWithFormat:@"点击了邮箱%@",link]];
            NSLog(@"点击了邮箱%@",link);
            break;
        case MLEmojiLabelLinkTypeAt:
            [SVProgressHUD showImage:nil status:[NSString stringWithFormat:@"点击了用户%@",link]];
            NSLog(@"点击了用户%@",link);
            break;
        case MLEmojiLabelLinkTypePoundSign:
            [SVProgressHUD showImage:nil status:[NSString stringWithFormat:@"点击了话题%@",link]];
            NSLog(@"点击了话题%@",link);
            break;
        default:
            NSLog(@"点击了????啥%@",link);
            [SVProgressHUD showImage:nil status:[NSString stringWithFormat:@"点击了????啥%@",link]];
            break;
    }
    
}


-(void)iconDidClick:(UIGestureRecognizer *)ges
{
    if ([self.delegate respondsToSelector:@selector(messageContentTxtTableViewCell:clickedUserLogo:)]) {
        [self.delegate messageContentTxtTableViewCell:self clickedUserLogo:tempDic];
    }
}

-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        if ([[tempDic valueForJSONStrKey:@"types"] isEqualToString:@"0"] && [self.delegate respondsToSelector:@selector(messageContentTxtTableViewCell:iconLongPress:)]) {
            [self.delegate messageContentTxtTableViewCell:self iconLongPress:tempDic];
        }
        
    }
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
