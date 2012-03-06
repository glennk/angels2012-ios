//
//  AwsURLHelper.m
//  Angels2011aws
//
//  Created by Glenn Kronschnabl on 1/2/12.
//  Copyright (c) 2012 CoreLogic. All rights reserved.
//

#import "AwsURLHelper.h"

@implementation AwsURLHelper

//#define _HOST @"localhost"
//#define _HOST @"glenn-env-1.elasticbeanstalk.com"
//#define _HOST @"192.168.3.105"
//#define _HOST @"10.71.0.6"
#define _HOST @"angelsv2-gkrondev.rhcloud.com"
//#define _PORT @":8080"
#define _PORT @""
#define _CONTEXT @"/mavenproject11"
#define _RESTPATH @"/rest"

+ (NSString *)buildURL:(NSString *)path
{
    NSString * url = [NSString stringWithFormat:@"http://%@%@%@%@%@", _HOST, _PORT, _CONTEXT, _RESTPATH, path];
    NSLog(@"buildURL = <%@>", url);
    return url;
}

+ (NSURL *)getTeams
{
    return [NSURL URLWithString: [self buildURL:@"/team"]];
}

+ (NSURL *)getPlayersOnASpecifiedTeam:(NSString *)key
{
    return [NSURL URLWithString: [self buildURL:[NSString stringWithFormat:@"/team/%@/players", key]]];
}

+ (NSURL *)getPlayers
{
    return [NSURL URLWithString: [self buildURL: @"/player"]];    
}

+ (NSURL *)getCoaches
{
    return [NSURL URLWithString: [self buildURL:@"/coach"]];
}

+ (NSURL *)getPhotoOfPlayer:(NSString *)key
{
    return [NSURL URLWithString: [self buildURL: [NSString stringWithFormat:@"/player/%@/photo", key]]];
}

+ (NSURL *)getGoogleCal
{
    //https://www.googleapis.com/calendar/v3/calendars/austinangelsbaseball%40yahoo.com/events?key=AIzaSyCPhC0NyIX-4skyCDCbwAWA6AhMTUqGClI
    //https://www.google.com/calendar/feeds/austinangelsbaseball%40yahoo.com/public/full?alt=jsonc&singleevents=true&sortorder=ascending&futureevents=true
    //return [[[NSURL alloc] initWithString:@"https://www.google.com/calendar/feeds/austinangelsbaseball%40yahoo.com/public/full?alt=jsonc&singleevents=true"] //autorelease];
    return [[[NSURL alloc]
initWithString:@"https://www.googleapis.com/calendar/v3/calendars/austinangelsbaseball%40yahoo.com/events?key=AIzaSyCPhC0NyIX-4skyCDCbwAWA6AhMTUqGClI&maxResults=20&timeMin=2012-02-01T00:00:00Z&singleEvents=true"] autorelease];
}

@end
