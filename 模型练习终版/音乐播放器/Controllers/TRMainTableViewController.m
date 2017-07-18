//
//  TRMainTableViewController.m
//  音乐播放器
#import "TRMainTableViewController.h"
#import "TRMusicTool.h"
#import "TRMusic.h"
#import "TRAudioTool.h"
#import "TRMusicDetailViewController.h"
#import "UIView+Extension.h"
@interface TRMainTableViewController ()
//所有音乐模型对象
@property(nonatomic,strong)NSArray *musicArray;
@property(nonatomic,strong)TRMusicDetailViewController *detailViewController;
@end
@implementation TRMainTableViewController
-(TRMusicDetailViewController *)detailViewController{
    if(!_detailViewController){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        _detailViewController=[storyboard instantiateViewControllerWithIdentifier:@"Detail"]; 
    }return _detailViewController;
}

-(NSArray *)musicArray{
    if(!_musicArray){
        _musicArray=[TRMusicTool musicArray];
    }return _musicArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"musicCell"];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.musicArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"musicCell" forIndexPath:indexPath];
    TRMusic *music= self.musicArray[indexPath.row];
    cell.imageView.image=[UIImage imageNamed:music.singerIcon];
    cell.textLabel.text=music.name;
    cell.detailTextLabel.text=music.singer;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
//点击cell触发方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [TRAudioTool stopAudioWithFileName:[TRMusicTool currentPlayingMusic].filename];
    [TRMusicTool setCurrentPlayingMusic:self.musicArray[indexPath.row]];
    [self.detailViewController showDetailView];
}

@end
