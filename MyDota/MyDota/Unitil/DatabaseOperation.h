//
//  DatabaseOperation.h
//  XeraTouch
//
//  Created by cai yong on 3/12/12.
//  Copyright (c) 2012 Aldelo. All rights reserved.
//

#import <Foundation/Foundation.h> 

#import "FMDatabase.h"
#import "FMResultSet.h"
#import "FMDatabaseAdditions.h" 




@interface DatabaseOperation : NSObject


+ (void)copy_DB2Doc_Live;
+ (void)copy_DB2Doc_Demo;
+ (void)initLiveDatabase;
+ (void)initDemoDatabase;


+ (FMDatabase *)openDataBase;
+ (void)closeDataBase:(FMDatabase *)db;
//+ (NSArray *)queryDataBase:(FMDatabase *)db Table:(NSString *)table QueryString:(NSString *)qs FieldType:(NSArray *)fieldtype FieldName:(NSArray *)fieldname;

//2012-4-9
+ (BOOL)createTable:(NSString *)tableName DB:(FMDatabase *)db;
+ (BOOL)dropTable:(NSString *)tableName DB:(FMDatabase *)db;


//没有用FMDB的方式:从第2个字段开始插入数据
+ (BOOL)insertObjectWithoutID:(NSObject *)obj toTable:(NSString *)tableName;
//从第1个字段开始插入数据(CSV专用方法)
+ (BOOL)insertObjectWithID:(NSObject *)obj toTable:(NSString *)tableName;

+ (BOOL)insertObjectWithID:(NSObject *)obj toTable:(NSString *)tableName database:(sqlite3 *)mySqlite;
+ (BOOL)insertObjectWithoutID:(NSObject *)obj toTable:(NSString *)tableName database:(sqlite3 *)mySqlite;
//原来的命名
//+ (BOOL)insertTable:(NSString *)tableName Obj:(NSObject *)obj;



//+ (BOOL)insertTable:(NSString *)tableName DB:(FMDatabase *)db Obj:(NSObject *)obj;
+ (BOOL)deleteRecordeWithID:(int)xid TableName:(NSString *)tableName DB:(FMDatabase *)db;
+ (int)recordeCountInTable:(NSString *)tableName DB:(FMDatabase *)db;
+ (NSArray *)queryTable:(NSString *)tableName QueryString:(NSString *)qs DB:(FMDatabase *)db;

//查询数据太多需耗时，如果查询的数量超过100个，先查100个。剩下的在子线程中完成
+ (NSArray *)queryTable100:(NSString *)tableName QueryString100:(NSString *)qs DB:(FMDatabase *)db;
+ (NSSet *)getGUIDfromTable:(NSString *)tableName DB:(FMDatabase *)db;

+ (BOOL)deleteRecordeWithGUID:(NSString *)gid TableName:(NSString *)tableName DB:(FMDatabase *)db;
+ (BOOL)deleteRecordeWithSqlStr:(NSString*)string DB:(FMDatabase *)db;
//+ (BOOL)updateRecordeWithID:(int)xid TableName:(NSString *)tableName Obj:(NSObject *)obj DB:(FMDatabase *)db;
+ (BOOL)updateRecordeWithID:(NSString *)xid TableName:(NSString *)tableName Obj:(NSObject *)obj DB:(FMDatabase *)db;

//StroeSetting

+ (NSString *)getStoreSettingValue:(int)value;
+ (NSString *)getStoreSettingValue:(int)value DB:(FMDatabase *)db;
+ (NSString *)getTerminalSettingValue:(int)value DB:(FMDatabase *)db;
//+ (void)display_StoreSetting;

//HRDepartment
//+ (BOOL)insertHRDepartment:(HRDepartment *)employee DB:(FMDatabase *)db; 
//+ (BOOL)updateHRDepartment:(HRDepartment *)employee DB:(FMDatabase *)db; 
//+ (BOOL)deleteHRDepartment:(int)hid DB:(FMDatabase *)db;

//Employee 
//+ (BOOL)insertEmployee:(Employee *)employee DB:(FMDatabase *)db; 
//+ (BOOL)updateEmployee:(Employee *)employee DB:(FMDatabase *)db; 
//+ (BOOL)deleteEmployee:(int)eid DB:(FMDatabase *)db;

//SecurityObject

//
+ (NSString *)getName:(NSString *)nameStr ByID:(NSString*)IDName IDValue:(int)value FromSql:(NSString *)sqlName;
//orderDetail&orderHeader
+ (int)insertOrderHeaderWithObj:(NSObject *)obj;

