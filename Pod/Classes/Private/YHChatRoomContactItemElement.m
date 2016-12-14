//
//  YHChatRoomContactItemElement.m
//  YaoHe
//
//  Created by stonedong on 16/7/19.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import "YHChatRoomContactItemElement.h"
#import "YHContactItemCell.h"
@implementation YHChatRoomContactItemElement

- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _indexTitle  = @"话题";
    return self;
}
- (void) willBeginHandleResponser:(YHContactItemCell *)responser
{
    [super willBeginHandleResponser:responser];
    responser.nickLabel.textColor = self.titleColor;
}

@end
