//
//  Coach.m
//  Angels2011aws
//
//  Created by Glenn Kronschnabl on 2/14/12.
//  Copyright (c) 2012 Glenn Kronschnabl. All rights reserved.
//

#import "Coach.h"
#import <YAJLios/YAJL.h>
#import "ASIHTTPRequest.h"
#import "AwsURLHelper.h"
#import "Logging.h"

@implementation Coach

@synthesize uniqueId;
@synthesize firstname;
@synthesize lastname;
@synthesize phone1, email1, phone2, email2;
@synthesize photo;

#define _BLANK_IF_NSNULL(a) (a == [NSNull null] ? @"" : a)

+ (Coach *)coachFromJson:(NSDictionary *)data
{
    Coach *c = [[[Coach alloc] init] autorelease];
    c.uniqueId = [data objectForKey:@"idcoaches"];
    c.firstname = [data objectForKey:@"firstname"];
    c.lastname = [data objectForKey:@"lastname"];
    c.phone1 = _BLANK_IF_NSNULL([data objectForKey:@"phone1"]);
    c.email1 = _BLANK_IF_NSNULL([data objectForKey:@"email1"]);
    c.phone2 = _BLANK_IF_NSNULL([data objectForKey:@"phone2"]);
    c.email2 = _BLANK_IF_NSNULL([data objectForKey:@"email2"]);
    
    return c;
}

+ (NSArray *)allCoaches
{
    DLog(@"getCoaches()");
    NSMutableArray *jcoaches = [[[NSMutableArray alloc] init] autorelease];
    NSURL *coachesURL = [AwsURLHelper getCoaches];
    DLog(@"coaches.url %@", coachesURL);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:coachesURL];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        DLog(@"coaches.response = %@", response);
        NSDictionary *temp = [response yajl_JSON];
        DLog(@"coaches[after json parse] = %@", temp);
        //NSArray *x = [temp objectForKey:@"coaches"];
        NSDictionary *x = temp;
        DLog(@"x = %@", x);
        for (NSDictionary *t in x) {
            DLog(@"t = %@", t);
            Coach *c = [Coach coachFromJson:t];
            [jcoaches addObject:c];
        }
    }
    else {
        DLog(@"error!! %@", error);
        UIAlertView *popup = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Network Unavailable" delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [popup show];
        [popup release];
        jcoaches = nil;
    }
    
    DLog(@"jcoaches array = %@", jcoaches);
    return jcoaches;
}

- (UIImage*)photo
{
    DLog(@"coachCardPhoto(), coach = %@", self);
    NSString *id = self.uniqueId;
    //sleep(5);
    NSURL *coachURL = [AwsURLHelper getPhotoOfCoach:id];
    DLog(@"coach.photo.url %@", coachURL);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:coachURL];
    [request addRequestHeader:@"Accept" value:@"image/jpeg"];
    [request startSynchronous];
    NSError *error = [request error];
    UIImage *image = nil;
    if (!error) {
        NSData *responseData = [request responseData];
        image = [UIImage imageWithData:responseData];
    }
    else {
        DLog(@"error!! %@", error);
        UIAlertView *popup = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Network Unavailable" delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [popup show];
        [popup release];
    }
    
    if (image == nil)
        DLog(@"Failed to load image for URL: %@", coachURL);

    return image;
}


@end
