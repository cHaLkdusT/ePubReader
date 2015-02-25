//
//  Section.h
//  ePubReader
//
//  Created by Mark Oliver Baltazar on 2/24/15.
//  Copyright (c) 2015 Cambridge University Press. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Section : NSObject

@property (strong, nonatomic) NSArray *arrNavPoints;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *src;
@property (nonatomic) int level;

@end
