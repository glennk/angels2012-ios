//
//  Player.m
//  Angels2011aws
//
//  Created by Glenn Kronschnabl on 1/12/12.
//  Copyright (c) 2012 CoreLogic. All rights reserved.
//

#import "Player.h"
#import "Parent.h"

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

@end
