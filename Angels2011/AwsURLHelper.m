//
//  AwsURLHelper.m
//  Angels2011aws
//
//  Created by Glenn Kronschnabl on 1/2/12.
//  Copyright (c) 2012 Glenn Kronschnabl. All rights reserved.
//

#import "AwsURLHelper.h"
#import "Logging.h"

@implementation AwsURLHelper

//#define _HOST @"localhost"
//#define _HOST @"glenn-env-1.elasticbeanstalk.com"
//#define _HOST @"192.168.3.105"
//#define _HOST @"10.71.0.6"
//#define _HOST @"angelsv2-gkrondev.rhcloud.com"

#define __DEV true

//openshift PROD
#if __PROD
#define _HOST @"angels2012.ktmsoftware.com"
#define _PORT @""
#define _CONTEXT @""
#define _RESTPATH @"/rest"
#endif

//local jboss DEV
#if __DEV
#define _HOST @"localhost"
#define _PORT @":8080"
#define _CONTEXT @"/mavenproject11-1.0-SNAPSHOT"
#define _RESTPATH @"/rest"
#endif

+ (NSString *)buildURL:(NSString *)path
{
    NSString * url = [NSString stringWithFormat:@"http://%@%@%@%@%@", _HOST, _PORT, _CONTEXT, _RESTPATH, path];
    DLog(@"buildURL = <%@>", url);
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

+ (NSURL *)getPhotoOfCoach:(NSString *)key
{
    return [NSURL URLWithString: [self buildURL: [NSString stringWithFormat:@"/coach/%@/photo", key]]];
}

static NSString *sFrom = @"2012-01-01T00:00:00Z";
static NSString *sTo = @"2012-12-31T00:00:00Z";

+ (NSURL *)getGoogleCal:(NSDate*)fromDate :(NSDate*)toDate
{
    static NSDateFormatter *dateFormatter;
    
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T00:00:00Z'"];
    }
    
    if (fromDate != nil) {
        sFrom = [dateFormatter stringFromDate:fromDate];
    }
    
    if (toDate != nil) {
        sTo = [dateFormatter stringFromDate:toDate];
    }
    
    NSString *sURL = [NSString stringWithFormat:@"https://www.googleapis.com/calendar/v3/calendars/austinangelsbaseball@yahoo.com/events?key=AIzaSyCPhC0NyIX-4skyCDCbwAWA6AhMTUqGClI&maxResults=1000&timeMin=%@&timeMax=%@&singleEvents=true", sFrom /*@"2012-05-01T00:00:00Z"*/, sTo];
    
    DLog(@"googleCalURL: <%@>", sURL);
    
    return [NSURL URLWithString: sURL];
}

@end
