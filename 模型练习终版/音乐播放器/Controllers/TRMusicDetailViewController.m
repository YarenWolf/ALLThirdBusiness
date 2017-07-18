//
//  TRMusicDetailViewController.m
//  音乐播放器
//
//  Created by ISD1510 on 16/1/4.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "TRMusicDetailViewController.h"
#import "UIView+Extension.h"
#import <AVFoundation/AVFoundation.h>
#import "TRMusic.h"
#import "TRAudioTool.h"
#import "TRMusicTool.h"
#import "UIImage+Circle.h"
@interface TRMusicDetailViewController ()<AVAudioPlayerDelegate>
@property(nonatomic,strong)AVAudioSession *session;//用于后台播放的对象
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIImageView *albumImageView;
@property (weak, nonatomic) IBOutlet UIView *currentProgressView;
@property (weak, nonatomic) IBOutlet UIButton *progressButton;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property(nonatomic,strong)AVAudioPlayer *player;
@property(nonatomic,strong)NSTimer *timer;
@end
@implementation TRMusicDetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self.progressButton addGestureRecognizer:pan];
   }
-(void)showDetailView{
   //1.拿到window
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    //2.设置frame添加到window上
    self.view.frame=window.bounds;
    [window addSubview:self.view];
    //3。view的y值动画
    self.view.x=-window.bounds.size.width;
    [UIView animateWithDuration:1 animations:^{
        self.view.x=0;
    } completion:^(BOOL finished) {
        //播放音频文件
        [self playAudioFile];
    }];
}
//播放手机系统声音的方法，需要真机。
-(void)playSystemAudio{
    //前提：播放系统的声音，震动，所有的声音都被系统表示成100--2000之间的数字了。需要在真机中测试
    AudioServicesPlaySystemSound(1600);
    //震动：
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    //播放小于30秒的音频
    NSString *audioPath=[[NSBundle mainBundle]pathForResource:@"audio" ofType:@"mp3"];
    SystemSoundID systemID;
    NSURL *audioURL=[NSURL fileURLWithPath:audioPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(audioURL), &systemID);
    //播放
    AudioServicesPlaySystemSound(systemID);
}
- (IBAction)clickBackButton:(id)sender {
    [UIView animateWithDuration:1 animations:^{
        self.view.y=self.view.bounds.size.height;
    } completion:^(BOOL finished) {
    }];
}
- (IBAction)clickPlayButton:(UIButton*)sender {
    //设置正在播放的音乐
    sender.selected=!sender.selected;
    //开始播放
    if(sender.selected){[TRAudioTool pauseAudioWithFileName:[TRMusicTool currentPlayingMusic].filename];
    }else[self playAudioFile];
}
- (IBAction)clickPreviousButton:(id)sender {
    [TRAudioTool stopAudioWithFileName:[TRMusicTool currentPlayingMusic].filename];
    [TRMusicTool setCurrentPlayingMusic:[TRMusicTool previousMusic]];
    [self playAudioFile];
}
- (IBAction)clickNextButton:(id)sender {
    [TRAudioTool stopAudioWithFileName:[TRMusicTool currentPlayingMusic].filename];
    [TRMusicTool setCurrentPlayingMusic:[TRMusicTool nextMusic]];
    [self playAudioFile];
}
-(void)playAudioFile{
    //1.session（对象+设置分类类型+激活）//设置后台播放的方法======================
    self.session=[AVAudioSession sharedInstance];//单例对象
    NSError *error=nil;
    [self.session setCategory:AVAudioSessionCategoryPlayback error:&error];
    [self.session setActive:YES error:&error];
    //需求：知道需要播放的音乐，怎么播放，设置delegate（监听是否已经播放完毕-》直接下一首。=================
    [self stopTimer];
    self.button.selected=NO;
    TRMusic *music=[TRMusicTool currentPlayingMusic];
    self.player=[TRAudioTool playAudioWithFileName:music.filename];
    self.player.delegate=self;
    //设置专辑封面
    self.albumImageView.hidden=NO;
    //7.设置封面视图为圆形
    UIImage *image = [UIImage imageNamed:music.icon];
    image = [UIImage scaleToSize:image size:self.albumImageView.frame.size];
    self.albumImageView.image = [UIImage circleImageWithImage:image borderWidth:10 borderColor:[UIColor lightGrayColor]];
    //8.专辑图片旋转
    [self.albumImageView rotate:6];
    self.durationLabel.text=[self changeTimeWithInterval:self.player.duration];
    // [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeTimer) userInfo:nil repeats:YES];
    NSLog(@"%@",music.filename);
     [self startTimer];
}

-(void)pan:(UIPanGestureRecognizer*)sender{
    CGPoint point=[sender translationInView:sender.view];
    self.progressButton.x+=point.x;
    self.currentProgressView.width=self.progressButton.center.x;
    if(sender.state==UIGestureRecognizerStateBegan){[self stopTimer];};
    if(sender.state==UIGestureRecognizerStateEnded){
        self.player.currentTime=self.progressButton.x/(self.view.width-90)*self.player.duration;
        [self startTimer];
        if(self.player.currentTime>=self.player.duration){
            [self clickNextButton:nil];
        }
    }
    [sender setTranslation:CGPointZero inView:sender.view];
}
//转时长显示格式
-(NSString *)changeTimeWithInterval:(NSTimeInterval)interval{
    int minute=interval/60;
    int second=(int)interval%60;
    return [NSString stringWithFormat:@"%02d:%02d",minute,second];
}

-(void)startTimer{
    //1.创建NSTimer定时器
    self.timer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
    //2.加入当前事件循环。
    [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}
-(void)stopTimer{
    [self.timer invalidate];
    self.timer=nil;
}
-(void)updateProgress{
    //计算当前音乐的播放进度
    double playingProgress=self.player.currentTime/self.player.duration;
    //计算能够移动的位移
    double offsetX=self.view.width-self.progressButton.width-self.durationLabel.width;
    //设置绿色按钮的位置和内容和绿色视图的位置
    self.progressButton.x=playingProgress*offsetX;
    [self.progressButton setTitle:[self changeTimeWithInterval:self.player.currentTime] forState:UIControlStateNormal];
    self.currentProgressView.width=self.progressButton.center.x;
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self clickNextButton:nil];
}

@end
