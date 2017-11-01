//
//  MessageContentViewController.m
//  YunDong55like
//
//  Created by junseek on 15-6-17.
//  Copyright (c) 2015年 五五来客 lj. All rights reserved.
//

#import "MessageContentViewController.h"
#import "EGORefreshChatTableHeaderView.h"
#import "NetEngine.h"
#import "MessageContentTxtTableViewCell.h"
#import "MLEmojiLabel.h"
#import "JSMessageInputView.h"
#import "RecordingView.h"
#import "KKNavigationController.h"
#import "TouchDownGestureRecognizer.h"
#import "RecoderAndPlayer.h"
#import "MessageContentVoiceBubbleTableViewCell.h"
#import "EmojiShowVIew.h"
#import "EmojiModule.h"
#import "OtherFeaturesView.h"
#import <ZYQAssetPickerController.h>
#import "MessageContentImageTableViewCell.h"
#import "SystemMessageTableViewCell.h"
#import "GroupMembersViewController.h"
#import "XHImageUrlViewer.h"


#import "NSObject+JSONCategories.h"



#define DDCOMPONENT_BOTTOM          CGRectMake(0, kScreenHeight -(kVersion7?0:20), kScreenWidth, 216)//初始表情、其他位置
#define DDINPUT_TOP_FRAME           CGRectMake(0, (kScreenHeight - (kVersion7?0:20)) -  H(messageInput)  - 216, kScreenWidth,  H(messageInput))//表情出现后输入块位置
#define DDEMOTION_FRAME             CGRectMake(0, (kScreenHeight - (kVersion7?0:20)) -216, kScreenWidth, 216)//表情、其他展示位置
#define DDINPUT_BOTTOM_FRAME        CGRectMake(0, (kScreenHeight - (kVersion7?0:20)) - H(messageInput),kScreenWidth,H(messageInput))//初始输入块位置

typedef NS_ENUM(NSUInteger, DDBottomShowComponent)
{
    DDInputViewUp                       = 1,
    DDShowKeyboard                      = 1 << 1,
    DDShowEmotion                       = 1 << 2,
    DDShowUtility                       = 1 << 3
};

typedef NS_ENUM(NSUInteger, DDBottomHiddComponent)
{
    DDInputViewDown                     = 14,
    DDHideKeyboard                      = 13,
    DDHideEmotion                       = 11,
    DDHideUtility                       = 7
};

typedef NS_ENUM(NSUInteger, DDInputType)
{
    DDVoiceInput,
    DDTextInput
};


@interface MessageContentViewController ()<EGORefreshChatTableHeaderViewDelegate,JSMessageInputViewDelegate,RecoderAndPlayerDelegate,EmojiShowVIewDelegate,OtherFeaturesViewDelegate,ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,MessageContentVoiceBubbleTableViewCellDelegate,MessageContentImageTableViewCellDelegate,MessageContentTxtTableViewCellDelegate>{
    UITableView *tabelMessage;
    EGORefreshChatTableHeaderView *egoRefresh;
    
    bool bbb;//刷新状态
    NSInteger numIndex;//当前页数
    NSInteger tempDataNum;//当前页条数
    NSMutableArray *tbDataArray;
    NSMutableArray *tableTempArray;
    BOOL boolLoadMore;
    MLEmojiLabel *emojiLabel;

 
    JSMessageInputView *messageInput;
     RecordingView* _recordingView;
    float _inputViewY;
    
    TouchDownGestureRecognizer* _touchDownGestureRecognizer;
    
    NSString *_currentInputContent;
    
    NSIndexPath *tempPlayIndex;//正在播放的语音下标
    RecoderAndPlayer *rcoder;//语音
     bool abool;
    
    //表情展示view
    EmojiShowVIew *viewEmojiShow;
    DDBottomShowComponent _bottomShowComponent;
    //其他
    OtherFeaturesView *otherFeaturesV;
    
    UIImagePickerController *ipc;
    //图片浏览
    NSMutableDictionary *dictAllImage;
    
    
    XHImageUrlViewer *imageReview;
    NSString *roomid;
    NSString *canchate;
    
}
@property (nonatomic, strong) MKNetworkOperation *networkOperation;

- (void)p_record:(UIButton*)button;
- (void)p_willCancelRecord:(UIButton*)button;
- (void)p_cancelRecord:(UIButton*)button;
- (void)p_sendRecord:(UIButton*)button;
- (void)p_endCancelRecord:(UIButton*)button;
@end

@implementation MessageContentViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //注册监听键盘事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(webSocketMessage:) name:@"webSocketMessage" object:nil];
     [self addObserver:self forKeyPath:@"_inputViewY" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FSVoiceBubbleShouldStopNotification" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

-(void)dealloc
{
    [self removeObserver:self forKeyPath:@"_inputViewY"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self initComponents];
}
- (void)initComponents{
    [self tempLbl];
    if ([[self.otherInfo valueForJSONStrKey:@"type"] isEqualToString:@"2"]) {//群        
        [self rightButton:@"" image:@"headicon01" sel:@selector(rightButtonClicked)];
    }
    
    dictAllImage=[[NSMutableDictionary alloc]init];
    tableTempArray=[[NSMutableArray alloc]init];
    tbDataArray=[[NSMutableArray alloc]init];
    
    tabelMessage = [[UITableView alloc]initWithFrame:CGRectMake(0, kTopHeight, kScreenWidth, kScreenHeight - 64 - 44) style:UITableViewStylePlain];
    tabelMessage.backgroundColor = [UIColor whiteColor];
    tabelMessage.delegate = self;
    tabelMessage.dataSource = self;
    [self.view addSubview:tabelMessage];
    tabelMessage.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tabelMessage registerClass:[MessageContentTxtTableViewCell class] forCellReuseIdentifier:@"MessageContentTxtTableViewCell"];
    [tabelMessage registerClass:[SystemMessageTableViewCell class] forCellReuseIdentifier:@"SystemMessageTableViewCell"];
    [tabelMessage registerClass:[MessageContentImageTableViewCell class] forCellReuseIdentifier:@"MessageContentImageTableViewCell"];
    [tabelMessage setClipsToBounds:YES];
    
    egoRefresh = [[EGORefreshChatTableHeaderView alloc]initWithFrame:CGRectMake(0, -60, kScreenWidth, 60)];
    egoRefresh.delegate = self;
    [tabelMessage addSubview:egoRefresh];
    
    
    messageInput=[[JSMessageInputView alloc]initWithFrame:CGRectMake(0, YH(tabelMessage), kScreenWidth, 44) delegate:self];
    [messageInput setBackgroundColor:[UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0]];
    [self.view addSubview:messageInput];
    [messageInput.emotionbutton addTarget:self
                                         action:@selector(showEmotions:)
                               forControlEvents:UIControlEventTouchUpInside];
    
    [messageInput.showUtilitysbutton addTarget:self
                                              action:@selector(showUtilitys:)
                                    forControlEvents:UIControlEventTouchUpInside];
    
    [messageInput.voiceButton addTarget:self
                                       action:@selector(p_clickThRecordButton:)
                             forControlEvents:UIControlEventTouchUpInside];
//    
//    UIView *viewTemp=[[UIView alloc]initWithFrame:CGRectMake(0, YH(messageInput), W(messageInput), 216)];
//    viewTemp.backgroundColor=[UIColor whiteColor];
//    
//    [self.view addSubview:viewTemp];
    
    
   

    
    _touchDownGestureRecognizer = [[TouchDownGestureRecognizer alloc] initWithTarget:self action:nil];
    __weak MessageContentViewController* weakSelf = self;
    _touchDownGestureRecognizer.touchDown = ^{
        [weakSelf p_record:nil];
    };
    
    _touchDownGestureRecognizer.moveInside = ^{
        [weakSelf p_endCancelRecord:nil];
    };
    
    _touchDownGestureRecognizer.moveOutside = ^{
        [weakSelf p_willCancelRecord:nil];
    };
    
    _touchDownGestureRecognizer.touchEnd = ^(BOOL inside){
        if (inside)
        {
            [weakSelf p_sendRecord:nil];
        }
        else
        {
            [weakSelf p_cancelRecord:nil];
        }
    };
    
    [_touchDownGestureRecognizer setDelaysTouchesBegan:YES];
    [_touchDownGestureRecognizer setDelaysTouchesEnded:NO];
    [messageInput.recordButton addGestureRecognizer:_touchDownGestureRecognizer];
    
    _recordingView = [[RecordingView alloc] initWithState:DDShowVolumnState];
    [_recordingView setHidden:YES];
    [_recordingView setCenter:CGPointMake(self.view.center.x, self.view.center.y)];
    
    numIndex=1;
    [self loadViewTableViewData:numIndex];
    

}

