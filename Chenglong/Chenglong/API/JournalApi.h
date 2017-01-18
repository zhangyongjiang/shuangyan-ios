/*Auto generated file. Do not modify. Tue Nov 29 16:01:14 CST 2016 */

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "APIError.h"
#import "WebService.h"
#import "Journal.h"
#import "JournalDetailsList.h"

@interface JournalApi : NSObject

+(NSURLSessionDataTask*) JournalAPI_RemoveResources:(Journal*)journal onSuccess:(void (^)(Journal *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(NSURLSessionDataTask*) JournalAPI_ListUserJournals:(NSString*)userId page:(NSNumber*)page onSuccess:(void (^)(JournalDetailsList *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(NSURLSessionDataTask*) JournalAPI_RemoveJournal:(NSString*)journalId onSuccess:(void (^)(Journal *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(NSURLSessionDataTask*) JournalAPI_UpdateText:(Journal*)journal onSuccess:(void (^)(Journal *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(NSURLSessionDataTask*) JournalAPI_GetJournal:(NSString*)journalId onSuccess:(void (^)(Journal *resp))successBlock onError:(void (^)(APIError *err))errorBlock;

+(NSURLSessionDataTask*) JournalAPI_CreateJournal:(NSDictionary*)filePart json:(NSString*)json onSuccess:(void (^)(Journal *resp))successBlock onError:(void (^)(APIError *err))errorBlock progress:(void (^)(NSProgress *progress))progressBlock;

+(NSURLSessionDataTask*) JournalAPI_AddResourceToJournal:(NSDictionary*)filePart journalId:(NSString*)journalId onSuccess:(void (^)(Journal *resp))successBlock onError:(void (^)(APIError *err))errorBlock progress:(void (^)(NSProgress *progress))progressBlock;


@end
