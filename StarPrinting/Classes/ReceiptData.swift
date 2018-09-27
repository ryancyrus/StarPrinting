//
//  ReceiptData.swift
//  starPrintIntegration
//
//  Created by Ryan on 2018-09-27.
//  Copyright © 2018 Ryan. All rights reserved.
//

import Foundation

struct OrderItem {
    var name: String;
    var price: Double;
    var options: [OrderItem]?;
}

struct Costs {
    var subtotal: Double;
    var tax: Double;
    var deliveryFee: Double;
    var deliveryTax: Double;
}

class ReceiptData {
    let storeName:String;
    let phoneNumber: String;
    let dateOfOrder: String;
    let webPromotion: String;
    let content: String;
    let storeUrl: String;
    let orders: Array<OrderItem>;
    let costs: Costs;
    let storePromotion: String;
    let footer: String;
    
    init(storeName: String,
         phoneNumber: String,
         dateOfOrder: String,
         webPromotion: String,
         content: String,
         storeUrl: String,
         orders: Array<OrderItem>,
         costs: Costs,
         storePromotion: String,
         footer: String) {
        self.storeName = storeName;
        self.phoneNumber = phoneNumber;
        self.dateOfOrder = dateOfOrder;
        self.webPromotion = webPromotion;
        self.content = content;
        self.storeUrl = storeUrl;
        self.orders = orders;
        self.costs = costs;
        self.storePromotion = storePromotion;
        self.footer = footer;
    }
    
}
