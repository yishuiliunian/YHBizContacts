//
//  YHPrivateContactsElement.m
//  YaoHe
//
//  Created by stonedong on 16/5/2.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHPrivateContactsElement.h"
#import "YHPrivateContactsViewController.h"
#import "YHContactsRequest.h"
#import "DZAuthSession.h"
#import "RpcAccountMessage.pbobjc.h"
#import "YHContactItemElement.h"
#import "YHCoreDB.h"
#import "DZAuthSession.h"
#import "YHPrivateContactsViewController.h"
#import "YHFixContactItemElement.h"
#import <DZCache/DZImageCache.h>
#import "YHContactsManager.h"
#import "YHMyActionGroupViewController.h"
#import "YHMyActionGroupElement.h"
#import <DZAlertPool/DZAlertPool.h>
#import "YHClassRoomListElement.h"
#import "YHClassRoomListViewController.h"
#import "YHChatRoomContactItemElement.h"
#import <YHNetCore.h>
#import "AppDelegate.h"
#import "UIView+SingleClick.h"
#import "YHChatRoomListElement.h"
#import "YHChatRoomListViewController.h"
#import "YHMineElement.h"
#import "YHMineViewController.h"
#import "YHBlockUserListElement.h"
#import "YHBlockUserListViewController.h"
#import "YHNotifications.h"
#import "YHURLRouteDefines.h"
@interface YHPrivateContactsElement() <YHRequestHandler>
{
    BOOL _isFirstAppear;
    YHFixContactItemElement* _activityItem;
    YHFixContactItemElement* _classItem;
    YHFixContactItemElement* _blackItem;
    YHFixContactItemElement * _phoneContactsItem;
    BOOL _syncing;
}
@property (nonatomic, weak, readonly) YHPrivateContactsViewController* contactsViewController;
@property (nonatomic, assign)     BOOL syncing;
@property (nonatomic, strong) UIBarButtonItem* syncItem;
@property (nonatomic, weak)  UIImageView* indicatorView;
@end
@implementation YHPrivateContactsElement

- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _isFirstAppear = YES ;
    _syncing = NO;
    
    return self;
}

- (YHPrivateContactsViewController*) contactsViewController
{
    return (YHPrivateContactsViewController*)self.uiEventPool;
}

- (void) reloadData
{
    NSMutableArray* array = [NSMutableArray new];
    NSArray* allProfile = [[YHContactsManager  shareManager] allContacts];
    for (UserProfile* profile in allProfile) {
        YHContactItemElement* ele = [[YHContactItemElement alloc] initWithContact:profile];
        [array addObject:ele];
    }
    [self updateContacts:array];
}

- (NSArray*) preOrderIndexs
{
    return @[@"※",@"话题"];
}
- (void) updateContacts:(NSMutableArray*)array
{
    __weak typeof(self) weakSelf = self;
    _activityItem = [[YHFixContactItemElement alloc] initWithImage:DZCachedImageByName(@"face_troop_default") title:@"我的活动"];
    [_activityItem setNextAction:^(void) {
        YHMyActionGroupElement * agEle = [YHMyActionGroupElement new];
        YHMyActionGroupViewController* agVC = [[YHMyActionGroupViewController alloc] initWithElement:agEle];
        agVC.hidesBottomBarWhenPushed = YES;
        [weakSelf.env.navigationController pushViewController:agVC animated:YES];
    }];
    
    _classItem = [[YHFixContactItemElement alloc] initWithImage:DZCachedImageByName(@"face_class") title:@"我的班级"];
    
    [_classItem setNextAction:^() {
        YHClassRoomListElement* ele = [YHClassRoomListElement new];
        YHClassRoomListViewController* crVC = [[YHClassRoomListViewController alloc] initWithElement:ele];
            crVC.hidesBottomBarWhenPushed = YES;
        [weakSelf.env.navigationController pushViewController:crVC animated:YES];
    }];
    
    
     _blackItem = [[YHFixContactItemElement alloc] initWithImage:DZCachedImageByName(@"face_black") title:@"黑名单"];
    [_blackItem setNextAction:^(void) {
        
        YHBlockUserListElement* listEle = [YHBlockUserListElement new];
        YHBlockUserListViewController* vc = [[YHBlockUserListViewController alloc] initWithElement:listEle];
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.env.navigationController pushViewController:vc animated:YES];
        
    }];
    //
    _phoneContactsItem = [[YHFixContactItemElement alloc] initWithImage:DZCachedImageByName(@"face_mobile") title:@"手机联系人"];

    [_phoneContactsItem setNextAction:^{
        [[DZURLRoute defaultRoute] routeURL:DZURLRouteQueryLink(kYHURLShowAddressContacts, @{})];
    }];
    //
    
    [array insertObject:_blackItem atIndex:0];
    [array insertObject:_phoneContactsItem atIndex:0];
    [array insertObject:_classItem atIndex:0];
    [array insertObject:_activityItem atIndex:0];

    
    ChatRoomInfo* chatroom  = [YHContactsManager shareManager].activeRoominfo;
    YHChatRoomContactItemElement* item = [[YHChatRoomContactItemElement alloc] initWithImage:DZCachedImageByName(@"face_room") title:chatroom.roomName];
    
    if ([YHContactsManager shareManager].activeRoominfo) {
        item.title = chatroom.roomName;
        item.titleColor = [UIColor blackColor];
        [item setNextAction:^(void) {
            YHChatSessionInfo* info = [YHChatSessionInfo new];
            info.uuid = chatroom.roomId;
            info.userType = UserType_ChatroomUser;
            
            NSURL* location = DZURLRouteQueryLink(kYHURLYohooStartChatAIO, info.yy_modelToJSONObject);
            [[DZURLRoute defaultRoute] routeURL:location];
        }];
    } else {
        item.title = @"未加入话题";
        item.titleColor = [UIColor lightGrayColor];
        __weak typeof(self) wSelf = self;
        [item setNextAction:^(void) {
            YHChatRoomListElement* ele = [YHChatRoomListElement new];
            ele.searchDefault = YES;
            YHChatRoomListViewController* vc = [[YHChatRoomListViewController alloc] initWithElement:ele];
            vc.title = @"热门话题";
            vc.hidesBottomBarWhenPushed = YES;
            [wSelf.env.navigationController pushViewController:vc animated:YES];
        }];
    }
    
    [array addObject:item];
    [self updateSectionDatas:array];
}

