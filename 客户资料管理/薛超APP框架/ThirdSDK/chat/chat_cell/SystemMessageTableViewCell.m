//
//  SystemMessageTableViewCell.m
//  YunDong55like
//
//  Created by junseek on 15/8/7.
//  Copyright (c) 2015年 五五来客 lj. All rights reserved.
//

#import "SystemMessageTableViewCell.h"

@interface SystemMessageTableViewCell (){
    //
    NSIndexPath *tempIndexPath;
    NSDictionary *tempDic;
    
    
    UILabel *lblTitle;
    
}


@end
@implementation SystemMessageTableViewCell




-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier

{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *BGV=[[UIView alloc]initWithFrame:self.bounds];
        [BGV setBackgroundColor:RGBCOLOR(255, 255, 255)];
        [self setBackgroundView: BGV];
        
        
        lblTitle=[RHMethods labelWithFrame:CGRectMake(50, 10, kScreenWidth-50, 20) font:fontSmallTitle color:rgbTitleColor text:@"" textAlignment:NSTextAlignmentCenter];
        lblTitle.backgroundColor=rgbGray;
        lblTitle.layer.masksToBounds = YES;
        lblTitle.layer.cornerRadius =6.0;
        lblTitle.layer.borderWidth=1;
        lblTitle.layer.borderColor =[[UIColor clearColor] CGColor];
        [self addSubview:lblTitle];
        
        
    }
    return self;
}

//内容更新
-(void)setValueForDictionary:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath{
    tempDic=dic;
    tempIndexPath=indexPath;
    
    lblTitle.text=[NSString stringWithFormat:@"  %@  ",[[dic objectForJSONKey:@"content"] valueForJSONStrKey:@"content"]];
    CGSize size = [lblTitle sizeThatFits:CGSizeMake(MAXFLOAT, 20)];
    float fw=kScreenWidth-100;
    float fh=20;
    if (size.width > fw) {
        CGSize size_h = [lblTitle sizeThatFits:CGSizeMake(fw, MAXFLOAT)];
        fh=size_h.height;
    }else{
        fw=size.width;
    }
    lblTitle.frame=CGRectMake((kScreenWidth-fw)/2.0, Y(lblTitle), fw, fh+6);
    
    //fh+20;
}










- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
