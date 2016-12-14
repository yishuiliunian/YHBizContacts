//
//  YHTalkGroupElement.m
//  YaoHe
//
//  Created by stonedong on 16/5/2.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHTalkGroupElement.h"
#import "YHTalkGroupViewController.h"
#import "YHTalkGroupItemElement.h"
@implementation YHTalkGroupElement

- (NSArray*) originFlatDatas
{
    NSMutableArray* array = [NSMutableArray new];
    for (int i = 0; i <100; i++) {
        [array addObject:[YHTalkGroupItemElement new]];
    }
    return array;
    
}
- (void) reloadData
{
    [super reloadData];
}


- (void) willBeginHandleResponser:(YHTalkGroupViewController *)responser
{
    [super willBeginHandleResponser:responser];
}

- (void) didBeginHandleResponser:(YHTalkGroupViewController *)responser
{
    [super didBeginHandleResponser:responser];
}

- (void) willRegsinHandleResponser:(YHTalkGroupViewController *)responser
{
    [super willRegsinHandleResponser:responser];
}

- (void) didRegsinHandleResponser:(YHTalkGroupViewController *)responser
{
    [super didRegsinHandleResponser:responser];
}
@end