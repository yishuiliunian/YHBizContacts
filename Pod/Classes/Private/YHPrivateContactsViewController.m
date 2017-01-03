//
//  YHPrivateContactsViewController.m
//  YaoHe
//
//  Created by stonedong on 16/5/2.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHPrivateContactsViewController.h"
#import <KxMenu/KxMenu.h>
#import "YHChatRoomListElement.h"
#import "YHSearchListViewController.h"
#import "YHSearchClassRoomElement.h"
#import "YHSearchListViewController.h"
#import "YHSearchContactsElement.h"
#import "YHCreateActionGroupElement.h"
#import "YHCreateActionGroupViewController.h"
#import "YHCreateClassElement.h"
#import <DZCache/DZImageCache.h>
#import "UIViewController+BarItem.h"
#import "YHInputTableViewController.h"
#import "DZURLRoute.h"
#import "YHURLRouteDefines.h"

@implementation YHPrivateContactsViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem* edit = [[UIBarButtonItem alloc] initWithImage:DZCachedImageByName(@"ic_new") style:UIBarButtonItemStyleDone target:self action:@selector(showActions)];
    self.navigationItem.rightBarButtonItem = edit;
    [self loadClearBackItem];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}


- (void) showActions
{
    
    KxMenuItem* firend = [KxMenuItem menuItem:@"添加联系人" image:DZCachedImageByName(@"ic_action_add_friend") target:self action:@selector(addFriend)];
    KxMenuItem* searchClass= [KxMenuItem menuItem:@"寻找班级" image:DZCachedImageByName(@"ic_action_search_cls") target:self action:@selector(searchClass)];
    KxMenuItem* searchChat = [KxMenuItem menuItem:@"搜索话题" image:DZCachedImageByName(@"ic_action_search_room") target:self action:@selector(searchChatContent)];
//    KxMenuItem * addressBook = [KxMenuItem menuItem:@"手机联系人" image:nil target:self action:@selector(showAddressBookContacts)];
    NSArray* elements =@[firend, searchClass,searchChat];
    
    CGRect rect = CGRectMake(0, 0, 0, 0);
    rect.origin.x = CGRectGetWidth(self.view.bounds) - 33;
    rect.origin.y = CGRectGetHeight(self.navigationController.navigationBar.bounds) + 10;
    [KxMenu showMenuInView:[UIApplication sharedApplication].keyWindow fromRect:rect menuItems:elements];
}

- (void) showAddressBookContacts
{
    [[DZURLRoute defaultRoute] routeURL:DZURLRouteQueryLink(kYHURLShowAddressContacts, @{})];
}

- (void) searchChatContent
{
    YHChatRoomListElement* searchEle = [[YHChatRoomListElement alloc] initWithModel:EKSyncListElementModelSearch];
    searchEle.searchDefault = YES;
    YHSearchListViewController* vc = [[YHSearchListViewController alloc] initWithElement:searchEle];
    vc.searchBar.placeholder = @"搜索话题名称";
    vc.hidesBottomBarWhenPushed = YES;
    [vc setCreateBlock:^(UIViewController* host) {
            YHCreateActionGroupElement* ele = [YHCreateActionGroupElement new];
            YHCreateActionGroupViewController* vc = [[YHCreateActionGroupViewController alloc] initWithElement:ele];
            [host.navigationController pushViewController:vc animated:YES];
    }];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) addFriend
{
    YHSearchContactsElement* ele = [[YHSearchContactsElement alloc] initWithModel:EKSyncListElementModelSearch];
    YHSearchListViewController* search = [[YHSearchListViewController alloc] initWithElement:ele];
    search.hidesBottomBarWhenPushed = YES;
    search.placeHolderView.label.text = @"没有找到匹配的人";
    search.placeHolderView.button.hidden = YES;
    search.searchBar.placeholder = @"搜索昵称/手机号/哟呵号";
    [search view];
    search.tableView.mj_header = nil;
    search.tableView.mj_footer = nil;
    [self.navigationController pushViewController:search animated:YES];
}

- (void) searchClass
{
    YHSearchClassRoomElement* searchEle = [[YHSearchClassRoomElement alloc] initWithModel:EKSyncListElementModelSearch];
    searchEle.searchDefalut = YES;
    YHSearchListViewController* search = [[YHSearchListViewController alloc] initWithElement:searchEle];
    search.placeHolderView.label.text = @"没有找到任何班级";
    search.searchBar.placeholder = @"搜索班级名称";
    [search.placeHolderView.button setTitle:@"创建班级" forState:UIControlStateNormal];
    [search setCreateBlock:^(UIViewController* host) {
        YHCreateClassElement* createElment = [YHCreateClassElement new];
        YHInputTableViewController* vc = [[YHInputTableViewController alloc] initWithElement:createElment];
        [host.navigationController pushViewController:vc animated:YES];
    }];
    search.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:search animated:YES];
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
