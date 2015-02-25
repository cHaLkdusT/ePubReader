//
//  SectionTableViewCell.m
//  ePubReader
//
//  Created by Mark Oliver Baltazar on 2/24/15.
//  Copyright (c) 2015 Cambridge University Press. All rights reserved.
//

#import "SectionTableViewCell.h"

@implementation SectionTableViewCell

@synthesize iconButton;
@synthesize titleTextField;
@synthesize treeItem;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setLevel:(NSInteger)level {
    CGRect rect;
    
    rect = iconButton.frame;
    rect.origin.x = level == 0 ? 15 : 20 * (level) +15;
    iconButton.frame = rect;
    
    rect = titleTextField.frame;
    rect.origin.x = iconButton.frame.origin.x + (40 * level);
    rect.size.width -= 40 * level;
    titleTextField.frame = rect;
}

@end
