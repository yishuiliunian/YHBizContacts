//
//  YHContactsManager.m
//  YaoHe
//
//  Created by stonedong on 16/7/2.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import "YHContactsManager.h"
#import <DZFileUtils/DZFileUtils.h>
#import "YHAccountData.h"
#import <DZAuthSession/DZAuthSession.h>
#import "YHCommonCache.h"
#import "DZLogger.h"
#import <DZLogger/DZLogger.h>
#import <YHNetCore/YHNetCore.h>
#import "YHNotifications.h"
#import "YHGetSelfChatRoomRequest.h"
#import "YHContactChangeRequest.h"
#import "YHContactsRequest.h"
#define kYHActiveRoomInfo YHActionRoomInfoKey()

NSString* YHActionRoomInfoKey(){
    return [NSString stringWithFormat:@"%@%@",DZActiveAuthSession.userID, @"shdfhsjkdfhjshfjksd"];
}

NSString* YHKeyAccountData(NSString* key) {
    return [NSString stringWithFormat:@"%@%@",DZActiveAuthSession.userID, key];
}

NSString* YHAccountNSStringWithKey(NSString* key) {
    NSString* accountKey = YHKeyAccountData(key);
    return [[NSUserDefaults standardUserDefaults] stringForKey:accountKey];
}

int YHAccountIntWithKey(NSString* key) {
  return   [YHAccountNSStringWithKey(key) intValue];
}

int64_t YHAccountInt64WithKey(NSString* key) {
    return [YHAccountNSStringWithKey(key) longLongValue];
}

void YHSetAccountNSString(NSString* key , NSString* value) {
    NSString* accountKey = YHKeyAccountData(key);
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:accountKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

void YHSetAccountInt(NSString* key, int value) {
    YHSetAccountNSString(key, [@(value) stringValue]);
}

void YHSetAccountInt64(NSString* key, int64_t value) {
    YHSetAccountNSString(key,[@(value) stringValue]);
}

@interface YHContactsManager ()
{
    NSMutableSet* _contacts;
    dispatch_queue_t _editQueue;
}
@property (nonatomic, strong, readonly) NSString* userID;
@property (nonatomic, strong, readonly) NSString* cachePath;
@property (nonatomic, assign, readonly) int64_t lastChangedSEQID;
@property (nonatomic, strong, readonly) NSMutableSet* contacts;
@property (atomic, assign) BOOL netSyncing;
@end

@implementation YHContactsManager
+ (YHContactsManager*) shareManager
{
    return [[YHAccountData shareFactory] shareInstanceFor:[self class]];
}
- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _editQueue = dispatch_queue_create("com.yaohe.edit.contact.queue", NULL);
    _contacts = [NSMutableSet set];
    _userID = DZActiveAuthSession.userID;
    _contactsChanged  = YES;
    [self loadDiskData];
    [self syncChatRoom];
    _netSyncing = NO;
    [self syncAllContacts];
    return self;
}

static NSString* YHAccountContanctsChangedKey = @"com.dzpqzb.yohoo.changed.contancts";
- (void) setLastChangedSEQID:(int64_t)lastChangedSEQID
{
    YHSetAccountInt64(YHAccountContanctsChangedKey, lastChangedSEQID);
}
- (int64_t) lastChangedSEQID
{
    return YHAccountInt64WithKey(YHAccountContanctsChangedKey);
}

- (NSString*) cachePath
{
    return DZFileInSubPath(_userID, @"contacts.phebe");
}

- (void) loadDiskData
{
    dispatch_barrier_sync(_editQueue, ^{
        NSData* data = [NSData dataWithContentsOfFile:self.cachePath];
        if (!data) {
            DDLogError(@"读取用户数据失败");
            return ;
        }
        NSError* error;
        NSArray* array = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (error) {
            DDLogError(@"解析用户联系人失败%@",error);
            return;
        }
        [_contacts addObjectsFromArray:array];
        [self loadData];
    });
}
- (void) synchroinze
{
    dispatch_barrier_async(_editQueue, ^{
        NSArray* array = _contacts.allObjects;
        NSError* error;
        NSData* data = [NSJSONSerialization dataWithJSONObject:array options:0 error:&error];
        if (error) {
            DDLogError(@"序列化用户%@数据失败%@",_userID,error);
            return ;
        }
        BOOL result = [data writeToFile:self.cachePath atomically:YES];
        if (!result) {
            DDLogError(@"写入用户联系人数据失败%@",_userID);
        }
    });
}

- (void) syncWithContacts:(NSArray*)contacts
{
    dispatch_barrier_sync(_editQueue, ^{
        [_contacts removeAllObjects];
        [_contacts addObjectsFromArray:contacts];
    });
    [self synchroinze];
}

- (void) addContact:(NSString*)uid
{
    if (!uid) {
        return;
    }
    __block BOOL changed = NO;
    dispatch_barrier_sync(_editQueue, ^{
        if ([_contacts containsObject:uid]) {
            return ;
        }
        [_contacts addObject:uid];
        changed = YES;
    });
    if (changed) {
        [self setNeedEatContactsChanged];
        [self synchroinze];
    }
}

