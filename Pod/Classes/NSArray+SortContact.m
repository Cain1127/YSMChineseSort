//
//  NSArray+SortContact.m
//  YSMChineseSortDemo
//
//  Created by ysmeng on 15/5/19.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "NSArray+SortContact.h"
#import "ChineseToPinyin.h"

@implementation NSArray (SortContact)

/**
 *  @author         yangshengmeng, 15-05-19 00:05:58
 *
 *  @brief          将给定的对象数组，按中英文排序形成联系人类似的双数据组，此方法表示当前数据内的元素为NSString对象
 *
 *  @param callBack 排序完成后的回调
 *
 *  @since          1.0.0
 */
- (void)sortContactTOTitleAndSectionRow:(void(^)(BOOL isSuccess,NSArray *titleArray,NSArray *rowArray))callBack
{
    
    ///判断当前数组的个数
    if (0 >= [self count]) {
        
        NSLog(@"====================中英文混排日志====================");
        NSLog(@"::::::::::当前数据源无元素，无需排序");
        NSLog(@"====================中英文混排日志====================");
        
        ///回调
        if (callBack) {
            
            callBack(NO,nil,nil);
            
        }
        
    }

    ///建立索引的核心
    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
    NSMutableArray *titleDataSource = [NSMutableArray arrayWithArray:[indexCollation sectionTitles]];
    
    ///返回27，是a－z和＃
    NSInteger highSection = [titleDataSource count];
    
    ///初始添加27个section对应的数组
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i <= highSection; i++) {
        
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sortedArray addObject:sectionArray];
        
    }
    
    ///名字分section
    for (NSObject *obj in self) {
        
        ///判断类型
        if (![obj isKindOfClass:[NSString class]]) {
            
            NSLog(@"====================中英文混排日志====================");
            NSLog(@"::::::::::当前数据源中存在非字符串对象，无法成功排序");
            NSLog(@"====================中英文混排日志====================");
            
            ///回调
            if (callBack) {
                
                callBack(NO,nil,nil);
                
            }
            return;
            
        }
        
        ///转为字符串
        NSString *contactName = (NSString *)obj;
        
        ///获取首字母
        NSString *firstLetter = [ChineseToPinyin pinyinFromChineseString:contactName];
        NSInteger section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
        
        NSMutableArray *array = [sortedArray objectAtIndex:section];
        [array addObject:contactName];
        
    }
    
    ///每个section内的数组排序
    for (int i = 0; i < [sortedArray count]; i++) {
        
        NSArray *array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
            
            /**
             *  @author yangshengmeng, 15-05-19 00:05:53
             *
             *  @brief  1、在这里可以添加中英文区分排序
             *  @brief  2、添加全英文字母排序
             *  @brief  3、添加数字相对于中文和英文相对位置
             *
             *  @since  1.0.0
             */
            
            NSString *firstString1 = [ChineseToPinyin pinyinFromChineseString:obj1];
            NSString *firstLetter1 = [[firstString1 substringToIndex:1] uppercaseString];
            
            NSString *firstString2 = [ChineseToPinyin pinyinFromChineseString:obj2];
            NSString *firstLetter2 = [[firstString2 substringToIndex:1] uppercaseString];
            
            ///添加第二字母排序:如果想要实现全字母排序，建议写前三个排序，如果前三个无法排出结果，则调用一个C函数的快速算法，用递归的话，估计会卡死
            if (NSOrderedSame == [firstLetter1 caseInsensitiveCompare:firstLetter2]) {
                
                ///判断长度:一个字每的在前面
                if ([firstString1 length] == 1) {
                    
                    return NO;
                    
                }
                
                if ([firstString2 length] == 1) {
                    
                    return YES;
                    
                }
                
                NSString *secondLetter1 = [[firstString1 substringWithRange:NSMakeRange(1, 1)] uppercaseString];
                NSString *secondLetter2 = [[firstString2 substringWithRange:NSMakeRange(1, 1)] uppercaseString];
                
                return [secondLetter1 caseInsensitiveCompare:secondLetter2];
                
            }
            
            return [firstLetter1 caseInsensitiveCompare:firstLetter2];
            
        }];
        
        [sortedArray replaceObjectAtIndex:i withObject:[NSMutableArray arrayWithArray:array]];
        
    }
    
    ///重置原始数据
    NSMutableIndexSet *emtyIndexSet = [NSMutableIndexSet indexSet];
    for (int i = 0; i < [titleDataSource count]; i++) {
        
        if ([[sortedArray objectAtIndex:i] count] <= 0) {
            
            [emtyIndexSet addIndex:i];
            
        }
        
    }
    
    ///清空无效标题
    [titleDataSource removeObjectsAtIndexes:emtyIndexSet];
    [sortedArray removeObjectsAtIndexes:emtyIndexSet];
    for (int i = (int)[sortedArray count]; i > 0 ; i--) {
        
        NSArray *tempArray = sortedArray[i - 1];
        if ([tempArray count] <= 0) {
            
            [sortedArray removeObjectAtIndex:i - 1];
            
        }
        
    }
    
    ///回调成功
    if (callBack) {
        
        callBack(YES,[NSArray arrayWithArray:titleDataSource],[NSArray arrayWithArray:sortedArray]);
        
    }

}

/**
 *  @author         yangshengmeng, 15-05-19 00:05:57
 *
 *  @brief          排序当前数据元素，生成通讯录类似的标题栏和行数据，同时排序字段通过sortKey获取，获取结果必须为NSString对象
 *
 *  @param sortKey  对象中需要排序的字段key，获取出来必须为NSString对象
 *  @param callBack 排序完成后的回调，回调标题数据和内容数组
 *
 *  @since          1.0.0
 */