-(void)righthButton{
    //发起群聊    
    NSMutableDictionary *message = [NSMutableDictionary dictionary];
    
    [message setValue:@"zcw_roomsay" forKey:@"type"];
    [message setValue:@"0" forKey:@"from_client_id"];//自己的id
    [message setValue:[self.otherInfo valueForJSONStrKey:@"id"] forKey:@"room_id"];//群ID
    [message setValue:@"all" forKey:@"to_client_id"];//聊天对象id
    
    
    /*
     types":"1"//消息类型（1:文本消息，2:图片消息 3:语音消息，4：视频消息，5：抖动，6：定位，7：分享）
     "content":"",	//文本消息内容
     */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@"1" forKey:@"types"];
    [dic setValue:@"计划开始啦,小伙伴们加油吧！" forKey:@"content"];
    [message setObject:dic  forKey:@"content"];
    
    [[Utility Share] WebSocketsend:[message JSONString_l]];
}

-(void)tempLbl{
    emojiLabel = [[MLEmojiLabel alloc]init];
    emojiLabel.numberOfLines = 0;
    emojiLabel.font =fontSmallTitle;
    emojiLabel.backgroundColor = [UIColor clearColor];
    emojiLabel.lineBreakMode = NSLineBreakByCharWrapping;
    emojiLabel.isNeedAtAndPoundSign = YES;
    [self.view addSubview:emojiLabel];
    
    emojiLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    emojiLabel.customEmojiPlistName = @"expressionImage_custom.plist";
    emojiLabel.hidden=YES;
}
#pragma mark button
-(void)rightButtonClicked{
    //群成员
    
    [self pushController:[GroupMembersViewController class] withInfo:@"" withTitle:@"群组成员" withOther:self.otherInfo];
}
-(void)showEmotions:(UIButton *)btn{
   
    //表情
    //改变语音按钮、输入框
    [messageInput.voiceButton setImage:[UIImage imageNamed:@"dd_record_normal"] forState:UIControlStateNormal];
    messageInput.voiceButton.tag = DDVoiceInput;//语音
    [messageInput willBeginInput];
    if ([_currentInputContent length] > 0  && !_bottomShowComponent )
    {
        [messageInput.textView setText:_currentInputContent];
    }
    
    if (!viewEmojiShow) {
        viewEmojiShow = [[EmojiShowVIew alloc] init];
        viewEmojiShow.frame=CGRectMake(0, kScreenHeight, kScreenWidth, 216);
        viewEmojiShow.delegate = self;
        [self.view addSubview:viewEmojiShow];
    }
    if (_bottomShowComponent & DDShowKeyboard)
    {
        //显示的是键盘,这是需要隐藏键盘，显示表情，不需要动画
        _bottomShowComponent = (_bottomShowComponent & 0) | DDShowEmotion;
        [messageInput.textView resignFirstResponder];
        [viewEmojiShow setFrame:DDEMOTION_FRAME];
        [messageInput.emotionbutton setImage:[UIImage imageNamed:@"dd_input_normal"] forState:UIControlStateNormal];
        [otherFeaturesV setFrame:DDCOMPONENT_BOTTOM];
    }
    else if (_bottomShowComponent & DDShowEmotion)
    {
        //表情面板本来就是显示的,这时需要隐藏所有底部界面,显示键盘
        
        [messageInput.textView becomeFirstResponder];
        _bottomShowComponent = _bottomShowComponent & DDHideEmotion;
    }
    else if (_bottomShowComponent & DDShowUtility)
    {
        //显示的是插件，这时需要隐藏插件，显示表情
        [messageInput.emotionbutton setImage:[UIImage imageNamed:@"dd_input_normal"] forState:UIControlStateNormal];
        [otherFeaturesV setFrame:DDCOMPONENT_BOTTOM];
        [viewEmojiShow setFrame:DDEMOTION_FRAME];
        _bottomShowComponent = (_bottomShowComponent & DDHideUtility) | DDShowEmotion;
    }
    else
    {
        //这是什么都没有显示，需用动画显示表情
        _bottomShowComponent = _bottomShowComponent | DDShowEmotion;
        [messageInput.emotionbutton setImage:[UIImage imageNamed:@"dd_input_normal"] forState:UIControlStateNormal];

        [UIView animateWithDuration:0.25 animations:^{
            [viewEmojiShow setFrame:DDEMOTION_FRAME];
            [messageInput setFrame:DDINPUT_TOP_FRAME];
        } completion:^(BOOL finished) {

        }];
        
        [self setValue:@(DDINPUT_TOP_FRAME.origin.y) forKeyPath:@"_inputViewY"];
    }
    
    
}
-(void)showUtilitys:(UIButton *)btn{
    //其他
   
    //    otherFeaturesV
    [messageInput.voiceButton setImage:[UIImage imageNamed:@"dd_record_normal"] forState:UIControlStateNormal];
    messageInput.voiceButton.tag = DDVoiceInput;
    [messageInput willBeginInput];
    if ([_currentInputContent length] > 0 && !_bottomShowComponent )
    {
        [messageInput.textView setText:_currentInputContent];
    }
    
    if (!otherFeaturesV)
    {
        otherFeaturesV = [[OtherFeaturesView alloc] init];
        otherFeaturesV.frame=DDCOMPONENT_BOTTOM;
        otherFeaturesV.delegate = self;
        [self.view addSubview:otherFeaturesV];
    }
    
    if (_bottomShowComponent & DDShowKeyboard)
    {
        //显示的是键盘,这是需要隐藏键盘，显示插件，不需要动画
        [messageInput.emotionbutton setImage:[UIImage imageNamed:@"dd_emotion"] forState:UIControlStateNormal];
        _bottomShowComponent = (_bottomShowComponent & 0) | DDShowUtility;
        [messageInput.textView resignFirstResponder];
        [otherFeaturesV setFrame:DDEMOTION_FRAME];
        [viewEmojiShow setFrame:DDCOMPONENT_BOTTOM];
    }
    else if (_bottomShowComponent & DDShowUtility)
    {
        //插件面板本来就是显示的,这时需要隐藏所有底部界面
        //        [self p_hideBottomComponent];
        [messageInput.emotionbutton setImage:[UIImage imageNamed:@"dd_input_normal"] forState:UIControlStateNormal];
        [messageInput.textView becomeFirstResponder];
        _bottomShowComponent = (_bottomShowComponent & DDHideUtility) | DDShowKeyboard;
    }
    else if (_bottomShowComponent & DDShowEmotion)
    {
        //显示的是表情，这时需要隐藏表情，显示插件
        [messageInput.emotionbutton setImage:[UIImage imageNamed:@"dd_emotion"] forState:UIControlStateNormal];
        [viewEmojiShow setFrame:DDCOMPONENT_BOTTOM];
        [otherFeaturesV setFrame:DDEMOTION_FRAME];
        _bottomShowComponent = (_bottomShowComponent & DDHideEmotion) | DDShowUtility;
    }
    else
    {
        //这是什么都没有显示，需用动画显示插件
        _bottomShowComponent = _bottomShowComponent | DDShowUtility;

        [UIView animateWithDuration:0.25 animations:^{
            [otherFeaturesV setFrame:DDEMOTION_FRAME];
            [messageInput setFrame:DDINPUT_TOP_FRAME];
        } completion:^(BOOL finished) {
            
        }];
        
        [self setValue:@(DDINPUT_TOP_FRAME.origin.y) forKeyPath:@"_inputViewY"];
        
    }
    
    
    
}

