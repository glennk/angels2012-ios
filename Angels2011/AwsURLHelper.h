//
//  AwsURLHelper.h
//  Angels2011aws
//
//  Created by Glenn Kronschnabl on 1/2/12.
//  Copyright (c) 2012 CoreLogic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AwsURLHelper : NSObject

+ (NSURL *)getTeams;
+ (NSURL *)getPlayersOnASpecifiedTeam:(NSString *)key;
+ (NSURL *)getPlayers;
+ (NSURL *)getPhotoOfPlayer:(NSString *)key;
+ (NSURL *)getCoaches;
+ (NSURL *)getGoogleCal;

@end
