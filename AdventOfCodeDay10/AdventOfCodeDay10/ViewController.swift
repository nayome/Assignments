//
//  ViewController.swift
//  AdventOfCodeDay10
//
//  Created by nayome.devapriya on 2017/06/19.
//  Copyright © 2017 nayome.devapriya. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    var botsThatAreProcessed = Array<RobotModel>()
    var botsToBeProcessed = [Int: RobotModel]()
    var outputBin = Array<OutputBinModel>()
    @IBOutlet weak var part1ResultTextField: NSTextField?
    @IBOutlet weak var part2ResultTextField: NSTextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let filePath = Bundle.main.path(forResource: "Input", ofType: "txt") {
            let arrayOfFileContents = readContentsOfFile(fromPath: filePath)
            
            //parse the input and put the data into "botsThatAreProcessed" and "botsToBeProcessed" varaiables
             if parseTheInput(fileConentsArray: arrayOfFileContents) {
                //Process the bots that are present in botsThatAreProcessed i.e., to exchange the data from given input statements to put low value and high values into respective bot
                processBots()
                
                //Find the bot responsible for given input
                let inputValue = (highValue: 61,lowValue: 17)
                let responsibleBot = findBotResponsibleForComparing(highvalue: inputValue.highValue, lowValue: inputValue.lowValue)
                print("The number of the bot that is responsible for comparing value-\(String(inputValue.highValue)) microchips with value-\(String(inputValue.lowValue)) microchips is ",responsibleBot);
                part1ResultTextField?.stringValue = responsibleBot.description
                
                //multiply the values prsent in output bin 0, 1, and 2
                let part2Input = [0,1,2]
                let multipliedValueOfBins = mutiplyValuesPresentIn(bins: part2Input)
                print("On multiplying the values of output bin at \(String(describing: part2Input)) is",multipliedValueOfBins)
                part2ResultTextField?.stringValue = multipliedValueOfBins.description
            }
            
        }
    }

    //MARK: Methods to evaluate part 1 and 2 of the puzzle
    func findBotResponsibleForComparing(highvalue: Int, lowValue: Int) -> Int {
        let filteredBots = botsThatAreProcessed.filter { $0.botHighvalue == highvalue && $0.botLowValue == lowValue }
        
        if filteredBots.count == 1 {
            return filteredBots[0].botId
        }
        return 0
    }
    
    func mutiplyValuesPresentIn(bins: [Int]) -> Int{
        var multipliedValueOfBins = 1
        let filteredBins = outputBin.filter { $0.binId == bins[0] || $0.binId == bins[1] || $0.binId == bins[2] }
        for binDetails in filteredBins
        {
            multipliedValueOfBins = multipliedValueOfBins * binDetails.binValue
        }
        return multipliedValueOfBins
    }

    //MARK: Methods to evaluate conents of file
    //Function to read the contents of file, and returns an array of strings
    func readContentsOfFile(fromPath: String) -> [String] {
        do {
            let content = try String(contentsOfFile:fromPath, encoding: String.Encoding.utf8)
            if content == Constants.emptyString {
                return []
            }
            return content.components(separatedBy: Constants.inputDelimiter)
        } catch {
            return []
        }
    }

    
    /**
     This method parses each statement give in the input into strings.
     Then based on the strings formed check if the statement starts with word "bot"
     If bot, then check in "botsToBeProcessed" dictionary for respectiveg bot and return the bot using getBotBy method
     If not bot, then check the value to be assigned to bot and get the bot details and assign the tempValue, check if high and low value are present then store in "botsThatAreProcessed" array
     */
    func parseTheInput(fileConentsArray: [String]) -> Bool {
        for instructionLine in fileConentsArray {
            if instructionLine != Constants.emptyString {
                let parseIntoWords = instructionLine.components(separatedBy: Constants.stringWithSpace)
                if(parseIntoWords[0] == Constants.kStringBot)
                {
                    guard let botId = Int(parseIntoWords[1]) else {
                        print("String conversion to integer failed ..!!")
                        return false
                    }
                    guard let lowBotId = Int(parseIntoWords[6]) else {
                        print("String conversion to integer failed ..!!")
                        return false
                    }
                    guard let highBotId = Int(parseIntoWords[11]) else {
                        print("String conversion to integer failed ..!!")
                        return false
                    }
                    let bot: RobotModel = getBotBy(id: botId)
                    
                    if(parseIntoWords[5] == Constants.kStringBot) {
                        bot.botIdDestination[0] = lowBotId
                    } else {
                        bot.outputDestination[0] = lowBotId
                    }
                    if(parseIntoWords[10] == Constants.kStringBot) {
                        bot.botIdDestination[1] = highBotId
                    } else {
                        bot.outputDestination[1] = highBotId
                    }
                } else {
                    guard let chipValue = Int(parseIntoWords[1]) else {
                        print("String conversion to integer failed ..!!")
                        return false
                    }
                    guard let botId = Int(parseIntoWords[5]) else {
                        print("String conversion to integer failed ..!!")
                        return false
                    }
                    let bot: RobotModel = getBotBy(id: botId)
                    bot.setTempvalue(value: chipValue)
                    let readyToProcess: Bool = bot.isBothLowHighPresent()
                    if(readyToProcess) {
                        botsThatAreProcessed.append(bot)
                    }
                }
            }
        }
        return true
    }
    
    func processBots(){
        var sizeOfProcessedArray: Int = botsThatAreProcessed.count
        var tempSizeOfProcessedArray = 0
        var index = 0
        
        while (sizeOfProcessedArray > 0) && tempSizeOfProcessedArray == sizeOfProcessedArray - 1 {
            var proccessedTimes = 0
            let indexToRefer = ((index > tempSizeOfProcessedArray) && (tempSizeOfProcessedArray == (sizeOfProcessedArray - 1))) ? tempSizeOfProcessedArray : index
            
            let bot: RobotModel = botsThatAreProcessed[indexToRefer]
            
            if( bot.botIdDestination[0] != Constants.defaultValue) {
                let isProcessed = assignLowOrHighValueToBotWith(id: bot.botIdDestination[0], value: bot.botLowValue)
                if  isProcessed {
                    sizeOfProcessedArray = botsThatAreProcessed.count
                    proccessedTimes += 1
                }
            }
            
            if(bot.botIdDestination[1] != Constants.defaultValue) {
                let isProcessed = assignLowOrHighValueToBotWith(id: bot.botIdDestination[1], value: bot.botHighvalue)
                if  isProcessed {
                    sizeOfProcessedArray = botsThatAreProcessed.count
                    proccessedTimes += 1
                }
            }
            if bot.outputDestination[0] != Constants.defaultValue {
                storeDataInOutputBin(binId: bot.outputDestination[0], binValue: bot.botLowValue)
            }
            if bot.outputDestination[1] != Constants.defaultValue {
                storeDataInOutputBin(binId: bot.outputDestination[1], binValue: bot.botHighvalue)
            }
            
            tempSizeOfProcessedArray += proccessedTimes
            index += 1
            if (proccessedTimes == 0) && (index > tempSizeOfProcessedArray) && (tempSizeOfProcessedArray == (sizeOfProcessedArray - 1)){
                break
            }
        }
    }

    
    func getBotBy(id: Int) -> RobotModel {
        var foundBot = botsToBeProcessed[id]
        if foundBot == nil { // if bot is nt found we need to create one with id given
            foundBot = RobotModel()
            foundBot?.botId = id
            botsToBeProcessed[id] = foundBot
        }
        return foundBot!
    }
    
    func assignLowOrHighValueToBotWith(id: Int, value: Int) -> Bool {
        var isProcessed = false
        let botLow: RobotModel = getBotBy(id: id)
        botLow.setTempvalue(value: value)
        
        let readyToProcess: Bool = botLow.isBothLowHighPresent()
        if(readyToProcess) {
            botsThatAreProcessed.append(botLow)
            isProcessed = true
        }
        return isProcessed
    }
    
    func storeDataInOutputBin(binId: Int, binValue: Int) {
        let newElement = OutputBinModel()
        newElement.binId = binId
        newElement.binValue = binValue
        outputBin.append(newElement)
    }
}
