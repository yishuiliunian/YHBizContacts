//
//  EKTableViewHeaderFooterView.m
//  YaoHe
//
//  Created by stonedong on 16/4/29.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import "EKTableViewHeaderFooterView.h"
#import "NSObject+EventBus.h"
@implementation EKTableViewHeaderFooterView

- (instancetype) initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (!self) {
        return self;
    }
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHandler:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];

    return self;
}

- (void) clickHandler:(UITapGestureRecognizer*)tap
{
    if (tap.state == UIGestureRecognizerStateRecognized) {
//        [self.eventBus performSelector:@selector(didSelectAtSection:) withObject:self.element];
    }
}
@end
