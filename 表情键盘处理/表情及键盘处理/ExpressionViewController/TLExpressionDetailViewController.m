//
//  TLExpressionDetailViewController.m
//  Created by 李伯坤 on 16/4/8.
//  Copyright © 2016年 李伯坤. All rights reserved.
#import "TLExpressionDetailViewController.h"
#import "TLExpressionProxy.h"
#import "TLExpressionHelper.h"
#import "UIImageView+WebCache.h"
#import "TLEmojiGroup.h"
#import "UIImage+GIF.h"
@interface TLImageExpressionDisplayView : UIView
@property (nonatomic, strong) TLEmoji *emoji;
@property (nonatomic, assign) CGRect rect;
- (void)displayEmoji:(TLEmoji *)emoji atRect:(CGRect)rect;
@property (nonatomic, strong) UIImageView *imageView;
@end
@implementation TLImageExpressionDisplayView
static NSString *curID;
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:CGRectMake(0, 0, 150, 162)]) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:self.imageView];
    }return self;
}
- (void)displayEmoji:(TLEmoji *)emoji atRect:(CGRect)rect{
    self.y = rect.origin.y - self.height + 13;
    if (_emoji == emoji) {return;}
    _emoji = emoji;
    curID = emoji.emojiID;
    NSData *data = [NSData dataWithContentsOfFile:emoji.emojiPath];
    if (data) {
        [self.imageView setImage:[UIImage sd_animatedGIFWithData:data]];
    }else {
        NSString *urlString = [NSString stringWithFormat:@"http://123.57.155.230:8080/ibiaoqing/admin/expre/download.do?pId=%@",emoji.emojiID];
        [self.imageView sd_setImageWithURL:TLURL(emoji.emojiURL) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSData *data = [NSData dataWithContentsOfURL:TLURL(urlString)];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.imageView setImage:[UIImage sd_animatedGIFWithData:data]];
                });
            });
        }];
    }
}
@end
@interface TLExpressionItemCell : UICollectionViewCell
@property (nonatomic, strong) TLEmoji *emoji;
@property (nonatomic, strong) UIImageView *imageView;
@end
@implementation TLExpressionItemCell
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [_imageView.layer setMasksToBounds:YES];
        [_imageView.layer setCornerRadius:3.0f];
        [self.contentView addSubview:self.imageView];
    }return self;
}
- (void)setEmoji:(TLEmoji *)emoji{
    _emoji = emoji;
    UIImage *image = [UIImage imageNamed:emoji.emojiPath];
    if (image) {
        [self.imageView setImage:image];
    }else {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:emoji.emojiURL]];
    }
}
@end

