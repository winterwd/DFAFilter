//
//  DFAFilter.h
//  DFAFilterDemo
//
//  Created by winter on 2020/11/18.
//  Copyright © 2020 winter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DFAFilter : NSObject
/// 异步初始化敏感词库
+ (void)asyncInit:(void(^)(DFAFilter *dfa))block;

/// 读取敏感词
/// @param path 敏感词的路径
- (void)parseSensitiveWords:(NSString *)path;

/// 添加敏感词到敏感词树
/// @param keyword 敏感词
- (void)addSensitiveWords:(NSString *)keyword;

//////////////////////////////////////////////////////////

/// 获取匹配到的词语
/// @param text 待检测的文本
/// @return 文字中的相匹配词
- (NSArray<NSString *> *)getMatchWord:(NSString *)text;

/// 检查文字中是否包含匹配的字符
/// @param text 待检测的文本
/// @param beginIndex 获取词语的上边界index
/// @return 如果存在，则返回匹配字符的长度，不存在返回0
- (int)checkMatchWord:(NSString *)text beginIndex:(int)beginIndex;

/// 判断文字是否包含敏感字符
/// @param text 待检测的文本
/// @return YES/NO
- (BOOL)containsString:(NSString *)text;

/// 替换匹配字符
/// @param text 待检测的文本
/// @param replaceChar 用于替换的字符 默认 *
/// @return 替换敏感字字符后的文本
- (NSString *)replaceSensitiveWord:(NSString *)text replaceChar:(NSString *)replaceChar;
@end
