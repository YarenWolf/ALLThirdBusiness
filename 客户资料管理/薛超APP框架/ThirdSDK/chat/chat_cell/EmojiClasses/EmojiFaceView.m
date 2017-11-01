//
//  DDEmojiFaceView.m
//  YunDong55like
//
//  Created by junseek on 15-5-25.
//  Copyright (c) 2015年 五五来客 lj. All rights reserved.

#import "EmojiFaceView.h"
#import "EmojiModule.h"
#define DD_MAC_EMOTIONS_COUNT_PERPAGE                           20
#define DD_EMOTIONS_PERROW                                      7
#define DD_EMPTIONS_ROWS                                        3
#define DD_EMOJi_COUNT                                          100  //表情数目

@interface EmojiFaceView (){
    
}


@end

@implementation EmojiFaceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
       
    }
    return self;
}
-(void)loadFacialView:(int)page size:(CGSize)size
{
	//row number  100个表情
    
	for (int i=0; i<DD_EMPTIONS_ROWS; i++) {
		//column numer
		for (int y=0; y<DD_EMOTIONS_PERROW; y++) {
			UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundColor:[UIColor clearColor]];
            [button setFrame:CGRectMake(y*size.width, i*size.height, size.width, size.height)];
            if ((i * DD_EMOTIONS_PERROW + y + page * DD_MAC_EMOTIONS_COUNT_PERPAGE) > DD_EMOJi_COUNT) {
                return;
            }else{
                if (i * DD_EMOTIONS_PERROW + y == DD_MAC_EMOTIONS_COUNT_PERPAGE || (i * DD_EMOTIONS_PERROW + y + page * DD_MAC_EMOTIONS_COUNT_PERPAGE) == DD_EMOJi_COUNT)
                {
                    [button setImage:[UIImage imageNamed:@"dd_emoji_delete"] forState:UIControlStateNormal];
                    button.tag=10000;
                    [button addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
                    [self addSubview:button];
                }
                else
                {
                    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Expression_%d",i*DD_EMOTIONS_PERROW+y+(page*DD_MAC_EMOTIONS_COUNT_PERPAGE) + 1]] forState:UIControlStateNormal];
                    button.tag=i*DD_EMOTIONS_PERROW+y+(page*DD_MAC_EMOTIONS_COUNT_PERPAGE);
                    [button addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
                    [self addSubview:button];
                }
            }
		}
	}
}
-(void)selected:(UIButton*)bt
{
    
    if (bt.tag==10000) {
        [self.delegate selectedFacialView:@"delete"];
    }else{
        
        NSString *strkey=@"";
        NSArray *arrayT=[[[EmojiModule Share] EmojiDic] allKeys];
        for (int i=0; i<[arrayT count]; i++) {
            if ([[[[EmojiModule Share] EmojiDic] valueForJSONStrKey:[arrayT objectAtIndex:i]] isEqualToString:[NSString stringWithFormat:@"Expression_%d",bt.tag+ 1]]) {
                strkey=[arrayT objectAtIndex:i];
                break;
            }
        }
        [self.delegate selectedFacialView:strkey];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
