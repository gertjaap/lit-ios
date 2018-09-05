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
    NSString *key = [[NSUserDefaults standardUserDefaults] objectForKey:@"privateKey"];
    if(key == nil) {
        NSString *alphabet  = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";
        NSMutableString *s = [NSMutableString stringWithCapacity:20];
        for (NSUInteger i = 0U; i < 20; i++) {
            u_int32_t r = arc4random() % [alphabet length];
            unichar c = [alphabet characterAtIndex:r];
            [s appendFormat:@"%C", c];
        }
        key = [NSString stringWithFormat:@"%@", s];
        [[NSUserDefaults standardUserDefaults] setObject:key forKey:@"privateKey"];
    }
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
