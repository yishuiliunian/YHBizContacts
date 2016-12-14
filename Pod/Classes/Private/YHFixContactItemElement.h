//
//  YHFixContactItemElement.h
//  YaoHe
//
//  Created by stonedong on 16/5/27.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import "YHIndexItemElement.h"

typedef void(^NextAction)(void);
@interface YHFixContactItemElement : YHIndexItemElement
@property (nonatomic, strong) NextAction nextAction;
@property (nonatomic, strong) NSString* title;
- (instancetype) initWithImage:(UIImage*)image title:(NSString*)title;
@end
