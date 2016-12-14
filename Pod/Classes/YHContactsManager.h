//
//  YHContactsManager.h
//  YaoHe
//
//  Created by stonedong on 16/7/2.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DZProgrameDefines/DZProgrameDefines.h>

@class UserProfile;
@class ChatRoomInfo;
@interface YHContactsManager : NSObject
@property (nonatomic, assign, readonly) NSInteger numberOfContacts;
@property (nonatomic, assign, readonly) BOOL contactsChanged;
@property (nonatomic, strong, readonly) ChatRoomInfo* activeRoominfo;
+ (YHContactsManager*) shareManager;
- (void) syncWithContacts:(NSArray*)contacts;
- (void) addContact:(NSString*)uid;
- (void) removeContact:(NSString*)uid;
- (BOOL) existContact:(NSString*)uid;
- (NSArray<UserProfile *>*) allContacts;
- (void) registerActiveRoominfo:(ChatRoomInfo*)info;
- (BOOL) eatChanged;
- (void) syncContacts;
@end
