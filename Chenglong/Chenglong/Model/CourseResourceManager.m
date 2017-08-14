//
//  BbzjResourceManager.m
//  Chenglong
//
//  Created by Kevin Zhang (BCG DV) on 8/14/17.
//  Copyright © 2017 Chenglong. All rights reserved.
//

#import "CourseResourceManager.h"

@implementation CourseResourceManager

- (BOOL) resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest
{
    NSURLRequest* request = loadingRequest.request;
    AVAssetResourceLoadingDataRequest* dataRequest = loadingRequest.dataRequest;
    AVAssetResourceLoadingContentInformationRequest* contentRequest = loadingRequest.contentInformationRequest;
    
    return YES;
}

@end
