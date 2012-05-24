//
//  GCalEvent.m
//  Angels2012
//
//  Created by Glenn Kronschnabl on 3/10/12.
//  Copyright (c) 2012 Glenn Kronschnabl. All rights reserved.
//

#import "GCalEvent.h"
#import "ASIHTTPRequest.h"
#import <YAJLios/YAJL.h>
#import "AwsURLHelper.h"
#import "Logging.h"

@implementation GCalEvent

@synthesize title, description, location, start;
//@synthesize key;

+ (GCalEvent *)gcalEventFromJson:(NSDictionary *)data
{
    GCalEvent *event = [[[GCalEvent alloc] init] autorelease];
    event.title = [data objectForKey:@"title"];
    event.description = [data objectForKey:@"description"];
    event.location = [data objectForKey:@"location"];
    // check shouldn't really be necessary due to guard condition below
    NSDictionary *s = [data objectForKey:@"start"];
    if (s) {
        NSString *d = [s objectForKey:@"date"];
        if (d) {
            event.start = d;
        }
    }
    
    return event;
}

//+ (NSArray *)allGcalEvents:(BOOL)includePast
//{
//    NSDate *fromDate = [[[NSDate alloc] init] autorelease];
//    
//    if (includePast) {
//        NSDateComponents *components = [[NSDateComponents alloc] init];
//        [components setMonth:2];
//        [components setYear:2012];
//        NSCalendar *gregorian = [[NSCalendar alloc]
//                                 initWithCalendarIdentifier:NSGregorianCalendar];
//        NSDate *date = [gregorian dateFromComponents:components];
//        fromDate = date;
//    }
//    NSLog(@"fromDate: %@", fromDate);
//        
//    return [self gcalFromUrl:fromDate :nil];
//}

+ (NSArray *)allGcalEvents
{
    return [self gcalFromUrl:nil :nil];
//    return [self gcalFromDisk];
}

+ (NSArray *)gcalFromDisk
{
    DLog(@"getGcalFromDisk()");
    NSMutableArray *gcal = [[[NSMutableArray alloc] init] autorelease];
    NSError *error = nil;
    NSString *txt = [[[NSString alloc] initWithContentsOfFile:@"/Users/grk/events.json" encoding:NSUTF8StringEncoding error:&error] autorelease];
    if (error) {
        DLog(@"error = %@", [error description]);
    }
    else {
        NSDictionary *temp = [txt yajl_JSON];
        //DLog(@"gcal[after json parse] = %@", temp);
        NSArray *y = [temp objectForKey:@"items"];
        //DLog(@"y = %@", y);
        for (NSDictionary *d in y) {
//            DLog(@"looking at item: %@", d);
            if ([d objectForKey:@"recurringEventId"]) {
                NSLog(@"recurringEventId FOUND!...skipping event!");
                continue;
            }
            NSDictionary *key = [d objectForKey:@"start"];
            if (!key || ![key objectForKey:@"date"])
                continue;
            
            GCalEvent *event = [GCalEvent gcalEventFromJson:d];
            [gcal addObject:event];
        }
    }
    
//    DLog(@"gcal = %@", gcal);
    
    return gcal;
}

+ (NSArray *)gcalFromUrl:(NSDate *)fromDate :(NSDate *)toDate
{
    DLog(@"allGcalEvents");
    NSMutableArray *gcal = [[[NSMutableArray alloc] init] autorelease];
    NSURL *url = [AwsURLHelper getGoogleCal :fromDate :toDate];
    DLog(@"gcalFromUrl: %@", url);
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        //DLog(@"gcal response: %@", response);
        NSDictionary *temp = [response yajl_JSON];
        //DLog(@"gcal[after json parse] = %@", temp);
        //NSDictionary *x = [temp objectForKey:@"data"];
        //DLog(@"x = %@", x);
        NSArray *y = [temp objectForKey:@"items"];
        //DLog(@"y = %@", y);
        for (NSDictionary *d in y) {
            DLog(@"looking at item: %@", d);
            if ([d objectForKey:@"recurringEventId"]) {
//                NSLog(@"recurringEventId FOUND!...skipping event!");
                continue;
            }
            NSDictionary *key = [d objectForKey:@"start"];
            if (!key || ![key objectForKey:@"date"])
                continue;

            GCalEvent *event = [GCalEvent gcalEventFromJson:d];
            [gcal addObject:event];
        }
    }
    else {
        DLog(@"error!! %@", error);
        UIAlertView *popup = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Network Unavailable" delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [popup show];
        [popup release];
        gcal = nil;
    }
    
//    DLog(@"gcal = %@", gcal);
    
    return gcal;
}


@end
