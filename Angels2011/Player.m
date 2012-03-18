//
//  Player.m
//  Angels2011aws
//
//  Created by Glenn Kronschnabl on 1/12/12.
//  Copyright (c) 2012 Glenn Kronschnabl. All rights reserved.
//

#import "Player.h"
#import "Parent.h"
#import "Team.h"
#import <YAJLios/YAJL.h>
#import "ASIHTTPRequest.h"
#import "AwsURLHelper.h"
#import "Logging.h"

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

// Necessary by the move to jboss and jackson-rs which actually puts null objects in the json stream as 'null'
// if that's what's in the database
#define _BLANK_IF_NSNULL(a) (a == [NSNull null] ? @"" : a)

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
    //DLog(@"looking at parent: %@", t);
    Parent *parent = [[[Parent alloc] init] autorelease];
    parent.name1 = _BLANK_IF_NSNULL([t objectForKey:@"parent1"]);
    parent.phone1 = _BLANK_IF_NSNULL([t objectForKey:@"phone1"]);
    parent.email1 = _BLANK_IF_NSNULL([t objectForKey:@"email1"]);
    parent.name2 = _BLANK_IF_NSNULL([t objectForKey:@"parent2"]);
    parent.phone2 = _BLANK_IF_NSNULL([t objectForKey:@"phone2"]);
    parent.email2 = _BLANK_IF_NSNULL([t objectForKey:@"email2"]);
    p.parents = parent;
    
    return p;
}

+ (NSArray *)allPlayers
{
    DLog(@"getPlayers()");
    //sleep(3);
    NSMutableArray *jplayers = [[[NSMutableArray alloc] init] autorelease];
    NSURL *playersURL = [AwsURLHelper getPlayers];
    DLog(@"players.url %@", playersURL);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:playersURL];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        //DLog(@"players.response = %@", response);
        NSDictionary *temp = [response yajl_JSON];
        //DLog(@"players[after json parse] = %@", temp);
        //NSArray *x = [temp objectForKey:@"players"];
        NSDictionary *x = temp;
        //DLog(@"x = %@", x);
        for (NSDictionary *t in x) {
            //DLog(@"t = %@", t);
            Player* p = [Player playerFromJson:t];
            [jplayers addObject:p];
        }
    }
    else {
        DLog(@"error!! %@", error);
        UIAlertView *popup = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Network Unavailable" delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [popup show];
        [popup release];
    }
    
    DLog(@"jplayers array = %@", jplayers);
    return jplayers;
}

+ (void)processPlayerDataWithBlock:(void (^)(NSArray *players))block
{
    //NSURL *url = [AwsURLHelper getPlayers];
	dispatch_queue_t callerQueue = dispatch_get_current_queue();
	dispatch_queue_t downloadQueue = dispatch_queue_create("Player downloader", NULL);
	dispatch_async(downloadQueue, ^{
		NSArray *players = [self allPlayers];
		dispatch_async(callerQueue, ^{
		    block(players);
		});
	});
	dispatch_release(downloadQueue);
}


+ (NSArray *)teamPlayers:(Team *)team
{
    DLog(@"getTeamPlayers()");
    DLog(@"team = %@", team);
    NSString *key = team.uniqueId;
    DLog(@"key = %@", key);
    
    NSMutableArray *jplayers = [[[NSMutableArray alloc] init] autorelease];
    NSURL *playersURL = [AwsURLHelper getPlayersOnASpecifiedTeam:key];
    DLog(@"players.url %@", playersURL);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:playersURL];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        DLog(@"players.response = %@", response);
        NSDictionary *temp = [response yajl_JSON];
        DLog(@"players[after json parse] = %@", temp);
        //NSArray *x = [temp objectForKey:@"players"];
        NSDictionary *x = temp;
        DLog(@"x = %@", x);
        for (NSDictionary *t in x) {
            DLog(@"t = %@", t);
            Player *p = [Player playerFromJson:t];
            [jplayers addObject:p];
        }
    }
    else {
        DLog(@"error!! %@", error);
        UIAlertView *popup = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Network Unavailable" delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [popup show];
        [popup release];
    }
    
    DLog(@"players dict = %@", jplayers);
    return jplayers;
}

//+ (void)processPlayerCardPhotoWithBlock:(void (^)(Player *player, UIImage * image))block
//{
//    //NSURL *url = [AwsURLHelper getPlayers];
//	dispatch_queue_t callerQueue = dispatch_get_current_queue();
//	dispatch_queue_t downloadQueue = dispatch_queue_create("Player downloader", NULL);
//	dispatch_async(downloadQueue, ^{
//        UIImage *image = [self playerCardPhoto: self.player];
//		dispatch_async(callerQueue, ^{
//		    block(player, image);
//		});
//	});
//	dispatch_release(downloadQueue);
//}

+ (UIImage*)playerCardPhoto:(Player *)player
{
    DLog(@"player = %@", player);
    NSString *id = player.uniqueId;
    //sleep(5);
    NSURL *playersURL = [AwsURLHelper getPhotoOfPlayer:id];
    DLog(@"players.photo.url %@", playersURL);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:playersURL];
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
        DLog(@"Failed to load image for URL: %@", playersURL);
    
    return image;
}


@end