+ (int)getUILanguageWithEmployeeID:(int)eid;
+ (NSString *)getEmployNameWithEmployeeID:(int)eid;
+ (NSString *)get_NameWithEmployeeID:(int)eid;
+ (NSString *)getNameWithEmployeeID:(int)eid DB:(FMDatabase *)db;
+ (NSArray *)get_employee_names;
+ (NSArray *)get_cashierDrawer_counter;
+ (int)get_AutologOutSeconds:(int)tid;

//oh/od/cashier/payment
+ (void)deleteRecord_before:(double)dd;
+ (void)deleteRecords;

//check Security
+ (int)check_rightWithEmployeeID:(int)eid withSecurityObjectName:(NSString *)sname;


+ (void)display_AuditTrail;


//Check OrderType should show visual floor plan
+ (BOOL)shouldShowVisualFloorPlan:(int)orderTypeID;

+ (BOOL)AlwaysPromptSeatNumberUponNewGuestAddition:(int)orderTypeID;

//Check OrderType should prompt guest count
+ (BOOL)shouldPromptGuestCount:(int)orderTypeID;

+ (BOOL)shouldShowVisualFloorPlan:(int)orderTypeID DB:(FMDatabase *)db;
+ (BOOL)shouldPromptGuestCount:(int)orderTypeID DB:(FMDatabase *)db;
+ (BOOL)guestCountRequired:(int)orderTypeID;
+ (BOOL)promptTableTentOnCompletion:(int)orderTypeID;
+ (BOOL)tableTentRequired:(int)orderTypeID;
+ (BOOL)promptCustomerNameOnCompletion:(int)orderTypeID;
+ (BOOL)customerNameRequired:(int)orderTypeID;

//0527
+ (BOOL)isBarTabService:(int)orderTypeID;
+ (BOOL)isBarTabService:(int)orderTypeID DB:(FMDatabase *)db;
+ (BOOL)isBarTabPreAuthEnabled:(int)orderTypeID DB:(FMDatabase *)db;
+ (BOOL)isBarTabPreAuthRequired:(int)orderTypeID DB:(FMDatabase *)db;
+ (BOOL)isBarTabPreAuthIsLimitedAuth:(int)orderTypeID DB:(FMDatabase *)db;
+ (BOOL)isBarTabAllowPaymentsWhileBarPreAuthExist:(int)orderTypeID DB:(FMDatabase *)db;
+ (BOOL)isBarTabAllowCashBarLimitedAuth:(int)orderTypeID DB:(FMDatabase *)db;
+ (BOOL)isEDCCreditUseSecondaryAccount:(int)orderTypeID;
+ (BOOL)isEDCCreditUseSecondaryAccount:(int)orderTypeID DB:(FMDatabase *)db;
+ (BOOL)isDisableEDCSignatureCaptureOniPad:(int)orderTypeID DB:(FMDatabase *)db;

//2014-5-12
+ (BOOL)PickupNameUsesTableTent:(int)orderTypeID;
+ (BOOL)PickupNameUsesTableTent:(int)orderTypeID DB:(FMDatabase *)db;

//0705
+ (BOOL)receiptGratuityOnDiscounts:(FMDatabase *)db;
+ (BOOL)receiptGratuityOnOrderSurcharge:(FMDatabase *)db;
+ (BOOL)receiptGratuityOnDeliverySurcharge:(FMDatabase *)db;
+ (BOOL)receiptGratuityOnExclusiveTaxes:(FMDatabase *)db;
+ (int)ReceiptCalculationOrder1:(FMDatabase *)db;
+ (int)ReceiptCalculationOrder2:(FMDatabase *)db;
+ (int)ReceiptCalculationOrder3:(FMDatabase *)db;
+ (int)ReceiptCalculationOrder4:(FMDatabase *)db;

+ (BOOL)EnableRounding:(int)orderTypeID database:(FMDatabase *)db;

+ (double)ReceiptRoundDownBasis:(FMDatabase *)db;
+ (double)ReceiptRoundDownAmount:(FMDatabase *)db;
+ (double)ReceiptRoundNormalBasis:(FMDatabase *)db;
+ (double)ReceiptRoundNormalAmount:(FMDatabase *)db;
+ (double)ReceiptRoundUpBasis:(FMDatabase *)db;
+ (double)ReceiptRoundUpAmount:(FMDatabase *)db;

+ (void)Update_StoreSettingValue:(NSString *)v withEnum:(int)num;
+ (BOOL)isApos:(FMDatabase *)db;
+ (BOOL)isApos;

 
+ (NSString *)getEmployName_2line_WithEmployeeID:(int)eid DB:(FMDatabase *)db;

//2014-3-20
+ (int)GetCreditCardType:(NSString *)creditCardNumber;// CardLength:(int *)cardLength CardLengthAlternate:(int *)cardLengthAlternate;
+ (int)GetTenderID:(int)creditCardType DB:(FMDatabase *)db;
+ (int)GetGiftCardTenderID:(NSString *)gcCardNumber;

