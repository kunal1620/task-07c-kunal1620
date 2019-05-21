//
//  DataManager.swift
//  Listy
//
//  Created by Kunal Pawar on 9/5/19.
//  Copyright © 2019 Kunal Pawar. All rights reserved.
//

import Foundation

public class DataManager {
    static private let FILE_NAME = "list"
    static private let FILE_TYPE = "json"
    
    ///Get File's default URL
    static private func getDefaultFileUrl() -> URL {
        
        if let url = Bundle.main.url(forResource: "\(FILE_NAME)", withExtension: "\(FILE_TYPE)") {
            return url
        }
        else {
            fatalError("Unable to find the default file")
        }
    }
    
    
    ///Get Document directory URL
    static public func getDocumentDirectoryUrl() -> URL {
        do {
            let url = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
            return url
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }
    
    
    ///Check if the list.json file exists in the documents directory
    static public func fileExistsInDocumentDir() -> Bool {
        let url = getDocumentDirectoryUrl().appendingPathComponent("\(FILE_NAME).\(FILE_TYPE)")
        return FileManager.default.fileExists(atPath: url.path) //Always use url.path and not url.absoluteString
    }
    
    
    ///Copy the list.json to documents directory from default location
    static public func copyFileToDocuments() {
        do {
            let srcUrl = getDefaultFileUrl()
            let dstUrl = getDocumentDirectoryUrl().appendingPathComponent("\(FILE_NAME).\(FILE_TYPE)")
            
            try FileManager.default.copyItem(at: srcUrl, to: dstUrl)
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }
    
    
    ///Save the data to the list.json
    ///By overwriting the existing file
    static public func saveData(list: [CastMember]) -> Bool {

        do {
            let data = try JSONEncoder().encode(list)
            let url = getDocumentDirectoryUrl().appendingPathComponent("\(FILE_NAME).\(FILE_TYPE)")
            
            if(fileExistsInDocumentDir()) {
                
                //Delete the existing file for overwriting
                deleteFile()
            }
            
            //Create a new file
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        }
        catch {
            print("ERROR WHILE STORING DATA: \n\(error)")
            return false
        }
        return true;
    }
    
    
    ///Load and return data from list.json
    static public func loadData() -> [CastMember] {
        
        //Check if file exists in document dir
        //If not, return empty array
        if(fileExistsInDocumentDir()) {
            
            //Read data from the file
            let url = getDocumentDirectoryUrl().appendingPathComponent("\(FILE_NAME).\(FILE_TYPE)")
            do {
                let data = try Data(contentsOf: url)    //Get data buffer with file's contents
                let castList = try JSONDecoder().decode([CastMember].self, from: data) //Decode JSON from buffer
                return castList
            }
            catch {
                print("ERROR OCCURED WHILE LOADING DATA")
                print(error)
                return [CastMember]()   //Return empty array
            }
            
        }
        else {
            return [CastMember]()   //Return empty array if file doesn't exist
                                    //in document directory
        }
    }
    
    
    ///Deletes the list.json file from documents directory
    static public func deleteFile() {
        let url = getDocumentDirectoryUrl().appendingPathComponent("\(FILE_NAME).\(FILE_TYPE)")
        do {
            try FileManager.default.removeItem(at: url)
        }
        catch {
            print(error)
        }
    }
}
