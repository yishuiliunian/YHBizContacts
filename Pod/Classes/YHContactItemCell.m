//
//  YHContactItemCell.m
//  YaoHe
//
//  Created by stonedong on 16/5/3.
//  Copyright © 2016年 stonedong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHContactItemCell.h"
#import "DZGeometryTools.h"
#import "YHAppearance.h"
#import "YHTextParser.h"
@implementation YHContactItemCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return self;
    }
    INIT_SUBVIEW(self.contentView, YYLabel, _nickLabel);
    INIT_SUBVIEW_UIImageView(self.contentView, _avatartImageView);
    INIT_SUBVIEW_UIImageView(self.contentView, _sexImageView);
    _avatartImageView.contentMode = UIStackViewAlignmentFill;
    _avatartImageView.layer.masksToBounds = YES;
    _avatartImageView.hnk_cacheFormat = LTHanekeCacheFormatAvatar();
    _nickLabel.textParser = [YHTextParser nickParser];
    _nickLabel.userInteractionEnabled = NO;
    _nickLabel.font = DZFontCellNormalTitle();
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    CGRect contentRect = self.bounds;
    contentRect = CGRectCenterSubSize(contentRect, CGSizeMake( 30,20));
    CGSize imageSize = CGSizeMake(CGRectGetHeight(contentRect), CGRectGetHeight(contentRect));
    
    CGRect imageRect;
    CGRect labelsR;
    
    CGRectDivide(contentRect, &imageRect, &labelsR, imageSize.width, CGRectMinXEdge);
    labelsR = CGRectShrink(labelsR, 10, CGRectMinXEdge);
    
    _nickLabel.frame= labelsR;
    _avatartImageView.frame = imageRect;
}


@end