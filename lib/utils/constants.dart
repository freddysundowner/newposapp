import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pointify/controllers/user_controller.dart';

const homePage = "Home";
const shopsPage = "Shops";
const attendantPage = "Attendants";
const profitsPage = "Profit & Expenses";
const salesPage = "Sales & orders";
const profilePage = "Profile";
const authPage = "Log Out";
const allowSubscription = true;



class Constants {
  static final RegExp emailValidatorRegExp =
      RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  var sortOrder = [
    "All",
    "Highest Stock Balance",
    "Out Of Stock",
    "Running Low",
    "Highest Buying Price",
    "Highest Selling Price"
  ];
  var sortOrderList = [
    "all",
    "quantity",
    "outofstock",
    "runninglow",
    "highestbuying",
    "highestselling"
  ];
  var sortOrderCaunt = [
    "All",
    "Counted Today",
    "Not Counted Today",
    "Never Counted"
  ];
  var sortOrderCauntList = [
    "all",
    "countedtoday",
    "notcountedtoday",
    "nevercounted"
  ];

  static final currenciesData = [
    "KES",
    "USD",
    "CAD",
    "EUR",
    "AED",
    "AFN",
    "ALL",
    "AMD",
    "ARS",
    "AUD",
    "AZN",
    "BAM",
    "BDT",
    "BGN",
    "BHD",
    "BIF",
    "BND",
    "BOB",
    "BRL",
    "BWP",
    "BYN",
    "BZD",
    "CDF",
    "CHF",
    "CLP",
    "CNY",
    "COP",
    "CRC",
    "CVE",
    "CZK",
    "DJF",
    "DKK",
    "DOP",
    "DZD",
    "EEK",
    "EGP",
    "ERN",
    "ETB",
    "GBP",
    "GEL",
    "GHS",
    "GNF",
    "GTQ",
    "HKD",
    "HNL",
    "HRK",
    "HUF",
    "IDR",
    "ILS",
    "INR",
    "IQD",
    "IRR",
    "ISK",
    "JMD",
    "JOD",
    "JPY",
    "KHR",
    "KMF",
    "KRW",
    "KWD",
    "KZT",
    "LBP",
    "LKR",
    "LTL",
    "LVL",
    "LYD",
    "MAD",
    "MDL",
    "MGA",
    "MKD",
    "MMK",
    "MOP",
    "MUR",
    "MXN",
    "MYR",
    "MZN",
    "NAD",
    "NGN",
    "NIO",
    "NOK",
    "NPR",
    "NZD",
    "OMR",
    "PAB",
    "PEN",
    "PHP",
    "PKR",
    "PLN",
    "PYG",
    "QAR",
    "RON",
    "RSD",
    "RUB",
    "RWF",
    "SAR",
    "SDG",
    "SEK",
    "SGD",
    "SOS",
    "SYP",
    "THB",
    "TND",
    "TOP",
    "TRY",
    "TTD",
    "TWD",
    "TZS",
    "UAH",
    "UGX",
    "UYU",
    "UZS",
    "VEF",
    "VND",
    "XAF",
    "XOF",
    "YER",
    "ZAR",
    "ZMK",
    "ZWL"
  ];
}
