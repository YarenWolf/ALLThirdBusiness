//
//  FSVoiceBubble.h
//  Pods
//
//  Created by Wenchao Ding on 3/25/15.
//
//

#import <UIKit/UIKit.h>

@class FSVoiceBubble;

#ifndef IBInspectable
#define IBInspectable
#endif

@protocol FSVoiceBubbleDelegate <NSObject>

- (void)voiceBubbleDidStartPlaying:(FSVoiceBubble *)voiceBubble;

- (void)voiceBubbleDidStopPlaying:(FSVoiceBubble *)voiceBubble;

@end

@interface FSVoiceBubble : UIView

@property (strong, nonatomic) NSString *contentURL;//语音路径
@property (strong, nonatomic) IBInspectable UIColor *textColor;
@property (strong, nonatomic) IBInspectable NSString *textTime;
@property (strong, nonatomic) IBInspectable UIColor *waveColor;
@property (strong, nonatomic) IBInspectable UIColor *animatingWaveColor;
@property (strong, nonatomic) IBInspectable UIImage *bubbleImage;//气泡（左右气泡箭头方向都向左）
@property (assign, nonatomic) IBInspectable BOOL    invert;//是否翻转
@property (assign, nonatomic) IBInspectable BOOL    exclusive;
@property (assign, nonatomic) IBInspectable BOOL    durationInsideBubble;
@property (assign, nonatomic) IBInspectable CGFloat waveInset;
@property (assign, nonatomic) IBInspectable CGFloat textInset;
@property (assign, nonatomic) IBOutlet id<FSVoiceBubbleDelegate> delegate;


- (void)play;
//- (void)pause;
- (void)stop;

- (void)startAnimating;
- (void)stopAnimating;

@end
