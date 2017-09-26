//
//  BearBaseRequestManager.m
//  BiZhi
//
//  Created by Chobits on 2017/9/19.
//  Copyright © 2017年 Chobits. All rights reserved.
//

#import "BearBaseRequestManager.h"
#import <GBDeviceInfo/GBDeviceInfo.h>
#import <AFNetworking/AFNetworking.h>

@implementation BearBaseRequestManager

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}

- (void)getRequestWithURLStr:(NSString *)URLStr
                    paraDict:(NSDictionary *)paraDict
                successBlock:(void (^)(id responseObject))successBlock
                failureBlock:(void (^)(NSString *errorStr))failureBlock
{
    [self getRequestWithURLStr:URLStr
                      paraDict:paraDict
             completionHandler:^(BearBaseResponseVO *responseBaseVO) {
                 if (responseBaseVO.error) {
                     if (failureBlock) {
                         failureBlock([NSString stringWithFormat:@"请求失败:%ld", responseBaseVO.error.code]);
                     }
                 }else{
                     if (successBlock) {
                         successBlock(responseBaseVO.responseObject);
                     }
                 }
             }];
}

- (void)getRequestWithURLStr:(NSString *)urlStr
                    paraDict:(NSDictionary *)paraDict
           completionHandler:(void (^)(BearBaseResponseVO *responseBaseVO))completionHandler
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLComponents *components = [NSURLComponents componentsWithString:urlStr];
    
    //Append Para
    if (paraDict) {
        NSMutableArray *queryItems = [NSMutableArray new];
        for (NSString *key in paraDict.allKeys) {
            NSURLQueryItem *queryItem = [NSURLQueryItem queryItemWithName:key value:[NSString stringWithFormat:@"%@", [paraDict objectForKey:key]]];
            [queryItems addObject:queryItem];
        }
        components.queryItems = queryItems;
    }
    
    NSURL *URL = components.URL;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [self setUserAgentWithRequest:request];
    [self baseRequestWithManager:manager
                         request:request
               completionHandler:^(BearBaseResponseVO *responseBaseVO) {
                   if (completionHandler) {
                       completionHandler(responseBaseVO);
                   }
               }];
}

- (void)baseRequestWithManager:(AFURLSessionManager *)manager
                       request:(NSURLRequest *)request
             completionHandler:(void (^)(BearBaseResponseVO *responseBaseVO))completionHandler
{
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (completionHandler) {
            BearBaseResponseVO *responseBaseVO = [BearBaseResponseVO new];
            responseBaseVO.response = response;
            responseBaseVO.responseObject = responseObject;
            responseBaseVO.error = error;
            completionHandler(responseBaseVO);
        }
        
//        if (error) {
//            NSLog(@"Error: %@", error);
//        } else {
//            NSLog(@"---%@ \n ---%@", response, responseObject);
//        }
    }];
    [dataTask resume];
}

- (void)setUserAgentWithRequest:(NSMutableURLRequest *)request
{
    GBDeviceInfo *devInfo = [GBDeviceInfo deviceInfo];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    NSDictionary *systemAttributes = [[NSFileManager defaultManager] fileSystemAttributesAtPath:NSHomeDirectory()];
    NSString *diskTotalSize = [NSString stringWithFormat:@"%.2f", [[systemAttributes objectForKey:@"NSFileSystemSize"] floatValue]/1024/1024/1024];
    NSString *diskFreeSize = [NSString stringWithFormat:@"%.2f", [[systemAttributes objectForKey:@"NSFileSystemFreeSize"] floatValue]/1024/1024/1024];
    
    NSString *secretAgent = [request valueForHTTPHeaderField:@"User-Agent"];
    if (!secretAgent)
    {
        secretAgent = @"";
    }
    
    NSString *newAgent = [NSString stringWithFormat:@"/---***---/%@/iOS/%@/%@/%@/%lu.%lu.%lu/%.0fppi/%.0fG/%.0fGHz(%lu)Cache%.0fKB/%@GB(%@GB)/", app_Name, identifier, version, devInfo.modelString, devInfo.osVersion.major, devInfo.osVersion.minor, devInfo.osVersion.patch, devInfo.displayInfo.pixelsPerInch, devInfo.physicalMemory, devInfo.cpuInfo.frequency, devInfo.cpuInfo.numberOfCores, devInfo.cpuInfo.l2CacheSize, diskTotalSize, diskFreeSize];
    NSString *allAgent = [secretAgent stringByAppendingString:newAgent];
    
    [request setValue:allAgent forHTTPHeaderField:@"User-Agent"];
}




//
//
//- (void)testRequest
//{
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//    
//    NSString *urlStr = @"https://h5.xinkouzi365.com/api/v2/bizhi/tags";
//    NSURL *URL = [NSURL URLWithString:urlStr];
//    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//    
//    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
//        if (error) {
//            NSLog(@"Error: %@", error);
//        } else {
//            NSLog(@"---%@ \n ---%@", response, responseObject);
//        }
//    }];
//    [dataTask resume];
//}
//
//- (void)testRequest2
//{
//    NSString *urlStr = @"https://h5.xinkouzi365.com/api/v2/bizhi/tags";
//    NSDictionary *parameters = @{@"": @""};
//    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:urlStr parameters:parameters error:nil];
//    
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//    
//    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
//        if (error) {
//            NSLog(@"Error: %@", error);
//        } else {
//            NSLog(@"---%@ \n ---%@", response, responseObject);
//        }
//    }];
//    [dataTask resume];
//}

@end