-(void)p_clickThRecordButton:(UIButton *)button{
    
    [messageInput.emotionbutton setImage:[UIImage imageNamed:@"dd_emotion"] forState:UIControlStateNormal];
    switch (button.tag) {
        case 0:{
            //开始录音
            KKNavigationController *KNV=(KKNavigationController *)self.navigationController;
            KNV.recognizer.enabled=NO;
            
            [self p_hideBottomComponent];
            [button setImage:[UIImage imageNamed:@"dd_input_normal"] forState:UIControlStateNormal];
            button.tag = 1;
            [messageInput willBeginRecord];
            _currentInputContent = messageInput.textView.text;
            if ([_currentInputContent length] > 0)
            {
                [messageInput.textView setText:nil];
            }
            break;
        }
        case 1:{
            //开始输入文字
            
            KKNavigationController *KNV=(KKNavigationController *)self.navigationController;
            KNV.recognizer.enabled=YES;
            [button setImage:[UIImage imageNamed:@"dd_record_normal"] forState:UIControlStateNormal];
            button.tag = 0;
            [messageInput willBeginInput];
            if ([_currentInputContent length] > 0)
            {
                [messageInput.textView setText:_currentInputContent];
            }
            [messageInput.textView becomeFirstResponder];
            break;
        }
    }
}
- (void)p_record:(UIButton*)button
{
//    KKNavigationController *KNV=(KKNavigationController *)self.navigationController;
//    KNV.navRecognizer.enabled=NO;
    if (![[self.view subviews] containsObject:_recordingView])
    {
        [self.view addSubview:_recordingView];
    }
    [_recordingView setHidden:NO];
    [messageInput.recordButton setSelected:YES];
    [_recordingView setRecordingState:DDShowVolumnState];
//    [[RecorderManager sharedManager] setDelegate:self];
//    [[RecorderManager sharedManager] startRecording];
    
    //开始
    if (!rcoder)
    {
        rcoder=[[RecoderAndPlayer alloc]init];
    }
    rcoder.viewDelegate=self;
    [rcoder SpeechRecordStart];
    
    NSLog(@"record");
}

- (void)p_hideBottomComponent
{
    _bottomShowComponent = _bottomShowComponent * 0;
    [messageInput.textView resignFirstResponder];
    [UIView animateWithDuration:0.25 animations:^{
        otherFeaturesV.frame = DDCOMPONENT_BOTTOM;
        viewEmojiShow.frame = DDCOMPONENT_BOTTOM;
        messageInput.frame = DDINPUT_BOTTOM_FRAME;
    }];
    NSLog(@"%f",Y(messageInput));
    [self setValue:@(Y(messageInput)) forKeyPath:@"_inputViewY"];
}

  
- (void)p_endCancelRecord:(UIButton*)button
{
    [_recordingView setHidden:NO];
    [_recordingView setRecordingState:DDShowVolumnState];
  
}
- (void)p_willCancelRecord:(UIButton*)button
{
    [_recordingView setHidden:NO];
    [_recordingView setRecordingState:DDShowCancelSendState];
    NSLog(@"will cancel record");
}
- (void)p_sendRecord:(UIButton*)button
{
//    [[RecorderManager sharedManager] stopRecording];
    NSLog(@"send record");
//    KKNavigationController *KNV=(KKNavigationController *)self.navigationController;
////    KNV.canDragBack=YES;
//     KNV.navRecognizer.enabled=YES;
    [_recordingView setHidden:YES];
    [messageInput.recordButton setSelected:NO];
    
    //录音结束
    [rcoder SpeechRecordStop];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}
- (void)p_cancelRecord:(UIButton*)button
{
//    [[RecorderManager sharedManager] cancelRecording];
    NSLog(@"cancel record");
//    KKNavigationController *KNV=(KKNavigationController *)self.navigationController;
//    //    KNV.canDragBack=YES;
//    KNV.navRecognizer.enabled=YES;
    
    [_recordingView setHidden:YES];
    [messageInput.recordButton setSelected:NO];
    
    //录音结束
    [rcoder SpeechRecordStop];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}


