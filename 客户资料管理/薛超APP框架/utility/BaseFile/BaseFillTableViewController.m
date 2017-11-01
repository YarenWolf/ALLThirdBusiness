//
//  BaseFillTableViewController.m
//  薛超APP框架
//
//  Created by 薛超 on 16/10/11.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import "BaseFillTableViewController.h"
#import "UIImage+expanded.h"
#import "selecttypeView.h"
#import "DatePickView.h"
@implementation SBaseGroup
@end
#pragma mark UITableViewCell
@interface SBaseCell(){
}
@end
@implementation SBaseCell
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"common";
    SBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SBaseCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = Font(15);
        self.detailTextLabel.font = [UIFont systemFontOfSize:14];
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView = self.selectedBackgroundView = [[UIImageView alloc] init];
        self.imageView.image = nil;
        self.textLabel.text = nil;
        self.detailTextLabel.text = nil;
        self.accessoryView = nil;
        self.cellArray = nil;
        self.isFill = NO;
    }return self;
}
-(void)initUI{};
-(NSArray *)observableKeypaths{
    return nil;
}
-(void)deallocTableCell{};
- (void)layoutSubviews{
    [super layoutSubviews];// 调整子标题的x
}
-(void)setIcon:(NSString *)icon{
    _icon = icon;
    self.imageView.image = [UIImage imageNamed:icon];
}
-(void)setTitle:(NSString *)title{
    _title = title;
    self.textLabel.text = title;
}
-(void)setSubtitle:(NSString *)subtitle{
    _subtitle = subtitle;
    self.detailTextLabel.text = [NSString stringWithFormat:@"%@",subtitle];
}
-(void)setBadgeValue:(NSString *)badgeValue{
    _badgeValue = badgeValue;
    if(!self.bageView){
        self.bageView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
        self.bageView.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.bageView setTitleColor:RGBCOLOR(148, 148, 148) forState:UIControlStateNormal];
        [self.bageView  setBackgroundImage:[UIImage resizableImageWithName:@"main_badge"] forState:UIControlStateNormal];
    }
    [self.bageView  setTitle:badgeValue forState:UIControlStateNormal];
    self.accessoryView = self.bageView;
}
-(void)setRightArrow:(UIImageView *)rightArrow{
    _rightArrow = rightArrow;
    //    self.rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_right"]];
    self.accessoryView = self.rightArrow = rightArrow;
}
-(void)setRightSwitch:(UISwitch *)rightSwitch{
    _rightSwitch = rightSwitch;
    self.accessoryView = rightSwitch;
}
-(void)setRightLabel:(UILabel *)rightLabel{
    _rightLabel = rightLabel;
    rightLabel.textAlignment = NSTextAlignmentRight;
    _rightLabel.textColor = [UIColor lightGrayColor];
    _rightLabel.font = [UIFont systemFontOfSize:13];
    self.accessoryView = _rightLabel;
}
-(void)setValue:(NSString *)value{
    _value = value;
    //    if(!_rightLabel){
    //       self.rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-self.textLabel.frameWidth, H(self))];
    //    }self.rightLabel.text = value;
    self.subtitle = value;
}
-(void)setIsFill:(BOOL)isFill{
    _isFill = isFill;
    if(isFill){
        UITextField *fill = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, APPW-self.textLabel.frameWidth, H(self))];
        fill.delegate = self;
        [self.contentView addSubview:fill];
    }
}
-(void)setCellArray:(NSArray *)cellArray{
    if(!self.cellArray){
        _cellArray = [NSArray array];
    }
    _cellArray = cellArray;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    self.value = [textField.text isEqualToString:@""]?self.value:textField.text;
    [textField endEditing:YES];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if([textField.text isEqualToString:@""]){
        if(![self.value notEmptyOrNull])return;
    }else{
        self.value = textField.text;
    }
    textField.text = @"";
    self.returnTextBlock(self.value,self.indexpath);
}
- (void)returnText:(ReturnTextBlock)block {
    self.returnTextBlock = block;
}
@end

#pragma mark BaseStaticTableView
@interface BaseFillTableViewController(){
    selecttypeView *typeView;
}
@end
@implementation BaseFillTableViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    self.realname = [[Utility Share]userName];
    self.phone = [[Utility Share]userphone];
    self.areaPickView = [[AreaPickView alloc]init];
    self.values = [NSMutableDictionary dictionaryWithCapacity:15];
    self.pictures = [NSMutableArray arrayWithCapacity:1];
    [self.values setObject:@"" forKey:@"info"];
    self.c1 = [SBaseCell cellWithTableView:(UITableView*)self.tableView];
    self.areaPickView.delegate = self;self.areaPickView.datasource = self;
    self.tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, 30, APPW, APPH-44) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}
