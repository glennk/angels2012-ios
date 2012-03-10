//
//  GCalEvent.h
//  Angels2012
//
//  Created by Glenn Kronschnabl on 3/10/12.
//  Copyright (c) 2012 CoreLogic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCalEvent : NSObject
 
@property (retain, nonatomic) NSString *title;
@property (retain, nonatomic) NSString *description;
@property (retain, nonatomic) NSString *location;
@property (retain, nonatomic) NSString *start;
//@property (retain, nonatomic) NSString *key;

+ (NSArray *)allGcalEvents;

@end
