//
//  NSObject+RBSQLite.h
//  Pods
//
//  Created by baxiang on 2017/2/18.
//
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface NSObject (RBSQLite)

+ (NSInteger)rowCountWithWhere:(nullable id)where, ...;
+ (NSInteger)rowCountWithWhereFormat:(nullable id)where, ...;

- (BOOL)saveToDB;
- (BOOL)updateToDB;
- (BOOL)deleteToDB;
+ (nullable NSMutableArray *)searchWithSQL:(NSString *)sql;


+ (nullable id)searchSingleWithWhere:(nullable id)where
                             orderBy:(nullable NSString *)orderBy;

+ (void)insertArrayByAsyncToDB:(NSArray *)models;
+ (void)insertArrayByAsyncToDB:(NSArray *)models completed:(void (^)(BOOL allInserted))completedBlock;

///begin translate for insert models  开始事务插入数组
+ (void)insertToDBWithArray:(NSArray *)models
                     filter:(void (^)(id model, BOOL inserted, BOOL * _Nullable rollback))filter;

+ (void)insertToDBWithArray:(NSArray *)models
                     filter:(void (^)(id model, BOOL inserted, BOOL * _Nullable rollback))filter
                  completed:(void (^)(BOOL allInserted))completedBlock;

@end
NS_ASSUME_NONNULL_END
