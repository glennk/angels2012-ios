//
//  Team.h
//  Angels2011aws
//
//  Created by Glenn Kronschnabl on 1/16/12.
//  Copyright (c) 2012 Glenn Kronschnabl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Team : NSObject

@property (nonatomic, retain) NSString * uniqueId;
@property (nonatomic, retain) NSString * level;
@property (nonatomic, retain) NSString * name;

//+ (Team *)teamFromJson:(NSDictionary *)jsonData;
+ (NSArray *)allTeams;

@end
