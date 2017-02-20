//
//  RBSQLUtils.h
//  Pods
//
//  Created by baxiang on 2017/2/18.
//
//

#import <Foundation/Foundation.h>




#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_0 || __MAC_OS_X_VERSION_MIN_REQUIRED >= __MAC_10_7
#define LKDBWeak weak
#define __LKDBWeak __weak
#else
#define LKDBWeak unsafe_unretained
#define __LKDBWeak
#endif

static NSString * const RBSQL_Map_Inherit = @"RBSQLInherit";
static NSString * const RBSQL_Map_UserCalculate = @"RBSQLUserCalculate";
static NSString * const RBSQL_Map_Binding = @"RBSQLBinding";

static NSString * const RBSQL_Type_Text = @"text";
static NSString * const RBSQL_Type_Int = @"integer";
static NSString * const RBSQL_Type_Double = @"double";
static NSString * const RBSQL_Type_Blob = @"blob";

static NSString * const RBSQL_Convert_IntType = @"int_char_short_long";
static NSString * const RBSQL_Convert_FloatType = @"float_double_decimal";
static NSString * const RBSQL_Convert_BlobType = @"";


static NSString * const RBSQL_TypeKey_JSON = @"DB_Type_JSON";
static NSString * const RBSQL_TypeKey_Combo = @"DB_Type_Combo";
static NSString * const RBSQL_TypeKey_Date = @"DB_Type_Date";
static NSString * const RBSQL_TypeKey_Model = @"DB_Type_Model";

static NSString * const RBSQL_TypeKey = @"DB_Type";
static NSString * const RBSQL_ValueKey = @"DB_Value";
static NSString * const RBSQL_TableNameKey = @"DB_TableName";
static NSString * const RBSQL_ClassKey = @"DB_Class";
static NSString * const RBSQL_RowIdKey = @"DB_RowId";
static NSString * const RBSQL_PValueKey = @"DB_PKeyValue";

static NSString * const RBSQL_Attribute_NotNull = @"NOT NULL";
static NSString * const RBSQL_Attribute_Check = @"CHECK";
static NSString * const RBSQL_Attribute_Default = @"DEFAULT";
static NSString * const RBSQL_Attribute_Unique = @"UNIQUE";
///Object-c type converted to SQLite type  把Object-c 类型 转换为sqlite 类型

@interface RBSQLUtils : NSObject
+ (NSString *)getPathForDocuments:(NSString *)filename inDir:(NSString *)dir;
+ (BOOL)checkStringIsEmpty:(NSString *)string;
+ (NSNumberFormatter *)numberFormatter;
+ (NSString *)stringWithDate:(NSDate *)date;
+ (NSDate *)dateWithString:(NSString *)str;
@end
