//
//  ItemRef.h
//  ePubReader
//
//  Created by Julius Lundang on 2/16/15.
//  Copyright (c) 2015 Cambridge University Press. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemRef : NSObject

@property (nonatomic, strong) NSString *idref;

- (instancetype)initWithInfo:(NSString *)idref;

@end
