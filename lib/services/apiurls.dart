const BASE_URL = "http://100.27.11.122:2000/";
//admin
const admin = BASE_URL + "admin";
const adminLogin = admin + "/login";
//shop
const shop = BASE_URL + "shop/";
const adminShop = shop + "owner/";
const updateShop = shop + "update/";
const searchShop = shop + "search";
//customer
const customer = BASE_URL + "customer/";
const customerPurchase = sales + "customerpurchase/";
const customerReturns = sales + "/" + "customerreturn/";
//supplier
const supplier = BASE_URL + "supplier/";
//product
const product = BASE_URL + "product/";
const productHistory = BASE_URL + "producthistory/";

//transfer
var stocktransfer="${product}"+"stocktransfer";
//category
const category = BASE_URL + "category/";
//attendant
const attendant = BASE_URL + "attendant/";
//roles
const roles = BASE_URL + "roles";
//sales
const sales = BASE_URL + "sale/";
const singleSaleItems = sales + "getSale/";

//transactions
const transaction = BASE_URL + "transaction";
const credit = BASE_URL + "/credit/";
const wallet = BASE_URL + "transaction/";
const usage = BASE_URL + "transaction/";
//expense
const expense = "${transaction}/expense/";
const allTransactions = "$transaction/alltransactions";
