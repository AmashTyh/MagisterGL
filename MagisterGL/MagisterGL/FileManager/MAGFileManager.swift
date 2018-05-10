//
//  MAGFileManager.swift
//  MagisterGL
//
//  Created by Хохлова Татьяна on 08.10.17.
//  Copyright © 2017 Хохлова Татьяна. All rights reserved.
//


import UIKit
import SceneKit


class MAGFileManager: NSObject
{
  public var testType: Int = 0
  static let sharedInstance = MAGFileManager()
  
  
  func getXYZArray(path: String) -> Array<SCNVector3>
  {
    do
    {
      let fileExtension = URL(fileURLWithPath: path).pathExtension
      if  fileExtension == "dat"
      {
        let scaner = try MAGBinaryDataScanner(data: NSData(contentsOfFile: path),
                                              littleEndian: true,
                                              encoding: String.Encoding.ascii)
        var arrayOfVectors: [SCNVector3]? = []
        var array: [Float64]? = []
        while let value = scaner.readDouble()
        {
          array?.append(value)
          if array?.count == 3
          {
            let vector = SCNVector3Make(Float(array![0]),
                                        Float(array![1]),
                                        Float(array![2]))
            arrayOfVectors?.append(vector)
            array = []
          }
        }
        return arrayOfVectors!
      }
      else
      {
        let data = try String(contentsOfFile: path,
                              encoding: String.Encoding.ascii)
        var arrayOfVectors: [SCNVector3]? = []
        for string in data.components(separatedBy: "\n")
        {
          if string != ""
          {
            let array = string.components(separatedBy: " ").map { Float($0)! }
            if array.count == 3
            {
              let vector = SCNVector3Make(array[0],
                                          array[1],
                                          array[2])
              arrayOfVectors?.append(vector)
            }
          }
        }
        return arrayOfVectors!
        
      }
    }
    catch let err as NSError
    {
      // do something with Error
      print(err)
    }
    return []
  }
  
  
  func getXYZArray() -> Array<SCNVector3>
  {
    var path: String
    switch testType
    {
    case 0:
      path = Bundle.main.path(forResource: "xyz",
                              ofType: "txt")!
      break
    case 1:
      path = Bundle.main.path(forResource: "xyz2",
                              ofType: "txt")!
      break
    case 2:
      path = Bundle.main.path(forResource: "xyz",
                              ofType: "dat")!
      break
    case 3:
      path = Bundle.main.path(forResource: "xyz4",
                              ofType: "dat")!
      break
    case 4:
      path = Bundle.main.path(forResource: "xyz5",
                              ofType: "dat")!
      break
    default:
      path = Bundle.main.path(forResource: "xyz",
                              ofType: "txt")!
      break
    }
    return self.getXYZArray(path: path)
  }
  
  
  func getNVERArray() -> [[Int]]
  {
    var path: String
    switch testType
    {
    case 0:
      path = Bundle.main.path(forResource: "nver",
                              ofType: "txt")!
      break
    case 1:
      path = Bundle.main.path(forResource: "nver2",
                              ofType: "txt")!
      break
    case 2:
      path = Bundle.main.path(forResource: "nver",
                              ofType: "dat")!
      break
    case 3:
      path = Bundle.main.path(forResource: "nver4",
                              ofType: "dat")!
      break
    case 4:
      path = Bundle.main.path(forResource: "nver5",
                              ofType: "dat")!
      break
    default:
      path = Bundle.main.path(forResource: "nver",
                              ofType: "txt")!
      break
    }
    return self.getNVERArray(path: path)
  }
  
  
  func getNVERArray(path: String) -> [[Int]]
  {
    do
    {
      let fileExtension = URL(fileURLWithPath: path).pathExtension
      if  fileExtension == "dat"
      {
        let scaner = try MAGBinaryDataScanner(data: NSData(contentsOfFile: path),
                                              littleEndian: true,
                                              encoding: String.Encoding.ascii)
        var arrayOfVectors: [[Int]]? = []
        var array: [Int]? = []
        while let value = scaner.read32()
        {
          array?.append(Int(value))
          if array?.count == 14
          {
            arrayOfVectors?.append(array!)
            array = []
          }
        }
        return arrayOfVectors!
      }
      else
      {
        let data = try String(contentsOfFile: path,
                              encoding: String.Encoding.ascii)
        var arrayOfVectors: [[Int]]? = []
        for string in data.components(separatedBy: "\n")
        {
          if string != ""
          {
            let array = string.components(separatedBy: " ").map { Int($0)!}
            arrayOfVectors?.append(array)
          }
        }
        return arrayOfVectors!
      }
    }
    catch let err as NSError
    {
      // do something with Error
      print(err)
    }
    return []
  }
  
