//
//  BaseTableViewCell.h
//  薛超APP框架
//
//  Created by 薛超 on 16/9/8.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView *iconV;
@property(nonatomic,strong)UIImageView *picV;
@property(nonatomic,strong)UIView      *line;
@property(nonatomic,strong)UILabel     *titleLabel;
@property(nonatomic,strong)UILabel     *script;
@property(nonatomic,strong)UIView      *cellContentView;
@property(nonatomic,strong)UISwitch    *swich;

+(id) getInstance;
+(NSString*)getTableCellIdentifier;
-(void) deallocTableCell;//子类继承
-(NSArray*)observableKeypaths;//子类继承
-(void)updateUIForKeypath:(NSString*) keyPath;//子类继承

-(void)initUI;
-(void)setDataWithDict:(NSDictionary*)dict;
@end
