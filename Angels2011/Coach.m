//
//  Coach.m
//  Angels2011aws
//
//  Created by Glenn Kronschnabl on 2/14/12.
//  Copyright (c) 2012 CoreLogic. All rights reserved.
//

#import "Coach.h"

@implementation Coach

@synthesize uniqueId;
@synthesize firstname;
@synthesize lastname;

+ (Coach *)coachFromJson:(NSDictionary *)data
{
    Coach *c = [[[Coach alloc] init] autorelease];
    c.uniqueId = [data objectForKey:@"idcoaches"];
    c.firstname = [data objectForKey:@"firstname"];
    c.lastname = [data objectForKey:@"lastname"];
    
    return c;
}


@end
