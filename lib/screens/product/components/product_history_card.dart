import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pointify/functions/functions.dart';

import '../../../Real/Models/schema.dart';
import '../../../controllers/shop_controller.dart';

Widget productHistoryContainer(ProductHistoryModel productHistoryModel) {
  return Padding(
    padding: const EdgeInsets.all(3.0),
    child: Card(
      color: Colors.white.withOpacity(0.9),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            child: Row(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${productHistoryModel.product!.name}".capitalize!,
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    Text('Qty ${productHistoryModel.quantity}'),
                    if (productHistoryModel.toShop != null)
                      Text(
                        "to ${productHistoryModel.toShop!.name!}",
                        style: TextStyle(color: Colors.amber),
                      ),
                    if (productHistoryModel.createdAt != null)
                      Text(
                          '${DateFormat("MMM dd,yyyy, hh:m a").format(productHistoryModel.createdAt!)} '),
                  ],
                )
              ],
            ),
            Spacer(),
            Column(
              children: [
                Text(
                    'BP/=  ${htmlPrice(productHistoryModel.product!.buyingPrice)}'),
                Text('SP/=  ${htmlPrice(productHistoryModel.product!.selling)}')
              ],
            )
          ],
        )),
      ),
    ),
  );
}

Widget productPurchaseHistoryContainer(InvoiceItem invoiceItem) {
  return Padding(
    padding: const EdgeInsets.all(3.0),
    child: Card(
      color: Colors.white.withOpacity(0.9),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            child: Row(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${invoiceItem.product!.name}".capitalize!,
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    Text(
                        'Qty ${invoiceItem.itemCount} @ ${htmlPrice(invoiceItem.product?.selling)}'),
                    if (invoiceItem.createdAt != null)
                      Text('${invoiceItem.createdAt} ')
                  ],
                )
              ],
            ),
            Spacer(),
            Column(
              children: [Text('by ~  ${invoiceItem.attendantid?.fullnames}')],
            )
          ],
        )),
      ),
    ),
  );
}

Widget productBadStockHistory(BadStock badStock) {
  return Padding(
    padding: const EdgeInsets.all(3.0),
    child: Card(
      color: Colors.white.withOpacity(0.9),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            child: Row(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${badStock.product!.name}".capitalize!,
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    Text('Qty ${badStock.quantity}'),
                    Text(
                        '${DateFormat("MMM dd,yyyy, hh:m a").format(badStock.createdAt!)} '),
                  ],
                )
              ],
            ),
            Spacer(),
            Column(
              children: [
                Text('BP/=  ${htmlPrice(badStock.product!.buyingPrice)}'),
                Text('SP/=  ${htmlPrice(badStock.product!.selling)}')
              ],
            )
          ],
        )),
      ),
    ),
  );
}
