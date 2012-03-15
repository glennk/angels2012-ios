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

@implementation GCalEvent

@synthesize title, description, location, start;
//@synthesize key;

//- (NSMutableDictionary *)gcalFromDisk
//{
//    NSLog(@"getGcal()");
//    if (!_gcal) {
//        NSLog(@"_gcal is nil, call URL to populate");
//        _gcal = [[[NSMutableDictionary alloc] init] autorelease];
//        NSError *error = nil;
//        NSString *txt = [[[NSString alloc] initWithContentsOfFile:@"/Users/grk/google_calendar.txt" encoding:NSUTF8StringEncoding error:&error] autorelease];
//        if (error) {
//            NSLog(@"error = %@", [error description]);
//        }
//        else {
//            NSDictionary *temp = [txt yajl_JSON];
//            //NSLog(@"gcal[after json parse] = %@", temp);
//            NSDictionary *x = [temp objectForKey:@"data"];
//            //NSLog(@"x = %@", x);
//            NSArray *y = [x objectForKey:@"items"];
//            //NSLog(@"y = %@", y);
//            for (NSDictionary *d in y) {
//                //NSLog(@"keys = %@", [d allKeys]);
//                //NSString *title = [d objectForKey:@"title"];
//                //NSLog(@"title = %@, when = %@", title, [d objectForKey:@"when"]);
//                NSString *start = [[[d objectForKey:@"when"] objectAtIndex:0] objectForKey:@"start"];
//                //                NSDateFormatter *inDateFormatter = [[NSDateFormatter alloc] init];
//                //                [inDateFormatter setDateFormat:@"yyyy-MM-dd"];
//                NSString *key = [start substringToIndex:10];
//                //                NSDate *dstart = [inDateFormatter dateFromString:c];
//                //                NSDateFormatter *outDateFormatter = [[NSDateFormatter alloc] init];
//                //                [outDateFormatter setDateStyle:NSDateFormatterMediumStyle];
//                //                NSString *x = [outDateFormatter stringFromDate:dstart];
//                NSLog(@"key = %@", key);
//                if (![_gcal objectForKey:key]) {
//                    NSMutableArray *x = [[NSMutableArray alloc] init];
//                    [x addObject:d];
//                    [_gcal setValue:x forKey:key];
//                    
//                } else {
//                    [[_gcal objectForKey:x] addObject:x];
//                }
//            }
//        }
//        NSLog(@"gcal = %@", _gcal);
//    }
//    return _gcal;
//}

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

+ (NSArray *)allGcalEvents
{
    NSLog(@"allGcalEvents");
    NSMutableArray *gcal = [[[NSMutableArray alloc] init] autorelease];
    NSURL *url = [AwsURLHelper getGoogleCal];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request startSynchronous];
    NSError *error = [request error];
    if (error) {
        NSLog(@"error = %@", [error description]);
    }
    else {
        NSString *response = [request responseString];
        //NSLog(@"gcal response: %@", response);
        NSDictionary *temp = [response yajl_JSON];
        //NSLog(@"gcal[after json parse] = %@", temp);
        //NSDictionary *x = [temp objectForKey:@"data"];
        //NSLog(@"x = %@", x);
        NSArray *y = [temp objectForKey:@"items"];
        //NSLog(@"y = %@", y);
        for (NSDictionary *d in y) {
            NSLog(@"looking at item: %@", d);
            if ([d objectForKey:@"recurrence"])
                continue;
            NSDictionary *key = [d objectForKey:@"start"];
            if (!key || ![key objectForKey:@"date"])
                continue;

            GCalEvent *event = [GCalEvent gcalEventFromJson:d];
            [gcal addObject:event];
        }
    }
    NSLog(@"gcal = %@", gcal);
    
    return gcal;
}


@end
