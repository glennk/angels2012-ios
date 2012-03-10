//
//  Coach.h
//  Angels2011aws
//
//  Created by Glenn Kronschnabl on 2/14/12.
//  Copyright (c) 2012 CoreLogic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Coach : NSObject

@property (nonatomic, retain) NSString * uniqueId;
@property (nonatomic, retain) NSString * firstname;
@property (nonatomic, retain) NSString * lastname;
@property (nonatomic, retain) NSString * phone1;
@property (nonatomic, retain) NSString * email1;
@property (nonatomic, retain) NSString * phone2;
@property (nonatomic, retain) NSString * email2;
@property (nonatomic, retain) UIImage * photo;

//+ (Coach *)coachFromJson:(NSDictionary *)jsonData;
+ (NSArray *)allCoaches;

@end
