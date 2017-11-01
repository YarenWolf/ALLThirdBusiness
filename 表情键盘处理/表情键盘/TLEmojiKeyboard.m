#import "TLEmojiKeyboard.h"
#import "TLEmojiItemCell.h"
#import "TLEmojiFaceItemCell.h"
#import "TLEmojiImageItemCell.h"
#import "TLEmojiImageTitleItemCell.h"
#import "TLExpressionViewController.h"
#import "TLMyExpressionViewController.h"
#define     HEIGHT_CHAT_KEYBOARD            215.0f
#define     HEIGHT_EMOJIVIEW            (HEIGHT_CHAT_KEYBOARD * 0.8)
#define     HEIGHT_PAGECONTROL          HEIGHT_CHAT_KEYBOARD * 0.1
#define     HEIGHT_GROUPCONTROL         HEIGHT_CHAT_KEYBOARD * 0.2
typedef NS_ENUM(NSInteger, TLChatBarStatus) {
    TLChatBarStatusInit,
    TLChatBarStatusVoice,
    TLChatBarStatusEmoji,
    TLChatBarStatusMore,
    TLChatBarStatusKeyboard,
};
static TLEmojiKeyboard *emojiKB;
@interface TLEmojiKeyboard()<UICollectionViewDelegate,UICollectionViewDataSource>{
    CGSize cellSize;
    CGSize headerReferenceSize;
    CGSize footerReferenceSize;
    CGFloat minimumLineSpacing;
    CGFloat minimumInteritemSpacing;
    UIEdgeInsets sectionInsets;
}
@end
@implementation TLEmojiKeyboard
static UICollectionViewCell *lastCell;
+ (TLEmojiKeyboard *)keyboard{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        emojiKB = [[TLEmojiKeyboard alloc] init];
    });return emojiKB;
}
- (id)init{
    if (self = [super init]) {
        UICollectionViewFlowLayout *Mylayout = [[UICollectionViewFlowLayout alloc]init];
        Mylayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        Mylayout.itemSize = CGSizeMake(50, 50);//cellSize
        Mylayout.headerReferenceSize = headerReferenceSize;
        Mylayout.footerReferenceSize = footerReferenceSize;
        Mylayout.minimumInteritemSpacing = 20;//minimumInteritemSpacing//格
        Mylayout.minimumLineSpacing = 20;//minimumLineSpacing//行
        Mylayout.sectionInset = UIEdgeInsetsMake(20, 20, 0,20);//sectionInsets
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, HEIGHT_EMOJIVIEW) collectionViewLayout:Mylayout];
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        [_collectionView setPagingEnabled:YES];
        [_collectionView setDataSource:self];
        [_collectionView setDelegate:self];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [_collectionView setScrollsToTop:NO];
        _collectionView.backgroundColor = gradcolor;
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, YH(_collectionView)-HEIGHT_PAGECONTROL, kScreenWidth, HEIGHT_PAGECONTROL)];
        _pageControl.centerX = self.centerX;
        [_pageControl setPageIndicatorTintColor:[UIColor grayColor]];
        [_pageControl setCurrentPageIndicatorTintColor:[UIColor greenColor]];
        [_pageControl addTarget:self action:@selector(pageControlChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.collectionView];
        [self addSubview:self.pageControl];
        
        UIButton *addIcon = [[UIButton alloc]initWithFrame:CGRectMake(0, YH(_pageControl), HEIGHT_GROUPCONTROL, HEIGHT_GROUPCONTROL)];
        [addIcon setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
        [addIcon addTarget:self action:@selector(downLoadNewEmoji) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addIcon];
        
        _groupEmojiScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(HEIGHT_GROUPCONTROL, Y(addIcon), kScreenWidth-2*HEIGHT_GROUPCONTROL, HEIGHT_GROUPCONTROL)];
        _groupEmojiScrollView.showsVerticalScrollIndicator = _groupEmojiScrollView.showsHorizontalScrollIndicator = NO;
        _groupEmojiScrollView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_groupEmojiScrollView];
        _sendButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-HEIGHT_GROUPCONTROL,Y(addIcon), HEIGHT_GROUPCONTROL, HEIGHT_GROUPCONTROL)];
        [_sendButton setImage:[UIImage imageNamed:@"settings"] forState:UIControlStateNormal];
        [_sendButton addTarget:self action:@selector(settingsEmojiView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_sendButton];
        [self.collectionView registerClass:[TLEmojiItemCell class] forCellWithReuseIdentifier:@"TLEmojiItemCell"];
        [self.collectionView registerClass:[TLEmojiFaceItemCell class] forCellWithReuseIdentifier:@"TLEmojiFaceItemCell"];
        [self.collectionView registerClass:[TLEmojiImageItemCell class] forCellWithReuseIdentifier:@"TLEmojiImageItemCell"];
        [self.collectionView registerClass:[TLEmojiImageTitleItemCell class] forCellWithReuseIdentifier:@"TLEmojiImageTitleItemCell"];
    }return self;
}
-(void)downLoadNewEmoji{
    UIViewController *curentVC = (UIViewController*)self.delegate;
    [curentVC.navigationController pushViewController:[[TLExpressionViewController alloc]init] animated:YES];
}
-(void)settingsEmojiView{
    UIViewController *curentVC = (UIViewController*)self.delegate;
    [curentVC.navigationController pushViewController:[[TLMyExpressionViewController alloc]init] animated:YES];
}

