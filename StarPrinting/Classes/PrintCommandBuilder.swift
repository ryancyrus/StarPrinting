//
//  PrintCommandBuilder.swift
//  Pods-StarPrinting_Example
//
//  Created by Ryan on 2018-09-27.
//  Copyright © 2018 Ryan. All rights reserved.
//

import Foundation

class CommandBuilder {
    static func create2InchReceiptData(_ emulation: StarIoExtEmulation, utf8: Bool, dataObject: ReceiptData) -> Data{
        let builder: ISCBBuilder = StarIoExt.createCommandBuilder(emulation)
        //        let maxChars = 32;
        let encoding: String.Encoding
        
        builder.beginDocument()
        
        if utf8 == true {
            encoding = String.Encoding.utf8
            
            builder.append(SCBCodePageType.UTF8)
        }
        else {
            encoding = String.Encoding.ascii
            
            builder.append(SCBCodePageType.CP998)
        }
        
        builder.append(SCBInternationalType.USA)
        builder.appendCharacterSpace(0)
        builder.appendAlignment(SCBAlignmentPosition.center)
        builder.appendData(withEmphasis: "\(dataObject.storeName)\n".data(using: encoding))
        builder.appendData(withEmphasis: "\(dataObject.phoneNumber)\n".data(using: encoding))
        builder.appendData(withEmphasis: "\(dataObject.dateOfOrder)\n".data(using: encoding))
        builder.append("--------------------------------\n".data(using: encoding))
        builder.append(dataObject.webPromotion.data(using: encoding));
        builder.append(dataObject.content.data(using: encoding));
        builder.append(dataObject.storeUrl.data(using: encoding));
        builder.append("--------------------------------\n".data(using: encoding))
        
        
        /*TODO
         FIX THE INDENTATION OF ORDER ITEMS
         */
        builder.appendAlignment(SCBAlignmentPosition.left)
        for order in dataObject.orders {
            builder.append(order.name.data(using: encoding))
            for item in (order.options)! {
                let it = item as OrderItem;
                builder.append("  \(it.name)".data(using: encoding))
            }
        }
        builder.append("--------------------------------\n".data(using: encoding))
        builder.append("\(dataObject.costs.subtotal)".data(using: encoding))
        let subtotal = ["Subtotal", String(format:"$%.02f", dataObject.costs.subtotal)]
        let tax = ["Tax:", String(format:"$%.02f", dataObject.costs.tax)]
        let dFee = ["Delivery Fee", String(format:"$%.02f", dataObject.costs.deliveryFee)]
        let dTax = ["Delivery Tax", String(format:"$%.02f", dataObject.costs.deliveryTax)]
        
        
        let firstCost = centerAlign2InchItems(strings: subtotal, secondColumnCharIndex: 0)
        let fir = NSString.init(string: firstCost).range(of: subtotal[1]).location
        let item1 = centerAlign2InchItems(strings: tax, secondColumnCharIndex: fir)
        let item2 = centerAlign2InchItems(strings: dFee, secondColumnCharIndex: fir)
        let item3 = centerAlign2InchItems(strings: dTax, secondColumnCharIndex: fir)
        let arrayLines = [firstCost, item1, item2, item3]
        builder.append(arrayLines.joined(separator: "\n").data(using: encoding))
        
        let totalCost = dataObject.costs.subtotal + dataObject.costs.tax + dataObject.costs.deliveryFee + dataObject.costs.deliveryTax
        let total = ["Total", String(format:"$%.02f", totalCost)]
        let totalString = centerAlign2InchItems(strings: total, secondColumnCharIndex: fir)
        builder.append(totalString.data(using: encoding))
        
        builder.appendAlignment(SCBAlignmentPosition.center)
        builder.append(dataObject.storePromotion.data(using: encoding))
        builder.append("--------------------------------\n".data(using: encoding))
        builder.append(dataObject.footer.data(using: encoding))
        
        builder.appendCutPaper(SCBCutPaperAction.partialCutWithFeed)
        
        builder.endDocument()
        
        return builder.commands.copy() as! Data
    }
    
    static func creatreQRCodeData(_ emulation: StarIoExtEmulation, utf8: Bool) -> Data{
        let builder: ISCBBuilder = StarIoExt.createCommandBuilder(emulation)
        let maxChars = 32;
        let encoding: String.Encoding
        
        builder.beginDocument()
        
        if utf8 == true {
            encoding = String.Encoding.utf8
            
            builder.append(SCBCodePageType.UTF8)
        }
        else {
            encoding = String.Encoding.ascii
            
            builder.append(SCBCodePageType.CP998)
        }
        
        builder.append(SCBInternationalType.USA)
        builder.appendCharacterSpace(0)
        builder.appendQrCodeData("Hello World".data(using: .utf8), model: .no2, level: .H, cell: 1)
        builder.appendCutPaper(SCBCutPaperAction.partialCutWithFeed)
        
        builder.endDocument()
        
        return builder.commands.copy() as! Data
        
    }
    
    static func centerAlign2Inch2ColHeader(strings: [String]) -> String {
        let numberOfSpaces = 32 - strings.joined(separator: "").count
        return strings.joined(separator: String(repeating: " ", count: numberOfSpaces))
    }
    
    static func centerAlign2Inch3ColHeader(strings: [String]) -> String {
        var leftSpaces = 32
        for string in strings{
            leftSpaces -= string.count
        }
        let joinedString = strings.joined(separator: "")
        var firstSpaces = 16 - joinedString.count/2
        leftSpaces -= firstSpaces
        firstSpaces += leftSpaces + 1
        let secondSpaces = leftSpaces - 1
        let stringSpaced: String = strings[0] + String(repeating: " ", count: firstSpaces) + strings[1] + String(repeating: " ", count: secondSpaces) + strings[2]
        return stringSpaced
    }
    
    static func centerAlign2InchItems(strings: [String], secondColumnCharIndex: Int) -> String {
        var leftSpaces = 32
        for string in strings{
            leftSpaces -= string.count
        }
        let firstSpaces = secondColumnCharIndex - strings[0].count
        let secondSpaces = leftSpaces - 1
        let stringSpaced: String = strings[0] + String(repeating: " ", count: firstSpaces) + strings[1] + String(repeating: " ", count: secondSpaces) + strings[2]
        return stringSpaced
    }
    
    
    
    

}