///========================TimeCard=================================
+ (int)LaborEnable:(FMDatabase *)db;
+ (int)LaborHolidayPayScale:(FMDatabase *)db;
+ (BOOL)LaborAutoInsertMissingBreakLunchUponClockOut:(FMDatabase *)db;
+ (int)LaborTimeClockRoundingMinutes:(FMDatabase *)db;
+ (BOOL)LaborBreakCompensated:(FMDatabase *)db;
+ (int)LaborBreakMinutes:(FMDatabase *)db;
+ (BOOL)LaborLunchCompensated:(FMDatabase *)db;
+ (int)LaborLunchMinutes:(FMDatabase *)db;
+ (int)LaborBreakMissedReimburseMinutes:(FMDatabase *)db;
+ (BOOL)LaborBreakMissedReimbursePerDay:(FMDatabase *)db;
+ (int)LaborLunchMissedReimburseMinutes:(FMDatabase *)db;
+ (BOOL)LaborLunchMissedReimbursePerDay:(FMDatabase *)db;
+ (int)LaborBeginLunchGraceBeforeMinutes:(FMDatabase *)db;
+ (int)LaborBeginLunchGraceAfterMinutes:(FMDatabase *)db;
+ (int)LaborEndLunchGraceAfterMinutes:(FMDatabase *)db;
+ (int)LaborEndLunchGraceBeforeMinutes:(FMDatabase *)db;
+ (BOOL)LaborAutoApproveEarlyLateEndLunchException:(FMDatabase *)db;
+ (BOOL)LaborDeferEarlyLateEndLunchExceptionApproval:(FMDatabase *)db;
+ (BOOL)EarlyLateEndLunchDeferredApprovalDoNotPromptReason:(FMDatabase *)db;


+ (int)LaborDailyOverTimeHourAfter:(FMDatabase *)db;
+ (int)LaborDailyDoubleTimeHourAfter:(FMDatabase *)db;
+ (NSArray *)LaborHolidayDates:(FMDatabase *)db;
+ (int)LaborWeekBeginDay:(FMDatabase *)db;
+ (BOOL)LaborOverTimeOn7thConsecutiveDay:(FMDatabase *)db;
+ (int)LaborWeeklyOverTimeHourAfter:(FMDatabase *)db;
+ (int)LaborWeeklyDoubleTimeHourAfter:(FMDatabase *)db;

// edit time card->add manual time card
+ (BOOL)DisableManualWorkHourEntry:(FMDatabase *)db;
+ (BOOL)LaborDisablePersonalHours:(FMDatabase *)db;
+ (BOOL)LaborDisableVacationHours:(FMDatabase *)db;
+ (BOOL)LaborDisableSickHours:(FMDatabase *)db;
+ (BOOL)LaborDisableHolidayHours:(FMDatabase *)db;

// edit time card->edit
+ (BOOL)LaborEnableGratuityReporting:(FMDatabase *)db;
+ (int)LaborPayPeriod:(FMDatabase *)db;
+ (int)LaborDailyMaximumWorkableHours:(FMDatabase *)db;

// Clcok in
+ (int)LaborClockInGraceBeforeMinutes:(FMDatabase *)db;
+ (int)LaborClockInGraceAfterMinutes:(FMDatabase *)db;
+ (BOOL)AutoApproveEarlyClockInAtCurrentTime:(FMDatabase *)db;
+ (BOOL)LaborDeferEarlyClockInExceptionApproval:(FMDatabase *)db;
+ (BOOL)EarlyClockInDeferredApprovalDoNotPromptReason:(FMDatabase *)db;
+ (BOOL)LaborAllowScheduledClockInTimeForEarlyClockIn:(FMDatabase *)db;
+ (BOOL)AutoApproveLateClockInAtCurrentTime:(FMDatabase *)db;
+ (BOOL)LaborDeferLateClockInExceptionApproval:(FMDatabase *)db;
+ (BOOL)LateClockInDeferredApprovalDoNotPromptReason:(FMDatabase *)db;
+ (BOOL)AutoApproveUnscheduledClockInAtCurrentTime:(FMDatabase *)db;
+ (BOOL)LaborDeferUnscheduledClockInExceptionApproval:(FMDatabase *)db;
+ (BOOL)LaborUnscheduledClockInDoNotPromptReason:(FMDatabase *)db;
+ (BOOL)LaborClockInWithinGraceTreatAsScheduledTime:(FMDatabase *)db;

