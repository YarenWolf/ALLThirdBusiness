//
//  MessageContentImageTableViewCell.m
//  YunDong55like
//
//  Created by junseek on 15-7-3.
//  Copyright (c) 2015年 五五来客 lj. All rights reserved.
//

#import "MessageContentImageTableViewCell.h"
#import <MKNetworkOperation.h>

@interface MessageContentImageTableViewCell (){
    //
    NSIndexPath *tempIndexPath;
    NSDictionary *tempDic;
    
    
    UIImageView *userLogo;
    
    UIImageView *imageViewS;
    
    UIImageView *imageVBG;
    
    UILabel *lblName;
    UILabel *lblDate;
    
    MKNetworkOperation *netOp;
}


@end
@implementation MessageContentImageTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier

{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *BGV=[[UIView alloc]initWithFrame:self.bounds];
        [BGV setBackgroundColor:RGBCOLOR(255, 255, 255)];
        [self setBackgroundView: BGV];
        
        
        
        userLogo=[RHMethods imageviewWithFrame:CGRectMake(10, 10, 44,44) defaultimage:@""];
//        userLogo.userInteractionEnabled=NO;
        userLogo.layer.masksToBounds = YES;
        userLogo.layer.cornerRadius =(W(userLogo))/2.0;
        userLogo.layer.borderWidth=0.1;
        userLogo.layer.borderColor =[[UIColor clearColor] CGColor];
        [self addSubview:userLogo];
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(iconDidClick:)];
        userLogo.userInteractionEnabled=YES;
        [userLogo addGestureRecognizer:tap];
        
        UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressToDo:)];
        longPress.minimumPressDuration=1;
        [userLogo addGestureRecognizer:longPress];
        
        
        imageVBG=[RHMethods imageviewWithFrame:CGRectMake(62, X(userLogo), 120, 160) defaultimage:@"dh_box01"];
        imageVBG.contentMode=UIViewContentModeScaleToFill;
        [self addSubview:imageVBG];
        
        lblName=[RHMethods labelWithFrame:CGRectMake(XW(userLogo)+10, Y(userLogo), kScreenWidth-XW(userLogo)-20, 20) font:fontSmallTitle color:rgbTxtGray text:@""];
        [self addSubview:lblName];

        imageViewS=[RHMethods imageviewWithFrame:CGRectMake(X(imageVBG)+10, Y(imageVBG)+5, W(imageVBG)-20, H(imageVBG)-10) defaultimage:@""];
        [self addSubview:imageViewS];
        
        UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(icondid:)];
        imageViewS.userInteractionEnabled = YES;
        
        [imageViewS addGestureRecognizer:tapImage];
        
        //
        lblDate=[RHMethods labelWithFrame:CGRectMake(0, 5, kScreenWidth, 20) font:fontSmallTitle color:rgbTxtGray text:@"2015-06-30 12:12" textAlignment:NSTextAlignmentCenter];
        [self addSubview:lblDate];
        
        
        
        
    }
    return self;
}

-(void)iconDidClick:(UIGestureRecognizer *)ges
{
    if ([self.delegate respondsToSelector:@selector(MessageContentImageTableViewCell:iconDidClick:)]) {
        [self.delegate MessageContentImageTableViewCell:self iconDidClick:tempDic];
    }
}
-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        if ([[tempDic valueForJSONStrKey:@"types"] isEqualToString:@"0"] && [self.delegate respondsToSelector:@selector(MessageContentImageTableViewCell:iconLongPress:)]) {
            [self.delegate MessageContentImageTableViewCell:self iconLongPress:tempDic];
        }

    }
}
//内容更新
-(void)setValueForDictionary:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath hiddenName:(BOOL)hiddenName{
    tempDic=dic;
    tempIndexPath=indexPath;
    if (netOp) {
        [netOp cancel];
    }
    
    float ft_y=0;
    lblDate.hidden=YES;
    if (![[dic valueForJSONStrKey:@"boolDate"] isEqualToString:@"hidden"]) {
        ft_y +=20;
        lblDate.hidden=NO;
    }
    lblName.hidden=YES;
    if ([[dic valueForJSONStrKey:@"types"] isEqualToString:@"0"]) {//他人
        
        userLogo.frame=CGRectMake(10, 10+ft_y, 44,44);
        imageVBG.frame = CGRectMake(62, Y(userLogo), 120, 160);
        if (!hiddenName) {
            lblName.frameY=Y(userLogo);
            lblName.hidden=hiddenName;
            lblName.text=[dic valueForJSONStrKey:@"name"];
            imageVBG.frameY =Y(userLogo)+25;
        }
        
        //他人
        imageVBG.image=[[UIImage imageNamed:@"dh_box01"] stretchableImageWithLeftCapWidth:20 topCapHeight:35];//
        imageViewS.frame=CGRectMake( X(imageVBG)+12, Y(imageVBG)+5, W(imageVBG)-17, H(imageVBG)-10) ;
//        imageViewS.image=[UIImage imageNamed:@"index_pic03"];
        
    }else{
        
        //自己
        userLogo.frame=CGRectMake(kScreenWidth-54, 10+ft_y, 44,44);
        
        imageVBG.frame =  CGRectMake(kScreenWidth-182, Y(userLogo), 120, 160);;
        imageVBG.image=[[UIImage imageNamed:@"dh_box02"] stretchableImageWithLeftCapWidth:20 topCapHeight:35];
        
        imageViewS.frame=CGRectMake(X(imageVBG)+5, Y(imageVBG)+5, W(imageVBG)-17, H(imageVBG)-10) ;
        //        imageViewS.image=[UIImage imageNamed:@"index_pic03"];
        
        
        
    }
    //if ([[[dic objectForJSONKey:@"content"] objectForJSONKey:@"image"] isKindOfClass:[NSString class]]) {
        netOp=[imageViewS imageWithURL:[[[dic objectForJSONKey:@"content"] objectForJSONKey:@"image"] valueForJSONStrKey:@"small_path"] useProgress:NO useActivity:NO];
    //}
    
    [userLogo imageWithURL:[dic valueForJSONStrKey:@"icon"] useProgress:NO useActivity:NO];
    lblDate.text = [[Utility Share] timeToTimestamp:[dic valueForJSONStrKey:@"createtime"]];
    
    
    
}

-(void)icondid:(UIGestureRecognizer *)ges
{
    if ([self.delegate respondsToSelector:@selector(MessageContentImageTableViewCell:reviewImages:index:)]) {
        [self.delegate MessageContentImageTableViewCell:self reviewImages:tempDic index:tempIndexPath];
    }
//    UIImageView *imageV=(UIImageView *)(ges.view);
//    if (!imahe) {
//        imahe = [[XHImageUrlViewer alloc]init];
//    }
//    // @[@{@"DefaultImage":image,@"DefaultName":@"imageName",@"url":@"http:xxx.jpg"}]
//    //    [imahe showWithImageViews:@[(UIImageView *)(ges.view)] selectedView:(UIImageView *)(ges.view)];
//    [imahe showWithImageDatas:@[@{@"DefaultImage":imageV.image,@"url":[[[tempDic objectForJSONKey:@"content"] objectForJSONKey:@"image"] valueForJSONStrKey:@"path"]}] selectedIndex:0];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
