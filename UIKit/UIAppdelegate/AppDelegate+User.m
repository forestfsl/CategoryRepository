//
//  AppDelegate+User.m
//  ksh3
//
//  Created by madao on 15/10/20.
//  Copyright © 2015年 jianminxian. All rights reserved.
//

#import "AppDelegate+User.h"
#import "ZDDRequestModel.h"
#import <FCUUID.h>
#import "KVcache.h"

@implementation AppDelegate (User)

-(void)userLogin{
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *token = [FCUUID uuidForDevice];
        [[Users sharedInfo] autoLogin:token logintType:1];
    });
}


- (void)saveUserOffline{
    
    NSDictionary *userinfo = [[Users sharedInfo] getUserInfo];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:userinfo[@"uid"] forKey:@"uid"];
    
    NSDictionary *result =  [ZDDRequestModel requestServerSyncWithData:kRequestUserUpdateOffLine withParams:dic];
    if (result[@"code"] != nil && [result[@"code"] intValue] == 0)
    {
        
    }
    
}


- (void)updateLoginTime{
    
    NSString *cacheKey = [NSString stringWithFormat:@"backToForeUpdateLoginTime"];
    KVcache *kvcache = [[KVcache alloc] init];
    NSString *hadUpdate = [kvcache getStringWithKey:cacheKey];
    
    if (hadUpdate == nil) {
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:[[Users sharedInfo] getUserUid] forKey:@"uid"];
        
        [ZDDRequestModel requestServerWithData:kRequestUserLoninTime withParams:dic debug:NO success:^(id responseObject) {
            
            NSDictionary *dic = (NSDictionary *)responseObject;
            id code = dic[@"code"];
            if (code != nil && [code intValue] == 0)
            {
                [kvcache saveString:@"1" withKey:cacheKey expire:600];
            }
            
        } failure:^(NSError *error) {
            
        }];
    }
}


@end