//FIXME: Public Methods
- (void)reset{
    [self selectedEmojiGroupWithIndex:0];
    [self.collectionView scrollRectToVisible:CGRectMake(0, 0, self.collectionView.width, self.collectionView.height) animated:NO];
}
- (void)setEmojiGroupData:(NSMutableArray *)emojiGroupData{
    for(int i=0;i<emojiGroupData.count;i++){
        TLEmojiGroup *group1 = emojiGroupData[i];
        TLEmojiGroup *group2 = _emojiGroupData[i];
        if([group1.groupID isEqualToString:group2.groupID]){
            return;
        }
    }
    _emojiGroupData = emojiGroupData;
    float insetX = 5;
    for(int i=0;i<emojiGroupData.count;i++){
        UIButton *icon = [[UIButton alloc]initWithFrame:CGRectMake(insetX, 3, HEIGHT_GROUPCONTROL-6, HEIGHT_GROUPCONTROL-6)];
        TLEmojiGroup *grou = emojiGroupData[i];
        [icon setImage:[UIImage imageNamed:grou.groupIconPath] forState:UIControlStateNormal];
        icon.layer.cornerRadius = 5;
        icon.clipsToBounds = YES;
        icon.tag = i;
        [icon addTarget:self action:@selector(selectEmojiGroup:) forControlEvents:UIControlEventTouchUpInside];
        [_groupEmojiScrollView addSubview:icon];
        insetX+=HEIGHT_GROUPCONTROL;
    }
    
    [self selectedEmojiGroupWithIndex:0];
}
-(void)selectEmojiGroup:(UIButton*)sender{
    [self selectedEmojiGroupWithIndex:sender.tag];
}
- (void)showInView:(UIView *)view withAnimation:(BOOL)animation;{
    if (_delegate && [_delegate respondsToSelector:@selector(chatKeyboardWillShow:)]) {
        [_delegate chatKeyboardWillShow:self];
    }
    [view addSubview:self];
//    self.frame = CGRectMake(0, kScreenHeight-HEIGHT_CHAT_KEYBOARD, kScreenWidth, HEIGHT_CHAT_KEYBOARD);
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(view);
        make.height.mas_equalTo(HEIGHT_CHAT_KEYBOARD);
        make.bottom.mas_equalTo(view).mas_offset(HEIGHT_CHAT_KEYBOARD);
    }];
    [view layoutIfNeeded];
    if (animation) {
        [UIView animateWithDuration:0.3 animations:^{
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(view);
            }];
            [view layoutIfNeeded];
            if (_delegate && [_delegate respondsToSelector:@selector(chatKeyboard:didChangeHeight:)]) {
                [_delegate chatKeyboard:self didChangeHeight:view.height - self.y];
            }
        } completion:^(BOOL finished) {
            if (_delegate && [_delegate respondsToSelector:@selector(chatKeyboardDidShow:)]) {
                [_delegate chatKeyboardDidShow:self];
            }
        }];
    }else {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(view);
        }];
        [view layoutIfNeeded];
        if (_delegate && [_delegate respondsToSelector:@selector(chatKeyboardDidShow:)]) {
            [_delegate chatKeyboardDidShow:self];
        }
    }
    if (_delegate && [_delegate respondsToSelector:@selector(emojiKeyboard:selectedEmojiGroupType:)]) {
        [_delegate emojiKeyboard:self selectedEmojiGroupType:self.curGroup.type];
    }
}
-(void)selectedEmojiGroupWithIndex:(NSInteger)index{
    TLEmojiGroup *group = [self.emojiGroupData objectAtIndex:index];
    self.curGroup = group;
    [self resetCollectionSize];
    [self.pageControl setNumberOfPages:group.pageNumber];
    [self.pageControl setCurrentPage:0];
    [self.collectionView reloadData];
    [self.collectionView scrollRectToVisible:CGRectMake(0, 0, self.collectionView.width, self.collectionView.height) animated:NO];
    // 更新chatBar的textView状态
    if (self.delegate && [self.delegate respondsToSelector:@selector(emojiKeyboard:selectedEmojiGroupType:)]) {
        [self.delegate emojiKeyboard:self selectedEmojiGroupType:group.type];
    }
}
- (void)dismissWithAnimation:(BOOL)animation{
    if (_delegate && [_delegate respondsToSelector:@selector(chatKeyboardWillDismiss:)]) {
        [_delegate chatKeyboardWillDismiss:self];
    }
    if (animation) {
        [UIView animateWithDuration:0.3 animations:^{
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.superview).mas_offset(HEIGHT_CHAT_KEYBOARD);
            }];
            [self.superview layoutIfNeeded];
            if (_delegate && [_delegate respondsToSelector:@selector(chatKeyboard:didChangeHeight:)]) {
                [_delegate chatKeyboard:self didChangeHeight:self.superview.height - self.y];
            }
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            if (_delegate && [_delegate respondsToSelector:@selector(chatKeyboardDidDismiss:)]) {
                [_delegate chatKeyboardDidDismiss:self];
            }
        }];
    }else {
        [self removeFromSuperview];
        if (_delegate && [_delegate respondsToSelector:@selector(chatKeyboardDidDismiss:)]) {
            [_delegate chatKeyboardDidDismiss:self];
        }
    }
}