// Clcok out
+ (BOOL)LaborRequireEmployeeNoOpenOrdersAtClockOut:(FMDatabase *)db;
+ (BOOL)LaborRequireEmployeeOpenCashiersClosedAtClockOut:(FMDatabase *)db;
+ (int)LaborClockOutGraceBeforeMinutes:(FMDatabase *)db;
+ (int)LaborClockOutGraceAfterMinutes:(FMDatabase *)db;
+ (BOOL)AutoApproveEarlyClockOutAtCurrentTime:(FMDatabase *)db;
+ (BOOL)AutoApproveLateClockOutAtCurrentTime:(FMDatabase *)db;
+ (BOOL)LaborDeferEarlyClockOutExceptionApproval:(FMDatabase *)db;
+ (BOOL)LaborDeferLateClockOutExceptionApproval:(FMDatabase *)db;
+ (BOOL)LaborDeferUnscheduledClockOutExceptionApproval:(FMDatabase *)db;
+ (BOOL)LaborClockOutWithinGraceTreatAsScheduledTime:(FMDatabase *)db;
+ (BOOL)LaborPerformPaymentGratuityTipOutAtClockOut:(FMDatabase *)db;
+ (BOOL)LaborPromptGratuityReportingAtClockOut:(FMDatabase *)db;

//break
+ (int)LaborBeginBreakGraceBeforeMinutes:(FMDatabase *)db;
+ (int)LaborBeginBreakGraceAfterMinutes:(FMDatabase *)db;
+ (int)LaborEndBreakGraceAfterMinutes:(FMDatabase *)db;
+ (int)LaborEndBreakGraceBeforeMinutes:(FMDatabase *)db;
+ (BOOL)LaborAutoApproveEarlyLateBeginBreakException:(FMDatabase *)db;
+ (BOOL)LaborDeferEarlyLateBeginBreakExceptionApproval:(FMDatabase *)db;
+ (BOOL)LaborAutoApproveEarlyLateBeginLunchException:(FMDatabase *)db;
+ (BOOL)LaborDeferEarlyLateBeginLunchExceptionApproval:(FMDatabase *)db;

+ (BOOL)LaborAutoApproveUnscheduledBreakException:(FMDatabase *)db;
+ (BOOL)LaborDeferUnscheduledBreakExceptionApproval:(FMDatabase *)db;
+ (BOOL)LaborAutoApproveUnscheduledLunchException:(FMDatabase *)db;
+ (BOOL)LaborDeferUnscheduledLunchExceptionApproval:(FMDatabase *)db;
+ (BOOL)LaborBeginBreakWithinGraceTreatAsScheduledTime:(FMDatabase *)db;
+ (BOOL)LaborBeginLunchWithinGraceTreatAsScheduledTime:(FMDatabase *)db;

+ (BOOL)LaborAutoApproveEarlyLateEndBreakException:(FMDatabase *)db;
+ (BOOL)LateClockOutDeferredApprovalDoNotPromptReason:(FMDatabase *)db;
+ (BOOL)EarlyClockOutDeferredApprovalDoNotPromptReason:(FMDatabase *)db;
+ (BOOL)EarlyLateBeginBreakDeferredApprovalDoNotPromptReason:(FMDatabase *)db;
+ (BOOL)EarlyLateBeginLunchDeferredApprovalDoNotPromptReason:(FMDatabase *)db;
+ (BOOL)EarlyLateEndBreakDeferredApprovalDoNotPromptReason:(FMDatabase *)db;
+ (BOOL)UnscheduledBreakDeferredApprovalDoNotPromptReason:(FMDatabase *)db;
+ (BOOL)UnscheduledLunchDeferredApprovalDoNotPromptReason:(FMDatabase *)db;
+ (BOOL)LaborEndBreakWithinGraceTreatAsScheduledTime:(FMDatabase *)db;
+ (BOOL)LaborEndLunchWithinGraceTreatAsScheduledTime:(FMDatabase *)db;
+ (BOOL)LaborDeferEarlyLateEndBreakExceptionApproval:(FMDatabase *)db;

+ (BOOL)LaborShowTimeCardAcknowledgementSignatureLine:(FMDatabase *)db;
+ (NSString *)LaborTimeCardAcknowledgementAgreementText:(FMDatabase *)db;

+ (BOOL)TimeCardValueShowInFraction:(FMDatabase *)db;
+ (NSArray *)getStoreSettingAmountValue;

+ (NSString *)getItemReMakeCount:(NSString *)value DB:(FMDatabase *)db;
+ (NSString *)getItemLineVoided:(NSString *)value DB:(FMDatabase *)db;
//通用对象存储到表的方法
+ (BOOL)saveDataWithDB:(FMDatabase *)db errorMessage:(NSString *__autoreleasing *)errorMessage nsobject:(NSObject *)nsobject;




/**
 *  unity
 */
+ (NSArray *)getPropertyAndType_SQLite:(Class)classname;




@end


