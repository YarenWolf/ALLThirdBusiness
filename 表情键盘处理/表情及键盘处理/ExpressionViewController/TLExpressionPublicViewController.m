//
//  TLExpressionPublicViewController.m
#import "TLExpressionPublicViewController.h"
#import "TLExpressionSearchViewController.h"
#import "TLExpressionDetailViewController.h"
#import "MJRefresh.h"
#import "TLExpressionHelper.h"
#import "UIImageView+WebCache.h"
#import "TLEmojiGroup.h"
@interface TLExpressionPublicCell : UICollectionViewCell
@property (nonatomic, strong) TLEmojiGroup *group;
@end
@interface TLExpressionPublicCell ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@end
@implementation TLExpressionPublicCell
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.titleLabel];
        [self p_addMasonry];
    }return self;
}
- (void)setGroup:(TLEmojiGroup *)group{
    _group = group;
    [self.titleLabel setText:group.groupName];
    UIImage *image = [UIImage imageNamed:group.groupIconPath];
    if (image) {
        [self.imageView setImage:image];
    }else {
        [self.imageView sd_setImageWithURL:TLURL(group.groupIconURL) placeholderImage:[UIImage imageNamed:@""]];
    }
}
#pragma mark - # Private Methods
- (void)p_addMasonry{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(self.imageView.mas_width);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.imageView.mas_bottom).mas_offset(7.0f);
        make.width.mas_lessThanOrEqualTo(self.contentView);
    }];
}
#pragma mark - # Getter
- (UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        [_imageView setUserInteractionEnabled:NO];
        [_imageView.layer setMasksToBounds:YES];
        [_imageView.layer setCornerRadius:5.0f];
        [_imageView.layer setBorderWidth:1];
        [_imageView.layer setBorderColor:[UIColor grayColor].CGColor];
    }return _imageView;
}
- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    }return _titleLabel;
}
@end
@interface TLExpressionPublicViewController () <UISearchBarDelegate,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) TLExpressionSearchViewController *searchVC;
@end
@implementation TLExpressionPublicViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    _proxy = [[TLExpressionProxy alloc] init];
    _searchVC = [[TLExpressionSearchViewController alloc] init];
    _searchController = [[UISearchController alloc] initWithSearchResultsController:self.searchVC];
    [_searchController setSearchResultsUpdater:self.searchVC];
    [_searchController.searchBar setPlaceholder:@"搜索表情"];
    [_searchController.searchBar setDelegate:self];
//    _searchController.searchBar.frameY = 64;
//    [self.view addSubview:self.searchController.searchBar];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGRect rect = CGRectMake(0,64, kScreenWidth, kScreenHeight - 64);
    _collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    [_collectionView setAlwaysBounceVertical:YES];
    [_collectionView addSubview:self.searchController.searchBar];
    [self.view addSubview:self.collectionView];
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [footer setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多数据了" forState:MJRefreshStateNoMoreData];
    [self.collectionView setMj_footer:footer];
    [self.collectionView registerClass:[TLExpressionPublicCell class] forCellWithReuseIdentifier:@"TLExpressionPublicCell"];
    [self loadDataWithLoadingView:YES];
}
#pragma mark - # Delegate
- (void)loadDataWithLoadingView:(BOOL)showLoadingView{
    if (showLoadingView) {[SVProgressHUD show];}
    kPageIndex = 1;
    [self.proxy requestExpressionPublicListByPageIndex:kPageIndex success:^(id data) {
        [SVProgressHUD dismiss];
        kPageIndex ++;
        self.data = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in data) {     // 优先使用本地表情
            TLEmojiGroup *group = [TLEmojiGroup replaceKeyFromDictionary:dict];
            TLEmojiGroup *localEmojiGroup = [[TLExpressionHelper sharedHelper] emojiGroupByID:group.groupID];
            if (localEmojiGroup) {
                [self.data addObject:localEmojiGroup];
            }else{
                [self.data addObject:group];
            }
        }
        [self.collectionView reloadData];
    } failure:^(NSString *error) {
        [SVProgressHUD dismiss];
    }];
}
- (void)loadMoreData{
    __weak typeof(self) weakSelf = self;
    [self.proxy requestExpressionPublicListByPageIndex:kPageIndex success:^(NSMutableArray *data) {
        [SVProgressHUD dismiss];
        if (data.count == 0) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.collectionView.mj_footer endRefreshing];
            kPageIndex ++;
            for (NSDictionary *dict in data) {     // 优先使用本地表情
                TLEmojiGroup *group = [TLEmojiGroup replaceKeyFromDictionary:dict];
                TLEmojiGroup *localEmojiGroup = [[TLExpressionHelper sharedHelper] emojiGroupByID:group.groupID];
                if (localEmojiGroup) {
                    [self.data addObject:localEmojiGroup];
                }
                else {
                    [self.data addObject:group];
                }
            }
            [weakSelf.collectionView reloadData];
        }
    } failure:^(NSString *error) {
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        [SVProgressHUD dismiss];
    }];
}
#pragma mark - # Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.data.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TLExpressionPublicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TLExpressionPublicCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[TLExpressionPublicCell alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    }
    TLEmojiGroup *group = self.data[indexPath.item];
    [cell setGroup:group];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    TLEmojiGroup *group = [self.data objectAtIndex:indexPath.row];
    TLExpressionDetailViewController *detailVC = [[TLExpressionDetailViewController alloc] init];
    [detailVC setGroup:group];
    [self.parentViewController setHidesBottomBarWhenPushed:YES];
    [self.parentViewController.navigationController pushViewController:detailVC animated:YES];
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(((kScreenWidth - 80) / 3.0), ((kScreenWidth - 80) / 3.0));
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 30.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 20.0;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(50.0, 20.0, 20.0, 20.0);
}

@end
