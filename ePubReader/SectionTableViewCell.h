//
//  SectionTableViewCell.h
//  ePubReader
//
//  Created by Mark Oliver Baltazar on 2/24/15.
//  Copyright (c) 2015 Cambridge University Press. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionItem.h"

@interface SectionTableViewCell : UITableViewCell

#pragma mark - UIElements
@property (nonatomic, strong) IBOutlet UITextField *titleTextField;
@property (nonatomic, strong) IBOutlet UIButton *iconButton;

#pragma mark - Helper variables
@property (nonatomic, strong) SectionItem *treeItem;

#pragma mark - Helper methods
- (void)setLevel:(NSInteger)pixels;
@end
