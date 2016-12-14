//
//  EKHeaderFooterElement.m
//  YaoHe
//
//  Created by stonedong on 16/4/29.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import "EKHeaderFooterElement.h"
#import "EKTableViewHeaderFooterView.h"
#import "NSObject+EventBus.h"

@implementation EKHeaderFooterElement
@synthesize identifier = _identifier;
- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _viewClass = [EKTableViewHeaderFooterView class];
    _height = 20;
    _opened = YES;
    return self;
}
- (NSString*) identifier
{
    if (!_identifier) {
        _identifier = NSStringFromClass(_viewClass);
    }
    return _identifier;
}
- (UIResponder*) createResponser
{
    return [[_viewClass alloc] initWithReuseIdentifier:self.identifier];
}

- (void) willBeginHandleResponser:(EKTableViewHeaderFooterView *)responser
{
    [super willBeginHandleResponser:responser];
    responser.eventBus = self.eventBus;
    responser.element = self;
    responser.textLabel.font = [UIFont boldSystemFontOfSize:13];
    responser.textLabel.textColor = [UIColor lightGrayColor];
    responser.textLabel.text = self.title;
}

- (void) didRegsinHandleResponser:(EKTableViewHeaderFooterView *)responser
{
    [super didRegsinHandleResponser:responser];
    responser.eventBus = nil;
    responser.element = nil;
}
@end
