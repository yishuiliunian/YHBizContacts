//
//  YHContactItemElement.m
//  YaoHe
//
//  Created by stonedong on 16/5/3.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHContactItemElement.h"
#import "YHContactItemCell.h"
#import "YHChatElement.h"
#import "YHChatViewController.h"
#import "DZPinyin.h"
#import "YHAppearance.h"
#import "YHCoreDB.h"
#import "YHNotifications.h"
#import "YHTextParser.h"
#import "YHURLRouteDefines.h"
#import "YHDelContactRequest.h"
#import <DZAuthSession/DZAuthSession.h>
#import <DZAlertPool.h>

#import "YHContactsManager.h"

@interface YHContactItemElement()
{
    NSString* _nick;
}
@end
@implementation YHContactItemElement
- (instancetype) init
{
    self = [super init];
    if (!self) {
        return self;
    }
    _viewClass = [YHContactItemCell class];
    self.cellHeight = 60;
    return self;
}

- (NSString*) indexTitle
{
    return _indexTitle;
}

- (instancetype) initWithContact:(UserProfile *)profile
{
    self =[self init];
    if (!self) {
        return self;
    }
    _contact = profile;
    _nick = _contact.nick.length ? _contact.nick : _contact.userName;
    if (_contact.userName.length < 1) {
        _nick  = @"未名";
    }

    if (_nick.length>0) {
        NSString* firstWord = [_nick substringToIndex:1];
        int utfCode = 0;
        void *buffer = &utfCode;
        BOOL b = [firstWord getBytes:buffer maxLength:2 usedLength:NULL encoding:NSUTF16LittleEndianStringEncoding options:NSStringEncodingConversionExternalRepresentation range:NSMakeRange(0, firstWord.length) remainingRange:NULL];
        if (b && (utfCode >= 0x4e00 && utfCode <= 0x9fa5)) {
            char first = pinyinFirstLetter([firstWord characterAtIndex:0]);
            _indexTitle = [[NSString stringWithFormat:@"%c",first] uppercaseString];
        } else {
            _indexTitle = [firstWord uppercaseString];
        }
        if (_indexTitle.length > 0) {
            unichar  c  = [_indexTitle characterAtIndex:0];
            if (c < 'A' || c > 'Z' ) {
                _indexTitle = @"#";
            }
        }
    }
    _nick = [YHTextParser prefixString:_nick gender:profile.gender];
    return self;
}

- (void) willBeginHandleResponser:(YHContactItemCell*)cell
{
    [super willBeginHandleResponser:cell];
    cell.nickLabel.text = _nick;
    [cell.avatartImageView loadAvatarURL:DZ_STR_2_URL(_contact.faceURL)];
}

- (void) didBeginHandleResponser:(YHContactItemCell *)cell
{
    [super didBeginHandleResponser:cell];
}

- (void) willRegsinHandleResponser:(YHContactItemCell *)cell
{
    [super willRegsinHandleResponser:cell];
}

- (void) didRegsinHandleResponser:(YHContactItemCell *)cell
{
    [super didRegsinHandleResponser:cell];
}

- (void) handleSelectedInViewController:(UIViewController *)vc
{
    NSMutableDictionary* info = [NSMutableDictionary new];
    [info safeSetObject:self.contact.userName forKey:kYHURLQueryParamterUID];
    [[DZURLRoute defaultRoute] routeURL:DZURLRouteQueryLink(kYHURLUserDetail, info)];
}


- (void) onHandleDeleteEditing
{
    YHDelContactRequest* request = [[YHDelContactRequest alloc] init];
    request.skey = DZActiveAuthSession.token;
    request.del.contactUserName= self.contact.userName;
    
    __weak typeof(self) weakSelf = self;
    DZAlertDisableIntereact;
    DZAlertShowLoading(@"删除中..");
    [request setSuccessHanlder:^(GetProfileResponse* response) {
        [[YHContactsManager  shareManager] removeContact:weakSelf.contact.userName];
        [weakSelf notifyRemoveThisElement];
        DZAlertEnableIntereact;
        DZAlertHideLoading;
    }];
    
    [request setErrorHandler:^(NSError * error) {
        DZAlertShowError(error.localizedDescription);
        DZAlertEnableIntereact;
    }];
    [request start];
}
@end
