//
//  NSArray+SortContact.h
//  YSMChineseSortDemo
//
//  Created by ysmeng on 15/5/19.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (SortContact)

/**
 *  @author         yangshengmeng, 15-05-19 00:05:58
 *
 *  @brief          将给定的对象数组，按中英文排序形成联系人类似的双数据组，此方法表示当前数据内的元素为NSString对象
 *
 *  @param callBack 排序完成后的回调
 *
 *  @since          1.0.0
 */
- (void)sortContactTOTitleAndSectionRow:(void(^)(BOOL isSuccess,NSArray *titleArray,NSArray *rowArray))callBack;

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
- (void)sortContactTOTitleAndSectionRowWithKey:(NSString *)sortKey callBack:(void(^)(BOOL isSuccess,NSArray *titleArray,NSArray *rowArray))callBack;

@end
