//
//  CountryListWorker.swift
//  GeoAtlasTest
//
//  Created by Dmitry Serebrov on 13.05.2023.
//

import Foundation
import Alamofire
/// протокол описывающий класс CountryListWorker, им будет пользоваться Interactor для вызова запросов в сеть
protocol ICountryListWorker {
	func fetchAllCountries(completion: @escaping ([CountryListModel.NetworkingData.CountryListData.Country]) -> Void)
}

/// класс, ответственный за запросы в сеть
class CountryListWorker: ICountryListWorker {
	/// функция, которая делает запрос в сеть для получения списка всех стран
	func fetchAllCountries(completion: @escaping ([CountryListModel.NetworkingData.CountryListData.Country])->Void) {
		AF.request(UIStrings.allCountriesHtpp).responseDecodable(of: [CountryListModel.NetworkingData.CountryListData.Country].self) { response in
			if let data = response.value {
				completion(data)
			} else {
				completion([])
				print(response.error ?? UIStrings.unknownError)
			}
			
		}
	}
}

