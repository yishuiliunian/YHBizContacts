//
//  EKHeaderFooterElement.h
//  YaoHe
//
//  Created by stonedong on 16/4/29.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import <ElementKit/ElementKit.h>

@interface EKHeaderFooterElement : EKElement
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong, readonly) NSString* identifier;
@property (nonatomic, assign) BOOL opened;
@property (nonatomic, strong) NSString* title;
@end