- (void) removeContact:(NSString *)uid
{
    if (!uid) {
        return;
    }
    __block BOOL changed = NO;
    dispatch_barrier_sync(_editQueue, ^{
        if (![_contacts containsObject:uid]) {
            return;
        }
        [_contacts removeObject:uid];
        changed = YES;
    });
    if (changed) {
        [self setNeedEatContactsChanged];
        [self synchroinze];
    }
}

- (void) syncChatRoom
{
    if (!DZActiveAuthSession.token) {
        return;
    }
    YHGetSelfChatRoomRequest* req = [YHGetSelfChatRoomRequest new];
    __weak typeof(self) weakSelf = self;
    req.skey = DZActiveAuthSession.token;
    [req setSuccessHanlder:^(ChatRoomResponse* object) {
        [weakSelf registerActiveRoominfo:object.room];
    }];
    [req start];
    
}
- (BOOL) existContact:(NSString*)uid
{
   __block  BOOL exist = NO;
    dispatch_sync(_editQueue, ^{
        exist = [_contacts containsObject:uid];
    });
    return exist;
}

- (NSInteger) numberOfContacts
{
    return _contacts.count;
}
- (NSArray<UserProfile*>*)allContacts
{
    NSMutableArray* contacts = [NSMutableArray new];
    dispatch_sync(_editQueue, ^{
        for (NSString* uid in _contacts) {
            UserProfile* profile = [[YHCommonCache shareCache] syncFetchUserProfile:uid];
            if (profile) {
                [contacts addObject:profile];
            } else {
                UserProfile* profile = [UserProfile new];
                profile.userName = uid;
                [contacts addObject:profile];
            }
        }
    });
    return contacts;
}
- (void) loadData
{
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:kYHActiveRoomInfo];
    if (data) {
        NSError* error;
        _activeRoominfo = [ChatRoomInfo parseFromData:data error:&error];
        if (error) {
            DDLogError(@"%@",error.localizedDescription);
        }
    }
}

- (void) storeRoomData
{
    NSData* data = [_activeRoominfo data];
    if (data) {
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kYHActiveRoomInfo];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kYHActiveRoomInfo];
     }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) setNeedEatContactsChanged
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _contactsChanged = YES;
        DZPostContactsChanged(@{});
    });
    
}
- (void) registerActiveRoominfo:(ChatRoomInfo *)info
{
    ChatRoomInfo* oldChatRoomInfo = _activeRoominfo;
    _activeRoominfo = info;
    [self storeRoomData];
    [self setNeedEatContactsChanged];
    if (![oldChatRoomInfo.roomId isEqualToString:info.roomId]) {
        DZPostExitChatroom(@{});
    }
}


- (BOOL) eatChanged
{
    BOOL chagned = _contactsChanged;
    _contactsChanged = NO;
    return chagned;
}
- (void) syncAllContacts
{
    if (_netSyncing) {
        return;
    }
    self.netSyncing = YES;
    YHContactsRequest* req = [YHContactsRequest new];
    req.skey = DZActiveAuthSession.token;
    __weak typeof(self) weakSelf = self;
    [req setErrorHandler:^(NSError *error) {
        weakSelf.netSyncing = NO;
    }];
 
    [req setSuccessHanlder:^(GetContactResponse* object) {
        NSMutableArray* userIDs  = [NSMutableArray new];
        for (UserProfile* up in object.contactArray) {
            if (up.userName) {
                [userIDs addObject:up.userName];
            }
        }
        dispatch_barrier_sync(_editQueue, ^{
            [weakSelf.contacts removeAllObjects];
            [weakSelf.contacts addObjectsFromArray:userIDs];
        });
        [weakSelf setNeedEatContactsChanged];
        [weakSelf synchroinze];
        weakSelf.netSyncing = NO;
        weakSelf.lastChangedSEQID = object.lastSeqid;
    }];
    
    [req start];
}
- (void) syncContacts
{
    if (self.lastChangedSEQID == 0) {
        [self syncAllContacts];
    } else {
        [self syncChanges];
    }
}
- (void) syncChanges
{
    if (_netSyncing) {
        return;
    }
    self.netSyncing = YES;
    __weak typeof(self) weakSelf = self;
    YHContactChangeRequest*  req = [YHContactChangeRequest new];
    req.change.seqid = self.lastChangedSEQID;
    req.skey = DZActiveAuthSession.token;
    [req setErrorHandler:^(NSError *error) {
        weakSelf.netSyncing = NO;
    }];
    [req setSuccessHanlder:^(ContactChangeResponse* object) {
        if (object.contactChangeArray.count) {
            dispatch_barrier_sync(_editQueue, ^{
                for (ContactChangeInfo* info in object.contactChangeArray) {
                    if (!info.contactUserName) {
                        continue;
                    }
                    if (info.action == 0) {
                        [weakSelf.contacts addObject:info.contactUserName];
                        if (info.contact) {
                            [[YHCommonCache shareCache] cacheUserProfile:info.contact];
                        }
                    } else if (info.action == 1) {
                        if ([weakSelf.contacts containsObject:info.contactUserName]) {
                            [weakSelf.contacts removeObject:info.contactUserName];
                        }
                    }
                    NSLog(@"contact user name is %@", info.contactUserName);
                }
                [weakSelf setNeedEatContactsChanged];
            });
            [weakSelf syncChanges];
        }
        weakSelf.netSyncing = NO;
        weakSelf.lastChangedSEQID = object.lastSeqid;
    }];
    [req start];
}
@end