#pragma mark private foundations -
// 显示Group表情
- (void)resetCollectionSize{
    float cellHeight,cellWidth,topSpace = 0,btmSpace = 0,hfSpace = 0;
    if (self.curGroup.type == TLEmojiTypeFace || self.curGroup.type == TLEmojiTypeEmoji) {
        cellWidth = cellHeight = (HEIGHT_EMOJIVIEW / self.curGroup.rowNumber) * 0.55;
        topSpace = 11;
        btmSpace = 19;
        hfSpace = (kScreenWidth - cellWidth * self.curGroup.colNumber) / (self.curGroup.colNumber + 1) * 1.4;
    }else if (self.curGroup.type == TLEmojiTypeImageWithTitle){
        cellHeight = (HEIGHT_EMOJIVIEW / self.curGroup.rowNumber) * 0.96;
        cellWidth = cellHeight * 0.8;
        hfSpace = (kScreenWidth - cellWidth * self.curGroup.colNumber) / (self.curGroup.colNumber + 1) * 1.2;
    }else {
        cellWidth = cellHeight = (HEIGHT_EMOJIVIEW / self.curGroup.rowNumber) * 0.72;
        topSpace = 8;
        btmSpace = 16;
        hfSpace = (kScreenWidth - cellWidth * self.curGroup.colNumber) / (self.curGroup.colNumber + 1) * 1.2;
    }
    cellSize = CGSizeMake(cellWidth, cellHeight);
    headerReferenceSize = CGSizeMake(hfSpace, HEIGHT_EMOJIVIEW);
    footerReferenceSize = CGSizeMake(hfSpace, HEIGHT_EMOJIVIEW);
    minimumLineSpacing = (kScreenWidth - hfSpace * 2 - cellWidth * self.curGroup.colNumber) / (self.curGroup.colNumber - 1);
    minimumInteritemSpacing = (HEIGHT_EMOJIVIEW - topSpace - btmSpace - cellHeight * self.curGroup.rowNumber) / (self.curGroup.rowNumber - 1);
    sectionInsets = UIEdgeInsetsMake(topSpace, 0, btmSpace, 0);
    [_collectionView reloadData];
}
- (void) pageControlChanged:(UIPageControl *)pageControl{
    [self.collectionView scrollRectToVisible:CGRectMake(kScreenWidth * pageControl.currentPage, 0, kScreenWidth, HEIGHT_PAGECONTROL) animated:YES];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self.pageControl setCurrentPage:(int)(scrollView.contentOffset.x / kScreenWidth)];
}
- (NSUInteger)transformModelIndex:(NSInteger)index{
    NSUInteger page = index / self.curGroup.pageItemCount;
    index = index % self.curGroup.pageItemCount;
    NSUInteger x = index / self.curGroup.rowNumber;
    NSUInteger y = index % self.curGroup.rowNumber;
    return self.curGroup.colNumber * y + x + page * self.curGroup.pageItemCount;
}
- (NSUInteger)transformCellIndex:(NSInteger)index{
    NSUInteger page = index / self.curGroup.pageItemCount;
    index = index % self.curGroup.pageItemCount;
    NSUInteger x = index / self.curGroup.colNumber;
    NSUInteger y = index % self.curGroup.colNumber;
    return self.curGroup.rowNumber * y + x + page * self.curGroup.pageItemCount;
}
#pragma mark collectionViewDatasource -
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
   return self.curGroup.pageNumber;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.curGroup.pageItemCount;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger index = indexPath.section * self.curGroup.pageItemCount + indexPath.row;
    TLEmojiBaseCell *cell;
    if (self.curGroup.type == TLEmojiTypeEmoji) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TLEmojiItemCell" forIndexPath:indexPath];
    }else if (self.curGroup.type == TLEmojiTypeFace) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TLEmojiFaceItemCell" forIndexPath:indexPath];
    }else if (self.curGroup.type == TLEmojiTypeImageWithTitle) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TLEmojiImageTitleItemCell" forIndexPath:indexPath];
    }else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TLEmojiImageItemCell" forIndexPath:indexPath];
    }
    NSUInteger tIndex = [self transformModelIndex:index];  // 矩阵坐标转置
    NSDictionary *dict =self.curGroup.count > tIndex ? [self.curGroup objectAtIndex:tIndex] : nil;
    TLEmoji *emojiItem =[TLEmoji replaceKeyFromDictionary:dict];
    [cell setEmojiItem:emojiItem];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger index = indexPath.section * self.curGroup.pageItemCount + indexPath.row;
    NSUInteger tIndex = [self transformModelIndex:index];  // 矩阵坐标转置
    if (tIndex < self.curGroup.count) {
        TLEmoji *item = [self.curGroup objectAtIndex:tIndex];
        if (self.delegate && [self.delegate respondsToSelector:@selector(emojiKeyboard:didSelectedEmojiItem:)]) {
            //FIXME: 表情类型
            item.type = self.curGroup.type;
            [self.delegate emojiKeyboard:self didSelectedEmojiItem:item];
        }
    }
}

@end
