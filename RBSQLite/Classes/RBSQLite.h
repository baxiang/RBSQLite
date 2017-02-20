//
//  RBSQLite.h
//  Pods
//
//  Created by baxiang on 2017/2/18.
//
//

#import <Foundation/Foundation.h>
#import "NSObject+RBSQLModel.h"
#import "NSObject+RBSQLite.h"
#import "RBSQLUtils.h"
#import "RBSQLModel.h"
#import <FMDB/FMDatabase.h>
#import <FMDB/FMDatabaseQueue.h>

NS_ASSUME_NONNULL_BEGIN
@interface RBSQLite : NSObject
@property (nullable, nonatomic, copy, readonly) NSString *encryptionKey;

#pragma mark - 表操作
- (void)executeDB:(void (^)(FMDatabase *db))block;
- (BOOL)executeSQL:(NSString *)sql arguments:(nullable NSArray *)args;
- (nullable NSString *)executeScalarWithSQL:(NSString *)sql arguments:(nullable NSArray *)args;
- (void)executeForTransaction:(BOOL (^)(RBSQLite *helper))block;


- (NSInteger)rowCount:(Class)modelClass where:(nullable id)where;
- (void)rowCount:(Class)modelClass where:(nullable id)where callback:(void (^)(NSInteger rowCount))callback;
- (NSInteger)rowCountWithTableName:(NSString *)tableName where:(nullable id)where;


- (nullable NSMutableArray *)searchWithParams:(RBSQLQueryParams *)params;

/**
 *	@brief	query table
 *
 *	@param 	modelClass      entity class
 *	@param 	where           can use NSString or NSDictionary or nil
 
 *	@param 	orderBy         The Sort: Ascending "name asc",Descending "name desc"
 For example: @"rowid desc"x  or @"rowid asc"
 
 *	@param 	offset          Skip how many rows
 *	@param 	count           Limit the number
 *
 *	@return	query finished result is an array(model instance collection)
 */
- (nullable NSMutableArray *)search:(Class)modelClass
                              where:(nullable id)where
                            orderBy:(nullable NSString *)orderBy
                             offset:(NSInteger)offset
                              count:(NSInteger)count;
/*  查询的sql语句 请使用小写 ，否则会不能自动获取 rowid
*  example:
NSMutableArray *array = [[LKDBHelper getUsingLKDBHelper] searchWithSQL:@"select * from @t where blah blah.." toClass:[ModelClass class]];
*
*/
- (nullable NSMutableArray *)searchWithSQL:(NSString *)sql toClass:(nullable Class)modelClass;
- (nullable NSMutableArray *)search:(Class)modelClass withSQL:(NSString *)sql, ...;
- (nullable NSMutableArray *)search:(Class)modelClass
                             column:(nullable id)columns
                              where:(nullable id)where
                            orderBy:(nullable NSString *)orderBy
                             offset:(NSInteger)offset
                              count:(NSInteger)count;
- (void)search:(Class)modelClass
         where:(nullable id)where
       orderBy:(nullable NSString *)orderBy
        offset:(NSInteger)offset
         count:(NSInteger)count
      callback:(void (^)(NSMutableArray * _Nullable array))block;

///return first model or nil
- (nullable id)searchSingle:(Class)modelClass where:(nullable id)where orderBy:(nullable NSString *)orderBy;
/**
 *	@brief	insert when the entity primary key does not exist
 *
 *	@param 	model 	you want to insert the entity
 *
 *	@return	the inserted was successful
 */
- (BOOL)insertToDB:(NSObject *)model;
- (void)insertToDB:(NSObject *)model callback:(void (^)(BOOL result))block;

/**
 *	@brief update table
 *
 *	@param 	model 	you want to update the entity
 *	@param 	where 	can use NSString or NSDictionary or nil
 when "where" is nil : update the value based on rowid column or primary key column
 *
 *	@return	the updated was successful
 */

- (BOOL)updateToDB:(NSObject *)model where:(nullable id)where;
- (void)updateToDB:(NSObject *)model where:(nullable id)where callback:(void (^)(BOOL result))block;
- (BOOL)updateToDB:(Class)modelClass set:(NSString *)sets where:(nullable id)where;
- (BOOL)updateToDBWithTableName:(NSString *)tableName set:(NSString *)sets where:(nullable id)where;


- (BOOL)deleteToDB:(NSObject *)model;
- (void)deleteToDB:(NSObject *)model callback:(void (^)(BOOL result))block;
- (BOOL)deleteWithClass:(Class)modelClass where:(nullable id)where;
- (void)deleteWithClass:(Class)modelClass where:(nullable id)where callback:(void (^)(BOOL result))block;
- (BOOL)deleteWithTableName:(NSString *)tableName where:(nullable id)where;


- (BOOL)isExistsModel:(NSObject *)model;
- (BOOL)isExistsClass:(Class)modelClass where:(nullable id)where;
- (BOOL)isExistsWithTableName:(NSString *)tableName where:(nullable id)where;


+ (void)clearTableData:(Class)modelClass;



#pragma mark - 数据库管理

- (instancetype)initWithDBName:(NSString *)dbname;
- (void)setDBName:(NSString *)fileName;
- (instancetype)initWithDBPath:(NSString *)filePath;
- (void)setDBPath:(NSString *)filePath;
- (BOOL)setKey:(NSString *)key;
- (BOOL)rekey:(NSString *)key;
- (BOOL)getTableCreatedWithClass:(Class)model;
- (BOOL)getTableCreatedWithTableName:(NSString *)tableName;
- (void)dropAllTable;
- (BOOL)dropTableWithClass:(Class)modelClass;
- (BOOL)dropTableWithTableName:(NSString *)tableName;

@end
NS_ASSUME_NONNULL_END
