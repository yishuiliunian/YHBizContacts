//
//  YHFixContactItemElement.m
//  YaoHe
//
//  Created by stonedong on 16/5/27.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import "YHFixContactItemElement.h"
#import "YHContactItemCell.h"
@interface  YHFixContactItemElement ()
{
    UIImage* _image;
    NSString* _title;
}
@end

@implementation YHFixContactItemElement

- (instancetype)init
{
    self = [super init];
    if (self) {
       _viewClass = [YHContactItemCell class];
        _indexTitle = @"※";
        self.cellHeight = 60;
    }
    return self;
}
- (instancetype) initWithImage:(UIImage *)image title:(NSString *)title
{
    self = [self init];
    if (!self) {
        return self;
    }
    _image = image;
    _title = title;
    return self;
}


- (void) willBeginHandleResponser:(YHContactItemCell*)cell
{
    [super willBeginHandleResponser:cell];
    cell.nickLabel.text = _title;
    cell.avatartImageView.image = _image;
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
    if (self.nextAction) {
        self.nextAction();
    }
}
@end