- (void)sortContactTOTitleAndSectionRowWithKey:(NSString *)sortKey callBack:(void(^)(BOOL isSuccess,NSArray *titleArray,NSArray *rowArray))callBack
{

    ///判断当前数组的个数
    if (0 >= [self count]) {
        
        NSLog(@"====================中英文混排日志====================");
        NSLog(@"::::::::::当前数据源无元素，无需排序");
        NSLog(@"====================中英文混排日志====================");
        
        ///回调
        if (callBack) {
            
            callBack(NO,nil,nil);
            
        }
        
    }
    
    ///判断获取的key
    if ([sortKey length] <= 0) {
        
        NSLog(@"====================中英文混排日志====================");
        NSLog(@"::::::::::给定的排序sortKey无效");
        NSLog(@"====================中英文混排日志====================");
        
        ///回调
        if (callBack) {
            
            callBack(NO,nil,nil);
            
        }
        
        return;
        
    }
    
    ///建立索引的核心
    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
    NSMutableArray *titleDataSource = [NSMutableArray arrayWithArray:[indexCollation sectionTitles]];
    
    ///返回27，是a－z和＃
    NSInteger highSection = [titleDataSource count];
    
    ///初始添加27个section对应的数组
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i <= highSection; i++) {
        
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sortedArray addObject:sectionArray];
        
    }
    
    ///名字分section
    for (NSObject *obj in self) {
        
        ///获取临时类型
        NSObject *tempObject = [obj valueForKey:sortKey];
        
        ///判断类型
        if (![tempObject isKindOfClass:[NSString class]]) {
            
            NSLog(@"====================中英文混排日志====================");
            NSLog(@"::::::::::当前数据源中的对象，根据sortKey获取的对象非字符串对象，无法成功排序");
            NSLog(@"====================中英文混排日志====================");
            
            ///回调
            if (callBack) {
                
                callBack(NO,nil,nil);
                
            }
            return;
            
        }
        
        ///转为字符串
        NSString *contactName = (NSString *)tempObject;
        
        ///获取首字母
        NSString *firstLetter = [ChineseToPinyin pinyinFromChineseString:contactName];
        NSInteger section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
        
        NSMutableArray *array = [sortedArray objectAtIndex:section];
        [array addObject:obj];
        
    }
    
    ///每个section内的数组排序
    for (int i = 0; i < [sortedArray count]; i++) {
        
        NSArray *array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(NSObject *obj1, NSObject *obj2) {
            
            /**
             *  @author yangshengmeng, 15-05-19 00:05:53
             *
             *  @brief  1、在这里可以添加中英文区分排序
             *  @brief  2、添加全英文字母排序
             *  @brief  3、添加数字相对于中文和英文相对位置
             *
             *  @since  1.0.0
             */
            
            NSString *firstString1 = [ChineseToPinyin pinyinFromChineseString:[obj1 valueForKey:sortKey]];
            NSString *firstLetter1 = [[firstString1 substringToIndex:1] uppercaseString];
            
            NSString *firstString2 = [ChineseToPinyin pinyinFromChineseString:[obj2 valueForKey:sortKey]];
            NSString *firstLetter2 = [[firstString2 substringToIndex:1] uppercaseString];
            
            ///添加第二字母排序:如果想要实现全字母排序，建议写前三个排序，如果前三个无法排出结果，则调用一个C函数的快速算法，用递归的话，估计会卡死
            if (NSOrderedSame == [firstLetter1 caseInsensitiveCompare:firstLetter2]) {
                
                ///判断长度:一个字每的在前面
                if ([firstString1 length] == 1) {
                    
                    return NO;
                    
                }
                
                if ([firstString2 length] == 1) {
                    
                    return YES;
                    
                }
                
                NSString *secondLetter1 = [[firstString1 substringWithRange:NSMakeRange(1, 1)] uppercaseString];
                NSString *secondLetter2 = [[firstString2 substringWithRange:NSMakeRange(1, 1)] uppercaseString];
                
                return [secondLetter1 caseInsensitiveCompare:secondLetter2];
                
            }
            
            return [firstLetter1 caseInsensitiveCompare:firstLetter2];
            
        }];
        
        [sortedArray replaceObjectAtIndex:i withObject:[NSMutableArray arrayWithArray:array]];
        
    }
    
    ///重置原始数据
    NSMutableIndexSet *emtyIndexSet = [NSMutableIndexSet indexSet];
    for (int i = 0; i < [titleDataSource count]; i++) {
        
        if ([[sortedArray objectAtIndex:i] count] <= 0) {
            
            [emtyIndexSet addIndex:i];
            
        }
        
    }
    
    ///清空无效标题
    [titleDataSource removeObjectsAtIndexes:emtyIndexSet];
    [sortedArray removeObjectsAtIndexes:emtyIndexSet];
    for (int i = (int)[sortedArray count]; i > 0 ; i--) {
        
        NSArray *tempArray = sortedArray[i - 1];
        if ([tempArray count] <= 0) {
            
            [sortedArray removeObjectAtIndex:i - 1];
            
        }
        
    }
    
    ///回调成功
    if (callBack) {
        
        callBack(YES,[NSArray arrayWithArray:titleDataSource],[NSArray arrayWithArray:sortedArray]);
        
    }

}

@end
