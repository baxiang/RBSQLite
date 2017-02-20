//
//  RBSQLUtils.m
//  Pods
//
//  Created by baxiang on 2017/2/18.
//
//

#import "RBSQLUtils.h"
@interface RBDateFormatter : NSDateFormatter
@property (nonatomic, strong) NSRecursiveLock *lock;
@end

@implementation RBDateFormatter
- (id)init
{
    self = [super init];
    if (self) {
        self.lock = [[NSRecursiveLock alloc] init];
        self.generatesCalendarDates = YES;
        self.dateStyle = NSDateFormatterNoStyle;
        self.timeStyle = NSDateFormatterNoStyle;
        self.AMSymbol = nil;
        self.PMSymbol = nil;
        NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        if (locale) {
            [self setLocale:locale];
        }
    }
    return self;
}
//防止在IOS5下 多线程 格式化时间时 崩溃
- (NSDate *)dateFromString:(NSString *)string
{
    [_lock lock];
    NSDate *date = [super dateFromString:string];
    [_lock unlock];
    return date;
}
- (NSString *)stringFromDate:(NSDate *)date
{
    [_lock lock];
    NSString *string = [super stringFromDate:date];
    [_lock unlock];
    return string;
}
@end

@interface RBNumberFormatter : NSNumberFormatter

@end

@implementation RBNumberFormatter
- (NSString *)stringFromNumber:(NSNumber *)number
{
    NSString *string = [number stringValue];
    if (!string) {
        string = [NSString stringWithFormat:@"%lf",[number doubleValue]];
    }
    return string;
}
- (NSNumber *)numberFromString:(NSString *)string
{
    NSNumber *number = [super numberFromString:string];
    if (!number) {
        number = @(string.doubleValue);
    }
    return number;
}
@end


@implementation RBSQLUtils

+ (BOOL)checkStringIsEmpty:(NSString *)string
{
    if (string == nil) {
        return YES;
    }
    if ([string isKindOfClass:[NSString class]] == NO) {
        return YES;
    }
    if (string.length == 0) {
        return YES;
    }
    return [[self getTrimStringWithString:string] isEqualToString:@""];
}
+ (NSString *)getTrimStringWithString:(NSString *)string
{
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}




+ (NSNumberFormatter *)numberFormatter
{
    static NSNumberFormatter *numberFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        numberFormatter = [[RBNumberFormatter alloc] init];
    });
    return numberFormatter;
}
+ (NSDateFormatter *)getDBDateFormat
{
    static NSDateFormatter *format;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        format = [[RBDateFormatter alloc] init];
        format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    });
    return format;
}
+ (NSDate *)dateWithString:(NSString *)str
{
    NSDateFormatter *formatter = [self getDBDateFormat];
    NSDate *date = [formatter dateFromString:str];
    return date;
}
+ (NSString *)stringWithDate:(NSDate *)date
{
    NSDateFormatter *formatter = [self getDBDateFormat];
    NSString *datestr = [formatter stringFromDate:date];
    if (datestr.length > 19) {
        datestr = [datestr substringToIndex:19];
    }
    return datestr;
}
+ (NSString *)getDocumentPath
{
#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
#else
    NSString *homePath = [[NSBundle mainBundle] resourcePath];
    return homePath;
#endif
}
+ (NSString *)getPathForDocuments:(NSString *)filename inDir:(NSString *)dir
{
    return [[self getDirectoryForDocuments:dir] stringByAppendingPathComponent:filename];
}
+ (NSString *)getDirectoryForDocuments:(NSString *)dir
{
    NSString *dirPath = [[self getDocumentPath] stringByAppendingPathComponent:dir];
    BOOL isDir = NO;
    BOOL isCreated = [[NSFileManager defaultManager] fileExistsAtPath:dirPath isDirectory:&isDir];
    if (isCreated == NO || isDir == NO) {
        NSError *error = nil;
        BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (success == NO)
            NSLog(@"create dir error: %@", error.debugDescription);
    }
    return dirPath;
}
@end
