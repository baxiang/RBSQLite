//
//  RBPerson.h
//  RBSQLite
//
//  Created by baxiang on 2017/2/18.
//  Copyright © 2017年 baxiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RBDog.h"
@interface RBPerson : NSObject
@property(nonatomic,strong) NSString *personID;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSNumber *age;
@property(nonatomic,strong) NSString *nation;
@property(nonatomic,strong) NSString *gender;
@property(nonatomic,strong) RBDog *dog;
@end
