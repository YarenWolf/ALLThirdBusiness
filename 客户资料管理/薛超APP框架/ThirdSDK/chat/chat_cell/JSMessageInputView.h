//
//  JSMessageInputView.h
//


#import <UIKit/UIKit.h>
//#import "JSMessageTextView.h"
#import "HPGrowingTextView.h"
typedef enum
{
    JSInputBarStyleDefault,
    JSInputBarStyleFlat
} JSInputBarStyle;


@protocol JSMessageInputViewDelegate <NSObject>

- (void)viewheightChanged:(float)height;
- (void)textViewEnterSend;

@end


@interface JSMessageInputView : UIImageView<HPGrowingTextViewDelegate>

@property (strong) HPGrowingTextView *textView;
@property (strong) UIButton *sendButton;
@property (strong) UIButton *showUtilitysbutton;
@property (strong) UIButton *voiceButton;
@property (strong) UIButton *recordButton;
@property (strong) UIButton *emotionbutton;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat bottom;
@property (assign) id<JSMessageInputViewDelegate> delegate;
#pragma mark - Initialization
- (id)initWithFrame:(CGRect)frame delegate:(id<JSMessageInputViewDelegate>)delegate;

#pragma mark - Message input view
//- (void)adjustTextViewHeightBy:(CGFloat)changeInHeight;

+ (CGFloat)textViewLineHeight;
+ (CGFloat)maxLines;
+ (CGFloat)maxHeight;
-(void)setDefaultHeight;
+ (JSInputBarStyle)inputBarStyle;
- (void)willBeginRecord;
- (void)willBeginInput;

@end