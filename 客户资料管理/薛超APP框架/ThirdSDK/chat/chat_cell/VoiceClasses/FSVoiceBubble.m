//
//  FSVoiceBubble.m
//  Pods
//
//  Created by Wenchao Ding on 3/25/15.
//
//

#import "FSVoiceBubble.h"
#import "UIImage+FSExtension.h"
#import "RecoderAndPlayer.h"


#define kFSVoiceBubbleShouldStopNotification @"FSVoiceBubbleShouldStopNotification"
#define kFSVoiceBubbleAnimationStopNotification @"kFSVoiceBubbleAnimationStopNotification"
#define UIImageNamed(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@", imageName]]

@interface FSVoiceBubble () <RecoderAndPlayerDelegate>{
    RecoderAndPlayer *rcoder;
    NSTimer *timeT;
}


@property (strong, nonatomic) NSArray       *animationImages;
@property (weak  , nonatomic) UIButton      *contentButton;

- (void)initialize;
- (void)voiceClicked:(id)sender;
- (void)bubbleShouldStop:(NSNotification *)notification;

@end

@implementation FSVoiceBubble

@dynamic bubbleImage, textColor;

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = NO;
    if (!rcoder)
    {
        rcoder=[[RecoderAndPlayer alloc]init];
        rcoder.viewDelegate=self;
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImageNamed(@"fs_icon_wave_2") imageWithOverlayColor:self.waveColor]  forState:UIControlStateNormal];
    [button setBackgroundImage:[[UIImage imageNamed:@"byqltbg010630"] stretchableImageWithLeftCapWidth:20 topCapHeight:35] forState:UIControlStateNormal];
    [button setTitle:@"0\"" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(voiceClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor                = [UIColor clearColor];
    button.titleLabel.font                = [UIFont systemFontOfSize:12];
    button.adjustsImageWhenHighlighted    = YES;
    button.imageView.animationDuration    = 0.5;
    button.imageView.animationRepeatCount = 0;
    button.imageView.clipsToBounds        = NO;
    button.imageView.contentMode          = UIViewContentModeCenter;
    button.contentHorizontalAlignment     = UIControlContentHorizontalAlignmentRight;
    [self addSubview:button];
    self.contentButton = button;
    
    self.waveColor = [UIColor colorWithRed:0/255.0 green:102/255.0 blue:51/255.0 alpha:1.0];
    self.textColor = [UIColor grayColor];
    
    _animatingWaveColor = [UIColor whiteColor];
    _exclusive = YES;
    _durationInsideBubble = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bubbleShouldStop:) name:kFSVoiceBubbleShouldStopNotification object:nil];
    //kFSVoiceBubbleAnimationStopNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopAnimating) name:kFSVoiceBubbleAnimationStopNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kFSVoiceBubbleShouldStopNotification object:nil];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _contentButton.frame = self.bounds;
    
    NSString *title = [_contentButton titleForState:UIControlStateNormal];
    if (title && title.length) {
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:[_contentButton titleForState:UIControlStateNormal] attributes:attributes];
        
        
        _contentButton.imageEdgeInsets = UIEdgeInsetsMake(0,
                                                          -self.bounds.size.width + 50 + _waveInset,
                                                          0,
                                                          self.bounds.size.width - 50 + 25 - attributedString.size.width - _waveInset);
        NSInteger textPadding = _invert ? 2 : 4;
        if (_durationInsideBubble) {
            _contentButton.titleEdgeInsets = UIEdgeInsetsMake(1, -8-_textInset, 0, 8+_textInset);
        } else {
            _contentButton.titleEdgeInsets = UIEdgeInsetsMake(self.bounds.size.height - attributedString.size.height,
                                                              attributedString.size.width + textPadding,
                                                              0,
                                                              -attributedString.size.width - textPadding);
        }
        self.layer.transform = _invert ? CATransform3DMakeRotation(M_PI, 0, 1.0, 0) : CATransform3DIdentity;
        _contentButton.titleLabel.layer.transform = _invert ? CATransform3DMakeRotation(M_PI, 0.0, 1.0, 0.0) : CATransform3DIdentity;
        
        
        
        
    }
}

# pragma mark - Setter & Getter

- (void)setWaveColor:(UIColor *)waveColor
{
    if (![_waveColor isEqual:waveColor]) {
        _waveColor = waveColor;
        [_contentButton setImage:[UIImageNamed(@"fs_icon_wave_2") imageWithOverlayColor:waveColor]  forState:UIControlStateNormal];
    }
}

- (void)setInvert:(BOOL)invert
{
    if (_invert != invert) {
        _invert = invert;
        [self setNeedsLayout];
    }
}

- (void)setBubbleImage:(UIImage *)bubbleImage
{
    [_contentButton setBackgroundImage:bubbleImage forState:UIControlStateNormal];
}

- (void)setTextColor:(UIColor *)textColor
{
    [_contentButton setTitleColor:textColor forState:UIControlStateNormal];
}
-(void)setTextTime:(NSString *)textTime{
    [_contentButton setTitle:textTime forState:UIControlStateNormal];
    [self setNeedsLayout];
}
- (UIColor *)textColor
{
    return [_contentButton titleColorForState:UIControlStateNormal];
}

- (UIImage *)bubbleImage
{
    return [_contentButton backgroundImageForState:UIControlStateNormal];
}

