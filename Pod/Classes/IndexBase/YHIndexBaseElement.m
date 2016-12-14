//
//  YHIndexBaseElement.m
//  YaoHe
//
//  Created by stonedong on 16/5/2.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHIndexBaseElement.h"
#import "YHIndexBaseViewController.h"
#import "EKHeaderFooterElement.h"
#import "YHIndexItemElement.h"
@interface YHIndexBaseElement()
{
    NSArray* _indexTitles;
}
@end

@implementation YHIndexBaseElement


- (void) updateSectionDatas:(NSArray*)originDatas
{
    [_originDataController clean];
    [self cleanSectionElements];
    NSMutableDictionary* dataCache = [NSMutableDictionary new];
    for (YHIndexItemElement* ele in originDatas) {
        NSString* title = ele.indexTitle;
        NSString* key = @"#";
        if (title) {
            key = title;
        }
        NSMutableArray* array = dataCache[key];
        if (!array) {
            array = [NSMutableArray new];
            dataCache[key] = array;
        }
        [array addObject:ele];
    }
    NSMutableArray* indexs = [dataCache.allKeys mutableCopy];
    [indexs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    if ([indexs containsObject:@"#"]) {
        NSInteger index = [indexs indexOfObject:@"#"];
        if (index != NSNotFound) {
            [indexs removeObjectAtIndex:index];
            [indexs addObject:@"#"];
        }
    }
    
    NSArray* preorder = [self preOrderIndexs];
    for (int i =0 ; i < preorder.count; i++) {
        NSString* key = preorder[i];
        if ([indexs containsObject:key]) {
            [indexs removeObject:key];
            if (indexs.count >= i) {
                [indexs insertObject:key atIndex:i];
            }
        }
    }
    _indexTitles = indexs;
    for(int i = 0; i < indexs.count ; i ++)
    {
        NSString* index = indexs[i];
        [_originDataController replaceObjects:dataCache[index] atSection:i];
        EKHeaderFooterElement* element = [EKHeaderFooterElement new];
        element.title = index;
        [self updateSection:i element:element];
        if ([element.title isEqualToString:@"※"]) {
            element.height = 0;
        }
    }
    [self updateTree];
}



- (void) willBeginHandleResponser:(YHIndexBaseViewController *)responser
{
    [super willBeginHandleResponser:responser];
}

- (void) didBeginHandleResponser:(YHIndexBaseViewController *)responser
{
    [super didBeginHandleResponser:responser];
}

- (void) willRegsinHandleResponser:(YHIndexBaseViewController *)responser
{
    [super willRegsinHandleResponser:responser];
}

- (void) didRegsinHandleResponser:(YHIndexBaseViewController *)responser
{
    [super didRegsinHandleResponser:responser];
}
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _indexTitles;
}

@end