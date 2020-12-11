//
//  DFAFilter.m
//  DFAFilterDemo
//
//  Created by winter on 2020/11/18.
//  Copyright © 2020 winter. All rights reserved.
//

#import "DFAFilter.h"

@interface NSString (DFAFilter)
/// 生成重复字符串
- (NSString *)repeating:(int)count;
@end

@interface DFAFilter ()

@property (nonatomic,strong) NSMutableDictionary *keyword_chains;
@property (nonatomic,  copy) NSString *delimit;
@property (nonatomic,  copy) NSString *meaningless;

@end

@implementation DFAFilter

+ (void)asyncInit:(void(^)(DFAFilter *dfa))block;
{
    // 初始化敏感词库
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        DFAFilter *dfaFilter = [[DFAFilter alloc] init];
        [dfaFilter parseSensitiveWords:nil];
        if (block) {
            block(dfaFilter);
        }
    });
}

- (instancetype)init
{
    if(self == [super init]) {
        _delimit = @"\x00";
        _meaningless = @"!@#$%^&*()-=_+\[]{};':,./?<>| ！￥？…《》，。..";
    }
    return self;
}

/// 读取解析敏感词
- (void)parseSensitiveWords:(NSString *)path
{
    if(path == nil) {
        path = [[NSBundle mainBundle] pathForResource:@"shieldwords" ofType:@"txt"];
    }
    NSString *content = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *keyWordList = [content componentsSeparatedByString:@","];
    for (NSString *keyword in keyWordList) {
        [self addSensitiveWords:keyword];
    }
}

- (void)addSensitiveWords:(NSString *)keyword
{
    keyword = keyword.lowercaseString;
    keyword = [keyword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(keyword.length <= 0){
        return;
    }
    
    NSMutableDictionary *node = self.keyword_chains;
    for (int i = 0; i < keyword.length; i ++) {
        NSString *word = [keyword substringWithRange:NSMakeRange(i, 1)];
        if (node[word] == nil) {
            node[word] = [NSMutableDictionary dictionary];
        }
        node = node[word];
    }
    //敏感词最后一个字符标识
    [node setValue:@1 forKey:self.delimit];
}

/// 检查文字中是否包含匹配的字符
/// @param text 待检测的文本
/// @param beginIndex 获取词语的上边界index
/// @return 如果存在，则返回匹配字符的长度，不存在返回0
- (int)checkMatchWord:(NSString *)text beginIndex:(int)beginIndex
{
    BOOL flag = NO;
    int match_flag_length = 0; // 匹配字符的长度
    int tmp_flag = 0; // 包括特殊字符的敏感词的长度
    NSMutableDictionary *nowMap = self.keyword_chains.mutableCopy;
    
    text = text.lowercaseString;
    for (int i = beginIndex; i < text.length; i++) {
        NSString *word = [text substringWithRange:NSMakeRange(i, 1)];
        // 检测是否是特殊字符
        BOOL hasMeaningless = [self.meaningless containsString:word];
        if (hasMeaningless) {
            tmp_flag += 1;
            continue;
        }
        
        nowMap = nowMap[word];
        if (nowMap) {
            // 找到相应key，匹配标识+1
            match_flag_length += 1;
            tmp_flag += 1;
            
            // 如果为最后一个匹配规则，结束循环，返回匹配标识数
            if (nowMap[self.delimit]) {
                // 结束标志位为YES
                flag = YES;
                break;
            }
        }
        else {
            // 不存在，直接返回
            break;
        }
    }
    if (tmp_flag < 2 || !flag) {
        // 长度必须大于等于1，为词
        tmp_flag = 0;
    }
        
    return tmp_flag;
}

/// 获取匹配到的词语
/// @param text 待检测的文本
/// @return 文字中的相匹配词
- (NSArray<NSString *> *)getMatchWord:(NSString *)text
{
    if (!text || text.length < 2) return nil;
    NSMutableArray *array = [NSMutableArray array];
    
    int count = (int)text.length;
    for (int i = 0; i < count; i++) {
        int len = [self checkMatchWord:text beginIndex:i];
        if (len > 0) {
            NSRange range = NSMakeRange(i, len);
            NSString *word = [text substringWithRange:range];
            [array addObject:word];
        }
    }
    return [array copy];
}

/// 判断文字是否包含敏感字符
/// @param text 待检测的文本
/// @return YES/NO
- (BOOL)containsString:(NSString *)text
{
    if (!text || text.length < 2) return nil;
    BOOL flag = NO;
    
    int count = (int)text.length;
    for (int i = 0; i < count; i++) {
        int len = [self checkMatchWord:text beginIndex:i];
        if (len > 0) {
            return YES;
        }
    }
    return flag;
}

/// 替换匹配字符
/// @param text 待检测的文本
/// @param replaceChar 用于替换的字符 默认 *
/// @return 替换敏感字字符后的文本
- (NSString *)replaceSensitiveWord:(NSString *)text replaceChar:(NSString *)replaceChar;
{
    replaceChar = replaceChar ?: @"*";
    NSArray *array = [self getMatchWord:text];
    if (array) {
        NSSet *resSet = [NSSet setWithArray:array];
        for (NSString *word in resSet) {
            NSString *replaceWord = [replaceChar repeating:(int)word.length];
            text = [text stringByReplacingOccurrencesOfString:word withString:replaceWord];
        }
    }
    return text;
}

- (NSMutableDictionary *)keyword_chains{
    if(_keyword_chains == nil){
        _keyword_chains = [[NSMutableDictionary alloc] initWithDictionary:@{}];
    }
    return _keyword_chains;
}

@end

@implementation NSString (DFAFilter)

- (NSString *)repeating:(int)count
{
    if (count > 0) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
        for (int i = 0; i < count; i++) {
            [array addObject:self];
        }
        return [array componentsJoinedByString:@""];
    }
    return self;
}
@end