#pragma mark selector
-(void)handleKeyboardDidShow:(NSNotification *)notification{
    NSDictionary *info = [notification userInfo];
    CGRect keyboardFrame;
    [[info objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size;
    CGFloat distanceToMove = kbSize.height;
    NSLog(@"---->动态键盘高度:%f",distanceToMove);
    if (distanceToMove<44) {
        return;
    }
    
    [messageInput.emotionbutton setImage:[UIImage imageNamed:@"dd_emotion"] forState:UIControlStateNormal];
    CGRect keyboardRect;
    keyboardRect = [(notification.userInfo)[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    _bottomShowComponent = _bottomShowComponent | DDShowKeyboard;
    
    
    [UIView animateWithDuration:0.3 animations:^{
         messageInput.frame=CGRectMake(X(messageInput), keyboardRect.origin.y - H(messageInput), W(messageInput), H(messageInput));
    } completion:^(BOOL finished) {
        
        if (tabelMessage.contentSize.height>H(tabelMessage)) {
            
            float f_off_y=tabelMessage.contentSize.height-H(tabelMessage);
            tabelMessage.contentOffset=CGPointMake(0, f_off_y);
        }
    }];
   
    
    [self setValue:@(keyboardRect.origin.y - H(messageInput)) forKeyPath:@"_inputViewY"];
}
- (void)handleKeyboardWillHide:(NSNotification *)notification
{
    
    _bottomShowComponent = _bottomShowComponent & DDHideKeyboard;
    if (_bottomShowComponent & DDShowUtility)
    {
        //显示的是插件
        [UIView animateWithDuration:0.25 animations:^{
            [messageInput setFrame:DDINPUT_TOP_FRAME];
        }];
        [self setValue:@(Y(messageInput)) forKeyPath:@"_inputViewY"];
    }
    else if (_bottomShowComponent & DDShowEmotion)
    {
        //显示的是表情
        //显示的是插件
        [UIView animateWithDuration:0.25 animations:^{
            [messageInput setFrame:DDINPUT_TOP_FRAME];
        }];
        [self setValue:@(Y(messageInput)) forKeyPath:@"_inputViewY"];
        
    }
    else
    {
        [self p_hideBottomComponent];
    }
    
   
}//

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"_inputViewY"])
    {
        
        [UIView animateWithDuration:0.25 animations:^{
            tabelMessage.frame=CGRectMake(X(tabelMessage), Y(tabelMessage), W(tabelMessage),_inputViewY-(kVersion7?64:44
                                                                                                         ));
            
        } completion:^(BOOL finished) {
            if (_inputViewY<kScreenHeight-100 && tabelMessage.contentSize.height>H(tabelMessage)) {
                float f_off_y=tabelMessage.contentSize.height-H(tabelMessage);
                tabelMessage.contentOffset=CGPointMake(0, f_off_y);
            }
        }];
    }
    
}

#pragma mark - Text view delegatef
- (void)viewheightChanged:(float)height
{
    [self setValue:@(Y(messageInput)) forKeyPath:@"_inputViewY"];
    DLog(@"messageInput:%f",height)
    
    
}
#pragma mark txt 发消息
- (void)textViewEnterSend
{
    NSLog(@"发送消息：%@",messageInput.textView.text);
    NSString *strMessage=messageInput.textView.text;
    if (![strMessage notEmptyOrNull]) {
        [SVProgressHUD showImage:nil status:@"哎呀！你还没输入内容哦"];
        return;
    }
 
    
    NSMutableDictionary *message = [NSMutableDictionary dictionary];
    
    if ([[self.otherInfo valueForJSONStrKey:@"type"] isEqualToString:@"2"]) {
        [message setValue:@"zcw_roomsay" forKey:@"type"];
        [message setValue:roomid forKey:@"room_id"];//群ID
        [message setValue:@"all" forKey:@"to_client_id"];//聊天对象id
    }else{
        [message setValue:@"zcw_say" forKey:@"type"];
        [message setValue:[self.otherInfo valueForJSONStrKey:@"id"] forKey:@"to_client_id"];//聊天对象id
        
        
    }

    [message setValue:[[Utility Share] userId] forKey:@"from_client_id"];//自己的id
    [message setValue:[[Utility Share] userToken] forKey:@"token"];
    [message setValue:[[Utility Share] userName] forKey:@"uname"];
    [message setValue:[[Utility Share] userLogo] forKey:@"uicon"];
    [message setValue:[self.otherInfo valueForJSONStrKey:@"order_no"] forKey:@"order_no"];
    
    /*
     types":"1"//消息类型（1:文本消息，2:图片消息 3:语音消息，4：视频消息，5：抖动，6：定位，7：分享）
     "content":"",	//文本消息内容
     "image":@{@"path":@"http://806165851_695.jpg",@"small_path":@"http://1_695.jpg"},	//图片消息内容
     "voice":{@"voiceUrl":http://xxxx,@"voiceLength":@"5"},	//语音消息内容
     "video":"",	//视频消息内容
     "content":"",	//文本消息内容
     "shake":"",	//抖动
     "lng":"",	    //定位（经度）
     "lat":"",	    //定位（纬度）
     "address":"",  //定位（地址）
     "share":"",	//分享消息内容
     */
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@"1" forKey:@"types"];
    [dic setValue:strMessage forKey:@"content"];
    [message setObject:dic  forKey:@"content"];
    
    [[Utility Share] WebSocketsend:[message JSONString_l]];
    
    messageInput.textView.text=@"";
    
    
    NSMutableDictionary *mysendMessage = [NSMutableDictionary dictionary];
    [mysendMessage setValue:@"1" forKey:@"types"];
    [mysendMessage setValue:[[Utility Share] userName] forKey:@"name"];
    [mysendMessage setValue:[[Utility Share] userLogo] forKey:@"icon"];
    [mysendMessage setValue:[[Utility Share] userId] forKey:@"id"];
    [mysendMessage setValue:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]] forKey:@"createtime"];
    [mysendMessage setObject:dic  forKey:@"content"];
    [tbDataArray insertObject:mysendMessage atIndex:0];
    
    [self refreshTabelView];
    
    
}
#pragma mark tableview

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableTempArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dicTT = tableTempArray[indexPath.row];
    NSDictionary *dic = [dicTT objectForJSONKey:@"content"];
    
    
    //types":"1"//消息类型（1:文本消息，2:图片消息 3:语音消息，4：视频消息，5：抖动，6：定位，7：分享）
    if ( [[self.otherInfo valueForJSONStrKey:@"type"] isEqualToString:@"2"] &&( [[dicTT valueForJSONStrKey:@"id"] isEqualToString:@"0"] || ![[dicTT valueForJSONStrKey:@"id"] notEmptyOrNull])) {
        //系统消息
        SystemMessageTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SystemMessageTableViewCell" forIndexPath:indexPath];
        [cell setValueForDictionary:dicTT indexPath:indexPath];
        return cell;
    }else if ([[dic valueForJSONStrKey:@"types"] isEqualToString:@"3"] ) {
        NSString *strIdentifier=dic.description.md5;
        MessageContentVoiceBubbleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strIdentifier];
        if (!cell) {
            cell = [[MessageContentVoiceBubbleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strIdentifier ];
            cell.delegate=self;
        }
        [cell setValueForDictionary:dicTT indexPath:indexPath payIndexP:tempPlayIndex  hiddenName:![[self.otherInfo valueForJSONStrKey:@"type"] isEqualToString:@"2"]];
 
        return cell;
    }else if ([[dic valueForJSONStrKey:@"types"] isEqualToString:@"2"]){
        MessageContentImageTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MessageContentImageTableViewCell" forIndexPath:indexPath];
        [cell setValueForDictionary:dicTT indexPath:indexPath  hiddenName:![[self.otherInfo valueForJSONStrKey:@"type"] isEqualToString:@"2"]];
        cell.delegate=self;
        return cell;
    }else{
        MessageContentTxtTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MessageContentTxtTableViewCell" forIndexPath:indexPath];
        [cell setValueForDictionary:dicTT indexPath:indexPath superViewController:self  hiddenName:![[self.otherInfo valueForJSONStrKey:@"type"] isEqualToString:@"2"]];
        cell.delegate=self;
        return cell;

    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dicTT = tableTempArray[indexPath.row];
    NSDictionary *dic = [dicTT objectForJSONKey:@"content"];
    //types":"1"//消息类型（1:文本消息，2:图片消息 3:语音消息，4：视频消息，5：抖动，6：定位，7：分享）
    if ( [[self.otherInfo valueForJSONStrKey:@"type"] isEqualToString:@"2"] && ( [[dicTT valueForJSONStrKey:@"id"] isEqualToString:@"0"] || ![[dicTT valueForJSONStrKey:@"id"] notEmptyOrNull])) {
        //系统消息
        float f_h=[self heightForLabel:kScreenWidth-100 font:fontSmallTitle text:[dic valueForJSONStrKey:@"content"]];
        
        return f_h+30;
        
    }
    
    
    float t_h;
    if ([[dic valueForJSONStrKey:@"types"] isEqualToString:@"3"] ) {
        
        t_h= 64;
    }else if ([[dic valueForJSONStrKey:@"types"] isEqualToString:@"2"]){
        
        t_h= 180;
    }else{
        [emojiLabel setEmojiText:[dic valueForJSONStrKey:@"content"]];
        emojiLabel.frame = CGRectMake(60, 10,kScreenWidth-120,10);
        [emojiLabel sizeToFit];
        t_h= H(emojiLabel)+40;
    }
    if (![[dicTT valueForJSONStrKey:@"boolDate"] isEqualToString:@"hidden"]) {
        t_h +=20;
    }
    if ([[dicTT valueForJSONStrKey:@"types"] isEqualToString:@"0"] && [[self.otherInfo valueForJSONStrKey:@"type"] isEqualToString:@"2"]) {
        //群聊//别人
        t_h+=25;
        
    }
    return t_h;
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self p_hideBottomComponent];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    egoRefresh.delegate?[egoRefresh egoRefreshScrollViewDidScroll:scrollView]:nil;
    
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    egoRefresh.delegate?[egoRefresh egoRefreshScrollViewDidEndDragging:scrollView]:nil;
    
}


