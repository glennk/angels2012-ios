//
//  Logging.h
//  Angels2012
//
//  Created by Glenn Kronschnabl on 3/16/12.
//  Copyright (c) 2012 CoreLogic. All rights reserved.
//

#ifndef Angels2012_Logging_h
#define Angels2012_Logging_h

#ifdef DEBUG
#	define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#	define DLog(...)
#endif


#endif
