const BASE_URL = "http://54.237.57.225:2000/";
//admin
const admin = BASE_URL + "admin";
const adminLogin = admin + "/login";
const resetpasswordemail = admin + "/resetpasswordemail";
//shop
const shop = "${BASE_URL}shop/";
const adminShop = "${shop}owner/";
const updateShop = "${shop}update/";
const searchShop = "${shop}search";
const shopcategories = "${BASE_URL}shop/category";
const getshopcategories = "${shopcategories}/all";
//customer
const customer = BASE_URL + "customer/";
const customerPurchase = sales + "customerpurchase/";
const customerReturns = "${customer}returns/customer/";
const customersOnCredit = "${customer}oncredit";
const customerDeposit = "$customer" + "deposit/";
const customerTransaction = "$customer" + "transactions/";

//supplier
const supplier = "${BASE_URL}supplier/";
const supplierOnCredit = "${supplier}oncredit";

//product
const product = BASE_URL + "product/";
const productHistory = BASE_URL + "producthistory";

//transfer
var stocktransfer = "${product}" + "stocktransfer";
//category
const category = "${BASE_URL}category/";
//attendant
const attendant = BASE_URL + "attendant/";
//roles
//services
const sales = BASE_URL + "sale/";
const salesbydate = "${BASE_URL}sale/salesbydate/";
const singleSaleItems = "${sales}getsale";

// badstock
const badstock = BASE_URL + "badstock/";

//transactions
const transaction = "${BASE_URL}transaction";
const credit = "$BASE_URL/credit/";
const wallet = "${BASE_URL}transaction/";
const usage = "${BASE_URL}transaction/";
//expense
const expense = "${transaction}/expense/";
const expenses = "$BASE_URL" + "expenses";
const allTransactions = "$transaction/alltransactions";
//purchases
const purchases = "${BASE_URL}purchases/";

//others
const cashflow = "${BASE_URL}cashflow/";
const plans = "${BASE_URL}plan/";
