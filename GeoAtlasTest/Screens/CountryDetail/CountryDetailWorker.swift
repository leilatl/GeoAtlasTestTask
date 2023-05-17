//
//  CountryDetailWorker.swift
//  GeoAtlasTest
//
//  Created by Dmitry Serebrov on 14.05.2023.
//

import Foundation
import Alamofire
/// протокол описывающий класс CountryDetailWorker, им будет пользоваться Interactor для вызова запросов в сеть
protocol ICountryDetailWorker {
	func fetchCountryDetails(cca2: String, completion: @escaping ([CountryDetailModel.NetworkingData.CountryDetailData])->Void)
}
/// класс, ответственный за запросы в сеть
class CountryDetailWorker: ICountryDetailWorker {
	/// функция, которая делает запрос в сеть для получения детайлей страны
	func fetchCountryDetails(cca2: String, completion: @escaping ([CountryDetailModel.NetworkingData.CountryDetailData])->Void) {
		AF.request("\(UIStrings.countryDetailHttp)\(cca2)").responseDecodable(of: [CountryDetailModel.NetworkingData.CountryDetailData].self) { response in
			if let data = response.value {
				completion(data)
			} else {
				print(response.error ?? UIStrings.unknownError)
			}

		}
	}
}
