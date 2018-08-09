//
//  ProxyManager.m
//  LitPOC
//
//  Created by Gert-Jaap Glasbergen on 09/08/2018.
//  Copyright © 2018 Gert-Jaap Glasbergen. All rights reserved.
//

#import "ProxyManager.h"
#import <Litrpcproxy/Litrpcproxy.h>

@implementation ProxyManager
+(BOOL)isInitialized {
    NSString *adr = [[NSUserDefaults standardUserDefaults] objectForKey:@"nodeAddress"];
    if(adr == nil) { return NO; }
    
    return YES;
}

+(void)setNodeAddress:(NSString *)nodeAddress {
    [[NSUserDefaults standardUserDefaults] setObject:nodeAddress forKey:@"nodeAddress"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSData *)getKey {
    // TODO Generate and store in KeyChain
    NSString *key = @"4b34iofasdfaposd";
    NSData *privKey = [key dataUsingEncoding:NSASCIIStringEncoding];
    return privKey;
}

+(void)startProxy {
    NSData *key = [ProxyManager getKey];
    NSString *adr = [[NSUserDefaults standardUserDefaults] objectForKey:@"nodeAddress"];
    NSError *err;
    LitrpcproxyStartLitRpcProxy(adr, key, 49583, &err);
    
}
@end
