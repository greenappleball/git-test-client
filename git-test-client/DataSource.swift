//
//  DataSource.swift
//  git-test-client
//
//  Created by Dmitri Petrishin on 12/13/16.
//  Copyright © 2016 PI. All rights reserved.
//

import UIKit
import Alamofire

class DataSource: Mappable, UITableViewDataSource {
    var dataSource: [AnyObject] = []
    let network = NetworkService()

    func load(since: String?, completionHandler: @escaping () -> Void) {
        network.loadRepos(since: since) {responce in
            self.dataSource = responce as [AnyObject]
            completionHandler()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        return cell;
    }
}

class WeatherResponse: Mappable {
    var location: String?
    var threeDayForecast: [Forecast]?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        location <- map["location"]
        threeDayForecast <- map["three_day_forecast"]
    }
}
