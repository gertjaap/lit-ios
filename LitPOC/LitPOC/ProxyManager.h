//
//  ProxyManager.h
//  LitPOC
//
//  Created by Gert-Jaap Glasbergen on 09/08/2018.
//  Copyright © 2018 Gert-Jaap Glasbergen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProxyManager : NSObject
+(void)startProxy;
+(BOOL)isInitialized;
+(void)setNodeAddress:(NSString *)nodeAddress;
@end
