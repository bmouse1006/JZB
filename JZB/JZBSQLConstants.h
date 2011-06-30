//macro define for JZB SQL template

//summary for income and expend for all accounts
#define SQL_COLUMNNAME_TOTALAMOUNT @"total_amount"
#define SQL_COLUMNNAME_TOTALINCOME @"total_income"
#define SQL_COLUMNNAME_TOTALEXPENSE @"total_expense"
#define SQL_COLUMNNAME_CATALOG_KIND @"catalog_kind"
#define SQL_BALANCESINCEDATE @"select sum(ZJZBBills.zamount) as total_amount, ZJZBCatalogs.zkind as catalog_kind from ZJZBBills, ZJZBCatalogs where ZJZBBills.zdate >= %.2f and ZJZBBills.zcatalog_id is not null and ZJZBBills.zcatalog_id = ZJZBCatalogs.zcatalog_id group by ZJZBBills.zcatalog_id;"
#define SQL_TEMPLATE_UPDATECATALOGIDINBILLS @"update ZJZBBills set zcatalog_id='' where zcatalog_id='%@'"
#define SQL_TEMPLATE_UPDATETOACCOUNTIDINBILLS @"update ZJZBILLs set zto_account_id='' where zto_account_id='%@'"
#define SQL_SUMMARYOFBILLSFORACCOUNT 

