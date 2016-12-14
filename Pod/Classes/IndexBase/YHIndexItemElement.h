//
//  YHIndexItemElement.h
//  YaoHe
//
//  Created by stonedong on 16/5/2.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import <ElementKit/ElementKit.h>


@interface YHIndexItemElement : EKAdjustCellElement
{
    @protected
    NSString* _indexTitle;
}
@property (nonatomic, strong, readonly) NSString* indexTitle;
@end
