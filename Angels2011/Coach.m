//
//  Coach.m
//  Angels2011aws
//
//  Created by Glenn Kronschnabl on 2/14/12.
//  Copyright (c) 2012 CoreLogic. All rights reserved.
//

#import "Coach.h"
#import <YAJLios/YAJL.h>
#import "ASIHTTPRequest.h"
#import "AwsURLHelper.h"

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

+ (NSArray *)allCoaches
{
    NSLog(@"getCoaches()");
    NSMutableArray *jcoaches = [[[NSMutableArray alloc] init] autorelease];
    NSURL *coachesURL = [AwsURLHelper getCoaches];
    NSLog(@"coaches.url %@", coachesURL);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:coachesURL];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"coaches.response = %@", response);
        NSDictionary *temp = [response yajl_JSON];
        NSLog(@"coaches[after json parse] = %@", temp);
        //NSArray *x = [temp objectForKey:@"coaches"];
        NSDictionary *x = temp;
        NSLog(@"x = %@", x);
        for (NSDictionary *t in x) {
            NSLog(@"t = %@", t);
            Coach *c = [Coach coachFromJson:t];
            [jcoaches addObject:c];
        }
    }
    NSLog(@"jcoaches array = %@", jcoaches);
    return jcoaches;
}

@end
