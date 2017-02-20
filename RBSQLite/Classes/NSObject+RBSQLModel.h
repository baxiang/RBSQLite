//
//  NSObject+RBSQLModel.h
//  Pods
//
//  Created by baxiang on 2017/2/18.
//
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
NS_ASSUME_NONNULL_BEGIN
@class RBSQLModel;
@class RBSQLite;
@class RBSQLProperty;

@interface NSObject (RBSQLModel)

@property (nullable, nonatomic, copy) NSString *db_tableName;
@property (nonatomic, assign) NSInteger rowid;
/**
 *  the model is inserting ..
 */
@property (nonatomic, readonly) BOOL db_inserting;

+ (RBSQLite *)defaultSQLite;
+ (NSString *)getTableName;
+ (BOOL)isContainSelf;
+ (void)columnAttributeWithProperty:(RBSQLProperty *)property;
+ (nullable NSString *)getPrimaryKey;
/**
 *  multi primary key
 *  联合主键
 *  @return
 */
+ (nullable  NSArray *)getPrimaryKeyUnionArray;

- (NSMutableString *)getAllPropertysString;

+ (RBSQLModel *)getModelInfos;
/**
 *	@brief Containing the super class attributes	设置是否包含 父类 的属性
 */
+ (BOOL)isContainParent;
- (RBSQLProperty *)singlePrimaryKeyProperty;
- (BOOL)singlePrimaryKeyValueIsEmpty;
- (nullable id)singlePrimaryKeyValue;
+ (NSDateFormatter *)getModelDateFormatter;
+ (NSString *)getDBImagePathWithName:(NSString *)filename;
+ (NSString *)getDBDataPathWithName:(NSString *)filename;

- (nullable  id)userGetValueForModel:(RBSQLProperty *)property;
- (nullable id)modelGetValue:(RBSQLProperty *)property;
+ (NSString *)db_rowidAliasName;

- (void)userSetValueForModel:(RBSQLProperty *)property value:(nullable id)value;
- (void)modelSetValue:(RBSQLProperty *)property value:(NSString *)value;
@end
NS_ASSUME_NONNULL_END
