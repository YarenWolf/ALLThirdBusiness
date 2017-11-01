//
//  JSMessageInputView.m
//



#import "JSMessageInputView.h"
#import "EmojiModule.h"

#define SEND_BUTTON_WIDTH 78.0f


@interface JSMessageInputView ()

- (void)setup;
- (void)setupTextView;
- (void)setupRecordButton;
@end



@implementation JSMessageInputView

@synthesize sendButton;

#pragma mark - Initialization
- (id)initWithFrame:(CGRect)frame delegate:(id<JSMessageInputViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if(self) {
        [self setup];
        _delegate = delegate;
        [self setAutoresizesSubviews:NO];
    }
    return self;
}

- (void)dealloc
{
    self.textView = nil;
    self.sendButton = nil;
}

- (BOOL)resignFirstResponder
{
    [self.textView resignFirstResponder];
    return [super resignFirstResponder];
}

+ (JSInputBarStyle)inputBarStyle
{
    return JSInputBarStyleDefault;
}
- (UIImage *)inputBar
{
    if ([JSMessageInputView inputBarStyle] == JSInputBarStyleFlat)
        return [UIImage imageNamed:@"input-bar-flat"];
    else      // jSInputBarStyleDefault
        return [[UIImage imageNamed:@"input-bar"] resizableImageWithCapInsets:UIEdgeInsetsMake(19.0f, 3.0f, 19.0f, 3.0f)];
}
#pragma mark - Setup
- (void)setup
{
    self.image = [self inputBar];
    self.backgroundColor = [UIColor whiteColor];
    
    self.opaque = YES;
    self.userInteractionEnabled = YES;
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
    line.backgroundColor=[UIColor colorWithRed:188/255.0 green:188/255.0 blue:188/255.0 alpha:1.0];
    [self addSubview:line];
    [self setupTextView];
    self.emotionbutton  = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.emotionbutton setImage:[UIImage imageNamed:@"dd_emotion"] forState:UIControlStateNormal];
    self.emotionbutton.frame=CGRectMake(kScreenWidth-84, 0.0f, 44.0f, 44.0f);
    //    self.emotionbutton.backgroundColor=[UIColor redColor];
    [self setSendButton:self.emotionbutton];
    self.showUtilitysbutton  = [UIButton  buttonWithType:UIButtonTypeCustom];
    [self.showUtilitysbutton setImage:[UIImage imageNamed:@"dd_utility"] forState:UIControlStateNormal];
    self.showUtilitysbutton.frame=CGRectMake(kScreenWidth-40, 0.0f, 40.0f, 44.0f);
    [self.showUtilitysbutton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
    [self addSubview:self.showUtilitysbutton];
    
    self.voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.voiceButton setImage:[UIImage imageNamed:@"dd_record_normal"] forState:UIControlStateNormal];
    self.voiceButton.tag = 0;
    self.voiceButton.frame = CGRectMake(3, 0.0, 44.0f, 44.0f);
    [self addSubview:self.voiceButton];
    [self setupRecordButton];
}

- (void)setupTextView
{
    //    CGFloat width = self.frame.size.width - SEND_BUTTON_WIDTH;
    CGFloat height = [JSMessageInputView textViewLineHeight];
    //    88+38
    self.textView = [[HPGrowingTextView  alloc] initWithFrame:CGRectMake(48, 7.0f, kScreenWidth-134, height)];///320.0*[UIScreen mainScreen].bounds.size.width
    //    self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.font = [UIFont systemFontOfSize:15];
    self.textView.minHeight = 31;
    self.textView.maxNumberOfLines = 5;
    self.textView.animateHeightChange = YES;
    self.textView.animationDuration = 0.25;
    self.textView.delegate = self;
    self.textView.isScrollable = NO;
    self.textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    self.textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    
    [self.textView.layer setBorderWidth:0.5];
    [self.textView.layer setBorderColor:[UIColor colorWithRed:188/255.0 green:188/255.0 blue:188/255.0 alpha:1.0].CGColor];
    [self.textView.layer setCornerRadius:4];
    self.textView.returnKeyType = UIReturnKeySend;
    [self addSubview:self.textView];
}

