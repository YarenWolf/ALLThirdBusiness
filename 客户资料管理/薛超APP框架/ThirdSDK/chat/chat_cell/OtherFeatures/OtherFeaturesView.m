//
//  OtherFeaturesView.m
//  YunDong55like
//
//  Created by junseek on 15-7-2.
//  Copyright (c) 2015年 五五来客 lj. All rights reserved.
//

#import "OtherFeaturesView.h"

#define  keyboardHeight 216


@interface OtherFeaturesView ()<UIScrollViewDelegate>{
    //
    UIScrollView *scrollViewEmoji;
    UIPageControl *pageControlEmoji;

}

@property(strong,nonatomic)UITextField *selecttextField;

@end
@implementation OtherFeaturesView

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
        scrollViewEmoji=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, keyboardHeight)];
        [scrollViewEmoji setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]];
        
        UIView *viewTemp=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, keyboardHeight)];
        viewTemp.backgroundColor=[UIColor clearColor];
        [scrollViewEmoji addSubview:viewTemp];
        
        float ftw=(kScreenWidth-10)/4.0;
        
        [viewTemp addSubview:[self loadButtonViewTitle:@"拍照" btnImage:@"paizhao2" btnFrame:CGRectMake(5, 0, ftw, 93) clicked:@selector(btnCameraClicked)]];
        [viewTemp addSubview:[self loadButtonViewTitle:@"相册" btnImage:@"sctp" btnFrame:CGRectMake(5 + ftw, 0, ftw, 93) clicked:@selector(btnPhotoClicked)]];
        
    }
    [scrollViewEmoji setShowsVerticalScrollIndicator:NO];
    [scrollViewEmoji setShowsHorizontalScrollIndicator:NO];
    scrollViewEmoji.contentSize=CGSizeMake(kScreenWidth*1, keyboardHeight);
    scrollViewEmoji.pagingEnabled=YES;
    scrollViewEmoji.delegate=self;
    [self addSubview:scrollViewEmoji];
    
    pageControlEmoji=[[UIPageControl alloc]initWithFrame:CGRectMake((kScreenWidth/2+10)/2, keyboardHeight-30 , (kScreenWidth - 20)/2, 30)];
    [pageControlEmoji setCurrentPage:0];
    pageControlEmoji.pageIndicatorTintColor=[UIColor whiteColor];
    pageControlEmoji.currentPageIndicatorTintColor=rgbpublicColor;
    pageControlEmoji.numberOfPages = 1;
    [pageControlEmoji setBackgroundColor:[UIColor clearColor]];
    [pageControlEmoji addTarget:self action:@selector(changePage:)forControlEvents:UIControlEventValueChanged];
    [self addSubview:pageControlEmoji];
    
    
    
    
    
}
-(void)btnCameraClicked{
    //相机
    if ([self.delegate respondsToSelector:@selector(OtherFeaturesViewCamera:)]) {
        [self.delegate OtherFeaturesViewCamera:self];
    }
    
}
-(void)btnPhotoClicked{
    //相册
    if ([self.delegate respondsToSelector:@selector(OtherFeaturesViewSelectPhoto:)]) {
        [self.delegate OtherFeaturesViewSelectPhoto:self];
    }
}


-(UIView *)loadButtonViewTitle:(NSString *)title btnImage:(NSString *)imageName btnFrame:(CGRect )rect clicked:(SEL)selector{
    UIView *viewT=[[UIView alloc]initWithFrame:rect];
    UIButton *btnT=[RHMethods buttonWithFrame:CGRectMake(0, 5, W(viewT), H(viewT)-20) title:@"" image:imageName bgimage:@""];
    [btnT addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [viewT addSubview:btnT];
    [viewT addSubview:[RHMethods labelWithFrame:CGRectMake(0, H(viewT)-15, W(viewT), 15) font:Font(12) color:rgbTxtDeepGray text:title textAlignment:NSTextAlignmentCenter]];
    
    return viewT;
}


- (void)scrollViewDidScroll:(UIScrollView *)sender {
    int page = scrollViewEmoji.contentOffset.x / kScreenWidth;
    pageControlEmoji.currentPage = page;
}
- (void)changePage:(id)sender {
    NSInteger page = pageControlEmoji.currentPage;
    [scrollViewEmoji setContentOffset:CGPointMake(kScreenWidth * page, 0)];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
