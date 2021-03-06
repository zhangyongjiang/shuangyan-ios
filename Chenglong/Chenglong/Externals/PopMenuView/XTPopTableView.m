//
//  XTPopTableView.m
//  XTPopView
//
//  Created by zjwang on 16/7/7.
//  Copyright © 2016年 夏天. All rights reserved.
//

#import "XTPopTableView.h"

@interface XTPopTableView ()

@end

@implementation XTPopTableView
- (instancetype)initWithOrigin:(CGPoint)origin Width:(CGFloat)width Height:(CGFloat)height Type:(XTDirectionType)type Color:(UIColor *)color
{
    if ([super initWithOrigin:origin Width:width Height:height Type:type Color:color]) {
        // 添加tableview
        [self.backGoundView addSubview:self.tableView];
    }
    return self;
}

#pragma mark -
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.backGoundView.frame.size.width, self.backGoundView.frame.size.height) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        [_tableView setSeparatorColor:[UIColor whiteColor]];
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 10)];
        }
        
    }
    return _tableView;
}
#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
#pragma mark -
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.row_height == 0) {
        return 44;
    }else{
        return self.row_height;
    }
}
#pragma mark -
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"cellIdentifier2";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.imageView.image = [UIImage imageNamed:self.images[indexPath.row]];
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:self.fontSize];
    cell.textLabel.textAlignment = _textAlignment;
    cell.textLabel.numberOfLines = 0;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = self.titleTextColor;
    if(![self.enabled[indexPath.row] boolValue])
        cell.textLabel.textColor = [UIColor colorFromHex:0xaaaaaa];
    
    if (self.dataArray.count == 1) {
        self.tableView.bounces = NO;
        self.tableView.separatorColor = [UIColor clearColor];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectIndexPathRow:view:)]) {
        if([self.enabled[indexPath.row] boolValue])
            [self.delegate selectIndexPathRow:indexPath.row view:self];
        [self removeFromSuperview];
    }
}

@end
