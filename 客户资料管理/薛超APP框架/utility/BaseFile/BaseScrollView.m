//
//  BaseScrollView.m
//  薛超APP框架
//
//  Created by 薛超 on 16/9/13.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import "BaseScrollView.h"
@interface BaseScrollView(){
    NSInteger count;
    NSInteger index;
    UIPageControl *pagecontroller;
}
@end
@implementation BaseScrollView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        index = 0;
        self.frame = frame;
    } return self;
}
#pragma mark 分类平分展示视图
+(BaseScrollView *)sharedSegmentWithFrame:(CGRect)frame Titles:(NSArray*)titles{
    BaseScrollView *segment = [[self alloc]initWithFrame:frame];
    [segment setSegmentWithTitles:titles];
    return segment;
}
-(void)setSegmentWithTitles:(NSArray*)titles{
    self.tag = MyScrollSegmentType;
    self.titles = titles;
    CGFloat starx = 0.0;
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    for (int i = 0; i < titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(starx, 0, W(self)/titles.count, H(self));
        button.titleLabel.font = fontTitle;
        button.tag = 10+i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:blacktextcolor forState:UIControlStateNormal];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        button.backgroundColor = gradcolor;
        [self addSubview:button];
        UIImageView *line1 = [[UIImageView alloc]initWithFrame:CGRectMake(XW(button), Y(button), 1, H(button))];
        line1.backgroundColor = RGBCOLOR(210, 210, 210);
        [self addSubview:line1];
        starx = XW(line1);
        if (i == titles.count - 1) {
            line1.backgroundColor = [UIColor clearColor];
        }
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, H(button) - 1, W(button), 1)];
        line.tag = button.tag  + 20;
        [button addSubview:line];
        if (i == 0) {
            button.backgroundColor = [UIColor whiteColor];
            line.backgroundColor = redcolor;
        }
    }
    self.contentSize = CGSizeMake(starx, 0);
    self.showsHorizontalScrollIndicator = NO;
    self.bounces = NO;
    self.bouncesZoom = NO;
    
}
#pragma mark 标题滑动，自适应文字宽度
+(BaseScrollView *)sharedTitleScrollWithFrame:(CGRect)frame Titles:(NSArray*)titles{
    BaseScrollView *titleScroll = [[self alloc]initWithFrame:frame];
    [titleScroll setTitleScrollWithTitles:titles];
    return titleScroll;
}
-(void)setTitleScrollWithTitles:(NSArray*)titles{
    self.titles = titles;
    self.tag = MyScrollTitleScrollType;
    CGFloat starx = 0.0;
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    for (int i = 0; i < titles.count; i++) {
        CGSize size = [Utility sizeOfStr:titles[i] andFont:fontTitle andMaxSize:CGSizeMake(APPW, H(self))];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(starx, 0, size.width+30, H(self));
        button.titleLabel.font = fontTitle;
        button.tag = 10 + i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:blacktextcolor forState:UIControlStateNormal];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        button.backgroundColor = gradcolor;
        [self addSubview:button];
        UIImageView *line1 = [[UIImageView alloc]initWithFrame:CGRectMake(XW(button), Y(button), 1, H(button))];
        line1.backgroundColor = RGBCOLOR(210, 210, 210);
        [self addSubview:line1];
        starx = XW(line1);
        if (i == self.titles.count - 1) {
            line1.backgroundColor = [UIColor clearColor];
        }
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, H(button) - 1, W(button), 1)];
        line.tag = button.tag  + 20;
        [button addSubview:line];
        if (i == 0) {
            button.backgroundColor = [UIColor whiteColor];
            line.backgroundColor = redcolor;
        }
    }
    self.contentSize = CGSizeMake(starx, 0);
    self.showsHorizontalScrollIndicator = NO;
    self.bounces = NO;
    self.bouncesZoom = NO;
    
}
#pragma mark 标题滑动，有文字和图标的
+(BaseScrollView *)sharedTitleScrollWithFrame:(CGRect)frame Titles:(NSArray*)titles icons:(NSArray*)icons{
    BaseScrollView *titleScroll = [[self alloc]initWithFrame:frame];
    [titleScroll setTitleScrollWithTitles:titles];
    return titleScroll;
}
-(void)setTitleScrollWithTitles:(NSArray*)titles icons:(NSArray*)icons{
    self.titles = titles;//item的长宽比为4/3
    self.icons = icons;
    self.tag = MyScrollTitleIconScrollType;
    CGFloat starx = 0.0;
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    for (int i = 0; i < titles.count; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(starx, 0, H(self)*0.75, H(self))];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:icons[i]] forState:UIControlStateNormal];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 30, 0)];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(30, -10, 0, 0)];
        button.titleLabel.font = fontTitle;
        button.tag = 10 + i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:blacktextcolor forState:UIControlStateNormal];
        button.backgroundColor = gradcolor;
        [self addSubview:button];
        if (i == 0) {
            button.backgroundColor = [UIColor whiteColor];
        }
    }
    self.contentSize = CGSizeMake(starx, 0);
    self.showsHorizontalScrollIndicator = NO;
    self.bounces = NO;
    self.bouncesZoom = NO;
    
}
#pragma mark 内容小项目滑动，一般在主页
+(BaseScrollView *)sharedBaseItemWithFrame:(CGRect)frame icons:(NSArray*)icons titles:(NSArray*)titles size:(CGSize)size round:(BOOL)round{
    BaseScrollView *baseItem = [[self alloc]initWithFrame:frame];
    [baseItem setBaseItemWithIcons:icons titles:titles size:size round:round];
    return baseItem;
}
-(void)setBaseItemWithIcons:(NSArray*)icons titles:(NSArray*)titles size:(CGSize)size round:(BOOL)round{
    self.titles = titles;self.icons = icons;self.size = size;self.round = round;
    self.tag = MyScrollBaseItemType;
    CGFloat starx = 0;
    CGFloat stary = 0;
    for (int i = 0; i < titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(starx, stary, size.width, size.height);
        button.tag = 10 + i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        starx = XW(button);
        if (starx>W(self)-W(button)) {//一行放不下的时候换行
            starx = 0;
            stary = YH(button);
            button.frame = CGRectMake(starx, stary, size.width, size.height);
            starx = XW(button);
        }
        [self addSubview:button];
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, size.height-30,size.height-30)];
        imageview.center = CGPointMake(button.frameWidth/2, button.frameY/2-15);
        imageview.contentMode = UIViewContentModeScaleAspectFill;
        if(round){
            imageview.layer.cornerRadius = imageview.frameWidth/2;
        }
        imageview.clipsToBounds = YES;
        imageview.image =[UIImage imageNamed:icons[i]];
        [button addSubview:imageview];
        
        UILabel *namelable = [[UILabel alloc]initWithFrame:CGRectMake(0, YH(imageview)+8, W(button), 20)];
        namelable.font = fontnomal;
        namelable.textColor = blacktextcolor;
        namelable.text = titles[i];
        namelable.textAlignment = NSTextAlignmentCenter;
        [button addSubview:namelable];
    }
    self.frameHeight = stary+size.height;
    DLog(@"最终的frameY是：%lf",YH(self));
}
#pragma mark 内容小项目滑动，一般在主页并且有分页的
+(BaseScrollView *)sharedBaseItemWithFrame:(CGRect)frame icons:(NSArray*)icons titles:(NSArray*)titles size:(CGSize)size hang:(NSInteger)hang round:(BOOL)round{
    BaseScrollView *baseItem = [[self alloc]initWithFrame:frame];
    [baseItem setBaseItemWithIcons:icons titles:titles size:size hang:hang round:round];
    return baseItem;
}
-(void)setBaseItemWithIcons:(NSArray*)icons titles:(NSArray*)titles size:(CGSize)size hang:(NSInteger)hang round:(BOOL)round{
    self.titles = titles;self.icons = icons;self.size = size;self.round = round;
    self.tag = MyScrollScrollItemType;
    self.showsHorizontalScrollIndicator = NO;
    self.pagingEnabled = YES;
    NSInteger qnum = (NSInteger)hang * W(self)/size.width;
    self.contentSize = CGSizeMake(W(self)*(titles.count/qnum + 1), size.height*hang);
    CGFloat starx = 0;
    CGFloat stary = 0;
    for (int i = 0; i < titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(starx, stary, size.width, size.height);
        button.tag = 10 + i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        starx = XW(button);
        if(i % (int)W(self)/W(button)) {//一行放不下的时候换行
            starx -= W(self);
            stary = YH(button);
            button.frame = CGRectMake(starx, stary, size.width, size.height);
            starx = XW(button);
        }
        if(stary/H(button)>=hang){//行数够了，翻页显示
            starx = W(self) * (i+1)/qnum;
            stary = 0;
            button.frame = CGRectMake(starx, stary, size.width, size.height);
            starx = XW(button);
        }
        [self addSubview:button];
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, size.height-30,size.height-30)];
        imageview.center = CGPointMake(button.frameWidth/2, button.frameY/2-15);
        imageview.contentMode = UIViewContentModeScaleAspectFill;
        if(round){
            imageview.layer.cornerRadius = imageview.frameWidth/2;
        }
        imageview.clipsToBounds = YES;
        imageview.image =[UIImage imageNamed:icons[i]];
        [button addSubview:imageview];
        
        UILabel *namelable = [[UILabel alloc]initWithFrame:CGRectMake(0, YH(imageview)+8, W(button), 20)];
        namelable.font = fontnomal;
        namelable.textColor = blacktextcolor;
        namelable.text = titles[i];
        namelable.textAlignment = NSTextAlignmentCenter;
        [button addSubview:namelable];
    }
    self.frameHeight = size.height * hang;
    DLog(@"最终的frameY是：%lf",YH(self));
}
#pragma mark 内容视图滑动，如新闻类，同时自带标题的滑动
+(BaseScrollView *)sharedContentViewWithFrame:(CGRect)frame titles:(NSArray*)titles controllers:(NSArray*)controllers{
    BaseScrollView *contentView = [[self alloc]initWithFrame:frame];
    [contentView setContentViewWithTitles:titles controllers:controllers];
    return contentView;
}
-(void)setContentViewWithTitles:(NSArray*)titles controllers:(NSArray*)controllers{
    count = self.titles.count;self.titles = titles;self.controllers = controllers;
    self.tag = MyScrollContentViewType;
    self.contentSize = CGSizeMake(controllers.count * APPW, 0);
    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    [self setContentOffset:CGPointMake(0, 0) animated:NO];
    for (int i = 0; i<count; i++) {
        UIViewController *vc =[[NSClassFromString(_controllers[i]) alloc]initWithFrame: CGRectMake(i * APPW, 0, APPW, H(self))];
        [self addSubview:vc.view];
    }
    
}
#pragma mark 横着的滚动视图一般见推荐或广告
+(BaseScrollView *)sharedBannerWithFrame:(CGRect)frame icons:(NSArray*)icons{
    BaseScrollView *banner = [[self alloc]initWithFrame:frame];
    [banner setBannerWithicons:icons];
    return banner;
}
-(void)setBannerWithicons:(NSArray*)icons{            //仅支持网址访问图片//pagecontroll在右下角
    self.tag = MyScrollBanner;
    self.contentOffset = CGPointMake(W(self), 0);
    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    pagecontroller = [[UIPageControl alloc]initWithFrame:CGRectMake(W(self)-110, H(self) - 20,100, 20)];
    pagecontroller.backgroundColor = [UIColor clearColor];
    pagecontroller.currentPageIndicatorTintColor = redcolor;
    pagecontroller.pageIndicatorTintColor = gradcolor;
    pagecontroller.currentPage = index;
    [self addSubview:pagecontroller];
    count = icons.count + 2;
    pagecontroller.numberOfPages = icons.count;
    self.contentSize = CGSizeMake(W(self) * (icons.count + 2), 0);
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, W(self), H(self))];
    [imageview imageWithURL:[icons lastObject] useProgress:NO useActivity:NO];;
    imageview.contentMode = UIViewContentModeScaleAspectFill;
    imageview.clipsToBounds = YES;
    [self addSubview:imageview];
    for (int i = 0; i < icons.count; i++) {
        UIImageView *imgv = [[UIImageView alloc]initWithFrame:CGRectMake(W(self) + i*W(self), 0, W(self), H(self))];
        [imgv imageWithURL:icons[i] useProgress:NO useActivity:NO];
        imgv.contentMode = UIViewContentModeScaleAspectFill;
        imgv.clipsToBounds = YES;
        [self addSubview:imgv];
    }
    UIImageView *lastimage = [[UIImageView alloc]initWithFrame:CGRectMake(W(self)*(icons.count + 1), 0, W(self), H(self))];
    [lastimage imageWithURL:[icons firstObject] useProgress:NO useActivity:NO];
    lastimage.contentMode = UIViewContentModeScaleAspectFill;
    lastimage.clipsToBounds = YES;
    [self addSubview:lastimage];
    _time = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(bannerTimeAction) userInfo:nil repeats:YES];
    [_time setFireDate:[NSDate date]];
    
    _selectBlock(3,nil);
}
#pragma mark 竖着动态播放的视图或广告
+(BaseScrollView *)sharedVerticallyBannerWithFrame:(CGRect)frame icons:(NSArray*)icons{
    BaseScrollView *banner = [[self alloc]initWithFrame:frame];
    [banner setBannerWithicons:icons];
    return banner;
}
-(void)setVerticallyBannerWithicons:(NSArray*)icons{
    self.tag = MyScrollVerticallyBanner;
    self.contentOffset = CGPointMake(0,H(self));
    self.pagingEnabled = YES;
    self.showsVerticalScrollIndicator = NO;
    count = icons.count + 2;
    self.contentSize = CGSizeMake(0,H(self) * (icons.count + 2));
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, W(self), H(self))];
    [imageview imageWithURL:[icons lastObject] useProgress:NO useActivity:NO];;
    imageview.contentMode = UIViewContentModeScaleAspectFill;
    imageview.clipsToBounds = YES;
    [self addSubview:imageview];
    for (int i = 0; i < icons.count; i++) {
        UIImageView *imgv = [[UIImageView alloc]initWithFrame:CGRectMake(0,H(self) + i*H(self), W(self), H(self))];
        [imgv imageWithURL:icons[i] useProgress:NO useActivity:NO];
        imgv.contentMode = UIViewContentModeScaleAspectFill;
        imgv.clipsToBounds = YES;
        [self addSubview:imgv];
    }
    UIImageView *lastimage = [[UIImageView alloc]initWithFrame:CGRectMake(0,H(self)*(icons.count + 1), W(self), H(self))];
    [lastimage imageWithURL:[icons firstObject] useProgress:NO useActivity:NO];
    lastimage.contentMode = UIViewContentModeScaleAspectFill;
    lastimage.clipsToBounds = YES;
    [self addSubview:lastimage];
    _time = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(VerticallbannerTimeAction) userInfo:nil repeats:YES];
    [_time setFireDate:[NSDate date]];
    
}
#pragma mark 欢迎界面
+(BaseScrollView *)sharedWelcomWithFrame:(CGRect)frame icons:(NSArray*)icons{
    BaseScrollView *welcom = [[self alloc]initWithFrame:frame];
    [welcom setWelcomWithIcons:icons];
    return welcom;
}
-(void)setWelcomWithIcons:(NSArray*)icons{
    self.icons = icons;self.tag = MyScrollWelcom;
    self.showsHorizontalScrollIndicator = NO;
    self.pagingEnabled = YES;
    for (int i=0; i<icons.count; i++) {
        UIImageView *imageV= [[UIImageView alloc]initWithFrame:CGRectMake(i * self.frameWidth, self.frameY, self.frameWidth, self.frameHeight)];
        imageV.image = [UIImage imageNamed:icons[i]];
        imageV.contentMode=UIViewContentModeScaleAspectFill;
        imageV.clipsToBounds=YES;
        [self addSubview:imageV];
        if (i==icons.count-1) {
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidden)];
            [imageV setUserInteractionEnabled:YES];
            [imageV addGestureRecognizer:tap];
        }
    }
    [self setContentSize:CGSizeMake(W(self)*icons.count, H(self))];
}
#pragma mark 集合配置
+(BaseScrollView *)sharedWithFrame:(CGRect)frame Titles:(NSArray *)titles icons:(NSArray *)icons round:(BOOL)round size:(CGSize)size type:(MyScrolltype)type controllers:(NSArray*)controllers selectIndex:(selectIndexBlock)block{
    BaseScrollView *ref = [[self alloc]initWithFrame:frame];
    [ref setWithTitles:titles icons:icons round:round size:size type:type controllers:controllers selectIndex:block];
    return ref;
}
-(void)setWithTitles:(NSArray *)titles icons:(NSArray *)icons round:(BOOL)round size:(CGSize)size type:(MyScrolltype)type controllers:(NSArray*)controllers selectIndex:(selectIndexBlock)block{
    self.titles = titles;
    self.icons = icons;
    self.controllers = controllers;
    self.selectBlock = block;
    switch (type) {
        case MyScrollSegmentType:{
            [self setSegmentWithTitles:titles];
        }break;
        case MyScrollTitleScrollType:{
            [self setTitleScrollWithTitles:titles];
        }break;
        case MyScrollTitleIconScrollType:{
            [self setTitleScrollWithTitles:titles icons:icons];
        }break;
        case MyScrollBaseItemType:{
            [self setBaseItemWithIcons:icons titles:titles size:size round:round];
        }break;
        case MyScrollScrollItemType:{
            [self setBaseItemWithIcons:icons titles:titles size:size hang:2 round:round];
        }break;
        case MyScrollContentViewType:{
            [self setContentViewWithTitles:titles controllers:controllers];
        }break;
        case MyScrollBanner:{
            [self setBannerWithicons:icons];
        }break;
        case MyScrollVerticallyBanner:{
            [self setVerticallyBannerWithicons:icons];
        }break;
        case MyScrollWelcom:{
            [self setWelcomWithIcons:icons];
        }break;
        default:{
            
        }break;
    }
}
#pragma mark Actions
-(void)selectThePage:(NSInteger)page{
    UIButton *button = (UIButton *)[self viewWithTag:page+10];
    [self buttonAction:button];
}
-(void)buttonAction:(UIButton *)btn{
    for (int i = 0; i < self.titles.count; i++) {
        UIButton *button = (UIButton *)[self viewWithTag:10 + i];
        button.backgroundColor = gradcolor;
        UIView *line = (UIView *)[self viewWithTag:button.tag + 20];
        line.backgroundColor = [UIColor clearColor];
    }
    btn.backgroundColor = [UIColor whiteColor];
    UIView *line = (UIView *)[self viewWithTag:btn.tag + 20];
    line.backgroundColor = redcolor;
    //////////////
    //    btn.transform = CGAffineTransformIdentity;
    //    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];    //文字变红
    //    btn.transform = CGAffineTransformMakeScale(1.5, 1.5);    //放大的效果,放大1.5倍
    //数据回传=================================
    self.selectBlock(btn.tag-10,nil);
    CGFloat centx =btn.frameX-APPW/2+btn.frameWidth/2;
    if(self.contentSize.width< btn.frameX+(APPW+btn.frameWidth)/2){
        centx = self.contentSize.width-APPW+29;
    }else if(centx<0){
        centx = 0;
    }
    [self setContentOffset:CGPointMake(centx, 0) animated:YES];
}
#pragma mark Others
-(void)bannerTimeAction{
    pagecontroller.currentPage = index++;
    [UIView animateWithDuration:0.3 animations:^{
        self.contentOffset = CGPointMake(W(self)*index, 0);
    } completion:^(BOOL finished) {
        if (self.contentOffset.x > W(self)*(count - 2)) {
            self.contentOffset = CGPointMake(W(self), 0);
            index = 0;
        }
        if (self.contentOffset.x < W(self)) {
            self.contentOffset = CGPointMake(W(self)*(count - 2), 0);
            index = count - 2;
        }
    }];
}
-(void)VerticallbannerTimeAction{
    [UIView animateWithDuration:0.3 animations:^{
        self.contentOffset = CGPointMake(0,H(self)*index);
    } completion:^(BOOL finished) {
        if (self.contentOffset.y > H(self)*(count - 2)) {
            self.contentOffset = CGPointMake(0,H(self));
            index = 0;
        }
        if (self.contentOffset.y < H(self)) {
            self.contentOffset = CGPointMake(0,H(self)*(count - 2));
            index = count - 2;
        }
    }];
}