#pragma mark -webSocket 收到消息
-(void)webSocketMessage:(NSNotification *)note
{
    if ([[self.otherInfo valueForJSONStrKey:@"type"] isEqualToString:@"2"]) {//群
        /*
         ///type类型（1：好友消息，2：群消息）
        
         if ([[self.otherInfo valueForJSONStrKey:@"type"] isEqualToString:@"1"]) {
         [message setValue:@"zcw_say" forKey:@"type"];
         [message setValue:[self.otherInfo valueForJSONStrKey:@"id"] forKey:@"to_client_id"];//聊天对象id
         
         }else{
         
         [message setValue:@"zcw_roomsay" forKey:@"type"];
         [message setValue:[self.otherInfo valueForJSONStrKey:@"id"] forKey:@"room_id"];//群ID
         [message setValue:@"all" forKey:@"to_client_id"];//聊天对象id
         }
         */
        if ([[note.userInfo valueForJSONStrKey:@"type"] isEqualToString:@"zcw_roomsay"] && [[note.userInfo valueForJSONStrKey:@"room_id"] isEqualToString:[self.otherInfo valueForJSONStrKey:@"id"]] && ![[note.userInfo valueForJSONStrKey:@"from_client_id"] isEqualToString:[[Utility Share] userId]]) {
            
            NSMutableDictionary *fsendMessage = [NSMutableDictionary dictionary];
            [fsendMessage setValue:@"0" forKey:@"types"];
            [fsendMessage setValue:[note.userInfo valueForJSONStrKey:@"uname"] forKey:@"name"];
            [fsendMessage setValue:[note.userInfo valueForJSONStrKey:@"uicon"] forKey:@"head"];
            [fsendMessage setValue:[note.userInfo valueForJSONStrKey:@"from_client_id"] forKey:@"id"];
            [fsendMessage setValue:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]] forKey:@"createtime"];
            
            [fsendMessage setObject:[note.userInfo objectForJSONKey:@"content"]  forKey:@"content"];
            [tableTempArray addObject:fsendMessage];
            
            [tbDataArray insertObject:fsendMessage atIndex:0];
            
            [self refreshTabelView];
            
        }
    }else{
        //单人聊天
        if ([[note.userInfo valueForJSONStrKey:@"type"] isEqualToString:@"zcw_say"] && [[note.userInfo valueForJSONStrKey:@"from_client_id"] isEqualToString:[self.otherInfo valueForJSONStrKey:@"id"]]) {
            
            NSMutableDictionary *fsendMessage = [NSMutableDictionary dictionary];
            [fsendMessage setValue:@"0" forKey:@"types"];
            [fsendMessage setValue:[note.userInfo valueForJSONStrKey:@"name"] forKey:@"name"];
            [fsendMessage setValue:[note.userInfo valueForJSONStrKey:@"uicon"] forKey:@"head"];
            [fsendMessage setValue:[note.userInfo valueForJSONStrKey:@"from_client_id"] forKey:@"id"];
            [fsendMessage setValue:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]] forKey:@"createtime"];
            
            [fsendMessage setObject:[note.userInfo objectForJSONKey:@"content"]  forKey:@"content"];
            [tableTempArray addObject:fsendMessage];
            
            [tbDataArray insertObject:fsendMessage atIndex:0];
            
            [self refreshTabelView];
        }
    }
    
    
    
    
}


#pragma mark load-- 获取历史记录
-(void)loadViewTableViewData:(NSInteger )currPage{
    NSString *strintex=[NSString stringWithFormat:@"%ld",(long)currPage];
    
    [self.networkOperation cancel];
    ///type类型（1：好友消息，2：群消息,3:客服）
    NSString *strOldMessageUrl;
    if ([[self.otherInfo valueForJSONStrKey:@"type"] isEqualToString:@"1"]) {
        strOldMessageUrl=[NSString stringWithFormat:CHATSINGLECHATMESSAGEget,[[Utility Share] userId],[[Utility Share] userToken],[self.otherInfo valueForJSONStrKey:@"order_no"],[self.otherInfo valueForJSONStrKey:@"id"],strintex,[self.otherInfo valueForJSONStrKey:@"orderType"]];
    }
    else if([[self.otherInfo valueForJSONStrKey:@"type"] isEqualToString:@"2"]){
        strOldMessageUrl=[NSString stringWithFormat:CHATCIRCLECHATMESSAGEget,[[Utility Share] userId],[[Utility Share] userToken],strintex,[self.otherInfo valueForJSONStrKey:@"order_no"],[self.otherInfo valueForJSONStrKey:@"orderType"]];
    }
//    }else if ([[self.otherInfo valueForJSONStrKey:@"type"] isEqualToString:@"3"]){
//        strOldMessageUrl=[NSString stringWithFormat:YDcircleserverChat,[[Utility Share] userId],[[Utility Share] userToken],strintex,[self.otherInfo valueForJSONStrKey:@"id"]];
//    }
    //
            //
    self.networkOperation =[NetEngine createGetAction_LJ :strOldMessageUrl onCompletion:^(id resData, BOOL isCache) {
        
        if ([[resData valueForJSONKey:@"status"] isEqualToString:@"200"]) {
            roomid = [[resData valueForKey:@"data"] valueForJSONKey:@"room_id"];
            canchate = [[resData valueForKey:@"data"] valueForJSONKey:@"can"];
            if ([canchate isEqualToString:@"0"]) {
                messageInput.hidden = YES;
                tabelMessage.frame = CGRectMake(X(tabelMessage), Y(tabelMessage), W(tabelMessage), kScreenHeight - 64);
            }
            
            
            NSArray *arrayTemp=[[resData objectForJSONKey:@"data"] objectForJSONKey:@"list"];
            if (arrayTemp.count) {
                tempDataNum=arrayTemp.count;
                if (arrayTemp.count>=default_PageSize) {//
                    //还有有数据
                    numIndex++;
                    egoRefresh.hidden = NO;
                    egoRefresh.delegate = self;
                }else if (arrayTemp.count<default_PageSize){
                    //有数据
                    numIndex++;
                    //没有跟多数据
                    egoRefresh.hidden = YES;
                    egoRefresh.delegate = nil;
                }else{
                    //没有跟多数据
                    egoRefresh.hidden = YES;
                    egoRefresh.delegate = nil;
                }
                
                //有数据哦
                if (currPage==default_StartPage) {
                    tbDataArray=[NSMutableArray arrayWithArray:arrayTemp];
                    
                }else{
                    [tbDataArray addObjectsFromArray:arrayTemp];
                }
            }
            [self refreshTabelView];
        }
        else{
            [SVProgressHUD showImage:nil status:[resData valueForJSONKey:@"info"]];
        }
    }];

}
-(void)refreshTabelView{
    
    egoRefresh.frame=CGRectMake(0, -60, kScreenWidth, 60);
    NSArray *array_a=[[tbDataArray reverseObjectEnumerator] allObjects];//tbDataArray;//
    //处理数据-插入时间段
    
    NSInteger tempSelectRow=[tableTempArray count];
    
    [tableTempArray removeAllObjects];
    tableTempArray=[NSMutableArray arrayWithCapacity:0];
    
    
    for (int i=0;i<[array_a count];i++) {
        NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:[array_a objectAtIndex:i]];
        [dict setValue:@"show" forKey:@"boolDate"];
        if (i>0) {
            NSDictionary *dt=[array_a objectAtIndex:i-1];
            //
            NSTimeInterval late=[[dict objectForJSONKey:@"createtime"] integerValue];
            NSTimeInterval lateOld=[[dt objectForJSONKey:@"createtime"] integerValue];
            
            if ((int)late/3600 == (int)lateOld/3600) {
                //小时内干掉
                [dict setValue:@"hidden" forKey:@"boolDate"];
            }
            
        }
        [tableTempArray addObject:dict];
        
        NSString *de  = [NSString stringWithFormat:@"%d",i];
        if ([[[dict objectForJSONKey:@"content"] valueForJSONStrKey:@"types"] isEqualToString:@"2"]) {
            [dictAllImage setValue:[dict objectForJSONKey:@"content"]  forKey:de];
        }else{
            [dictAllImage removeObjectForKey:de];
        }

        
    }
    
    
    
    if (bbb) {
        boolLoadMore=YES;
    }else{
        boolLoadMore=NO;
    }
    //刷新
    
