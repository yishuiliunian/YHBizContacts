//
//  YHTalkGroupItemElement.m
//  YaoHe
//
//  Created by stonedong on 16/5/2.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHTalkGroupItemElement.h"
#import "YHTalkGroupItemCell.h"
@interface YHTalkGroupItemElement()
{
    NSString* text;
}
@end
@implementation YHTalkGroupItemElement
- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _viewClass = [YHTalkGroupItemCell class];
    text = [@(rand()%100) stringValue];
    return self;
}
- (NSString*) indexTitle
{
    return text;
}

- (void) willBeginHandleResponser:(YHTalkGroupItemCell*)cell
{
    [super willBeginHandleResponser:cell];
    cell.textLabel.text = text;
}

- (void) didBeginHandleResponser:(YHTalkGroupItemCell *)cell
{
    [super didBeginHandleResponser:cell];
}

- (void) willRegsinHandleResponser:(YHTalkGroupItemCell *)cell
{
    [super willRegsinHandleResponser:cell];
}

- (void) didRegsinHandleResponser:(YHTalkGroupItemCell *)cell
{
    [super didRegsinHandleResponser:cell];
}
@end