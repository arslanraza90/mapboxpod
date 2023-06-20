//
//  ImagesManager.swift
//  MapBoxFramework
//
//  Created by Innzamam Ul Haq on 6/20/23.
//

import Foundation
import UIKit

typealias PhotoCompletion = (UIImage?) -> Void

final class ImagesManager {
    
    static let shared = ImagesManager()
    
    private var photoCache: [String: UIImage] = [:]
    private var session: URLSession {
        return URLSession.shared
    }
    
    private init() {}
    
    func fetchPhotoFromReference(_ reference: String, completion: @escaping PhotoCompletion) -> Void {
        if let photo = photoCache[reference] {
            completion(photo)
        } else {
            let urlString = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=125&photoreference=\(reference)&key=\(API_KEY)"
            guard let url = URL(string: urlString) else {
                completion(nil)
                return
            }
            
            session.downloadTask(with: url) { url, response, error in
                var downloadedPhoto: UIImage? = nil
                defer {
                    DispatchQueue.main.async {
                        completion(downloadedPhoto)
                    }
                }
                guard let url = url else {
                    return
                }
                guard let imageData = try? Data(contentsOf: url) else {
                    return
                }
                downloadedPhoto = UIImage(data: imageData)
                self.photoCache[reference] = downloadedPhoto
            }
            .resume()
        }
    }
}