//    NSLog(@"tableTempArray_____%@",tableTempArray);
    
       
    
    
    [tabelMessage reloadData];
    if (tbDataArray.count>0) {
//        DLog(@"____%ld",(long)numIndex);
        if (!boolLoadMore) {
            //第一页
            [tabelMessage selectRowAtIndexPath:[NSIndexPath indexPathForRow:([tableTempArray count]-1) inSection:0] animated:NO scrollPosition:UITableViewScrollPositionBottom];
        }else {//if(numIndex > default_StartPage+1)
            //显示第二页第一条
            [tabelMessage selectRowAtIndexPath:[NSIndexPath indexPathForRow:[tableTempArray count]-tempSelectRow inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        }
    }
    
    [self performSelector:@selector(finishTable)];
    
    //
    
}

-(void)finishTable{
    bbb=NO;
    [egoRefresh egoRefreshScrollViewDataSourceDidFinishedLoading:tabelMessage];
}

#pragma mark - EGORefreshChatTableHeaderViewDelegate
#pragma mark 刷新表格协议
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshChatTableHeaderView*)view{
    return bbb;
}
//提供最后一次刷新时间
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshChatTableHeaderView*)view{
    return [NSDate date];
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshChatTableHeaderView*)view{
    //提供下一次刷新的数据
    
    //创建一个新线程来异步加载数据
    [NSThread detachNewThreadSelector:@selector(newThread:) toTarget:self withObject:nil];
}
-(void)newThread:(EGORefreshChatTableHeaderView*)view{
    bbb=YES;
    //刷新
    [self loadViewTableViewData:numIndex];
    
}



#pragma mark RecoderAndPlayerDelegate
#pragma mark //录制的音频文件名，大小，时长
-(void)recordAndSendAudioFile:(NSString *)fileName fileSize:(NSString *)fileSize duration:(NSString *)timelength
{
    DLog(@"__________%@________%@+_______%@",fileName,fileSize,timelength);
    if ([timelength integerValue]<2) {
        [SVProgressHUD showImage:nil status:@"时间太短"];
        return;
    }
    [_recordingView setHidden:YES];
    [messageInput.recordButton setSelected:NO];
    
    NSData *amrData = [NSData dataWithContentsOfFile:fileName];
    if (!amrData) {
        [SVProgressHUD showImage:nil status:@"录音失败！"];
        return;
    }
    //chat/uploadVoice
    NSMutableDictionary *dics = [NSMutableDictionary dictionary];
    [dics setValue:[[Utility Share] userId] forKey:@"uid"];
    [dics setValue:[[Utility Share] userToken] forKey:@"token"];
    [NetEngine uploadAudioFileAction:YDcirclevoiceUpload fileData:amrData withParams:dics fileKey:@"voice" fileName:@"ios_audio.amr" onCompletion:^(id resData, BOOL isCache) {
        
        if ([[resData valueForJSONStrKey:@"status"] isEqualToString:@"200"]) {
            DLog(@"resData：%@",[[resData objectForJSONKey:@"data"] valueForJSONStrKey:@"path"]);
            
            NSMutableDictionary *message = [NSMutableDictionary dictionary];
            ///type类型（1：好友消息，2：群消息）
            if ([[self.otherInfo valueForJSONStrKey:@"type"] isEqualToString:@"2"]) {
                
                [message setValue:@"zcw_roomsay" forKey:@"type"];
                [message setValue:[self.otherInfo valueForJSONStrKey:@"id"] forKey:@"room_id"];//群ID
                [message setValue:@"all" forKey:@"to_client_id"];//聊天对象id
            }else{
                [message setValue:@"zcw_say" forKey:@"type"];
                [message setValue:[self.otherInfo valueForJSONStrKey:@"id"] forKey:@"to_client_id"];//聊天对象id
                
            }
            
            [message setValue:[[Utility Share] userId] forKey:@"from_client_id"];//自己的id
            [message setValue:[[Utility Share] userToken] forKey:@"token"];
            [message setValue:[[Utility Share] userName] forKey:@"uname"];
            [message setValue:[[Utility Share] userLogo] forKey:@"uicon"];
            [message setValue:[self.otherInfo valueForJSONStrKey:@"order_no"] forKey:@"order_no"];
            
            /*
             types":"1"//消息类型（1:文本消息，2:图片消息 3:语音消息，4：视频消息，5：抖动，6：定位，7：分享）
             "content":"",	//文本消息内容
             "image":@{@"path":@"http://806165851_695.jpg",@"small_path":@"http://1_695.jpg"},	//图片消息内容
             "voice":{@"voiceUrl":http://xxxx,@"voiceLength":@"5"},	//语音消息内容
             "video":"",	//视频消息内容
             "content":"",	//文本消息内容
             "shake":"",	//抖动
             "lng":"",	    //定位（经度）
             "lat":"",	    //定位（纬度）
             "address":"",  //定位（地址）
             "share":"",	//分享消息内容
             */
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:@"3" forKey:@"types"];
            [dic setValue:@"语音消息" forKey:@"content"];
            [dic setValue:@{@"voiceUrl":[[resData objectForJSONKey:@"data"] valueForJSONStrKey:@"voice"],@"voiceLength":timelength} forKey:@"voice"];
            [message setObject:dic  forKey:@"content"];
            
            [[Utility Share] WebSocketsend:[message JSONString]];
            
            
            
            NSMutableDictionary *mysendMessage = [NSMutableDictionary dictionary];
            [mysendMessage setValue:@"1" forKey:@"types"];//我自己发的
            [mysendMessage setValue:[[Utility Share] userName] forKey:@"name"];
            [mysendMessage setValue:[[Utility Share] userLogo] forKey:@"icon"];
            [mysendMessage setValue:[[Utility Share] userId] forKey:@"id"];
            [mysendMessage setValue:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]] forKey:@"createtime"];
            [mysendMessage setObject:dic  forKey:@"content"];
            [tbDataArray insertObject:mysendMessage atIndex:0];
            [self refreshTabelView];
        }else{
            [SVProgressHUD showImage:nil status:[resData valueForJSONStrKey:@"info"]];
        }
        
    } onError:^(NSError *error) {
        [SVProgressHUD showImage:nil status:@"服务器异常,稍后再试"];
    } withMask:SVProgressHUDMaskTypeNone];
    
    
    
    //    NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:[fileName lastPathComponent],@"name",timelength,@"timelength", nil];
    
    // [self submit];
    //[self initComponents];
}