- (void)setWaveInset:(CGFloat)waveInset
{
    if (_waveInset != waveInset) {
        _waveInset = waveInset;
        [self setNeedsLayout];
    }
}

- (void)setTextInset:(CGFloat)textInset
{
    if (_textInset != textInset) {
        _textInset = textInset;
        [self setNeedsLayout];
    }
}

//- (void)setContentURL:(NSString *)contentURL
//{
//    if (![_contentURL isEqual:contentURL]) {
//        _contentURL = contentURL;
//        if (self.isPlaying) {
//            [self stop];
//        }
//        _contentButton.enabled = NO;
////        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
////            _asset = [[AVURLAsset alloc] initWithURL:contentURL options:@{AVURLAssetPreferPreciseDurationAndTimingKey: @YES}];
////            CMTime duration = _asset.duration;
////            NSInteger seconds = CMTimeGetSeconds(duration);
////            if (seconds > 60) {
////                NSLog(@"A voice audio should't last longer than 60 seconds");
////                _contentURL = nil;
////                _asset = nil;
////                return;
////            }
////            NSData *data = [NSData dataWithContentsOfURL:contentURL];
////            _player = [[AVAudioPlayer alloc] initWithData:data error:NULL];
////            _player.delegate = self;
////            [_player prepareToPlay];
////            dispatch_async(dispatch_get_main_queue(), ^{
////                NSString *title = [NSString stringWithFormat:@"%@\"",@(seconds)];
////                [_contentButton setTitle:title forState:UIControlStateNormal];
////                _contentButton.enabled = YES;
////                [self setNeedsLayout];
////            });
////        });
//    }
//}

- (BOOL)isPlaying
{
    return rcoder.isPlaying;
}


#pragma mark - Nofication

- (void)bubbleShouldStop:(NSNotification *)notification
{
    [self stopAnimating];
    if (rcoder.isPlaying) {
        [self stop];
    }
}

#pragma mark - Target Action

- (void)voiceClicked:(id)sender
{
    //    if (!_contentButton.imageView.isAnimating) {
    //        [[NSNotificationCenter defaultCenter] postNotificationName:kFSVoiceBubbleShouldStopNotification object:nil];
    //        [self startAnimating];
    //    }else{
    //
    //        [self stopAnimating];
    //    }
    //
    
    if (rcoder.playing && _contentButton.imageView.isAnimating) {
        [self stop];
        [self stopAnimating];
        if (_delegate && [_delegate respondsToSelector:@selector(voiceBubbleDidStopPlaying:)]) {
            [_delegate voiceBubbleDidStopPlaying:self];
        }
    } else {
        if (_exclusive) {
            if (_delegate && [_delegate respondsToSelector:@selector(voiceBubbleDidStopPlaying:)]) {
                [_delegate voiceBubbleDidStopPlaying:self];
            }
            //关闭其他播放
            [[NSNotificationCenter defaultCenter] postNotificationName:kFSVoiceBubbleShouldStopNotification object:nil];
        }
        [self play];
        if (_delegate && [_delegate respondsToSelector:@selector(voiceBubbleDidStartPlaying:)]) {
            [_delegate voiceBubbleDidStartPlaying:self];
        }
    }
}


#pragma mark - Public

- (void)startAnimating
{
    if (!_contentButton.imageView.isAnimating) {
        timeT=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(OnTimer) userInfo:nil repeats:YES];
        UIImage *image0 = [UIImageNamed(@"fs_icon_wave_0") imageWithOverlayColor:_animatingWaveColor];
        UIImage *image1 = [UIImageNamed(@"fs_icon_wave_1") imageWithOverlayColor:_animatingWaveColor];
        UIImage *image2 = [UIImageNamed(@"fs_icon_wave_2") imageWithOverlayColor:_animatingWaveColor];
        _contentButton.imageView.animationImages = @[image0, image1, image2];
        [_contentButton.imageView startAnimating];
        
    }
}

- (void)stopAnimating
{
    
    [timeT invalidate];
    if (_contentButton.imageView.isAnimating) {
        [_contentButton.imageView stopAnimating];
    }
}


-(void)OnTimer {
    if ( [_contentButton.imageView  isAnimating] )
    {
        // still animating
    }
    else
    {
        // Animating done
        [timeT invalidate];
        [_contentButton setImage:[UIImageNamed(@"fs_icon_wave_2") imageWithOverlayColor:_waveColor]  forState:UIControlStateNormal];
    }
    
}

- (void)play
{
    
    if (!_contentURL || ![_contentURL length]) {
        NSLog(@"ContentURL of voice bubble was not set");
        [SVProgressHUD showImage:nil status:@"语音文件损坏！"];
        return;
    }
    if (!rcoder.playing) {
        [rcoder SpeechChatAMR2WAVUrl:self.contentURL];
    }
}


- (void)stop
{
    if (rcoder.playing) {
        [rcoder stopPlaying];
    }
}

#pragma mark RecoderAndPlayerDelegate
//播放完成回调
-(void)playingFinishWithBBS:(BOOL)isFinish{
    //关闭所有动画
    if (_delegate && [_delegate respondsToSelector:@selector(voiceBubbleDidStopPlaying:)]) {
        [_delegate voiceBubbleDidStopPlaying:self];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kFSVoiceBubbleAnimationStopNotification object:nil];
    //    [self stopAnimating];
}
-(void)playingStartWithBBS{
    [self startAnimating];
    
}



@end