- (void)setupRecordButton
{
    //    CGFloat width = self.frame.size.width - SEND_BUTTON_WIDTH;
    CGFloat height = [JSMessageInputView textViewLineHeight];
    
    
    self.recordButton = [[UIButton alloc] initWithFrame:CGRectMake(48, 7.0f, W(self.textView), height)];
    self.recordButton.backgroundColor=[UIColor whiteColor];
    self.recordButton.layer.borderColor=[RGBACOLOR(100, 100, 100, 0.6) CGColor];
    self.recordButton.layer.borderWidth=0.5;
    self.recordButton.layer.cornerRadius=4;
    
    [self.recordButton setTitleColor:rgbTxtDeepGray forState:UIControlStateNormal];
    [self.recordButton setTitle:@"按住 说话" forState:UIControlStateNormal];
    [self.recordButton setTitle:@"松手 发送" forState:UIControlStateSelected];
    [self.recordButton setUserInteractionEnabled:YES];
    
    [self.recordButton setHidden:YES];
    [self.recordButton setOpaque:YES];
    [self addSubview:self.recordButton];
    
    
    
}

#pragma mark - HPTextViewDelegate
//- (BOOL)growingTextViewShouldBeginEditing:(HPGrowingTextView *)growingTextView;
//- (BOOL)growingTextViewShouldEndEditing:(HPGrowingTextView *)growingTextView;

//- (void)growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView;
//- (void)growingTextViewDidEndEditing:(HPGrowingTextView *)growingTextView;

- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@""]) {
        //删除键
        
        NSString* toDeleteString = nil;
        if (growingTextView.text.length == 0)
        {
            return NO;
        }
        if (growingTextView.text.length == 1)
        {
            growingTextView.text = @"";
        }else
        {
            
            int length=1;
            if (growingTextView.text.length >= 3){
                length=3;//表情最少3个长度
                toDeleteString = [growingTextView.text substringFromIndex:growingTextView.text.length -length];
                //                DLog(@"toDeleteString___3___:%@",toDeleteString);
                if ([toDeleteString hasSuffix:@"]"]) {
                    //是否以“]”结尾
                    if (![toDeleteString hasPrefix:@"["]) {//是否以“]”开始
                        //不是
                        length=4;
                        toDeleteString = [growingTextView.text substringFromIndex:growingTextView.text.length -length];
                        //                        DLog(@"toDeleteString___4___:%@",toDeleteString);
                        if (![toDeleteString hasPrefix:@"["]) {//是否以“]”开始
                            //不是
                            length=5;//表情标志最多5个长度
                            toDeleteString = [growingTextView.text substringFromIndex:growingTextView.text.length -length];
                            //                            DLog(@"toDeleteString___5___:%@",toDeleteString);
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
            
            growingTextView.text = [growingTextView.text substringToIndex:growingTextView.text.length - length];
        }
        
        
        
        return NO;
    }
    if ([text isEqual:@"\n"])
    {
        [self.delegate textViewEnterSend];
        return NO;
    }
    return YES;
}
//- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView;

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float bottom = self.bottom;
    if ([growingTextView.text length] == 0)
    {
        [self setHeight:height + 13];
    }
    else
    {
        [self setHeight:height + 10];
    }
    [self setBottom:bottom];
    //    [growingTextView setContentInset:UIEdgeInsetsZero];
    //    [UIView animateKeyframesWithDuration:0.25 delay:0 options:0 animations:^{
    //
    //    } completion:^(BOOL finished) {
    //
    //    }];
    [self.delegate viewheightChanged:height];
}

//- (void)growingTextView:(HPGrowingTextView *)growingTextView didChangeHeight:(float)height
//{
//}

//- (void)growingTextViewDidChangeSelection:(HPGrowingTextView *)growingTextView;
- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView
{
    return YES;
}


#pragma mark - Setters
- (void)setSendButton:(UIButton *)btn
{
    if(sendButton)
        [sendButton removeFromSuperview];
    
    sendButton = btn;
    [self addSubview:self.sendButton];
}

#pragma mark - Message input view

+ (CGFloat)textViewLineHeight
{
    return 32.0f; // for fontSize 16.0f
}

+ (CGFloat)maxLines
{
    return 5.0f;
}

+ (CGFloat)maxHeight
{
    return ([JSMessageInputView maxLines] + 1.0f) * [JSMessageInputView textViewLineHeight];
}

- (void)willBeginRecord
{
    [self.textView setHidden:YES];
    [self.recordButton setHidden:NO];
}

- (void)willBeginInput
{
    [self.textView setHidden:NO];
    [self.recordButton setHidden:YES];
}
-(void)setDefaultHeight
{
    
}
- (CGFloat)bottom {
    return self.top + self.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setBottom:(CGFloat)bottom {
    if(bottom == self.bottom){
        return;
    }
    
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}
- (CGFloat)height {
    return self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setHeight:(CGFloat)height {
    if(height == self.height){
        return;
    }
    
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
- (CGFloat)top {
    return self.frame.origin.y;
}
- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}




@end
