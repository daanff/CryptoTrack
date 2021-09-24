//
//  APICaller.swift
//  CryptoTrack
//
//  Created by daanff on 2021-09-23.
//

import Foundation

final class APICaller{
    static let shared = APICaller()
    
    private struct Constants{
        static let apiKey = "7C6FC29B-7A80-452A-9152-559B24ED1E6C"
        static let assetsEndpoint = "https://rest-sandbox.coinapi.io/v1/assets/"
    }
    
    private init(){
        
    }
    public var icons: [Icon] = []
    
    private var whenReadyBlock: ((Result<[Crypto], Error>) -> Void)?
    //MARK: - Public
    
    public func getAllCryptoData(
        completion: @escaping (Result<[Crypto], Error>) -> Void
    ){
        guard !icons.isEmpty else{
            whenReadyBlock = completion
            return
        }
        guard let url = URL(string: Constants.assetsEndpoint + "?apikey=" + Constants.apiKey) else {return}
        
        let task = URLSession.shared.dataTask(with: url){data, _, error in
            guard let data = data, error == nil else{
                return
            }
            do{
               //Decode response
                let cryptos = try JSONDecoder().decode([Crypto].self, from: data)
                completion(.success(cryptos.sorted{
                    first,second -> Bool in
                    return first.price_usd ?? 0 > second.price_usd ?? 0
                }))
            }
            catch{
                completion(.failure(error))
            }
        }
        task.resume()
    }

    public func getAllIcons(){
        guard let url = URL(string: Constants.assetsEndpoint + "icons/55/?apikey=" + Constants.apiKey) else {return}
        let task = URLSession.shared.dataTask(with: url){data, _, error in
            guard let data = data, error == nil else{
                return
            }
            do{
               //Decode response
                self.icons = try JSONDecoder().decode([Icon].self, from: data)
                if let completion = self.whenReadyBlock{
                    self.getAllCryptoData(completion: completion)
                }
            }
            catch{
             print(error)
            }
        }
        task.resume()
        
    }
}
