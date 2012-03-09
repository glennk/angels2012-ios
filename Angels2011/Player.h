//
//  Player.h
//  Angels2011aws
//
//  Created by Glenn Kronschnabl on 1/12/12.
//  Copyright (c) 2012 CoreLogic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parent.h"
#import "Team.h"

@interface Player : NSObject

@property (nonatomic, retain) NSString * uniqueId;
@property (nonatomic, retain) NSString * firstname;
@property (nonatomic, retain) NSString * lastname;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSString * number;
@property (nonatomic, retain) NSString * positions;
@property (nonatomic, retain) NSString * level;
@property (nonatomic, retain) NSString * bats;
@property (nonatomic, retain) NSString * throws;
@property (nonatomic, retain) Parent * parents;

//+ (Player *)playerFromJson:(NSDictionary *)jsonData;
+ (void)processPlayerDataWithBlock:(void (^)(NSArray *players))fetchPlayers;
+ (NSArray *)allPlayers;
+ (NSArray *)teamPlayers:(Team *)team;
+ (UIImage *)playerCardPhoto:(Player *)player;

@end
