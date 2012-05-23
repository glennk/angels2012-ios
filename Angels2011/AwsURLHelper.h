//
//  AwsURLHelper.h
//  Angels2011aws
//
//  Created by Glenn Kronschnabl on 1/2/12.
//  Copyright (c) 2012 Glenn Kronschnabl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AwsURLHelper : NSObject

+ (NSURL *)getTeams;
+ (NSURL *)getPlayersOnASpecifiedTeam:(NSString *)key;
+ (NSURL *)getPlayers;
+ (NSURL *)getPhotoOfPlayer:(NSString *)key;
+ (NSURL *)getPhotoOfCoach:(NSString *)key;
+ (NSURL *)getCoaches;
+ (NSURL *)getGoogleCal:(NSDate*)fromDate :(NSDate*)toDate;

@end
