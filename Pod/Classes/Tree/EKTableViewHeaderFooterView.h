//
//  EKTableViewHeaderFooterView.h
//  YaoHe
//
//  Created by stonedong on 16/4/29.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EKHeaderFooterElement;
@interface EKTableViewHeaderFooterView : UITableViewHeaderFooterView
@property (nonatomic,weak) EKHeaderFooterElement* element;
@end
