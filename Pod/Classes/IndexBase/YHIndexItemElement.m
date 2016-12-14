//
//  YHIndexItemElement.m
//  YaoHe
//
//  Created by stonedong on 16/5/2.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHIndexItemElement.h"
#import "YHIndexItemCell.h"
@implementation YHIndexItemElement
- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _viewClass = [YHIndexItemCell class];
    return self;
}

- (void) willBeginHandleResponser:(YHIndexItemCell*)cell
{
    [super willBeginHandleResponser:cell];
}

- (void) didBeginHandleResponser:(YHIndexItemCell *)cell
{
    [super didBeginHandleResponser:cell];
}

- (void) willRegsinHandleResponser:(YHIndexItemCell *)cell
{
    [super willRegsinHandleResponser:cell];
}

- (void) didRegsinHandleResponser:(YHIndexItemCell *)cell
{
    [super didRegsinHandleResponser:cell];
}
@end