-(void)setTableFootView:(UIView *)tableFootView{
    _tableFootView = tableFootView;
    self.tableView.tableFooterView = tableFootView;
}
- (NSMutableArray *)groups{
    if (_groups == nil) {
        self.groups = [NSMutableArray array];
    }return _groups;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    SBaseGroup *group = self.groups[section];
    return group.items.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SBaseCell *cell = [SBaseCell cellWithTableView:tableView];
    SBaseGroup *group = self.groups[indexPath.section];
    cell = group.items[indexPath.row];
    cell.indexpath = indexPath;
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, H(cell)-1, APPW, 1)];line.backgroundColor = gradcolor;[cell addSubview:line];
    if(cell.cellArray){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        __weak __typeof__(SBaseCell)*weakc = cell;
        if (!cell.subtitle) {
            cell.detailTextLabel.text = cell.cellArray[0];
            [self.values setObject:cell.cellArray[0] forKey:[NSString stringWithFormat:@"%ld%ld",cell.indexpath.section,cell.indexpath.row]];
        }
        cell.operation = ^{
            typeView.hidden = !typeView.hidden;
            if(!typeView){
                typeView = [[selecttypeView alloc]init];
                [typeView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(typeViewAction)]];
                typeView.backgroundColor = gradcolor;
                [self.tableView addSubview:typeView];
            }
            typeView.frame = CGRectMake(0, weakc.frameHeight*indexPath.row+5*indexPath.section+64+10, APPW, weakc.cellArray.count*44);
            [typeView setdatawitharr:weakc.cellArray withselexttext:weakc.cellArray[0] wihtimage:@"icon_gou02"];
            __weak __typeof__(selecttypeView)*weakT = typeView;WS(weakself)
            [typeView setSelectypeveiwblock:^(NSString *value) {
                weakT.hidden = YES;
                weakc.subtitle = value;
                [weakself.values setObject:value forKey:[NSString stringWithFormat:@"%ld%ld",weakc.indexpath.section,weakc.indexpath.row]];
            }];
        };
    }
    [cell returnText:^(NSString *showText, NSIndexPath *path) {
        [self.values setObject:showText forKey:[NSString stringWithFormat:@"%ld%ld",path.section,path.row]];
    }];
    return cell;
}
-(void)typeViewAction{
    typeView.hidden = YES;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    SBaseGroup *group = self.groups[section];
    return group.header;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    SBaseGroup *group = self.groups[section];
    return group.footer;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {return nil;}
    UILabel *label = [[UILabel alloc] init] ;
    label.frame = CGRectMake(20, 0, CGRectGetWidth(tableView.frame)-20, 20);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = blacktextcolor;
    label.shadowColor = [UIColor whiteColor];
    label.shadowOffset = CGSizeMake(0.0, 1.0);
    label.font = [UIFont boldSystemFontOfSize:16];
    label.text = sectionTitle;
    label.textAlignment = NSTextAlignmentCenter;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 20)];
    view.backgroundColor=gradcolor;
    [view addSubview:label];
    return view;
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    NSString *sectionTitle = [self tableView:tableView titleForFooterInSection:section];
    if (sectionTitle == nil) {return nil;}
    UILabel *label = [[UILabel alloc] init] ;
    label.frame = CGRectMake(20, 0, CGRectGetWidth(tableView.frame)-20, 20);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = blacktextcolor;
    label.shadowColor = [UIColor whiteColor];
    label.shadowOffset = CGSizeMake(0.0, 1.0);
    label.font = [UIFont boldSystemFontOfSize:16];
    label.text = sectionTitle;
    label.textAlignment = NSTextAlignmentCenter;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 20)];
    view.backgroundColor=gradcolor;
    [view addSubview:label];
    return view;
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 1.取出这行对应的item模型
    SBaseGroup *group = self.groups[indexPath.section];
    SBaseCell *cell = group.items[indexPath.row];
    // 2.判断有无需要跳转的控制器
    if (cell.destVcClass) {
        [self pushController:[cell.destVcClass class] withInfo:nil withTitle:cell.title];
    }
    // 3.判断有无想执行的操作
    if (cell.operation) {
        cell.operation();
    }
}

#pragma mark - Action
-(void)idcardoneAction:(UIButton*)sender{
    self.pictype = sender.tag;
    UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相册" otherButtonTitles:@"拍照", nil];
    action.tag = 200;
    [action showInView:self.view];
}
#pragma mark UIActionSheet
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (!self.ipc) {
        self.ipc=[[UIImagePickerController alloc]init];
        self.ipc.delegate=self;
    }
    if (buttonIndex==0) {//打开相册
        self.ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.ipc.allowsEditing = YES;
        [self presentViewController:self.ipc animated:YES completion:^{if (Version7) {[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault];}}];
    }else if (buttonIndex==1){
        //判断当前相机是否可用
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){// 打开相机
            self.ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
            self.ipc.allowsEditing = YES;
            [self presentViewController:self.ipc animated:YES completion:^{
            }];
        }else{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"设备不可用..." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil ];
            [alert show];
        }
    }
}
#pragma mark pickerC
//设备协议
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image1=[info objectForKey:UIImagePickerControllerOriginalImage];
    float t_w=image1.size.width>640?640:image1.size.width;
    float t_h= t_w/image1.size.width * image1.size.height;
    //处理图片
    UIImage *imageTmpeLogo=[self imageWithImageSimple:image1 scaledToSize:CGSizeMake(t_w, t_h)];
    [self.pictures addObject:imageTmpeLogo];
    [self dismissViewControllerAnimated:YES completion:^{}];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:^{}];
}
//压缩图片
-(UIImage*)imageWithImageSimple:(UIImage*)image1 scaledToSize:(CGSize)newSize{
    UIGraphicsBeginImageContext(newSize);
    [image1 drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
#pragma mark - textfielededelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];typeView.hidden = YES;
    return YES;
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
   [self.view endEditing:YES];typeView.hidden = YES;
}
#pragma mark  使用
-(void)fillTheAddress:(NSDictionary *)a :(NSDictionary *)b :(NSDictionary *)c{
    self.province = a;
    self.city = b;
    self.area = c;
    NSArray *aarea = [NSArray arrayWithObjects:a,b,c, nil];
    [self.values setObject:aarea forKey:[NSString stringWithFormat:@"%ld%ld",self.c1.indexpath.section,self.c1.indexpath.row]];
    //    area1.text = [NSString stringWithFormat:@"%@-%@-%@",a[@"name"],b[@"name"],c[@"name"]];
    //    areaValue = area1.text;
}
- (NSArray *)areaPickerData:(AreaPickView *)picker{
    return nil;
}
@end
