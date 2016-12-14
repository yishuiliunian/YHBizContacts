//
//  YHSearchUserProfileItemElement.m
//  YaoHe
//
//  Created by stonedong on 16/7/20.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import "YHSearchUserProfileItemElement.h"
#import "YHChatRecentCell.h"
#import <YHNetCore.h>
#import "YHURLRouteDefines.h"
#import "YHUtils.h"
@implementation YHSearchUserProfileItemElement

- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    self.cellHeight = 60;
    return self;
}
- (void) willBeginHandleResponser:(YHChatRecentCell *)cell
{
    [super willBeginHandleResponser:cell];
    cell.nickLabel.text = self.profile.readNick;
    if (self.profile.longNick.length) {
        cell.detailLabel.text = self.profile.longNick;
    } else {
        cell.detailLabel.text = @"这家伙很聪明,什么都没有留下";
    }
}


- (void) handleSelectedInViewController:(UIViewController *)vc
{
    NSMutableDictionary* info = [NSMutableDictionary new];
    [info safeSetObject:self.profile.userName forKey:kYHURLQueryParamterUID];
    [info setProtobuffInstance:self.profile forKey:kYHURLQueryParamterProfile];
    [[DZURLRoute defaultRoute] routeURL:DZURLRouteQueryLink(kYHURLUserDetail, info)];

}
@end
