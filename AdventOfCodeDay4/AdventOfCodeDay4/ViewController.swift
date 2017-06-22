//
//  ViewController.swift
//  AdventOfCodeDay4
//
//  Created by nayome.devapriya on 2017/06/15.
//  Copyright © 2017 nayome.devapriya. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var part1ResultTextField: NSTextField?
    @IBOutlet weak var part2ResultTextField: NSTextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let filePath = Bundle.main.path(forResource: "Input", ofType: "txt") {
            let arrayOfFileContents = readContentsOfFile(fromPath: filePath)
            let pharsedInput = parseInputToStrings(InputList: arrayOfFileContents)
            
            let sumOfSectorId = findRealRoomsAndAddSectorIdFor(parsedStrings: pharsedInput)
            print("Sum of sector id for real rooms is ",sumOfSectorId)
            part1ResultTextField?.stringValue = sumOfSectorId.description
            
            let sectorIdForNorthPole = findRoomFrom(parsedStrings: pharsedInput, whoseRealNameContains: "northpole")
            print("Sector id of the room with objects stored in northpole is \(sectorIdForNorthPole)")
            part2ResultTextField?.stringValue = sectorIdForNorthPole.description

            
        }
        // Do any additional setup after loading the view.
    }
    
    //MARK: Methods to solve Part 1 and Part 2 of the puzzle
    //Function is used to find out which is a real room and add the sector ids of the real rooms and return the total sector id
    func findRealRoomsAndAddSectorIdFor(parsedStrings: [Array<Any>]) -> Int {
        var sumOfSectorId = 0
        for stringPharsed in parsedStrings {
            //Get the last element
            let lastElement: String = stringPharsed[stringPharsed.index(before: stringPharsed.endIndex)] as! String
            //parse the string to get sector Id
            let sectorId = lastElement.components(separatedBy: Constants.openSquareBrace)[0]
            //parse the string to get check sum
            var checkSum = lastElement.components(separatedBy: Constants.openSquareBrace)[1]
            checkSum = checkSum.components(separatedBy: Constants.closedSquareBrace)[0]
            
            //Call a function to get the number of times the character exists.
            var charactersCountArray = getCountOfCharacters(arrayOfStrings: stringPharsed as! [String])
            var checkSumBuilt = Constants.emptyString
            var lengthOfCheckSum = 1
            
            //Adding a do while loop to check for real room and proceed, intially the value is made true to execute the first parsed input
            while lengthOfCheckSum > 0 {
                var filteredChars = filterCharactersWhichHaveGreaterValue(charactersDict: charactersCountArray)
                filteredChars.sort()//sort the array to make it alphabetical as the corect checksum will be in alphabetical form
                
                for chars in filteredChars {
                    checkSumBuilt =  checkSumBuilt + chars
                    guard let indexToRemove = charactersCountArray.index(forKey: chars) else {
                        print("Error: Unable to get index !!")
                        break
                    }
                    charactersCountArray.remove(at: indexToRemove)
                    if checkSumBuilt.characters.count == 5 {
                        lengthOfCheckSum = 0
                        break
                    }
                }
            }
            if checkSum == checkSumBuilt {
                guard let sectorIdConverted = Int(sectorId) else {
                    print("Unable to convert to Int")
                    break
                }
                sumOfSectorId = sumOfSectorId + sectorIdConverted
            }
        }
        return sumOfSectorId
    }
    
    //To solve second part of the puzzle
    func findRoomFrom(parsedStrings: [Array<Any>],whoseRealNameContains: String) -> Int {
        for words in parsedStrings {
            //Get the last element
            let lastElement: String = words[words.index(before: words.endIndex)] as! String
            //parse the string to get sector Id
            let sectorId = Int(lastElement.components(separatedBy: Constants.openSquareBrace)[0])
            //parse the string to get check sum
            let shiftBy: Int = sectorId! % Constants.countOfAlphabets
            var convertedString = Constants.emptyString
            
            for index in 0..<words.count-1 {
                let element:String = words[index] as! String
                for items in element.unicodeScalars {
                    var unicodeValue = Int(items.value)
                    unicodeValue = unicodeValue + shiftBy
                    if unicodeValue > Constants.asciiValueAboveCharactersRange {
                        unicodeValue -= Constants.countOfAlphabets
                    }
                    let c = Character(UnicodeScalar(unicodeValue)!)
                    convertedString.append(c)
                }
                convertedString.append(Constants.stringWithSpace)
            }
            if (convertedString.contains(whoseRealNameContains)) {
                return sectorId!
            }
        }
        return 0
    }


    //MARK: Methods to read and parse the input
    func parseInputToStrings(InputList: [String]) -> Array<Array<String>> {
        var pharsedArray = Array<Array<String>>()
        for item in InputList {
            if item != Constants.emptyString {
                let componentsInItem:Array = item.components(separatedBy: Constants.parsingDelimiter)
                pharsedArray.append(componentsInItem)
            }
        }
        return pharsedArray;
    }
    
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
    
    //MARK: Methods to evaluate the instructions
    //Function is used to get the encrypted name and check number of times a character is repated and store all of them in array
    func getCountOfCharacters(arrayOfStrings: [String]) -> [String:Int] {
        var dictionaryToFrame:[String:Int] = [:]
        for index in 0..<arrayOfStrings.count-1 {
            let element = arrayOfStrings[index]
            
            for newChar in element.characters {
                let keyExists = dictionaryToFrame[String(newChar)] == nil
                if keyExists {
                    dictionaryToFrame[String(newChar)] = 1
                } else {
                    guard let valueOfCharacter = dictionaryToFrame[String(newChar)] else {
                        print("Failed to retreive data.. !!")
                        break
                    }
                    dictionaryToFrame[String(newChar)] = valueOfCharacter + 1
                }
            }
        }
        return dictionaryToFrame
    }
    
    func filterCharactersWhichHaveGreaterValue(charactersDict : [String:Int]) -> [String]{
        var greatestValue = 0
        var filteredChars = [String]()
        
        for key in charactersDict.keys{
            guard let valueOfCharacter = charactersDict[key] else {
                print("Failed to retreive data.. !!")
                break
            }
            if valueOfCharacter > greatestValue {
                filteredChars.removeAll()
                greatestValue = valueOfCharacter
                filteredChars.append(key)
            } else if valueOfCharacter == greatestValue { //If same value exists for diferent keys then store them also
                filteredChars.append(key)
            }
        }
        return filteredChars
    }

}

