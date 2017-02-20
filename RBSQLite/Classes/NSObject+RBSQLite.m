//
//  NSObject+RBSQLite.m
//  Pods
//
//  Created by baxiang on 2017/2/18.
//
//

#import "NSObject+RBSQLite.h"
#import "RBSQLite.h"
@implementation NSObject (RBSQLite)


+ (NSInteger)rowCountWithWhere:(id)where, ...
{
    if ([where isKindOfClass:[NSString class]]) {
        va_list list;
        va_start(list, where);
        where = [[NSString alloc] initWithFormat:where arguments:list];
        va_end(list);
    }
    return [[self defaultSQLite] rowCount:self where:where];
}
- (BOOL)saveToDB
{
    return [self.class insertToDB:self];
}
+ (BOOL)updateToDB:(NSObject *)model where:(id)where, ...
{
    if ([self checkModelClass:model]) {
        if ([where isKindOfClass:[NSString class]]) {
            va_list list;
            va_start(list, where);
            where = [[NSString alloc] initWithFormat:where arguments:list];
            va_end(list);
        }
        return [[self defaultSQLite] updateToDB:model where:where];
    }
    return NO;
}
+ (NSInteger)rowCountWithWhereFormat:(id)where, ...
{
    if ([where isKindOfClass:[NSString class]]) {
        va_list list;
        va_start(list, where);
        where = [[NSString alloc] initWithFormat:where arguments:list];
        va_end(list);
    }
    return [[self defaultSQLite] rowCount:self where:where];
}
- (BOOL)updateToDB
{
   
    if (self.rowid > 0) {
         return [self.class updateToDB:self where:nil];
    }
    else {
        return [self saveToDB];
    }
}
+ (BOOL)insertToDB:(NSObject *)model
{
    if ([self checkModelClass:model]) {
        return [[self defaultSQLite] insertToDB:model];
    }
    return NO;
}

+ (BOOL)checkModelClass:(NSObject *)model
{
    if ([model isMemberOfClass:self])
        return YES;
    
    NSLog(@"%@ can not use %@", NSStringFromClass(self), NSStringFromClass(model.class));
    return NO;
}
#pragma mark -- delete data
- (BOOL)deleteToDB
{
    return [self.class deleteToDB:self];
}
+ (BOOL)deleteToDB:(NSObject *)model
{
    if ([self checkModelClass:model]) {
        return [[self defaultSQLite] deleteToDB:model];
    }
    return NO;
}



+ (NSMutableArray *)searchWithSQL:(NSString *)sql
{
    return [[self defaultSQLite] searchWithSQL:sql toClass:self];
}

+ (void)insertArrayByAsyncToDB:(NSArray *)models
{
    [self insertArrayByAsyncToDB:models completed:nil];
}
+ (void)insertArrayByAsyncToDB:(NSArray *)models completed:(void (^)(BOOL))completedBlock
{
    if (models.count > 0) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self insertToDBWithArray:models filter:nil completed:completedBlock];
        });
    }
}
+ (void)insertToDBWithArray:(NSArray *)models filter:(void (^)(id model, BOOL inserted, BOOL *rollback))filter
{
    [self insertToDBWithArray:models filter:filter completed:nil];
}
+ (void)insertToDBWithArray:(NSArray *)models filter:(void (^)(id model, BOOL inserted, BOOL *rollback))filter completed:(void (^)(BOOL))completedBlock
{
    __block BOOL allInserted = YES;
    [[self defaultSQLite] executeForTransaction:^BOOL(RBSQLite *helper) {
        BOOL isRollback = NO;
        for (int i = 0; i < models.count; i++) {
            id obj = [models objectAtIndex:i];
            BOOL inserted = [helper insertToDB:obj];
            allInserted &= inserted;
            if (filter) {
                filter(obj, inserted, &isRollback);
            }
            if (isRollback) {
                allInserted = NO;
                break;
            }
        }
        return (isRollback == NO);
    }];
    
    if (completedBlock) {
        completedBlock(allInserted);
    }
}
+ (id)searchSingleWithWhere:(id)where orderBy:(NSString *)orderBy
{
    return [[self defaultSQLite] searchSingle:self where:where orderBy:orderBy];
}

@end