@interface TLExpressionDetailViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>{
    CGFloat headHeight;
}
@property (nonatomic, strong) TLExpressionProxy *proxy;
@end
@implementation TLExpressionDetailViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    
    
    [self.navigationItem setTitle:self.group.groupName];
    _proxy = [[TLExpressionProxy alloc] init];
    _emojiDisplayView = [[TLImageExpressionDisplayView alloc] init];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    [self.collectionView addSubview:[self creatHeaderViewWithGroup:self.group]];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    [_collectionView setAlwaysBounceVertical:YES];
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[TLExpressionItemCell class] forCellWithReuseIdentifier:@"TLExpressionItemCell"];
    UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] init];
    [longPressGR setMinimumPressDuration:1.0f];
    [longPressGR addTarget:self action:@selector(didLongPressScreen:)];
    [self.collectionView addGestureRecognizer:longPressGR];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] init];
    [tapGR setNumberOfTapsRequired:1];
    [tapGR setNumberOfTouchesRequired:1];
    [tapGR addTarget:self action:@selector(didTap5TimesScreen:)];
    [self.collectionView addGestureRecognizer:tapGR];
}
-(UIView*)creatHeaderViewWithGroup:(TLEmojiGroup*)group{
    headHeight =[self cellHeightForModel:group];
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,headHeight)];
    UIImageView *bannerView = [[UIImageView alloc] init];
    if (group.bannerURL.length > 0) {
        [bannerView sd_setImageWithURL:TLURL(group.bannerURL)];
        [bannerView setFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    }
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,YH(bannerView)+20, 200, 20)];
    UIButton *downloadButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-100,YH(bannerView)+15, 80, 30)];
    [downloadButton setTitle:@"下载" forState:UIControlStateNormal];
    [downloadButton setBackgroundColor:[UIColor greenColor]];
    [downloadButton.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
    [downloadButton.layer setMasksToBounds:YES];
    [downloadButton.layer setCornerRadius:3.0f];
    [downloadButton.layer setBorderWidth:1];
    [downloadButton.layer setBorderColor:[UIColor grayColor].CGColor];
    [downloadButton addTarget:self action:@selector(downloadDetailEmojy:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat detailHeight = [group.groupDetailInfo boundingRectWithSize:CGSizeMake(kScreenWidth - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:13.0f]} context:nil].size.height;
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, YH(downloadButton), kScreenWidth-30, detailHeight)];
    [detailLabel setFont:[UIFont systemFontOfSize:13.0f]];
    [detailLabel setTextColor:[UIColor grayColor]];
    [detailLabel setNumberOfLines:0];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, headHeight-11, kScreenWidth-20, 1)];
    line.backgroundColor = gradcolor;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-100)/2, Y(line)-10, 100, 20)];
    label.backgroundColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [label setTextColor:[UIColor grayColor]];
    [label setFont:[UIFont systemFontOfSize:12.0f]];
    [label setText:@"长按表情可预览"];
   
    [titleLabel setText:group.groupName];
    [detailLabel setText:group.groupDetailInfo];
    if (group.status == TLEmojiGroupStatusDownloaded) {
        [downloadButton setTitle:@"已下载" forState:UIControlStateNormal];
        [downloadButton setBackgroundColor:[UIColor grayColor]];
    }else if (group.status == TLEmojiGroupStatusDownloading) {
        [downloadButton setTitle:@"下载中" forState:UIControlStateNormal];
        [downloadButton setBackgroundColor:[UIColor greenColor]];
    }else {
        [downloadButton setTitle:@"下载" forState:UIControlStateNormal];
        [downloadButton setBackgroundColor:[UIColor greenColor]];
    }
    [headerView addSubviews:bannerView,titleLabel,downloadButton,detailLabel,line,label,nil];
    return headerView;
}
- (void)downloadDetailEmojy:(UIButton*)sender{
    [[TLExpressionHelper sharedHelper] downloadExpressionsWithGroupInfo:_group progress:^(CGFloat progress) {
    } success:^(TLEmojiGroup *group) {
        group.status = TLEmojiGroupStatusDownloaded;
        [self.collectionView reloadData];
        BOOL ok = [[TLExpressionHelper sharedHelper] addExpressionGroup:group];
        if (!ok) {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"表情 %@ 存储失败！", group.groupName]];
        }
    } failure:^(TLEmojiGroup *group, NSString *error) {
        group.status = TLEmojiGroupStatusUnDownload;
        [self.collectionView reloadData];
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"\"%@\" 下载失败: %@", group.groupName, error]];
    }];
}
- (CGFloat)cellHeightForModel:(TLEmojiGroup *)group{
    CGFloat detailHeight = [group.groupDetailInfo boundingRectWithSize:CGSizeMake(kScreenWidth - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:13.0f]} context:nil].size.height;
    CGFloat bannerHeight = group.bannerURL.length > 0 ? kScreenWidth * 0.45 : 0;
    CGFloat height = 70 + detailHeight + bannerHeight;
    return height;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.group.data == nil) {
        [SVProgressHUD show];
        [self p_loadData];
    }
}
- (void)didLongPressScreen:(UILongPressGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled) {        // 长按停止
        [self.emojiDisplayView removeFromSuperview];
    }else {
        CGPoint point = [sender locationInView:self.collectionView];
        for (UICollectionViewCell *cell in self.collectionView.visibleCells) {
            if (cell.x <= point.x && cell.y <= point.y && cell.x + cell.width >= point.x && cell.y + cell.height >= point.y) {
                NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
                TLEmoji *emoji = [self.group objectAtIndex:indexPath.row];
                CGRect rect = cell.frame;
                rect.origin.y -= (self.collectionView.contentOffset.y + 13);
                [self.emojiDisplayView removeFromSuperview];
                [self.emojiDisplayView displayEmoji:emoji atRect:rect];
                [self.view addSubview:self.emojiDisplayView];
                break;
            }
        }
    }
}
- (void)didTap5TimesScreen:(UITapGestureRecognizer *)sender{
    CGPoint point = [sender locationInView:self.collectionView];
    for (UICollectionViewCell *cell in self.collectionView.visibleCells) {
        if (cell.x <= point.x && cell.y <= point.y && cell.x + cell.width >= point.x && cell.y + cell.height >= point.y) {
            NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
            TLEmoji *emoji = [self.group objectAtIndex:indexPath.row];
            [SVProgressHUD showWithStatus:@"正在将表情保存到系统相册"];
            NSString *urlString = [NSString stringWithFormat:@"http://123.57.155.230:8080/ibiaoqing/admin/expre/download.do?pId=%@",emoji.emojiID];
            NSData *data = [NSData dataWithContentsOfURL:TLURL(urlString)];
            if (!data) {
                data = [NSData dataWithContentsOfFile:emoji.emojiPath];
            }
            if (data) {
                UIImage *image = [UIImage imageWithData:data];
                UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
            }
            break;
        }
    }
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        //        [UIAlertView bk_alertViewWithTitle:@"错误" message:[NSString stringWithFormat:@"保存图片到系统相册失败\n%@", [error description]]];
    }else {
        [SVProgressHUD showSuccessWithStatus:@"已保存到系统相册"];
    }
}
#pragma mark - # Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.group.data.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TLExpressionItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TLExpressionItemCell" forIndexPath:indexPath];
    TLEmoji *emoji = [self.group objectAtIndex:indexPath.row];
    [cell setEmoji:emoji];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(((kScreenWidth - 95) / 4.0), ((kScreenWidth - 95) / 4.0));
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 15.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 15.0;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(headHeight, 20.0, headHeight, 20.0);
}
#pragma mark - # Private Methods
- (void)p_loadData{
    __weak typeof(self) weakSelf = self;
    [self.proxy requestExpressionGroupDetailByGroupID:self.group.groupID pageIndex:1 success:^(id data) {
        [SVProgressHUD dismiss];
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:10];
        for(NSDictionary *dict in data){
            [temp addObject:[TLEmoji replaceKeyFromDictionary:dict]];
        }
        weakSelf.group.data = temp;
        [weakSelf.collectionView reloadData];
    } failure:^(NSString *error) {
        [SVProgressHUD dismiss];
    }];
}

@end
