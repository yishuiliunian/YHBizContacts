//
//  YHContactItemCell.h
//  YaoHe
//
//  Created by stonedong on 16/5/3.
//  Copyright © 2016年 stonedong. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <ElementKit/ElementKit.h>
#import "DZProgrameDefines.h"
#import <YYText/YYText.h>

@interface YHContactItemCell : EKAdjustTableViewCell
DEFINE_PROPERTY_STRONG_UIImageView(avatartImageView);
DEFINE_PROPERTY_STRONG_UIImageView(sexImageView);
DEFINE_PROPERTY_STRONG(YYLabel*, nickLabel);
@end
