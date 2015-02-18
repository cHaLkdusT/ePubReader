//
//  Item.h
//  ePubReader
//
//  Created by Julius Lundang on 2/16/15.
//  Copyright (c) 2015 Cambridge University Press. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject

@property (nonatomic, strong) NSString *href;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *mediaType;
@property (nonatomic, strong) NSString *properties;

- (instancetype)initWithInfo:(NSString *)href ID:(NSString *)ID mediaType:(NSString *)mediaType properties:(NSString *)properties;

@end
