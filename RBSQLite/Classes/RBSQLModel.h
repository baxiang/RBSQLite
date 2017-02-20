//
//  RBSQLModel.h
//  Pods
//
//  Created by baxiang on 2017/2/18.
//
//

#import <Foundation/Foundation.h>
//
NS_ASSUME_NONNULL_BEGIN

@interface RBSQLProperty : NSObject
///保存的方式
@property (nonatomic, copy, readonly) NSString *type;

/**
 表字段的名称
 */
@property (nonatomic, copy, readonly) NSString *sqlColumnName;
///保存到数据的类型
@property (nonatomic, copy, readonly) NSString *sqlColumnType;

///属性名
@property (nonatomic, copy, readonly) NSString *propertyName;
///属性的类型
@property (nonatomic, copy, readonly) NSString *propertyType;

@property (nonatomic, assign) NSInteger length;
@property (nonatomic, assign) BOOL isNotNull;
@property (nullable, nonatomic, copy) NSString *checkValue;
@property (nullable, nonatomic, copy) NSString *defaultValue;
@property (nonatomic, assign) BOOL isUnique;
- (id)initWithType:(NSString *)type cname:(NSString *)cname ctype:(NSString *)ctype pname:(NSString *)pname ptype:(NSString *)ptype;
- (BOOL)isUserCalculate;
@end


@interface RBSQLModel : NSObject

@property (nonatomic, readonly) NSUInteger count;
@property (nullable, nonatomic, readonly) NSArray *primaryKeys;
- (RBSQLProperty *)objectWithIndex:(NSInteger)index;
- (nullable RBSQLProperty *)objectWithSqlColumnName:(NSString *)columnName;
- (id)initWithKeyMapping:(nullable NSDictionary *)keyMapping
           propertyNames:(NSArray *)propertyNames
            propertyType:(NSArray *)propertyType
             primaryKeys:(nullable NSArray *)primaryKeys;
@end


@interface RBSQLQueryParams : NSObject

///columns or array
@property (nullable, nonatomic, copy) NSString *columns;
@property (nullable, nonatomic, copy) NSArray *columnArray;

@property (nullable, nonatomic, copy) NSString *tableName;

///where or dic
@property (nullable, nonatomic, copy) NSString *where;
@property (nullable, nonatomic, copy) NSDictionary *whereDic;

@property (nullable, nonatomic, copy) NSString *groupBy;
@property (nullable, nonatomic, copy) NSString *orderBy;

@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) NSInteger count;

@property (nullable, nonatomic, assign) Class toClass;

@property (nullable, nonatomic, copy) void (^callback)(NSMutableArray * _Nullable results);

@end
NS_ASSUME_NONNULL_END
