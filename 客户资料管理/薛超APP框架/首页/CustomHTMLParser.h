//
//  CustomHTMLParser.h
//  薛超APP框架
//
//  Created by 薛超 on 16/10/28.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomHTMLParser : NSObject
-(NSArray*)parseWithData:(NSData*)data;
@end