  func getNVKATArray() -> Array<Int>
  {
    var path: String
    switch testType
    {
    case 0:
      path = Bundle.main.path(forResource: "nvkat",
                              ofType: "txt")!
      break
    case 1:
      path = Bundle.main.path(forResource: "nvkat2",
                              ofType: "txt")!
      break
    case 2:
      path = Bundle.main.path(forResource: "nvkat",
                              ofType: "dat")!
      break
    case 3:
      path = Bundle.main.path(forResource: "nvkat4",
                              ofType: "dat")!
      break
    case 4:
      path = Bundle.main.path(forResource: "nvkat5",
                              ofType: "dat")!
      break
    default:
      path = Bundle.main.path(forResource: "nvkat",
                              ofType: "txt")!
      break
    }
    return self.getNVKATArray(path: path)
  }
  
  func getNVKATArray(path: String) -> Array<Int>
  {
    do
    {
      let fileExtension = URL(fileURLWithPath: path).pathExtension
      if  fileExtension == "dat"
      {
        let scaner = try MAGBinaryDataScanner(data: NSData(contentsOfFile: path),
                                              littleEndian: true,
                                              encoding: String.Encoding.ascii)
        var array: [Int]? = []
        while let value = scaner.read32()
        {
          array?.append(Int(value))
        }
        return array!
      }
      else
      {
        let data = try String(contentsOfFile: path,
                              encoding: String.Encoding.ascii)
        var array: [Int]? = []
        for string in data.components(separatedBy: "\n")
        {
          if string != ""
          {
            let value = Int(string.components(separatedBy: "\r")[0]
              .trimmingCharacters(in: .whitespaces))!
            array?.append(Int(value))
          }
        }
        return array!
      }
    }
    catch let err as NSError
    {
      // do something with Error
      print(err)
    }
    return []
  }
  
  func getNEIBArray() -> [[Int]]
  {
    var path: String
    switch testType
    {
    case 0:
      path = Bundle.main.path(forResource: "elem_neib",
                              ofType: "txt")!
      break;
    case 1:
      path = Bundle.main.path(forResource: "elem_neib2",
                              ofType: "txt")!
      break;
    case 2:
      path = Bundle.main.path(forResource: "elem_neib",
                              ofType: "")!
      break;
    case 3:
      path = Bundle.main.path(forResource: "elem_neib4",
                              ofType: "")!
      break
    case 4:
      path = Bundle.main.path(forResource: "elem_neib5",
                              ofType: "")!
      break
    default:
      path = Bundle.main.path(forResource: "elem_neib",
                              ofType: "txt")!
      break;
    }
    return self.getNEIBArray(path: path)
  }
  
  func getNEIBArray(path: String) -> [[Int]]
  {
    do
    {
      let fileExtension = URL(fileURLWithPath: path).pathExtension
      if  fileExtension == ""
      {
        let scaner = try MAGBinaryDataScanner(data: NSData(contentsOfFile: path),
                                              littleEndian: true,
                                              encoding: String.Encoding.ascii)
        var arrayOfVectors: [[Int]]? = []
        var array: [Int]? = []
        while let value = scaner.read32()
        {
          let arrayCount = Int(value)
          if ( arrayCount == 0)
          {
            arrayOfVectors?.append([arrayCount])
          }
          else if (arrayCount > 0)
          {
            array?.append(arrayCount)
            while let val = scaner.read32()
            {
              array?.append(Int(val))
              
              if array?.count == arrayCount+1
              {
                arrayOfVectors?.append(array!)
                array = []
                break
              }
            }
          }
        }
        return arrayOfVectors!
      }
      else
      {
        let data = try String(contentsOfFile: path,
                              encoding: String.Encoding.ascii)
        var arrayOfVectors: [[Int]]? = []
        for string in data.components(separatedBy: "\n")
        {
          if string != ""
          {
            // trim \r if need
            let array = string.components(separatedBy: "\r")[0].trimmingCharacters(in: .whitespaces).components(separatedBy: " ")
            if (array.count == 1)
            {
              let value = Int(array[0])
              if value == 0
              {
                arrayOfVectors?.append([0])
              }
              
            }
            else if (array.count > 1)
            {
              var neibArray: [Int] = []
              let countOfNeib: Int = Int(array[0])!
              neibArray.append(countOfNeib)
              for index in 1...countOfNeib
              {
                neibArray.append(Int(array[index])!)
              }
              arrayOfVectors?.append(neibArray)
            }
          }
        }
        return arrayOfVectors!
      }
    }
    catch let err as NSError
    {
      // do something with Error
      print(err)
    }
    return []
  }
}
