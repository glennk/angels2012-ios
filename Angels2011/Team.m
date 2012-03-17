//
//  Team.m
//  Angels2011aws
//
//  Created by Glenn Kronschnabl on 1/16/12.
//  Copyright (c) 2012 Glenn Kronschnabl. All rights reserved.
//

#import "Team.h"
#import <YAJLios/YAJL.h>
#import "ASIHTTPRequest.h"
#import "AwsURLHelper.h"

@implementation Team

@synthesize uniqueId;
@synthesize level;
@synthesize name;

+ (Team *)teamFromJson:(NSDictionary *)data
{
    Team *t = [[[Team alloc] init] autorelease];
    t.uniqueId = [data objectForKey:@"idteams"];
    t.level = [data objectForKey:@"level"];
    t.name = [data objectForKey:@"name"];
    
    return t;
}

+ (NSArray *)allTeams
{
    NSMutableArray *jteams = [[[NSMutableArray alloc] init] autorelease];

    NSURL *teamsURL = [AwsURLHelper getTeams];
    NSLog(@"teams.url %@", teamsURL);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:teamsURL];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"teams.response = %@", response);
        NSDictionary *temp = [response yajl_JSON];
        NSLog(@"teams[after json parse] = %@", temp);
        //NSArray *x = [temp objectForKey:@"teams"];
        NSDictionary *x = temp;
        NSLog(@"x = %@", x);
        for (NSDictionary *d in x) {
            NSLog(@"t = %@", d);
            Team *t = [Team teamFromJson:d];
            [jteams addObject:t];
        }
    }
    else {
        NSLog(@"error!! %@", error);
        UIAlertView *popup = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Network Unavailable" delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [popup show];
        [popup release];
    }
    
    NSLog(@"teams = %@ (retain count=%d)", jteams, [jteams retainCount]);
    return jteams;
}

@end
