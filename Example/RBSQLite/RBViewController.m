//
//  RBViewController.m
//  RBSQLite
//
//  Created by baxiang on 02/17/2017.
//  Copyright (c) 2017 baxiang. All rights reserved.
//

#import "RBViewController.h"
#import "RBPerson.h"
#import "RBSQLite.h"
#import "NSObject+RBSQLite.h"
@interface RBViewController ()

@end

@implementation RBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    RBPerson *persionWang = [RBPerson new];
    persionWang.personID = @"2";
    persionWang.name = @"wang1";
    persionWang.age = @(45);
    //persionWang.gender = @"男";
    
    RBDog *dogWang = [RBDog new];
    dogWang.dogID = @"4";
    dogWang.name = @"wanggou1";
   // dogWang.age = @(5);
    persionWang.dog = dogWang;
    [persionWang updateToDB];
   // [[RBPerson defaultSQLite] updateToDB:persionWang where:nil];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
