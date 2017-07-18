//
//  WXSpeechSynthesizerViewControllerForLongText.m
//  WXVoiceSDKDemo
//
//  Created by 宫亚东 on 14-1-2.
//  Copyright (c) 2014年 Tencent Research. All rights reserved.
//

#import "WXSpeechSynthesizerViewControllerForLongText.h"
#import "WXSpeechSynthesizerWithPlayerForLongText.h"
#import "WXSpeechSynthesizerView.h"
#import "WXErrorMsg.h"
@interface WXSpeechSynthesizerViewControllerForLongText ()<WXSpeechSynthesizerWithPlayerForLongTextDelegate,WXSpeechSynthesizerViewDelegate>

@end


@implementation WXSpeechSynthesizerViewControllerForLongText
{
    WXSpeechSynthesizerView *_ssView;
    WXSpeechSynthesizerWithPlayerForLongText *_longTextPlayer;
    NSArray *_strArray;
    NSInteger _index;
    NSInteger _playlength;
}
- (void)dealloc
{
    [_longTextPlayer release];
    [_ssView release];
    [_strArray release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.size.height -= 64;
    _ssView = [[WXSpeechSynthesizerView alloc] initWithFrame:frame];
    _ssView.delegate = self;
    [_ssView setText:@"解放！将那铭刻心底的梦想\n就连未来我也不惜抛在身后\n无视毫无意义的所谓极限\n任凭手中的力量肆意绽放\n为我照亮遥远前路的理想\n这条曾经的路　若是除了留作回顾\n此外再无意义　宁愿亲手将其湮灭\n身处于堕入黑暗的都市\n人们究竟能坚持到何时\n面对着愈演愈烈的伤痛\n我也一定能守护你到底\nLooking!The blitz loop this planet to search way\nOnly my RAILGUN can shoot it.唯我超电磁炮凝聚雷霆一击\n周身光速环绕的凛冽电光\n似在诉说无比真切的预感\n握紧！既然渴望就决不放手\n我能绽放出属于自己的光芒\n始终坚信曾经许下的誓言\n就连在我眼中闪烁的泪光\n也会化作永不妥协的坚强\n每次无路可走　都难免有几分难过\n我又怎能声称　不曾因其心怀迷惑\n天空中飞速旋转的硬币\n轨迹承载着彼此的命运\n那一天断然击出的答案\n如今依然激荡在我胸中\nSparkling!The shiny lights awake true desire\nOnly my RAILGUN can shoot it.唯我超电磁炮凝聚绚烂一击\n一路贯穿所有踌躇与迷惘\n无惧伤痛奔向目标的方向\n瞄准！凛然不屈的清澈目光\n精准无误地撕裂黑暗的笼罩\n让迷茫在电光中灰飞烟灭\n只要这颗心仍在激烈脉动\n绝对不容任何人将我阻挡\n无数转瞬即逝的心愿飘落\n渐渐堆积在我的双手之中\n当撕裂深邃夜幕的那一刻\n却见到了沉重悲伤的记忆\n在褪色的现实中几欲动摇\n却不甘心在绝望面前认输\n只要此刻我依然坚持自我\n我就能挺起胸膛傲然前行\nLooking!The blitz loop this planet to search way\nOnly my RAILGUN can shoot i周身光速环绕的凛冽电光\n似在诉说无比真切的预感\n解放！将那铭刻心底的梦想\n就连未来我也不惜抛在身后\n无视毫无意义的所谓极限\n任凭手中的力量肆意绽放\n为我照亮遥远前路的理想。\n\n宛如那残酷的天使\n少年啊，请成为神话吧\n在此刻、苍凉的风\n轻轻敲击着你的心\n但你只凝视我\n对我微笑，轻轻摇晃\n手指轻轻触及的是\n我一直不断沉醉于追寻着的目标\n你连那命运都还不知道的\n稚嫩的眼眸\n不过总有一天会发觉\n就在你背后\n有那为了前往遥远的未来而生的\n羽翼存在着\n残酷天使的行动纲领\n你就将从窗边飞去\n飞迸出炙热的悲怆\n如果这计划背叛你的记忆\n拥抱这宇宙的光辉\n少年啊，成为神话吧\n一直沉睡在，\n自我的爱的摇篮中\n只有你一人被梦之使者唤醒的\n早晨即将来临\n在你纤细的颈项上\n正映着高悬的月光\n而我想停止全世界的时间\n将你封存于沉眠之中\n如果说我们两人的相逢\n是有意义的话\n那么我就是那本为了让你知道\n“自由”的圣经\n残酷的天使计划\n悲伤自此开始\n请你紧抱你生命的形体\n就在这梦境觉醒之时！\n放出无人可比的耀眼光芒\n少年啊！变成神话吧\n人是因为纠缠着的爱\n才创造出了历史\n依然不能成为女神的我\n就这样生存着\n残酷天使的行动纲领\n你就将从窗边飞去\n飞迸出炙热的悲怆\n如果这计划背叛你的记忆\n拥抱这宇宙的光辉\n少年啊，成为神话吧。\n\n樱花，樱花，想见你，不要嘛，现在就想要见你。\n没关系，不要再哭了，我是风，正包围在你的身边。\n樱花，樱花，想见你，不要嘛，现在就想要见你。\n谢谢，一直都最喜欢你，我是星星，会永远看着你守护着你。\n和你认识真好，真的真的是很好很好。\n已经不能在这里了，已经不走不行了，真的对不起。\n我已经必须一个人要到远方去（不走不行）。\n到哪里？不要问好吗？ 为什么？不要问好吗？真的对不起。\n我已经不能再在你的身边了。\n总是在散步道，樱花树并排的地方慢慢远去。\n经常游戏的河面上的天空的光的方向去。\n虽然已经不能见面了，虽然孤独，但是不要紧。\n出生真好，真的很好，和你遇见真的很好。\n樱花，樱花，想见你，不要嘛，现在就想要见你。\n没关系，不要再哭了，我是风，正包围在你的身边。\n樱花，樱花，想见你，不要嘛，现在就想要见你。\n谢谢，一直都最喜欢你，我是星星，会永远看着你守护着你。\n和你认识真好，真的真的是很好很好。\n等你归来的午后，你的足音，不形于色的事情（不能告诉别人只有自己知道的事情）。\n对我来说的，（知道了）是最开心的事情。\n你对我说的话，一天的事情，很多的事情。\n对我来说的，（知道了）是最悲伤的事情。\n那是你的笑脸，你的泪水，都是你的温柔。\n叫我名字的声音，抱紧我的手腕，都是你的温暖。\n虽然已经不能再接触，也不会忘掉，（这是）幸福的事情。\n出生真好，真的很好，能遇见你真好。\n樱花，樱花，想见你，不要嘛，现在就想要见你。\n没关系的，在这里，我是春天，抱着你的天空。\n樱花，樱花，想见你，不要嘛，现在就想要见你。\n谢谢，一直都最喜欢，我是鸟，永远为你唱歌。\n在樱花满空飞舞的他方，如果闭上眼睛就在心里。\n樱花，樱花，想见你，不要嘛，现在就想要见你。\n可以啊，微笑的看哪，我是花，你指尖上的花。\n樱花，樱花，想见你，不要嘛，现在就想要见你。\n谢谢，一直最喜欢，我是爱，在你的胸（心）上。\n樱花，樱花，想见你，不要嘛，现在就想要见你。\n没关系，不要再哭了，我是风，正包围在你的身边。\n樱花，樱花，想见你，不要嘛，现在就想要见你。\n谢谢，一直都最喜欢你，我是星星，会永远看着你守护着你。\n和你认识真好，真的真的是很好很好。\n真的真的是很好很好。"];
    [_ssView textView].font = [UIFont systemFontOfSize:30];
    [self.view addSubview:_ssView];
    
    _longTextPlayer = [[WXSpeechSynthesizerWithPlayerForLongText alloc] init];
    _longTextPlayer.delegate = self;


}
#pragma mark =========ViewButton===========

- (BOOL)startWithText:(NSString *)text{
    [_ssView addTestStr:[NSString stringWithFormat:@"size=%d",text.length]];
    [_longTextPlayer startWithText:text];
    return YES;
}
- (void)pause{
    [_longTextPlayer pause];
}
- (void)play{
    [_longTextPlayer goon];
}
- (void)reSet{
    [_longTextPlayer stop];
    [_ssView reSetView];
}
#pragma mark =========SDK+PlayerDelegate===========
- (void)willPlayTextLocation:(NSInteger)location length:(NSInteger)length{
    [_ssView selectRange:NSMakeRange(location, length)];
}

- (void)didEnd{
    [_ssView reSetView];
}

- (void)errorCode:(NSInteger)errorCode{
    [_ssView reSetView];
    [WXErrorMsg showErrorMsg:[NSString stringWithFormat:@"错误码：%d",errorCode] onView:self.view];
}

#pragma mark ====================

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
