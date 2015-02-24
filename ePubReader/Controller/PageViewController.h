//
//  DetailViewController.h
//  ePubReader
//
//  Created by Julius Lundang on 2/16/15.
//  Copyright (c) 2015 Cambridge University Press. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"

@interface PageViewController : UIViewController
@property (nonatomic) NSInteger tableViewCellRow;
@property (strong, nonatomic) NSMutableArray *arrItemRefs;
@property (strong, nonatomic) NSMutableDictionary *items;
@end

