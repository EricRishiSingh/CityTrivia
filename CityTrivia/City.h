//
//  City.h
//  CityTrivia
//
//  Created by Eric Singh on 2013-06-28.
//  Copyright (c) 2016 Eric Singh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface City : NSObject
{
    @public NSString *name;
    @public NSString *fact;
    @public NSString *firstHint;
    @public NSString *secondHint;
}

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *fact;
@property (nonatomic) NSString *firstHint;
@property (nonatomic) NSString *secondHint;

@end
