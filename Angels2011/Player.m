//
//  Player.m
//  Angels2011aws
//
//  Created by Glenn Kronschnabl on 1/12/12.
//  Copyright (c) 2012 CoreLogic. All rights reserved.
//

#import "Player.h"
#import "Parent.h"
#import "Team.h"
#import <YAJLios/YAJL.h>
#import "ASIHTTPRequest.h"
#import "AwsURLHelper.h"

@implementation Player

@synthesize uniqueId;
@synthesize firstname;
@synthesize lastname;
@synthesize nickname;
@synthesize number;
@synthesize positions;
@synthesize level;
@synthesize bats;
@synthesize throws;
@synthesize parents;

+ (NSString *)translate:(NSString *)abbrevLorR
{
    if ([abbrevLorR isEqualToString:@"L"])
        return @"Left";
    else
        return @"Right";
}

+ (Player *)playerFromJson:(NSDictionary *)data
{
    Player *p = [[[Player alloc] init] autorelease];
    p.uniqueId = [data objectForKey:@"idplayers"];
    p.firstname = [data objectForKey:@"firstname"];
    p.lastname = [data objectForKey:@"lastname"];
    p.nickname = [data objectForKey:@"nickname"];
    p.number = [data objectForKey:@"number"];
    p.bats = [self translate: [data objectForKey:@"bats"]];
    p.throws = [self translate:[data objectForKey:@"throwsLR"]];
    
    NSArray *ptmp = [data objectForKey:@"positionsCollection"];
    if (!ptmp || ptmp.count == 0) {
        p.positions = @"Unknown";
    }
    else {
        for (NSDictionary *s in ptmp) {
            NSString *pos = [s objectForKey:@"position"];
            p.positions = pos;
        }
    }
    
    NSDictionary *teams = [data objectForKey:@"teamsId"];
    p.level = [teams objectForKey:@"level"];
    
    NSDictionary *t = [data objectForKey:@"parents"];
    NSLog(@"looking at parent: %@", t);
    Parent *parent = [[[Parent alloc] init] autorelease];
    parent.name1 = [t objectForKey:@"parent1"];
    parent.phone1 = [t objectForKey:@"phone1"];
    parent.email1 = [t objectForKey:@"email1"];
    parent.name2 = [t objectForKey:@"parent2"];
    parent.phone2 = [t objectForKey:@"phone2"];
    parent.email2 = [t objectForKey:@"email2"];
    p.parents = parent;
    
    return p;
}

+ (NSArray *)allPlayers
{
    NSLog(@"getPlayers()");
    NSMutableArray *jplayers = [[[NSMutableArray alloc] init] autorelease];
    NSURL *playersURL = [AwsURLHelper getPlayers];
    NSLog(@"players.url %@", playersURL);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:playersURL];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"players.response = %@", response);
        NSDictionary *temp = [response yajl_JSON];
        NSLog(@"players[after json parse] = %@", temp);
        NSArray *x = [temp objectForKey:@"players"];
        NSLog(@"x = %@", x);
        for (NSDictionary *t in x) {
            NSLog(@"t = %@", t);
            Player* p = [Player playerFromJson:t];
            [jplayers addObject:p];
        }
    }
    NSLog(@"jplayers array = %@", jplayers);
    return jplayers;
}

+ (NSArray *)teamPlayers:(Team *)team
{
    NSLog(@"getTeamPlayers()");
    NSLog(@"team = %@", team);
    NSString *key = team.uniqueId;
    NSLog(@"key = %@", key);
    
    NSMutableArray *jplayers = [[[NSMutableArray alloc] init] autorelease];
    NSURL *playersURL = [AwsURLHelper getPlayersOnASpecifiedTeam:key];
    NSLog(@"players.url %@", playersURL);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:playersURL];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSLog(@"players.response = %@", response);
        NSDictionary *temp = [response yajl_JSON];
        NSLog(@"players[after json parse] = %@", temp);
        NSArray *x = [temp objectForKey:@"players"];
        NSLog(@"x = %@", x);
        for (NSDictionary *t in x) {
            NSLog(@"t = %@", t);
            Player *p = [Player playerFromJson:t];
            [jplayers addObject:p];
        }
    }
    //NSLog(@"players dict = %@", jplayers);
    return jplayers;
}

+ (UIImage*)playerCardPhoto:(Player *)player
{
    NSLog(@"player = %@", player);
    NSString *id = player.uniqueId;
    NSURL *playersURL = [AwsURLHelper getPhotoOfPlayer:id];
    NSLog(@"players.photo.url %@", playersURL);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:playersURL];
    [request addRequestHeader:@"Accept" value:@"image/jpeg"];
    [request startSynchronous];
    NSError *error = [request error];
    UIImage *image = nil;
    if (!error) {
        NSData *responseData = [request responseData];
        image = [UIImage imageWithData:responseData];
    }      
    
    if (image == nil)
        NSLog(@"Failed to load image for URL: %@", playersURL);
    else {
        //        fieldImage.image = image;
        //        playerPhoto.frame = CGRectMake(0, 0, image.size.width*SCALE, image.size.height*SCALE);
        //        CGSize size = CGSizeMake(image.size.width*SCALE, image.size.height*SCALE);
        //        scrollView.contentSize = size; //image.size;
    }
    return image;
}


@end
