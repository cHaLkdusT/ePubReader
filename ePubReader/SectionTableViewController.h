//
//  SectionTableViewController.h
//  ePubReader
//
//  Created by Mark Oliver Baltazar on 2/24/15.
//  Copyright (c) 2015 Cambridge University Press. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PageViewController;

@interface SectionTableViewController : UITableViewController
@property (strong, nonatomic) PageViewController *detailViewController;
@end
