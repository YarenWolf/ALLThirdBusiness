//
//  EmojiShowVIew.m
//  YunDong55like
//
//  Created by junseek on 15-7-1.
//  Copyright (c) 2015年 五五来客 lj. All rights reserved.
//

#import "EmojiShowVIew.h"
#import "EmojiFaceView.h"


#define  keyboardHeight 216
#define  facialViewWidth kScreenWidth-20
#define  facialViewHeight 160
#define  DD_EMOTION_MENU_HEIGHT  46

@interface EmojiShowVIew ()<facialViewDelegate,UIScrollViewDelegate>{
    UIScrollView *scrollViewEmoji;
    UIPageControl *pageControlEmoji;
}


@end

@implementation EmojiShowVIew
-(instancetype)init{
    self=[super init];
    if (self) {
        [self loadDataView];
    }
    return self;
}

-(void)loadDataView{
    self.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, keyboardHeight);
    if (scrollViewEmoji==nil) {
        scrollViewEmoji=[[UIScrollView alloc] initWithFrame:self.frame];
        [scrollViewEmoji setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]];
        //100 个表情 5页显示
        for (int i=0; i<5; i++) {
            EmojiFaceView *fview=[[EmojiFaceView alloc] initWithFrame:CGRectMake(10 + kScreenWidth*i, 10, facialViewWidth, facialViewHeight)];
            [fview setBackgroundColor:[UIColor clearColor]];
            [fview loadFacialView:i size:CGSizeMake(42.5/320.0*kScreenWidth, 40)];
            fview.delegate=self;
            [scrollViewEmoji addSubview:fview];
        }
    }
    [scrollViewEmoji setShowsVerticalScrollIndicator:NO];
    [scrollViewEmoji setShowsHorizontalScrollIndicator:NO];
    scrollViewEmoji.contentSize=CGSizeMake(kScreenWidth*5, keyboardHeight);
    scrollViewEmoji.pagingEnabled=YES;
    scrollViewEmoji.delegate=self;
    [self addSubview:scrollViewEmoji];
    
    pageControlEmoji=[[UIPageControl alloc]initWithFrame:CGRectMake((kScreenWidth/2+10)/2, keyboardHeight-30 - DD_EMOTION_MENU_HEIGHT, (kScreenWidth - 20)/2, 30)];
    [pageControlEmoji setCurrentPage:0];
    pageControlEmoji.pageIndicatorTintColor=[UIColor whiteColor];
    pageControlEmoji.currentPageIndicatorTintColor=rgbpublicColor;
    pageControlEmoji.numberOfPages = 5;
    [pageControlEmoji setBackgroundColor:[UIColor clearColor]];
    [pageControlEmoji addTarget:self action:@selector(changePage:)forControlEvents:UIControlEventValueChanged];
    [self addSubview:pageControlEmoji];
    
    UIView* menuView = [[UIView alloc] initWithFrame:CGRectMake(0, keyboardHeight - DD_EMOTION_MENU_HEIGHT, kScreenWidth, DD_EMOTION_MENU_HEIGHT)];
    [menuView setBackgroundColor:[UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0]];
    
    UIButton* sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton addTarget:self action:@selector(clickTheSendButton:) forControlEvents:UIControlEventTouchUpInside];
    [sendButton setFrame:CGRectMake(kScreenWidth-70, 0, 70, H(menuView))];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendButton setBackgroundColor:RGBACOLOR(45, 91, 255, 1)];
    [menuView addSubview:sendButton];
    [self addSubview:menuView];
    
    
    
}


- (void)scrollViewDidScroll:(UIScrollView *)sender {
    int page = scrollViewEmoji.contentOffset.x / kScreenWidth;
    pageControlEmoji.currentPage = page;
}
- (void)changePage:(id)sender {
    NSInteger page = pageControlEmoji.currentPage;
    [scrollViewEmoji setContentOffset:CGPointMake(kScreenWidth * page, 0)];
}

#pragma mark - privateAPI
- (void)clickTheSendButton:(id)sender
{
    if (self.delegate)
    {
        [self.delegate emotionViewClickSendButton];
    }
}

#pragma mark facialViewDelegate
-(void)selectedFacialView:(NSString*)str
{
    if ([str isEqualToString:@"delete"]) {
        [self.delegate deleteEmojiFace];
        return;
    }
    [self.delegate insertEmojiFace:str];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
