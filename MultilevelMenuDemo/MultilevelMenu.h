//
//  MultilevelMenu.h
//  MultilevelMenuDemo
//
//  Created by YZY on 2018/7/6.
//  Copyright © 2018年 ZMJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MultilevelMenuDelegate;

@interface MultilevelMenu : UIView
@property(nullable,nonatomic,weak) id<MultilevelMenuDelegate> delegate;
@property(nonatomic,readonly) NSInteger numberOfComponents;
- (NSInteger)selectedRowInComponent:(NSInteger)component;
@end

@protocol MultilevelMenuDelegate <NSObject>
@optional

-(NSInteger)multilevelMenu:(MultilevelMenu *)menu numberOfRowsInComponent:(NSInteger)component;
- (void)multilevelMenu:(MultilevelMenu *)menu didSelectInComponent:(NSInteger)component row:(NSInteger)row;

- (nullable NSString *)multilevelMenu:(MultilevelMenu *)menu subComponentTitleForRow:(NSInteger)row forComponent:(NSInteger)component;
- (nullable NSAttributedString *)multilevelMenu:(MultilevelMenu *)menu subComponentAttributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component;
- (CGFloat)multilevelMenu:(MultilevelMenu *)menu rowHeightForComponent:(NSInteger)component;

@end


