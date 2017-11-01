//  TLExpressionViewController.m
#import "TLExpressionViewController.h"
#import "TLExpressionChosenViewController.h"
#import "TLExpressionPublicViewController.h"
#import "TLMyExpressionViewController.h"
@interface TLExpressionViewController ()
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) TLExpressionChosenViewController *expChosenVC;
@property (nonatomic, strong) TLExpressionPublicViewController *expPublicVC;
@end
@implementation TLExpressionViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"精选表情", @"网络表情"]];
    [_segmentedControl setWidth:200];
    [_segmentedControl setSelectedSegmentIndex:0];
    [_segmentedControl addTarget:self action:@selector(segmentedControlChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self.navigationItem setTitleView:self.segmentedControl];
    [self.view addSubview:self.expChosenVC.view];
    [self addChildViewController:self.expChosenVC];
    [self addChildViewController:self.expPublicVC];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonDown)];
    [self.navigationItem setRightBarButtonItem:rightBarButton];
}
#pragma mark - # Event Response
- (void)rightBarButtonDown{
    TLMyExpressionViewController *myExpressionVC = [[TLMyExpressionViewController alloc] init];
    [self setHidesBottomBarWhenPushed:NO];
    [self.navigationController pushViewController:myExpressionVC animated:YES];
}

- (void)segmentedControlChanged:(UISegmentedControl *)segmentedControl{
    if (segmentedControl.selectedSegmentIndex == 0) {
        [self transitionFromViewController:self.expPublicVC toViewController:self.expChosenVC duration:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        } completion:^(BOOL finished) {}];
    }else{
        [self transitionFromViewController:self.expChosenVC toViewController:self.expPublicVC duration:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        } completion:^(BOOL finished) {}];
    }
}

#pragma mark - # Getter
- (TLExpressionChosenViewController *)expChosenVC{
    if (_expChosenVC == nil) {
        _expChosenVC = [[TLExpressionChosenViewController alloc] init];
    }
    return _expChosenVC;
}

- (TLExpressionPublicViewController *)expPublicVC{
    if (_expPublicVC == nil) {
        _expPublicVC = [[TLExpressionPublicViewController alloc] init];
    }
    return _expPublicVC;
}

@end
