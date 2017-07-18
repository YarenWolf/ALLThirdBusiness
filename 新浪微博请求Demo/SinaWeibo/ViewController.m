//
//  ViewController.m
//  SinaWeibo
//
//  Created by Stephy_xue on 13-9-25.
//  Copyright (c) 2013年 Stephy_xue. All rights reserved.
//

#import "ViewController.h"

#import "LoginViewController.h"
#import "LPSinaEngine.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)dealloc
{
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_scroll setContentSize:CGSizeMake(320, 1460)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case 1://登录
        {
            if (![LPSinaEngine isAuthorized])
            {
                LoginViewController *loginVC = [[LoginViewController alloc] initWithLoginCompletion:^(BOOL isSuccess){
                    if (isSuccess) {
                        [self showAlertView:@"登录成功"];
                    }
                    else{
                        [self showAlertView:@"登录失败"];
                    }
                }];
                [self presentViewController:loginVC animated:YES completion:nil];
                [loginVC release];
            }
            else{
                [self showAlertView:@"已经登录"];
            }
        }
            break;
        case 2:// 登出
            [LPSinaEngine logout];
            [self showAlertView:@"已经登出"];
            break;
        case 3:// 获取用户信息
        {
            NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:SINA_USER_ID_KEY];
            [LPSinaEngine getUserInfo:uid
                              success:^(BOOL isSuccess, User *aUser)
             {
                 if (isSuccess) {
                     [self showAlertView:[NSString stringWithFormat:@"获取用户信息成功\n用户ID：%@",aUser.userId]];
                 }

             }];
        }
            break;
        case 4:// 验证昵称是否可用
        {
            [LPSinaEngine verifyNickName:@"夏贝贝"
                                 success:^(BOOL isSuccess, BOOL isLegal, NSMutableArray *array) {
                if (isSuccess) {
                    [self showAlertView:[NSString stringWithFormat:@"推荐了%d个昵称",[array count]]];
                }
            }];
        }
            break;
        case 5:// 发送普通文字微博
            [LPSinaEngine sendStatus:@"发送普通文字微博"
                             picData:nil
                            latFloat:+39.9
                           longFloat:+116.38
                             visible:0
                              listId:nil
                             success:^(BOOL isSuccess, Status *aStatus)
             {
                 if (isSuccess) {
                     [self showAlertView:[NSString stringWithFormat:@"发送微博成功\n微博内容：%@",aStatus.text]];
                 }
             }];
            break;
        case 6:// 发送有图片的微博
        {
            NSData *data = UIImagePNGRepresentation([UIImage imageNamed:@"icon.png"]);
            
            [LPSinaEngine sendStatus:@"发送微博并上传图片"
                             picData:data
                            latFloat:+39.9
                           longFloat:+116.38
                             visible:0
                              listId:@""
                             success:^(BOOL isSuccess, Status *aStatus)
             {
                 if (isSuccess) {
                     [self showAlertView:[NSString stringWithFormat:@"发送微博并上传图片成功\n图片地址：%@",aStatus.bmiddlePic]];
                 }
             }];
        }
            break;
        case 7:// 转发一条微博
        {
            [LPSinaEngine repostStatusWithStatusId:@"3629319139826696"
                                           content:@"我转发了这条微博"
                                         isComment:0 success:^(BOOL isSuccess, Status *aStatus)
             {
                 if (isSuccess) {
                     [self showAlertView:[NSString stringWithFormat:@"转发微博成功\n我的内容：%@",aStatus.text]];
                 }
             }];
        }
            break;
        case 8:// 删除一条微博
        {
            [LPSinaEngine destroyStatusWithStatusId:@"3629686036690081"
                                            success:^(BOOL isSuccess, Status *aStatus)
             {
                 if (isSuccess) {
                     [self showAlertView:[NSString stringWithFormat:@"删除微博成功\n该条微博的ID：%@",aStatus.statusId]];
                 }
             }];
        }
            break;
        case 9:// 获取好友微博
        {
            [LPSinaEngine getStatusesWithSinceId:0
                                           maxId:0
                                           count:20
                                            page:1
                                         feature:0
                                        trimUser:0
                                         success:^(BOOL isSuccess, NSMutableArray *array)
             {
                 if (isSuccess) {
                     [self showAlertView:[NSString stringWithFormat:@"共获取%d条微博",array.count]];
                 }
             }];
        }
            break;
        case 10:// 获取双向关注用户的最新微博
        {
            [LPSinaEngine getBilateralStatusesWithSinceId:0
                                                    maxId:0
                                                    count:20
                                                     page:1
                                                  feature:0
                                                 trimUser:0
                                                  success:^(BOOL isSuccess, NSMutableArray *array)
             {
                 if (isSuccess) {
                     [self showAlertView:[NSString stringWithFormat:@"共获取%d条微博",array.count]];
                 }
             }];
        }
            break;
        case 11:// 获取当前或某一用户的微博
        {
            NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:SINA_USER_ID_KEY];
            [LPSinaEngine getStatusesWithUId:uid
                                orScreenName:nil
                                     sinceId:0
                                       maxId:0
                                       count:20
                                        page:1
                                     feature:0
                                    trimUser:0
                                     success:^(BOOL isSuccess, NSMutableArray *array)
             {
                 if (isSuccess) {
                     [self showAlertView:[NSString stringWithFormat:@"共获取%d条微博",array.count]];
                 }
             }];
        }
            break;
        case 12:// 获取某一微博转发微博列表
        {
            [LPSinaEngine getRepostStatusesWithStatusId:@"3629319139826696"
                                                SinceId:0
                                                  maxId:0
                                                  count:20
                                                   page:1
                                         filterByAuthor:0
                                                success:^(BOOL isSuccess, NSMutableArray *array)
             {
                 if (isSuccess) {
                     [self showAlertView:[NSString stringWithFormat:@"共获取%d条转播的微博",array.count]];
                 }
             }];
        }
            break;
        case 13:// 获取@我的微博
        {
            [LPSinaEngine getMentionsStatusesWithSinceId:0
                                                   maxId:0
                                                   count:20
                                                    page:1
                                          filterByAuthor:0
                                          filterBySource:0
                                            filterByType:0
                                                 success:^(BOOL isSuccess, NSMutableArray *array)
             {
                 if (isSuccess) {
                     [self showAlertView:[NSString stringWithFormat:@"共获取%d条@我的微博",array.count]];
                 }
             }];
        }
            break;
        case 14:// 获取微博官方表情
        {
            [LPSinaEngine getEmotionsWithType:@"face"
                                     language:@"cnname"
                                      success:^(BOOL isSuccess, NSMutableArray *array)
             {
                 if (isSuccess) {
                     [self showAlertView:[NSString stringWithFormat:@"共获取%d个表情",array.count]];
                 }
             }];
        }
            break;
        case 15:// 对微博进行评论
        {
            [LPSinaEngine creatComment:@"测试发送评论的。。。"
                              statusId:@"3629319139826696"
                            commentOri:0
                               success:^(BOOL isSuccess, Comment *aComment){
                                   if (isSuccess) {
                                       [self showAlertView:[NSString stringWithFormat:@"评论成功\n该条评论ID：%@",aComment.commentId]];
                                   }
                               }];
        }
            break;
        case 16:// 删除一条评论
        {
            [LPSinaEngine destroyCommentWithCommentId:@"3629812251394736"
                                              success:^(BOOL isSuccess, Comment *aComment)
             {
                 if (isSuccess) {
                     [self showAlertView:[NSString stringWithFormat:@"删除评论成功\n该条评论的微博的ID：%@",aComment.status.statusId]];
                 }
             }];
        }
            break;
        case 17:// 回复一条评论
        {
            [LPSinaEngine replyCommentWithCommentId:@"3589200982840375"
                                           statusId:@"3587740060818203"
                                            content:@"正在测试回复一条评论呢"
                                     withoutMention:0
                                         commentOri:0
                                            success:^(BOOL isSuccess, Comment *aComment)
             {
                 if (isSuccess) {
                     [self showAlertView:[NSString stringWithFormat:@"回复评论成功\n该条评论的内容：%@",aComment.text]];
                 }
             }];
        }
            break;
        case 18:// 根据微博ID获取评论
        {
            [LPSinaEngine getCommentsWithStatusId:@"3629319139826696"
                                          sinceId:0
                                            maxId:0
                                            count:50
                                             page:1
                                   filterByAuthor:0
                                          success:^(BOOL isSuccess, NSMutableArray *array)
             {
                 if (isSuccess) {
                     [self showAlertView:[NSString stringWithFormat:@"共获取%d条评论",array.count]];
                 }
             }];
        }
            break;
        case 19:// 我发出的评论
        {
            [LPSinaEngine getCommentsByMeWithSinceId:0
                                               maxId:0
                                               count:50
                                                page:1
                                      filterBySource:0
                                             success:^(BOOL isSuccess, NSMutableArray *array)
             {
                 if (isSuccess) {
                     [self showAlertView:[NSString stringWithFormat:@"共获取%d条评论",array.count]];
                 }
             }];
        }
            break;
        case 20:// 我收到的评论
        {
            [LPSinaEngine getComments2MeWithSinceId:0
                                              maxId:0
                                              count:50
                                               page:1
                                     filterByAuthor:0
                                     filterBySource:0
                                            success:^(BOOL isSuccess, NSMutableArray *array)
             {
                 if (isSuccess) {
                     [self showAlertView:[NSString stringWithFormat:@"共获取%d条评论",array.count]];
                 }
             }];
        }
            break;
        case 21:// 当前用户的评论
        {
            [LPSinaEngine getCommentsWithSinceId:0
                                           maxId:0
                                           count:50
                                            page:1
                                        trimUser:0
                                         success:^(BOOL isSuccess, NSMutableArray *array)
             {
                 if (isSuccess) {
                     [self showAlertView:[NSString stringWithFormat:@"共获取%d条评论",array.count]];
                 }
             }];
        }
            break;
        case 22:// 获取@我的评论
        {
            [LPSinaEngine getMentionsCommentsWithSinceId:0
                                                   maxId:0
                                                   count:50
                                                    page:1
                                          filterByAuthor:0
                                          filterBySource:0
                                                 success:^(BOOL isSuccess, NSMutableArray *array)
             {
                 if (isSuccess) {
                     [self showAlertView:[NSString stringWithFormat:@"共获取%d条评论",array.count]];
                 }
             }];
        }
            break;
        case 23:// 用户关注的列表
        {
            NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:SINA_USER_ID_KEY];
            [LPSinaEngine getFriendsOrFollowersWithUId:uid
                                          orScreenName:nil
                                                  flag:0
                                                 count:50
                                                cursor:0
                                            trimStatus:0
                                               success:^(BOOL isSuccess, NSMutableArray *array, NSString *nextCursor, NSString *previousCursor, NSString *totalNumber) {
                                                   if (isSuccess) {
                                                       [self showAlertView:[NSString stringWithFormat:@"共关注了%@个用户",totalNumber]];
                                                   }
                                               }];
            
        }
            break;
        case 24:// 用户粉丝的列表
        {
            [LPSinaEngine getFriendsOrFollowersWithUId:@"2097190395"
                                          orScreenName:nil
                                                  flag:1
                                                 count:50
                                                cursor:0
                                            trimStatus:0
                                               success:^(BOOL isSuccess, NSMutableArray *array, NSString *nextCursor, NSString *previousCursor, NSString *totalNumber) {
                                                   if (isSuccess) {
                                                       [self showAlertView:[NSString stringWithFormat:@"共有%@个粉丝",totalNumber]];
                                                   }
                                               }];
            
        }
            break;
        case 25:// 添加一个关注
        {
            [LPSinaEngine creatOrDestroyFriendWithUserId:@"2097190395"
                                              screenName:@"FIT随享微博客户端"
                                                    flag:0
                                                 success:^(BOOL isSuccess, User *aUser) {
                if (isSuccess) {
                    [self showAlertView:[NSString stringWithFormat:@"添加关注成功\n用户id：%@",aUser.userId]];
                }
            }];
        }
            break;
        case 26:// 取消关注一个用户
        {
            [LPSinaEngine creatOrDestroyFriendWithUserId:@"2097190395"
                                              screenName:@"FIT随享微博客户端"
                                                    flag:1
                                                 success:^(BOOL isSuccess, User *aUser) {
                if (isSuccess) {
                    [self showAlertView:[NSString stringWithFormat:@"取消关注成功\n用户id：%@",aUser.userId]];
                }
            }];
        }
            break;
        case 27:// 收藏一条微博
        {
            [LPSinaEngine creatOrDestroyFavoriteWithStatusId:@"3629319139826696"
                                                        flag:0
                                                     success:^(BOOL isSuccess, Favorite *aFavorite){
                                                         if (isSuccess) {
                                                             [self showAlertView:[NSString stringWithFormat:@"收藏成功\n该条微博的ID：%@",aFavorite.status.statusId]];
                                                         }
                                                     }];
        }
            break;
        case 28:// 删除一条收藏
        {
            [LPSinaEngine creatOrDestroyFavoriteWithStatusId:@"3629319139826696"
                                                        flag:1
                                                     success:^(BOOL isSuccess, Favorite *aFavorite)
             {
                 if (isSuccess) {
                     [self showAlertView:[NSString stringWithFormat:@"删除收藏成功\n该条微博的ID：%@",aFavorite.status.statusId]];
                 }
             }];
        }
            break;
        case 29:// 获取当前用户的收藏
        {
            [LPSinaEngine getFavoriteWithFlag:0
                                        count:50
                                         page:1
                                      success:^(BOOL isSuccess, NSMutableArray *array)
             {
                 if (isSuccess) {
                     [self showAlertView:[NSString stringWithFormat:@"共获取%d条收藏",array.count]];
                 }
             }];
        }
            break;
        case 30:// 获取热门话题
        {
            [LPSinaEngine getTrendsWithFlag:0
                                    success:^(BOOL isSuccess, NSMutableArray *array) {
                if (isSuccess) {
                    [self showAlertView:[NSString stringWithFormat:@"获取了%d个热门话题",[array count]]];
                }
            }];
        }
            break;
        case 31:// 搜索时的联想搜索建议
        {
            [LPSinaEngine searchSuggestionWithQStr:@"一" flag:0 count:10 type:0 range:2 success:^(BOOL isSuccess, NSMutableArray *array) {
                if (isSuccess) {
                    [self showAlertView:[NSString stringWithFormat:@"获取了%d个搜索建议",[array count]]];
                }
            }];
        }
            break;
        case 32:// 短链转长链
        {
            [LPSinaEngine convertUrlWithFlag:1 urlStr:@"http://t.cn/zRbxCGr" success:^(BOOL isSuccess, NSMutableArray *array) {
                if (isSuccess) {
                    Urls *url = [array objectAtIndex:0];
                    [self showAlertView:[NSString stringWithFormat:@"转化后的长链\n%@",url.urlLong]];
                }
            }];
        }
            break;
        case 33:// 获取附近地点
        {
            [LPSinaEngine getNearbyPoisWithLatFloat:+39.9
                                          longFloat:+116.38
                                              range:2000
                                              count:20
                                               page:1
                                               sort:1
                                             offset:0
                                            success:^(BOOL isSuccess, NSMutableArray *array) {
                                              if (isSuccess) {
                                                  [self showAlertView:[NSString stringWithFormat:@"共获取了%d个附近地点",[array count]]];
                                              }
                                          }];
        }
            break;
        case 34:// 根据坐标获取附近发微博的人
        {
            [LPSinaEngine getNearbyUsersWithFlag:0
                                        latFloat:+39.9
                                       longFloat:+116.38
                                           range:2000
                                           count:20
                                            page:1
                                       startTime:0
                                         endTime:0
                                            sort:1
                                          offset:0
                                         success:^(BOOL isSuccess, NSMutableArray *array) {
                if (isSuccess) {
                    [self showAlertView:[NSString stringWithFormat:@"共获取了%d个附近发微博的人",[array count]]];
                }
            }];
        }
            break;
        case 35:// 根据坐标获取附近的微博
        {
            [LPSinaEngine getNearbyUsersWithFlag:1
                                        latFloat:+39.9
                                       longFloat:+116.38
                                           range:2000
                                           count:20
                                            page:1
                                       startTime:0
                                         endTime:0
                                            sort:1
                                          offset:0
                                         success:^(BOOL isSuccess, NSMutableArray *array) {
                                             if (isSuccess) {
                                                 [self showAlertView:[NSString stringWithFormat:@"共获取了%d个附近的微博",[array count]]];
                                             }
                                         }];
        }
            break;
        case 36:// 获取好友的位置动态
        {
            [LPSinaEngine getPlaceStatusesWithSinceId:0
                                                maxId:0
                                                count:20
                                                 page:1
                                                 type:0
                                              success:^(BOOL isSuccess, NSMutableArray *array)
             {
                 if (isSuccess) {
                     [self showAlertView:[NSString stringWithFormat:@"共获取%d条微博",array.count]];
                 }
             }];
        }
            break;
        case 37:// 获取当前用户或某个用户的位置动态
        {
            NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:SINA_USER_ID_KEY];
            [LPSinaEngine getPlaceStatusesWithUId:uid
                                          sinceId:0
                                            maxId:0
                                            count:20
                                             page:1
                                          success:^(BOOL isSuccess, NSMutableArray *array)
             {
                 if (isSuccess) {
                     [self showAlertView:[NSString stringWithFormat:@"共获取%d条微博",array.count]];
                 }
             }];
        }
            break;
        default:
            break;
    }
}

- (void)showAlertView:(NSString *)str
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

@end
