//
//  MultilevelMenu.m
//  MultilevelMenuDemo
//
//  Created by YZY on 2018/7/6.
//  Copyright © 2018年 ZMJ. All rights reserved.
//

#import "MultilevelMenu.h"
#import "MultilevelMenuCell.h"

static CGFloat const kDefaultCellHeight = 45;

@interface MultilevelMenu () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray <NSNumber *>*selectArray;
@property (nonatomic, strong) NSMutableArray <UITableView *>*tableViewArray;
@end

@implementation MultilevelMenu

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    UITableView *firstTableView = self.tableViewArray.firstObject;
    [self addSubview: firstTableView];
    [self adjustTableViews];
    [firstTableView reloadData];
}

-(void)adjustTableViews{
    for (int i = 0; i < [self numberOfComponents]; i++) {
        UITableView *tableView = self.tableViewArray[i];
        CGRect adjustFrame = tableView.frame;
        adjustFrame.size.width = self.frame.size.width / [self numberOfComponents] ;
        adjustFrame.origin.x = adjustFrame.size.width * i;
        adjustFrame.size.height = self.frame.size.height ;
        tableView.frame = adjustFrame;
    }
}

#pragma mark - TableView协议

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger level = [self currentLevel: tableView];
    return [self.delegate multilevelMenu: self numberOfRowsInComponent: level];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MultilevelMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MultilevelMenuCell"];
    NSInteger level = [self currentLevel: tableView];
    
    if ([self.delegate respondsToSelector: @selector(multilevelMenu:subComponentTitleForRow:forComponent:)]) {
        cell.title = [self.delegate multilevelMenu: self
                           subComponentTitleForRow: indexPath.row
                                      forComponent: level];
    } else if ([self.delegate respondsToSelector: @selector(multilevelMenu:subComponentAttributedTitleForRow:forComponent:)]) {
        cell.attributedTitle = [self.delegate multilevelMenu: self
                           subComponentAttributedTitleForRow: indexPath.row
                                                forComponent: level];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector: @selector(multilevelMenu:rowHeightForComponent:)]) {
        return [self.delegate multilevelMenu: self rowHeightForComponent: [self currentLevel: tableView]];
    }
    return kDefaultCellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //从0开始
    NSInteger currentLevel = [self currentLevel: tableView];

    //首次点击第一层
    if (currentLevel == 0 && self.selectArray.count == 0) {
        [self.selectArray addObject: @(indexPath.row)];
        
    } else if ((currentLevel + 1) < self.numberOfComponents) {
        //点击的是前面层  替换数据 并删除后面的选择数据
        [self.selectArray replaceObjectAtIndex: currentLevel withObject: @(indexPath.row)];
        [self.selectArray removeObjectsInRange: NSMakeRange( currentLevel + 1, self.selectArray.count - (currentLevel + 1))];
    } else {
        //点击最新自子层
        //如果已经有最新自层的点击数据  替换数据
        if (self.selectArray.count == self.numberOfComponents) {
            [self.selectArray replaceObjectAtIndex: currentLevel withObject: @(indexPath.row)];
        } else {
            //如果还没有点击过最新自层  增加数据
            [self.selectArray addObject: @(indexPath.row)];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(multilevelMenu:didSelectInComponent:row:)]) {
        [self.delegate multilevelMenu: self didSelectInComponent: currentLevel row: indexPath.row];
    }
    
    //下一层数据
    NSInteger subComponentRowCount = [self.delegate multilevelMenu: self
                                           numberOfRowsInComponent: currentLevel + 1];

    if ((currentLevel + 1) < self.numberOfComponents) {
        //点击前面层如2 下面有数据 下一层3 tableview reloaddata  从4开始tableview删除 ，下面没数据2  从3开始tableview删除
        if (subComponentRowCount) {
            [self.tableViewArray[currentLevel + 1] reloadData];
            [self removeTableViewFromIndex: currentLevel + 2];
        } else {
            [self removeTableViewFromIndex: currentLevel + 1];
        }
        
    } else {
        //点击最新自子层 下面有数据 增加tableview ，下面没数据  不作处理
        //点击第一层
        if (subComponentRowCount) {
            UITableView *newTableView = [self commanTableView];
            [self.tableViewArray addObject: newTableView];
            [self addSubview: newTableView];
            [newTableView reloadData];
        }
    }
    
    [self adjustTableViews];
    NSLog(@"select array:%@",self.selectArray);
}

- (void)removeTableViewFromIndex:(NSInteger)index {
    if (index >= self.tableViewArray.count) {
        return;
    }
    
    for (NSInteger i = index; i < self.tableViewArray.count; i ++) {
        [self.tableViewArray[i] removeFromSuperview];
    }
    
    [self.tableViewArray removeObjectsInRange: NSMakeRange(index, self.tableViewArray.count - index)];
}

//当前显示的是第几级
- (NSInteger)currentLevel:(UITableView *)tableView {
    NSInteger i = 0;
    for (UITableView *item in self.tableViewArray) {
        if (item == tableView) {
            return i;
        }
        i++;
    }
    return i;
}

- (NSMutableArray *)tableViewArray {
    if (!_tableViewArray) {
        _tableViewArray = [NSMutableArray array];
        [_tableViewArray addObject: [self commanTableView]];
    }
    return _tableViewArray;
}

- (UITableView *)commanTableView {
    UITableView *tableView = [[UITableView alloc] init];
    [tableView registerClass:[MultilevelMenuCell class] forCellReuseIdentifier:@"MultilevelMenuCell"];
    tableView.delegate = self;
    tableView.dataSource = self;
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.frame = CGRectMake(0, 0, 0, 0);
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.showsVerticalScrollIndicator = NO;
    return tableView;
}

- (NSMutableArray *)selectArray {
    if (!_selectArray) {
        _selectArray = [@[] mutableCopy];
    }
    return _selectArray;
}

- (NSInteger)numberOfComponents {
    return  self.tableViewArray.count;
}

- (NSInteger)selectedRowInComponent:(NSInteger)component {
    if (component > self.selectArray.count) {
        return -1;
    }
    return [self.selectArray[component] integerValue];
}

@end
