#import "TLMyExpressionViewController.h"
#import "TLExpressionDetailViewController.h"
#import "TLExpressionHelper.h"
#import "TLEmojiGroup.h"
@protocol TLMyExpressionCellDelegate <NSObject>
- (void)myExpressionCellDeleteButtonDown:(TLEmojiGroup *)group;
@end
@interface TLMyExpressionCell : UITableViewCell
@property (nonatomic, assign) id<TLMyExpressionCellDelegate>delegate;
@property (nonatomic, strong) TLEmojiGroup *group;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *delButton;
@end
@implementation TLMyExpressionCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 40, 40)];
        [self.contentView addSubview:self.iconView];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(XW(_iconView)+10, 10, W(self.contentView)-XW(_iconView)-10, 20)];
        [self.contentView addSubview:self.titleLabel];
        _delButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        [_delButton setTitle:@"移除" forState:UIControlStateNormal];
        [_delButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_delButton setBackgroundColor:[UIColor grayColor]];
        [_delButton.titleLabel setFont:Font(13)];
        [_delButton addTarget:self action:@selector(delButtonDown) forControlEvents:UIControlEventTouchUpInside];
        [_delButton.layer setMasksToBounds:YES];
        [_delButton.layer setCornerRadius:3.0f];
        [_delButton.layer setBorderWidth:1];
        [_delButton.layer setBorderColor:[UIColor grayColor].CGColor];
        [self setAccessoryView:self.delButton];
    }return self;
}
- (void)setGroup:(TLEmojiGroup *)group{
    _group = group;
    [self.iconView setImage:[UIImage imageNamed:group.groupIconPath]];
    [self.titleLabel setText:group.groupName];
}
#pragma mark - Event Response -
- (void)delButtonDown{
    if (_delegate && [_delegate respondsToSelector:@selector(myExpressionCellDeleteButtonDown:)]) {
        [_delegate myExpressionCellDeleteButtonDown:self.group];
    }
}
@end
@interface TLMyExpressionViewController () <TLMyExpressionCellDelegate>
@property (nonatomic, strong) TLExpressionHelper *helper;
@property (nonatomic, strong) NSMutableArray *data;
@end
@implementation TLMyExpressionViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationItem setTitle:@"我的表情"];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"排序" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonDown:)];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    UIBarButtonItem *dismissBarButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonDown:)];
    [self.navigationItem setLeftBarButtonItem:dismissBarButton];
    [self.tableView registerClass:[TLMyExpressionCell class] forCellReuseIdentifier:@"TLMyExpressionCell"];
    self.helper = [TLExpressionHelper sharedHelper];
    self.data = [self.helper myExpressionListData];
}
#pragma mark - Delegate -
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TLEmojiGroup *emojiGroup =self.data[indexPath.row];
    TLMyExpressionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TLMyExpressionCell"];
    [cell setGroup:emojiGroup];
    [cell setDelegate:self];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TLEmojiGroup *emojiGroup = self.data[indexPath.row];
    TLExpressionDetailViewController *detailVC = [[TLExpressionDetailViewController alloc] init];
    [detailVC setGroup:emojiGroup];
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:detailVC animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}
//MARK: TLMyExpressionCellDelegate
- (void)myExpressionCellDeleteButtonDown:(TLEmojiGroup *)group{
    BOOL ok = [self.helper deleteExpressionGroupByID:group.groupID];
    if (ok) {
        NSError *error;
        ok = [[NSFileManager defaultManager] removeItemAtPath:group.path error:&error];
        if (!ok) {DLog(@"删除表情文件失败\n路径:%@\n原因:%@", group.path, [error description]);}
        NSInteger row = [self.data[0] indexOfObject:group];
        [self.data[0] removeObject:group];
        if ([self.data[0] count] == 0) {
            [self.data removeObjectAtIndex:0];
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else {
            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }else {
        [SVProgressHUD showErrorWithStatus:@"表情包删除失败"];
    }
}
#pragma mark - Event Response -
- (void)rightBarButtonDown:(UIBarButtonItem *)sender{
}
- (void)leftButtonDown:(UIBarButtonItem*)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
