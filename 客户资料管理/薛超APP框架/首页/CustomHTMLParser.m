//
//  CustomHTMLParser.m
//  薛超APP框架
//
//  Created by 薛超 on 16/10/28.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import "CustomHTMLParser.h"


@interface CustomHTMLParser()<NSXMLParserDelegate>
@property (nonatomic, strong) NSXMLParser *par;
@property (nonatomic, copy) NSString *currentElement;//标记当前标签，以索引找到XML文件内容
@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic ,strong)NSMutableArray *ps;
@property (nonatomic ,strong)NSString *value;
@property (nonatomic, assign)BOOL isName;
@end

@implementation CustomHTMLParser
//几个代理方法的实现，是按逻辑上的顺序排列的，但实际调用过程中中间三个可能因为循环等问题乱掉顺序
//开始解析
- (void)parserDidStartDocument:(NSXMLParser *)parser{
    DLog(@"开始解析...");
}
//准备节点
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict{
    self.currentElement = elementName;
}
//获取节点内容
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if ([self.currentElement isEqualToString:@"td"]||[self.currentElement isEqualToString:@"a"]||[self.currentElement isEqualToString:@"div"]){
        self.value = string;
    }
}
//解析完一个节点
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName{
    if ([elementName isEqualToString:@"td"]||[self.currentElement isEqualToString:@"a"]||[self.currentElement isEqualToString:@"div"]) {
        [self.ps addObject:self.value];
    }
    self.currentElement = nil;
}
//解析结束
- (void)parserDidEndDocument:(NSXMLParser *)parser{
    DLog(@"解析结束...");
}
-(NSArray*)parseWithData:(NSData *)data{
    self.par = [[NSXMLParser alloc]initWithData:data];
    self.par.delegate = self;
    self.ps = [NSMutableArray arrayWithCapacity:10];
    [self.par parse];
    return self.ps;
}
@end

