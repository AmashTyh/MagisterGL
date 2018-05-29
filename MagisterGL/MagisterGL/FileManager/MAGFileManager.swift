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
      print(err)
    }
    return []
  }
  
  func getXYZValuesArray(path: String) -> [Double]
  {
    do
    {
      let fileExtension = URL(fileURLWithPath: path).pathExtension
      if  fileExtension == "txt"
      {
        let data = try String(contentsOfFile: path,
                              encoding: String.Encoding.ascii)
        var array: [Double] = []
        for obj in data.components(separatedBy: "\n")
        {
          if obj != ""
          {
            array.append(Double(obj)!)
          }
        }
        return array
      }
      else
      {
        let scaner = try MAGBinaryDataScanner(data: NSData(contentsOfFile: path),
                                              littleEndian: true,
                                              encoding: String.Encoding.ascii)
        var array: [Double]? = []
        while let value = scaner.readDouble()
        {
          array?.append(value)
        }
        return array!
      }
    }
    catch let err as NSError
    {
      print(err)
    }
    return []
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
      print(err)
    }
    return []
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
      print(err)
    }
    return []
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
              
              if array?.count == arrayCount + 1
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
      print(err)
    }
    return []
  }
  
  func getSig3dArray(path: String) -> [[Double]]
  {
    do
    {
      let data = try String(contentsOfFile: path,
                            encoding: String.Encoding.ascii)
      var arrayOfSig3d: [[Double]]? = []
      for string in data.components(separatedBy: "\n")
      {
        if string != ""
        {
          var sig3dArray = [Double]()
          let array = string.components(separatedBy: "\r")[0].trimmingCharacters(in: .whitespaces).components(separatedBy: " ")
          for elem in array
          {
            if elem != ""
            {
              sig3dArray.append(Double(elem)!)
            }
          }
          arrayOfSig3d?.append(sig3dArray)
        }
      }
      return arrayOfSig3d!
    }
    catch let err as NSError
    {
      print(err)
    }
    return []
  }
  
  
  func getProfileArray(path: String) -> [SCNVector3]
  {
    do
    {
      let data = try String(contentsOfFile: path,
                            encoding: String.Encoding.ascii)
      var arrayOfVectors: [SCNVector3]? = []
      for string in data.components(separatedBy: "\n")
      {
        if string != ""
        {
          let array = string.components(separatedBy: "\t")
          if array.count == 4
          {
            let vector = SCNVector3Make(Float(array[1])!,
                                        Float(array[2])!,
                                        Float(array[3].components(separatedBy: "\r")[0])!)
            arrayOfVectors?.append(vector)
          }
        }
      }
      return arrayOfVectors!
      
    }
    catch let err as NSError
    {
      print(err)
    }
    return []
  }
}
