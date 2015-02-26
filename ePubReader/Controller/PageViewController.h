//
//  DetailViewController.h
//  ePubReader
//
//  Created by Julius Lundang on 2/16/15.
//  Copyright (c) 2015 Cambridge University Press. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageViewController : UIViewController <UIWebViewDelegate>
@property (nonatomic) NSInteger tableViewCellRow;
@property (nonatomic, strong) NSArray *arrSections;

#pragma mark - IBActions
- (IBAction)prevButton:(id)sender;
- (IBAction)nextButton:(id)sender;
@end

