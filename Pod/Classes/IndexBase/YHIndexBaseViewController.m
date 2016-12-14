//
//  YHIndexBaseViewController.m
//  YaoHe
//
//  Created by stonedong on 16/5/2.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ChameleonFramework/ChameleonMacros.h>
#import "YHIndexBaseViewController.h"
@implementation YHIndexBaseViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.tableView.sectionIndexColor = [UIColor flatGrayColorDark];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

@end