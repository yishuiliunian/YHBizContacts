//
//  EKTreeTableElement.m
//  YaoHe
//
//  Created by stonedong on 16/4/29.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import "EKTreeTableElement.h"
#import "EKHeaderFooterElement.h"
@interface EKTreeTableElement ()
{
    NSMutableDictionary* _sectionElements;
}
@end
@implementation EKTreeTableElement

- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _sectionElements = [NSMutableDictionary new];
    _originDataController = [EKTableDataController new];
    return self;
}
- (NSArray*) preOrderIndexs
{
    return nil;
}
- (void) updateTree
{
    [_dataController clean];
    NSMutableArray* allIndex = [_sectionElements.allKeys mutableCopy];
     [allIndex sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    for (NSNumber* index in allIndex) {
        EKHeaderFooterElement* ele = _sectionElements[index];
        NSInteger sectionIndex = index.integerValue;
        if (ele.opened) {
            [_dataController replaceObjects:[_originDataController objectsForSections:sectionIndex] atSection:sectionIndex];
        } else {
            [_dataController replaceObjects:@[] atSection:sectionIndex];
        }
    }
    [self.tableView reloadData];
}


- (void) updateSection:(NSInteger)index element:(EKHeaderFooterElement*)ele
{
    _sectionElements[@(index)] = ele;
    ele.eventBus = self.eventBus;
}

- (void) removeHeaderAtIndex:(NSInteger)index
{
    [_sectionElements removeObjectForKey:@(index)];
}

- (void) cleanSectionElements
{
    [_sectionElements removeAllObjects];
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    EKHeaderFooterElement* ele = [_sectionElements objectForKey:@(section)];
    if (!ele) {
        return nil;
    }
    return [ele createResponser];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    EKHeaderFooterElement* ele = [_sectionElements objectForKey:@(section)];
    return ele.height;
}

- (void) tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    EKHeaderFooterElement* ele = [_sectionElements objectForKey:@(section)];
    
    [ele willBeginHandleResponser:view];
    [ele didBeginHandleResponser:view];
}

- (void) tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section
{
   EKHeaderFooterElement* ele = [_sectionElements objectForKey:@(section)];
    [ele willRegsinHandleResponser:view];
    [ele didRegsinHandleResponser:view];
}

- (void) didSelectAtSection:(EKHeaderFooterElement*)ele
{
    NSInteger sectionIndex = NSNotFound;
    for (NSNumber* index  in _sectionElements.allKeys) {
        if (_sectionElements[index] == ele) {
            sectionIndex = index.integerValue;
        }
    }
    
    if (sectionIndex != NSNotFound) {
        ele.opened = !ele.opened;
       
        if (ele.opened) {
            [_dataController replaceObjects:[_originDataController objectsForSections:sectionIndex] atSection:sectionIndex];
        } else {
            [_dataController replaceObjects:@[] atSection:sectionIndex];
        }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void) willBeginHandleResponser:(UIResponder *)responser
{
    [super willBeginHandleResponser:responser];
    [self.eventBus addHandler:self priority:1 port:@selector(didSelectAtSection:)];
}
- (void) didBeginHandleResponser:(UIResponder *)responser
{
    [super didBeginHandleResponser:responser];

}
- (void) didRegsinHandleResponser:(UIResponder *)responser
{
    [super didRegsinHandleResponser:responser];
    [self.eventBus removeHandler:self prot:@selector(didSelectAtSection:)];
}
@end
