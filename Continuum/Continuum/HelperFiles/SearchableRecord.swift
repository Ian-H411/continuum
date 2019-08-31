//
//  SearchableRecord.swift
//  Continuum
//
//  Created by Ian Hall on 8/28/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import Foundation

protocol SearchableRecord {
    func matches(searchTerm: String) -> Bool
}
