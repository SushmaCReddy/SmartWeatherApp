//
//  EndPoints.swift
//  SmartWeatherApp
//
//  Created by msushmar on 1/8/18.
//  Copyright © 2018 msushmar. All rights reserved.
//

import Foundation

/// WebServiceEndPointsError are of type Error, thrown if the endpoint is not found in local json configuration file
public enum WebServiceEndPointsError: Error {
    
    case emptyOrCorruptGlobalAPIGatewayEndPoint
    case emptyOrCorruptSearchAPI
    
    public var description: String {
        switch self {
        case .emptyOrCorruptGlobalAPIGatewayEndPoint: return "Empty or Corrupt gloabl endpoint in App Config file"
        case .emptyOrCorruptSearchAPI: return "Empty or Corrupt search API in App config file"
        }
    }
}

///  WebServiceEndPoints provides with host, api values from local json configuration file
public struct WebServiceEndPoints {
    
    /// Computed Properties
    let endPoints: Dictionary<String, Any>

    ///  Global Gateway EndPoints & Flags
    ///
    /// - Returns: of type string
    /// - Throws: exception from WebServiceEndpointsError
    public func globalAPIGatewayEndPoint() throws -> String {
        guard
            let endPointGlobals = self.endPoints["global"] as? [String: Any],
            let endPoint = endPointGlobals["apiGateway"] as? String else {
                throw WebServiceEndPointsError.emptyOrCorruptGlobalAPIGatewayEndPoint
        }
        return endPoint
    }
    
    /// Returns search API from config file
    public func searchAPIEndpoint(location: String) throws -> String {
        guard
            let apis = self.endPoints["api"] as? [String: Any],
            let api = apis["search"] as? String else {
                throw WebServiceEndPointsError.emptyOrCorruptSearchAPI
        }
        return api
    }
    
    /// Returns weather icon API from config file
    public func weatherIconAPIEndpoint(iconId: String) throws -> String {
        let icon = "{iconId}"
        guard
            let apis = self.endPoints["api"] as? [String: Any],
            var api = apis["weatherIcon"] as? String,
            api.contains(icon) else {
                throw WebServiceEndPointsError.emptyOrCorruptSearchAPI
        }
        api = api.replacingOccurrences(of: icon, with: iconId)
        return api
    }
   
    ///Public Init Method
    public init(endPoints: Dictionary<String, Any>) {
        self.endPoints = endPoints
    }
    
}

