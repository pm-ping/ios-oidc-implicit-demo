//
//  SampleAppCurrentSession.m
//  SampleApp
//
//  Created by Paul Meyer on 11/25/13.
//  Copyright (c) 2013 Ping Identity. All rights reserved.
//

#import "SampleAppCurrentSession.h"
#import "OpenIDConnectLibrary.h"

@implementation SampleAppCurrentSession

+(SampleAppCurrentSession *)session
{
    static SampleAppCurrentSession *sess;
    
    if(sess == nil)
    {
        sess = [[SampleAppCurrentSession alloc] init];
    }
    
    return sess;
}

-(id)init
{
    self = [super init];
    
    if (self)
    {
    }
    
    return self;
}

-(NSArray *)getAllAttributes
{
    return [_allAttributes allKeys];
}

-(NSString *)getValueForAttribute:(NSString *)attribute
{
    return [_allAttributes valueForKey:attribute];
}

-(void)createSession
{
    if(![self inErrorState])
    {
        NSString *id_token = [_OIDCImplicitProfile getOAuthResponseValueForParameter:kOAuth2ResponseParamIdToken];
        _allAttributes = [OpenIDConnectLibrary parseIDToken:id_token forClient:_OIDCImplicitProfile];
        NSLog(@"Created Session: %@", _allAttributes);
    }
}

-(BOOL)isAuthenticated
{
    if([_allAttributes count] > 0)
    {
        return YES;
    }
    else {
        return NO;
    }
}

-(void)logout
{
    _allAttributes = nil;
}

-(BOOL)inErrorState
{
    if([_OIDCImplicitProfile getOAuthResponseValueForParameter:kOAuth2ResponseParamError] != nil)
    {
        return YES;
    }
    
    return NO;
}

-(NSString *)getLastError
{
    if ([self inErrorState]) {
        return [_OIDCImplicitProfile getOAuthResponseValueForParameter:kOAuth2ResponseParamErrorDescription];
    } else {
        return @"";
    }
}

-(void)setIssuer:(NSString *)newIssuer {
    
    issuer = newIssuer;
}

-(void)setClientId:(NSString *)newClientId {
    
    client_id = newClientId;
}

-(void)setNonce:(NSString *)newNonce {
    
    nonce = newNonce;
}


@end
