//
//  RobotModel.swift
//  AdventOfCodeDay10
//
//  Created by nayome.devapriya on 2017/06/19.
//  Copyright © 2017 nayome.devapriya. All rights reserved.
//

import Cocoa

open class OutputBinModel: NSObject {
    var binId: Int = -1
    var binValue: Int = -1
    
}

open class RobotModel: NSObject {
    var botId: Int = 0
    var botLowValue: Int = -1
    var botHighvalue: Int = -1
    var botTempvalue: Int = 0
    
    var botIdDestination = [-1,-1]
    var outputDestination = [-1, -1]
    
    func setTempvalue(value: Int) {
        if(self.botTempvalue == 0) {
            self.botTempvalue = value;
        } else {
            let botTempValueGreaterThanValueReceived = (self.botTempvalue > value) ? true : false
            self.botHighvalue = botTempValueGreaterThanValueReceived ? self.botTempvalue : value
            self.botLowValue = botTempValueGreaterThanValueReceived ? value : self.botTempvalue
        }
    }
    
    
    func isBothLowHighPresent() -> Bool
    {
        return ((self.botHighvalue != Constants.defaultValue) && (self.botLowValue != Constants.defaultValue)) ? true : false
    }
}


