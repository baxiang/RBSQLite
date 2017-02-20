//
//  RBSQLModel.m
//  Pods
//
//  Created by baxiang on 2017/2/18.
//
//

#import "RBSQLModel.h"
#import "RBSQLUtils.h"

@implementation RBSQLProperty

- (id)initWithType:(NSString *)type cname:(NSString *)cname ctype:(NSString *)ctype pname:(NSString *)pname ptype:(NSString *)ptype
{
    self = [super init];
    if (self) {
        _type = [type copy];
        _sqlColumnName = [cname copy];
        _sqlColumnType = [ctype copy];
        _propertyName = [pname copy];
        _propertyType = [ptype copy];
    }
    return self;
}
- (BOOL)isUserCalculate
{
    return ([_type isEqualToString:RBSQL_Map_UserCalculate] || _propertyName == nil || [_propertyName isEqualToString:RBSQL_Map_UserCalculate]);
}
@end

@interface RBSQLModel () {
    __strong NSMutableDictionary *_proNameDic;
    __strong NSMutableDictionary *_sqlNameDic;
    __strong NSArray *_primaryKeys;
}
@end
@implementation RBSQLModel
- (id)initWithKeyMapping:(NSDictionary *)keyMapping propertyNames:(NSArray *)propertyNames propertyType:(NSArray *)propertyType primaryKeys:(NSArray *)primaryKeys
{
    self = [super init];
    if (self) {
        
        _primaryKeys = [NSArray arrayWithArray:primaryKeys];
        
        _proNameDic = [[NSMutableDictionary alloc] init];
        _sqlNameDic = [[NSMutableDictionary alloc] init];
        
        NSString *type, *column_name, *column_type, *property_name, *property_type;
        if (keyMapping.count > 0) {
            NSArray *sql_names = keyMapping.allKeys;
            
            for (NSInteger i = 0; i < sql_names.count; i++) {
                
                type = column_name = column_type = property_name = property_type = nil;
                
                column_name = [sql_names objectAtIndex:i];
                NSString *mappingValue = [keyMapping objectForKey:column_name];
                
                //如果 设置的 属性名 是空白的  自动转成 使用ColumnName
                if ([RBSQLUtils checkStringIsEmpty:mappingValue]) {
                    NSLog(@"#ERROR sql column name %@ mapping value is empty,automatically converted LKDBInherit", column_name);
                    mappingValue = RBSQL_Map_Inherit;
                }
                
                if ([mappingValue isEqualToString:RBSQL_Map_UserCalculate]) {
                    type = RBSQL_Map_UserCalculate;
                    column_type = RBSQL_Type_Text;
                }
                else {
                    
                    if ([mappingValue isEqualToString:RBSQL_Map_Inherit] || [mappingValue isEqualToString:RBSQL_Map_Binding]) {
                        type = RBSQL_Map_Inherit;
                        property_name = column_name;
                    }
                    else {
                        type = RBSQL_Map_Binding;
                        property_name = mappingValue;
                    }
                    
                    NSUInteger index = [propertyNames indexOfObject:property_name];
                    
                    NSAssert(index != NSNotFound, @"#ERROR TableMapping SQL column name %@ not fount %@ property name", column_name, property_name);
                    
                    property_type = [propertyType objectAtIndex:index];
                    column_type = [RBSQLModel _SQLTypeFromObjcType:property_type];
                }
                
                [self addDBPropertyWithType:type cname:column_name ctype:column_type pname:property_name ptype:property_type];
            }
        }
        else {
            for (NSInteger i = 0; i < propertyNames.count; i++) {
                type = RBSQL_Map_Inherit;
                property_name = [propertyNames objectAtIndex:i];
                column_name = property_name;
                
                property_type = [propertyType objectAtIndex:i];
                column_type = [RBSQLModel _SQLTypeFromObjcType:property_type];
                
                [self addDBPropertyWithType:type cname:column_name ctype:column_type pname:property_name ptype:property_type];
            }
        }
        
        if (_primaryKeys.count == 0) {
            _primaryKeys = [NSArray arrayWithObject:@"rowid"];
        }
        
        for (NSString *pkname in _primaryKeys) {
            if ([pkname.lowercaseString isEqualToString:@"rowid"]) {
                if ([self objectWithSqlColumnName:pkname] == nil) {
                    [self addDBPropertyWithType:RBSQL_Map_Inherit cname:pkname ctype:RBSQL_Type_Int pname:pkname ptype:@"int"];
                }
            }
        }
    }
    return self;
}

+ (NSString *) _SQLTypeFromObjcType:(NSString *)objcType
{
    if ([RBSQL_Convert_IntType rangeOfString:objcType].length > 0) {
        return RBSQL_Type_Int;
    }
    if ([RBSQL_Convert_FloatType rangeOfString:objcType].length > 0) {
        return RBSQL_Type_Double;
    }
    if ([RBSQL_Convert_BlobType rangeOfString:objcType].length > 0) {
        return RBSQL_Type_Blob;
    }
    
    return RBSQL_Type_Text;
}

- (NSArray *)primaryKeys
{
    return _primaryKeys;
}

- (RBSQLProperty *)objectWithSqlColumnName:(NSString *)columnName
{
    return [_sqlNameDic objectForKey:columnName];
}
- (void)addDBPropertyWithType:(NSString *)type cname:(NSString *)column_name ctype:(NSString *)ctype pname:(NSString *)pname ptype:(NSString *)ptype
{
    RBSQLProperty *db_property = [[RBSQLProperty alloc] initWithType:type cname:column_name ctype:ctype pname:pname ptype:ptype];
    
    if (db_property.propertyName) {
        _proNameDic[db_property.propertyName] = db_property;
    }
    if (db_property.sqlColumnName) {
        _sqlNameDic[db_property.sqlColumnName] = db_property;
    }
}
- (NSUInteger)count
{
    return _sqlNameDic.count;
}
- (RBSQLProperty *)objectWithIndex:(NSInteger)index
{
    if (index < _sqlNameDic.count) {
        id key = [_sqlNameDic.allKeys objectAtIndex:index];
        return [_sqlNameDic objectForKey:key];
    }
    return nil;
}
@end
@implementation RBSQLQueryParams
@end
