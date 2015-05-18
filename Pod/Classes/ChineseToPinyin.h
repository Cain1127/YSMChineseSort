//
//  ChineseToPinyin.h
//  YSMChineseSortDemo
//
//  Created by ysmeng on 15/5/18.
//  Copyright (c) 2015年 ysmeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChineseToPinyin : NSObject

+ (NSString *) pinyinFromChineseString:(NSString *)string;
+ (char) sortSectionTitle:(NSString *)string; 

@end