//计时提醒
-(void)TimePromptAction:(int)sencond
{
   
    
}
//播放完成回调
-(void)playingFinishWithBBS:(BOOL)isFinish
{
    
}
//倒计时
-(void)theTestTimePromptAction:(int)sencond{
    if (sencond<=0) {
        [_recordingView setHidden:YES];
        [messageInput.recordButton setSelected:NO];
        
        //录音结束
        [rcoder SpeechRecordStop];
        return;
    }
    _recordingView.recordingState=DDShowTheRestTimeRemind;
    [_recordingView setTheRestTimeRemindNum:sencond];
    
}
//音量
-(void)theVolumeChangeValue:(float)volume{
    [_recordingView setVolume:volume];
}

#pragma mark 表情
#pragma mark EmojiShowVIewDelegate
-(void)insertEmojiFace:(NSString *)string{
    NSMutableString* content = [NSMutableString stringWithString:messageInput.textView.text];
    [content appendString:string];
    [messageInput.textView setText:content];
}
-(void)deleteEmojiFace{
    
    NSString* toDeleteString = nil;
    if (messageInput.textView.text.length == 0)
    {
        return;
    }
    if (messageInput.textView.text.length == 1)
    {
        messageInput.textView.text = @"";
    }else
    {
        
        int length=1;
        if (messageInput.textView.text.length >= 3){
            length=3;//表情最少3个长度
            toDeleteString = [messageInput.textView.text substringFromIndex:messageInput.textView.text.length -length];
//            DLog(@"toDeleteString___3___:%@",toDeleteString);
            if ([toDeleteString hasSuffix:@"]"]) {
                //是否以“]”结尾
                if (![toDeleteString hasPrefix:@"["]) {//是否以“]”开始
                    //不是
                    length=4;
                    toDeleteString = [messageInput.textView.text substringFromIndex:messageInput.textView.text.length -length];
//                    DLog(@"toDeleteString___4___:%@",toDeleteString);
                    if (![toDeleteString hasPrefix:@"["]) {//是否以“]”开始
                        //不是
                        length=5;//表情标志最多5个长度
                        toDeleteString = [messageInput.textView.text substringFromIndex:messageInput.textView.text.length -length];
//                        DLog(@"toDeleteString___5___:%@",toDeleteString);
                        if (![toDeleteString hasPrefix:@"["]) {//是否以“]”开始
                            //不是
                            length=1;
                        }
                    }
                }
                if (length>1 && [[[[EmojiModule Share] EmojiDic] allKeys] containsObject:toDeleteString]) {
                    //是表情
                    DLog(@"表情：%@",toDeleteString);
                }else{
                    //不是表情
                    length=1;
                }
            }else{
                length=1;
            }
        }else{
            //不是表情----删除一个
            length=1;
           
        }
        
         messageInput.textView.text = [messageInput.textView.text substringToIndex:messageInput.textView.text.length - length];
    }
    

}
- (void)emotionViewClickSendButton{
    //发送
    [self textViewEnterSend];
}

#pragma mark 其他功能
#pragma mark OtherFeaturesViewDelegate
//选择照片
-(void)OtherFeaturesViewSelectPhoto:(OtherFeaturesView *)view{
    //    pod 'ZYQAssetPickerController',  '~> 1.0.0'
    ZYQAssetPickerController *ZYQPicker = [[ZYQAssetPickerController alloc] init];
    ZYQPicker.maximumNumberOfSelection = 10;
    ZYQPicker.minimumNumberOfSelection=1;
    ZYQPicker.assetsFilter = [ALAssetsFilter allPhotos];
    ZYQPicker.showEmptyGroups=NO;
    ZYQPicker.delegate=self;
    ZYQPicker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];
    
    [self presentViewController:ZYQPicker animated:YES completion:NULL];
}
//拍照
-(void)OtherFeaturesViewCamera:(OtherFeaturesView *)view{
    if (!ipc) {
        ipc=[[UIImagePickerController alloc]init];
    }
    //判断当前相机是否可用
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {// 打开相机
        ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
        //设置是否可编辑
        ipc.allowsEditing = YES;
        ipc.delegate=self;
        
        //打开@
        [self presentViewController:ipc animated:YES completion:^{
            
        }];
    }else
    {
        //如果不可用
        [[Utility Share] ShowMessage:nil msg:@"设备不可用..."];
       
    }
}

#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    
    //    arrayTemp=[assets copy];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        for (int i=0; i<assets.count; i++) {
            ALAsset *asset=assets[i];
            
            UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            
            
            CGSize size =  tempImg.size ;
            CGFloat fullW = kScreenWidth;
            CGFloat fullH = kScreenHeight;
            CGFloat ratio = MIN(fullW / size.width, fullH / size.height);
            CGFloat W = ratio * size.width;
            CGFloat H = ratio * size.height;
            
            UIImage *logo=[[Utility Share] imageWithImageSimple:tempImg scaledToSize:CGSizeMake(W, H)];
            //处理图片上传或其他
            NSData *imgData=UIImageJPEGRepresentation(logo, 1.0);
            dispatch_async(dispatch_get_main_queue(), ^{
               //处理图片上传或其他
                
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setValue:[[Utility Share] userId] forKey:@"uid"];
                [dic setValue:[[Utility Share] userToken] forKey:@"token"];
                [self uploadImageDic:dic iamgeData:imgData];
                
            });
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        
    });
}
-(void)assetPickerControllerDidMaximum:(ZYQAssetPickerController *)picker{
    [SVProgressHUD showImage:nil status:[NSString stringWithFormat:@"您只能选择%ld张",(long)picker.maximumNumberOfSelection]];
}

#pragma mark UIImagePickerControllerDelegate
//设备协议
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    DLog(@"_____info:%@",info);
    //获得编辑过的图片
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    
    CGSize size =  image.size ;
    CGFloat fullW = kScreenWidth;
    CGFloat fullH = kScreenHeight;
    CGFloat ratio = MIN(fullW / size.width, fullH / size.height);
    CGFloat W = ratio * size.width;
    CGFloat H = ratio * size.height;
    
    //处理图片
    UIImage *logo=[[Utility Share] imageWithImageSimple:image scaledToSize:CGSizeMake(W, H)];
     NSData *imgData=UIImageJPEGRepresentation(logo, 1.0);
    //处理图片上传或其他
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[[Utility Share] userId] forKey:@"uid"];
    [dic setValue:[[Utility Share] userToken] forKey:@"token"];
    [self uploadImageDic:dic iamgeData:imgData];
   
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}



