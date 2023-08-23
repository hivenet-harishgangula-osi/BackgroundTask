//
//  DownloadManager.swift
//  SampleiOSApp
//
//  Created by hgangula on 26/07/23.
//

import Foundation
import UIKit
import OSLog

class DownloadManager: NSObject, ObservableObject {
  static var shared = DownloadManager()
  
  @Published var tasks: [URLSessionTask] = []
  
  private lazy var urlSession: URLSession = {
    let config = URLSessionConfiguration.background(withIdentifier: "\(Bundle.main.bundleIdentifier ?? "").backgrouns")
    config.isDiscretionary = true
    config.sessionSendsLaunchEvents = true
    return URLSession(configuration: config, delegate: self, delegateQueue: nil)
  }()
  
  func startDownload(url: URL) {
    print("Download start.")
    let task = urlSession.downloadTask(with: url)
    task.resume()
  }
  
  func startUpload(urlRequest: URLRequest, fileData: Data) {
    let task = urlSession.uploadTask(with: urlRequest, from: fileData)
    task.resume()
  }
  
  private func updateTasks() {
    urlSession.getAllTasks { tasks in
      DispatchQueue.main.async {
        self.tasks = tasks
      }
    }
  }
}

extension DownloadManager: URLSessionDelegate, URLSessionDownloadDelegate {
  func urlSession(_ session: URLSession,
                  downloadTask: URLSessionDownloadTask,
                  didWriteData bytesWritten: Int64,
                  totalBytesWritten: Int64,
                  totalBytesExpectedToWrite: Int64) {
    //    print(totalBytesExpectedToWrite)
    //    print(totalBytesWritten)
    let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
    debugPrint("Progress \("") \(progress)")
  }
  
  func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                  didFinishDownloadingTo location: URL) {
    print("Download completed.")
    guard let httpResponse = downloadTask.response as? HTTPURLResponse,
          (200...299).contains(httpResponse.statusCode) else {
      print("server error")
      return
    }
    do {
      let documentsURL = try
      FileManager.default.url(for: .documentDirectory,
                              in: .userDomainMask,
                              appropriateFor: nil,
                              create: false)
      let savedURL = documentsURL.appendingPathComponent("\(randomString(length: 2)).jpg")
      print(location)
      print(savedURL)
      try FileManager.default.moveItem(at: location, to: savedURL)
    } catch {
      print("file error: \(error)")
    }
  }
  
  func randomString(length: Int) -> String {
    let letters: NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let len = UInt32(letters.length)
    var randomString = ""
    for _ in 0 ..< length {
      let rand = arc4random_uniform(len)
      var nextChar = letters.character(at: Int(rand))
      randomString += NSString(characters: &nextChar, length: 1) as String
    }
    return randomString
  }
  
  func urlSession(_: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
    if let error = error {
      print("Download error: %@", String(describing: error))
    } else {
      print("Task finished: %@", task)
    }
  }
  
  func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
    DispatchQueue.main.async {
      guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let backgroundCompletionHandler =
              appDelegate.backgroundCompletionHandler else {
        return
      }
      backgroundCompletionHandler()
    }
  }
}
