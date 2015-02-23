//
//  MasterViewController.h
//  ePubReader
//
//  Created by Julius Lundang on 2/16/15.
//  Copyright (c) 2015 Cambridge University Press. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PageViewController;

@interface SectionViewController : UITableViewController

@property (strong, nonatomic) PageViewController *detailViewController;

@end