-(void)uploadImageDic:(NSDictionary *)dic iamgeData:(NSData *)imgData{
 
    [NetEngine uploadFileAction:YDcirclechatUpload fileData:imgData withParams:dic fileKey:@"image" fileName:@"ios_message.jpg" onCompletion:^(id resData, BOOL isCache) {
        if ([[resData valueForJSONStrKey:@"status"] isEqualToString:@"200"]) {
            NSMutableDictionary *message = [NSMutableDictionary dictionary];
            
            
            [message setValue:[[Utility Share] userId] forKey:@"from_client_id"];//自己的id
            [message setValue:[[Utility Share] userToken] forKey:@"token"];
            [message setValue:[[Utility Share] userName] forKey:@"uname"];
            [message setValue:[[Utility Share] userLogo] forKey:@"uicon"];
            [message setValue:[self.otherInfo valueForJSONStrKey:@"order_no"] forKey:@"order_no"];
            
            if ([[self.otherInfo valueForJSONStrKey:@"type"] isEqualToString:@"2"]) {
                [message setValue:@"zcw_roomsay" forKey:@"type"];
                [message setValue:[self.otherInfo valueForJSONStrKey:@"id"] forKey:@"room_id"];//群ID
                [message setValue:@"all" forKey:@"to_client_id"];//聊天对象id
            }else{
                [message setValue:@"zcw_say" forKey:@"type"];
                [message setValue:[self.otherInfo valueForJSONStrKey:@"id"] forKey:@"to_client_id"];//聊天对象id
                
                
            }

            /*
             types":"1"//消息类型（1:文本消息，2:图片消息 3:语音消息，4：视频消息，5：抖动，6：定位，7：分享）
             "content":"",	//文本消息内容
             "image":@{@"path":@"http://806165851_695.jpg",@"small_path":@"http://1_695.jpg"},	//图片消息内容
             "voice":{@"voiceUrl":http://xxxx,@"voiceLength":@"5"},	//语音消息内容
             "video":"",	//视频消息内容
             "content":"",	//文本消息内容
             "shake":"",	//抖动
             "lng":"",	    //定位（经度）
             "lat":"",	    //定位（纬度）
             "address":"",  //定位（地址）
             "share":"",	//分享消息内容
             */
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:@"2" forKey:@"types"];
            [dic setValue:@"图片" forKey:@"content"];
            [dic setValue:[resData objectForJSONKey:@"data"] forKey:@"image"];
            [message setObject:dic  forKey:@"content"];
            
            [[Utility Share] WebSocketsend:[message JSONString_l]];
            
            
            
            NSMutableDictionary *mysendMessage = [NSMutableDictionary dictionary];
            [mysendMessage setValue:@"1" forKey:@"types"];//我自己发的
            [mysendMessage setValue:[[Utility Share] userName] forKey:@"name"];
            [mysendMessage setValue:[[Utility Share] userLogo] forKey:@"head"];
            [mysendMessage setValue:[[Utility Share] userId] forKey:@"id"];
            [mysendMessage setValue:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]] forKey:@"createtime"];
            [mysendMessage setObject:dic  forKey:@"content"];
            [tbDataArray insertObject:mysendMessage atIndex:0];
            
            
            [self refreshTabelView];
        }else{
            [SVProgressHUD showImage:nil status:@"发送失败"];
        }
    } onError:^(NSError *error) {
        
    } withMask:(SVProgressHUDMaskTypeNone)];
}



#pragma mark MessageContentVoiceBubbleTableViewCellDelegate
-(void)MessageContentVoiceBubbleTableViewCell:(MessageContentVoiceBubbleTableViewCell *)sview PlaybackAudio:(NSIndexPath *)index{
    tempPlayIndex=index;
}
-(void)MessageContentVoiceBubbleTableViewCellStopPlay:(MessageContentVoiceBubbleTableViewCell *)sview{
    tempPlayIndex=nil;
}
-(void)MessageContentVoiceBubbleTableViewCell:(MessageContentVoiceBubbleTableViewCell *)sview clickedUserLogo:(NSDictionary *)userDic{
    
}
-(void)MessageContentVoiceBubbleTableViewCell:(MessageContentVoiceBubbleTableViewCell *)sview iconLongPress:(NSDictionary *)userDic{
    if ([[self.otherInfo valueForJSONStrKey:@"type"] isEqualToString:@"2"]) {//群
        if ([_currentInputContent notEmptyOrNull]) {
            _currentInputContent=[NSString stringWithFormat:@"%@ @%@ ",_currentInputContent,[userDic valueForJSONStrKey:@"name"]];
        }else{
            _currentInputContent=[NSString stringWithFormat:@"@%@ ",[userDic valueForJSONStrKey:@"name"]];
            
        }
        [self showKeyBoard];
    }
   
}
#pragma mark MessageContentImageTableViewCellDelegate,MessageContentTxtTableViewCellDelegate
-(void)MessageContentImageTableViewCell:(MessageContentImageTableViewCell *)messageContentImageTableViewCell iconDidClick:(NSDictionary *)dic{
    
}
-(void)MessageContentImageTableViewCell:(MessageContentImageTableViewCell *)messageContentImageTableViewCell iconLongPress:(NSDictionary *)dic{
    if ([[self.otherInfo valueForJSONStrKey:@"type"] isEqualToString:@"2"]) {//群
        if ([_currentInputContent notEmptyOrNull]) {
            _currentInputContent=[NSString stringWithFormat:@"%@ @%@ ",_currentInputContent,[dic valueForJSONStrKey:@"name"]];
        }else{
            _currentInputContent=[NSString stringWithFormat:@"@%@ ",[dic valueForJSONStrKey:@"name"]];
            
        }
        [self showKeyBoard];
    }
    
}
-(void)MessageContentImageTableViewCell:(MessageContentImageTableViewCell *)messageContentImageTableViewCell reviewImages:(NSDictionary *)dic index:(NSIndexPath *)indexPath{
    
    if (!imageReview) {
        imageReview =[[XHImageUrlViewer alloc]init];
    }
    
    
    NSArray *arrayIndex=[dictAllImage allKeys];
    NSComparator cmptemp = ^(id obj1, id obj2){
        if ([obj1 doubleValue]>[obj2 doubleValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([obj1 doubleValue]<[obj2 doubleValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    
    NSArray *keyS = [arrayIndex sortedArrayUsingComparator:cmptemp];
    NSMutableArray *arrayTemp=[[NSMutableArray alloc]init];
    for (NSString *strindex in keyS) {
        [arrayTemp addObject:@{@"cacheUrl":[[[dictAllImage objectForJSONKey:strindex] objectForJSONKey:@"image"] valueForJSONStrKey:@"small_path"],@"url":[[[dictAllImage objectForJSONKey:strindex] objectForJSONKey:@"image"] valueForJSONStrKey:@"path"]}];
    }
    
    
    [imageReview showWithImageDatas:arrayTemp selectedIndex:[keyS indexOfObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]];
    
}

////点击头像
-(void)messageContentTxtTableViewCell:(MessageContentTxtTableViewCell *)sview clickedUserLogo:(NSDictionary *)userDic{
    
}
-(void)messageContentTxtTableViewCell:(MessageContentTxtTableViewCell *)sview iconLongPress:(NSDictionary *)dic{
    if ([[self.otherInfo valueForJSONStrKey:@"type"] isEqualToString:@"2"]) {//群
        if ([_currentInputContent notEmptyOrNull]) {
            _currentInputContent=[NSString stringWithFormat:@"%@ @%@ ",_currentInputContent,[dic valueForJSONStrKey:@"name"]];
        }else{
            _currentInputContent=[NSString stringWithFormat:@"@%@ ",[dic valueForJSONStrKey:@"name"]];
            
        }
        [self showKeyBoard];
    }
   
}



///处理键盘弹出影响
-(void)showKeyBoard{
    //改变语音按钮、输入框
    [messageInput.voiceButton setImage:[UIImage imageNamed:@"talkIcon"] forState:UIControlStateNormal];
    messageInput.voiceButton.tag = DDVoiceInput;//语音
    [messageInput willBeginInput];
    
    if ([_currentInputContent length] > 0 )
    {
        [messageInput.textView setText:_currentInputContent];
    }
    
//    _bottomShowComponent = _bottomShowComponent & DDHideEmotion;
    
    [messageInput.emotionbutton setImage:[UIImage imageNamed:@"dd_input_normal"] forState:UIControlStateNormal];
    [messageInput.textView becomeFirstResponder];
    _bottomShowComponent =(_bottomShowComponent & DDHideEmotion)| (_bottomShowComponent & DDHideUtility ) | DDShowKeyboard;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
