//
//  YHContactItemElement.h
//  YaoHe
//
//  Created by stonedong on 16/5/3.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import <ElementKit/ElementKit.h>

#import "YHIndexItemElement.h"
#import "RpcAccountMessage.pbobjc.h"
@class UserProfile;
@interface YHContactItemElement : YHIndexItemElement
@property (nonatomic, strong,readonly) UserProfile* contact;
- (instancetype) initWithContact:(UserProfile*)profile;
@end
