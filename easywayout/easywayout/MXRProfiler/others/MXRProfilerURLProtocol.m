//
//  MXRProfilerURLProtocol.m
//  easywayout
//
//  Created by mxr on 17/1/19.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MXRProfilerURLProtocol.h"

@interface MXRProfilerURLProtocol() <NSURLSessionDelegate>
@property (nonnull,strong) NSURLSessionDataTask *task;
@end

@implementation MXRProfilerURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    return YES;
}

+ (BOOL)canInitWithTask:(NSURLSessionTask *)task
{
    return YES;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b
{
    return [super requestIsCacheEquivalent:a toRequest:b];
}

- (void)startLoading;
{
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    self.task = [session dataTaskWithRequest:self.request];
    [self.task resume];
    //    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
    //    //标示改request已经处理过了，防止无限循环
    //    [NSURLProtocol setProperty:@YES forKey:@"MXRPROfilerURLProkey" inRequest:mutableReqeust];
    //    self.connection = [NSURLConnection connectionWithRequest:mutableReqeust delegate:self];
}

/*!
 @method stopLoading
 @abstract Stops protocol-specific loading of a request.
 @discussion When this method is called, the protocol implementation
 should end the work of loading a request. This could be in response
 to a cancel operation, so protocol implementations must be able to
 handle this call while a load is in progress.
 */
- (void)stopLoading
{
    if (self.task != nil)
    {
        [self.task  cancel];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.client URLProtocolDidFinishLoading:self];
    
    if (connection.originalRequest) {
        NSLog(@"endtime: %f \nrequestSize:%ld \nresponseSize:%ld \ncontentType:%@", [[NSDate date] timeIntervalSince1970], connection.originalRequest.HTTPBody.length, self.cachedResponse.data.length, connection.originalRequest.allHTTPHeaderFields);
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
    
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [[self client] URLProtocol:self didLoadData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error {
    [self.client URLProtocolDidFinishLoading:self];
}

@end