#pragma mark - scrollviewdelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_time setFireDate:[NSDate dateWithTimeIntervalSinceNow:3]];
}

/// 实现字体颜色大小的渐变
-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    switch (self.tag) {
        case MyScrollSegmentType:{
            
        }break;
        case MyScrollTitleScrollType:{
            
        }break;
        case MyScrollBaseItemType:{
            
        }break;
        case MyScrollContentViewType:{
            CGFloat offset = scrollView.contentOffset.x;
            //定义一个两个变量控制左右按钮的渐变
            NSInteger left = offset/APPW;
            NSInteger right = 1 + left;
            UIButton * leftButton = (UIButton*)[self viewWithTag:left+10];
            UIButton * rightButton = nil;
            if (right < self.titles.count) {
                rightButton = (UIButton*)[self viewWithTag:10+right];
            }
            //切换左右按钮
            CGFloat scaleR = offset/APPW - left;
            CGFloat scaleL = 1 - scaleR;
            //左右按钮的缩放比例
            CGFloat tranScale = 1.2 - 1 ;
            //宽和高的缩放(渐变)
            leftButton.transform = CGAffineTransformMakeScale(scaleL * tranScale + 1, scaleL * tranScale + 1);
            rightButton.transform = CGAffineTransformMakeScale(scaleR * tranScale + 1, scaleR * tranScale + 1);
            //颜色的渐变
            //    UIColor * rightColor = [UIColor colorWithRed:scaleR green:250 blue:250 alpha:1];
            UIColor * leftColor = [UIColor colorWithRed:230 green:230 blue:230 alpha:1];
            //重新设置颜色
            [leftButton setTitleColor:leftColor forState:UIControlStateNormal];
            //    [rightButton setTitleColor:rightColor forState:UIControlStateNormal];
        }break;
        case MyScrollBanner:{
            
        }break;
        case MyScrollVerticallyBanner:{
            
        }break;
        case MyScrollWelcom:{
            
        }break;
        default:{
            
        }break;
    }
    
}
/// 滑动结束的时候
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    switch (self.tag) {
        case MyScrollSegmentType:{
            
        }break;
        case MyScrollTitleScrollType:{
            
        }break;
        case MyScrollBaseItemType:{
            
        }break;
        case MyScrollContentViewType:{
            NSUInteger i = self.contentOffset.x / APPW;
            //            [self setTitleBtn:self.buttons[i]];
            //            [self setOnchildViewController:i];
        }break;
        case MyScrollBanner:{
            if (self.contentOffset.x > W(self)*(count - 2)) {
                self.contentOffset = CGPointMake(W(self), 0);
            }
            if (self.contentOffset.x < W(self)) {
                self.contentOffset = CGPointMake(W(self)*(count - 2), 0);
            }
            index = self.contentOffset.x/W(self);
            if (index > count - 2) {
                index = 0;
            }
            if (index < 0) {
                index = count-2;
            }
            pagecontroller.currentPage = index;
        }break;
        case MyScrollVerticallyBanner:{
            if (self.contentOffset.y > H(self)*(count - 2)) {
                self.contentOffset = CGPointMake(0,H(self));
            }
            if (self.contentOffset.y < H(self)) {
                self.contentOffset = CGPointMake(0,H(self)*(count - 2));
            }
            index = self.contentOffset.y/H(self);
            if (index > count - 2) {
                index = 0;
            }
            if (index < 0) {
                index = count-2;
            }
            pagecontroller.currentPage = index;
        }break;
        case MyScrollWelcom:{
            
        }break;
        default:{
            
        }break;
    }
    
}
#pragma mark welcome的方法
- (void)show{
    [[[UIApplication sharedApplication].windows objectAtIndex:0] addSubview:self];
    self.hidden = NO;
    self.alpha = 1.0f;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 1.0f;
    } completion:^(BOOL finished) {
    }];
}

- (void)hidden{
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        
    }];
}

@end
















