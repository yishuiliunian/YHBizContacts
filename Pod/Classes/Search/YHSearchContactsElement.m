//
//  YHSearchContactsElement.m
//  YaoHe
//
//  Created by stonedong on 16/7/20.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import "YHSearchContactsElement.h"
#import "YHUserSearchRequest.h"
#import <DZAuthSession.h>
#import "YHSearchUserProfileItemElement.h"
@implementation YHSearchContactsElement
- (int64_t)lastNewestID
{
    return 0;
}

- (int64_t) lastOldestID
{
    return 0;
}

- (YHRequest*) syncOldDataReqeust;
{
    YHUserSearchRequest* request = [YHUserSearchRequest new];
    request.search.keywords = self.keyword;
    request.skey = DZActiveAuthSession.token;
    return request;
}

- (YHRequest*) syncNewDataReqeust
{
    YHUserSearchRequest* request = [YHUserSearchRequest new];
    request.search.keywords = self.keyword;
    request.skey = DZActiveAuthSession.token;
    return request;
}



- (NSArray*) transfromResponseToElements:(UserSearchResponse*)response
{
    NSMutableArray* array = [NSMutableArray new];
    for (UserProfile* wallinfo in response.profileArray) {
        YHSearchUserProfileItemElement* element = [[YHSearchUserProfileItemElement alloc] initWithUserProfile:wallinfo];
        [array addObject:element];
    }
    return array;
}
@end
