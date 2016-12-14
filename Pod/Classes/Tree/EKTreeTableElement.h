//
//  EKTreeTableElement.h
//  YaoHe
//
//  Created by stonedong on 16/4/29.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import "EKAdjustTableElement.h"

@class EKHeaderFooterElement;
@interface EKTreeTableElement : EKAdjustTableElement
{
    EKTableDataController* _originDataController;
}
- (void) updateSection:(NSInteger)index element:(EKHeaderFooterElement*)ele;
- (void) updateTree;

- (NSArray*) preOrderIndexs;
- (void) cleanSectionElements;
@end
