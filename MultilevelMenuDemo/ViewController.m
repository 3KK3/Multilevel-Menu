//
//  ViewController.m
//  MultilevelMenuDemo
//
//  Created by YZY on 2018/7/6.
//  Copyright © 2018年 ZMJ. All rights reserved.
//

#import "ViewController.h"
#import "MultilevelMenu.h"

@interface ViewController () <MultilevelMenuDelegate>
@property (nonatomic, strong) MultilevelMenu *menuView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview: self.menuView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (MultilevelMenu *)menuView {
    if (!_menuView) {
        _menuView = [[MultilevelMenu alloc] initWithFrame: CGRectMake(10, 20, self.view.frame.size.width - 20, 400)];
        _menuView.delegate = self;
    }
    return _menuView;
}

#pragma mark --- menu datasource

- (NSInteger)multilevelMenu:(MultilevelMenu *)menu numberOfRowsInComponent:(NSInteger)component {
    if (0 == component) {
        return [self firstComponentDatas].count;
    }
    
    if (1 == component) {
        NSInteger firstComponentSelectRow = [menu selectedRowInComponent: 0];
        if (0 == firstComponentSelectRow) {
            return [self secondComponentDatasFromFirstComponentTap1].count;
        }
        
        if (1 == firstComponentSelectRow) {
            return [self secondComponentDatasFromFirstComponentTap2].count;
        }
    }
    
    if (2 == component) {
        return [self thirdComponentDatasFromFirstComponentTap4].count;
    }
    
    return 0;
}


- (NSString *)multilevelMenu:(MultilevelMenu *)menu subComponentTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (0 == component) {
        return [self firstComponentDatas][row];
    }
    
//    第二层要展示的数据
    if (1 == component) {
        if ([menu selectedRowInComponent: 0] == 0) {
            return [self secondComponentDatasFromFirstComponentTap1][row];
        }
        if ([menu selectedRowInComponent: 0] == 1) {
            return [self secondComponentDatasFromFirstComponentTap2][row];
        }
    }
    
    //第三层要展示的数据
    if (2 == component) {
        return [self thirdComponentDatasFromFirstComponentTap4][row];
    }
    
    return nil;
}

- (NSArray *)firstComponentDatas {
    return @[@"1",@"2",@"3",@"4"];
}

- (NSArray *)secondComponentDatasFromFirstComponentTap1 {
    return @[@"1-1"];
}

- (NSArray *)secondComponentDatasFromFirstComponentTap2 {
    return @[@"2-1",@"2-2"];
}

- (NSArray *)thirdComponentDatasFromFirstComponentTap4 {
    return @[@"1-2-1",@"1-2-2",@"1-2-3",@"1-2-4"];
}


@end
