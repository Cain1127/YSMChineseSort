//
//  YSMViewController.m
//  YSMChineseSort
//
//  Created by ysmeng on 05/19/2015.
//  Copyright (c) 2014 ysmeng. All rights reserved.
//

#import "YSMViewController.h"
#import "NSArray+SortContact.h"

@interface YSMViewController () <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *inputField;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UITableView *listView;

@property (nonatomic,retain) NSMutableArray *dataSource;        //!<原始数据记录
@property (nonatomic,retain) NSMutableArray *rowDataSource;     //!<每一行数据源
@property (nonatomic,retain) NSMutableArray *titleDataSource;   //!<标题和指引数据源

@end

@implementation YSMViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
	
    ///初始化数据
    self.dataSource = [NSMutableArray array];
    self.rowDataSource = [NSMutableArray array];
    self.titleDataSource = [NSMutableArray array];
    
    ///添加初始化联系人
    [self.dataSource addObjectsFromArray:@[@"李世民",
                                           @"m马云",
                                           @"Facebook",
                                           @"m了个j",
                                           @"千峰",
                                           @"Astone",
                                           @"Twitter"]];
    
    ///重构形成排序列
    [self sortDataArray];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        ///刷新数据
        [self.listView reloadData];
        
    });
    
}

- (IBAction)addNewContactItem:(UIButton *)sender
{
    
    if ([self.inputField.text length] > 0) {
        
        NSString *inputItem = self.inputField.text;
        self.inputField.text = nil;
        
        ///查询原来是否存在数据
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF == %@",inputItem];
        NSArray *searchArray = [self.dataSource filteredArrayUsingPredicate:predicate];
        
        ///查找无数据，则添加
        if (![searchArray count] > 0) {
            
            [self.dataSource addObject:inputItem];
            
            ///重构数据源
            [self sortDataArray];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.listView reloadData];
                
            });
            
        }
        
    }
    
    [self.inputField resignFirstResponder];
    
}

- (void)sortDataArray
{
    
    ///清空原数据
    [self.titleDataSource removeAllObjects];
    [self.rowDataSource removeAllObjects];
    
    [self.dataSource sortContactTOTitleAndSectionRow:^(BOOL isSuccess, NSArray *titleArray, NSArray *rowArray) {
        
        if (isSuccess) {
            
            [self.titleDataSource addObjectsFromArray:titleArray];
            [self.rowDataSource addObjectsFromArray:rowArray];
            
        }
        
    }];
    
}

#pragma mark - 配置列表
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.rowDataSource[section] count];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return [self.rowDataSource count];
    
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    
    return index;
    
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    
    return self.titleDataSource;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *titleCell = @"titleCell";
    UITableViewCell *cellTitle = [tableView dequeueReusableCellWithIdentifier:titleCell];
    if (nil == cellTitle) {
        
        cellTitle = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:titleCell];
        
    }
    
    ///获取联系人
    cellTitle.textLabel.text = [NSString stringWithFormat:@".      %@",self.rowDataSource[indexPath.section][indexPath.row]];
    
    return cellTitle;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    static NSString *viewTitle = @"viewTitle";
    UILabel *titleLabel = [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewTitle];
    if (nil == titleLabel) {
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, tableView.frame.size.width, 44.0f)];
        titleLabel.backgroundColor = [UIColor lightGrayColor];
        titleLabel.textColor = [UIColor orangeColor];
        
    }
    
    titleLabel.text = [NSString stringWithFormat:@".      %@",self.titleDataSource[section]];
    
    return titleLabel;
    
}

#pragma mark - 回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if ([textField.text length] > 0) {
        
        NSString *inputItem = textField.text;
        textField.text = nil;
        
        ///查询原来是否存在数据
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF == %@",inputItem];
        NSArray *searchArray = [self.dataSource filteredArrayUsingPredicate:predicate];
        
        ///查找无数据，则添加
        if (![searchArray count] > 0) {
            
            [self.dataSource addObject:inputItem];
            
            ///重构数据源
            [self sortDataArray];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.listView reloadData];
                
            });
            
        }
        
    }
    
    [textField resignFirstResponder];
    return YES;
    
}

@end