- (void) syncContactsFromUser:(BOOL)fromUser
{
    if (_syncing) {
        return;
    }
    [self startSyncAnimation];
    YHContactsRequest* req = [YHContactsRequest new];
    req.skey = DZActiveAuthSession.token;
    req.delegate = self;
    _syncing = YES;
    __weak typeof(self) weakSelf = self;
    [req setErrorHandler:^(NSError *error) {
           DZAlertShowError(error.localizedDescription);
        weakSelf.syncing = NO;
        [weakSelf stopSyncAnimation];
    }];
    
    
    [req setSuccessHanlder:^(GetContactResponse* object) {
        NSMutableArray* userIDs  = [NSMutableArray new];
        for (UserProfile* up in object.contactArray) {
            if (up.userName) {
                [userIDs addObject:up.userName];
            }
        }
        [[YHContactsManager shareManager] syncWithContacts:userIDs];
        [weakSelf reloadData];
        weakSelf.syncing = NO;
        [weakSelf stopSyncAnimation];
        if (fromUser) {
            DZAlertShowSuccess(@"联系人同步成功");
        }

    }];
    
    [req start];
}
- (void) startSyncAnimation
{
    [self stopSyncAnimation];
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = CGFLOAT_MAX;
    [self.indicatorView.layer addAnimation:rotationAnimation forKey:@"transform.rotation"];
    
}

- (void) stopSyncAnimation
{
    [self.indicatorView.layer removeAnimationForKey:@"transform.rotation"];
}

- (void) onHandleContactsChanged:(NSNotification*)nc
{
    if ([YHContactsManager shareManager].eatChanged) {
        [self reloadData];
    }
}
- (void) willBeginHandleResponser:(UIResponder *)responser
{
    [super willBeginHandleResponser:responser];
    DZAddObserverForContactsChanged(self, @selector(onHandleContactsChanged:));
    if ([[YHContactsManager shareManager] eatChanged]) {
        [self reloadData];
    }
    [[YHContactsManager shareManager] syncContacts];
    
    UIImageView* imageView = [UIImageView new];
    imageView.image = DZCachedImageByName(@"ic_ref");
    imageView.frame = CGRectMake(0, 0, 24, 24);
    [imageView addSingleClick:self selector:@selector(handleSync)];
    _syncItem = [[UIBarButtonItem alloc] initWithCustomView:imageView];
    self.env.navigationItem.leftBarButtonItem = _syncItem;
    self.indicatorView = imageView;
}

- (void) handleSync
{
    [self syncContactsFromUser:YES];
}
- (void) didBeginHandleResponser:(YHPrivateContactsViewController *)responser
{
    [super didBeginHandleResponser:responser];
}

- (void) willRegsinHandleResponser:(YHPrivateContactsViewController *)responser
{
    [super willRegsinHandleResponser:responser];
    DZRemoveObserverForContactsChanged(self);
}

- (void) didRegsinHandleResponser:(YHPrivateContactsViewController *)responser
{
    [super didRegsinHandleResponser:responser];
}



- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    EKCellElement* ele = [_dataController objectAtIndexPath:EKIndexPathFromNS(indexPath)];
    if ([ele isKindOfClass:[YHFixContactItemElement class]]) {
        return NO;
    } else if ([ele isKindOfClass:[YHChatRoomContactItemElement class]]) {
        return NO;
    } else if([ele isKindOfClass:[YHContactItemElement class]]) {
        return YES;
    }
    return NO;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        YHContactItemElement* ele = (YHContactItemElement*)[_dataController objectAtIndexPath:EKIndexPathFromNS(indexPath)];
        [ele onHandleDeleteEditing];
    }
}

- (void) onHanldeRemoveElement:(EKElement *)ele{
    [self  reloadData];
}
@end
