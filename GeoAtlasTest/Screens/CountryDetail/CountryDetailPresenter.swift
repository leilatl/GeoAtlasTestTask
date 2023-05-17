//
//  CountryDetailPresenter.swift
//  GeoAtlasTest
//
//  Created by Dmitry Serebrov on 14.05.2023.
//
 
import Foundation
/// протокол описывающий класс CountryDetailPresenter, им будет пользоваться Interactor для передачи данных
protocol ICountryDetailPresenter {
	func presentDetails(response: CountryDetailModel.Data)
}

/// класс, ответственный за подготовку данных к отображению на экране
class CountryDetailPresenter: ICountryDetailPresenter {
	/// вью контроллер, который должен отобразить данные
	weak var viewController: CountryDetailViewController?
	
	/// функция для определения вью контроллера
	func setViewController(viewController: CountryDetailViewController) {
		self.viewController = viewController
	}
	
	/// функция, которая готовит данные для отображения на экране и передает их в вью контроллер
	func presentDetails(response: CountryDetailModel.Data) {
		let detailViewModel = CountryDetailModel.ViewModel(flag: response.image,
														   name: response.name,
														   capital: response.capital?[0] ?? "Unknown",
														   coordinates: self.transformCoordinates(dataCoordinates: response.coordinates),
														   population: self.transformPopulation(dataPopulation: response.population),
														   area: self.transformArea(dataArea: response.area),
														   currencies: self.transformCurrency(dataCurrency: response.currencies),
														   timezones: self.transformTimezones(dataTimezones: response.timezones),
														   region: response.region)
		viewController?.showDetails(viewModel: detailViewModel)
	}
}

/// расширение для приватных функций
extension CountryDetailPresenter {
	/// функция, которая преобразует часовые пояса из модели в строку для оторажения на экране
	private func transformTimezones(dataTimezones: [String]) -> String {
		var timezonesString = ""
		for timezone in dataTimezones {
			timezonesString += "\(timezone) \n"
		}
		return String(timezonesString.dropLast(1))
	}
	
	/// функция, которая преобразует валюты из модели в строку для оторажения на экране
	private func transformCurrency(dataCurrency: [String]) -> String{
		var currencyString = ""
		for currency in dataCurrency {
			currencyString += "\(currency)\n"
		}
		return String(currencyString.dropLast(1))
	}
	
	/// функция, которая преобразует площадь из модели в строку для оторажения на экране
	private func transformArea(dataArea: Float) -> String {
		let intArea = Int(dataArea)
		var stringArea = String(intArea)
		let numOfCharacters = stringArea.count
		
		if numOfCharacters <= 3 {
			
		} else if numOfCharacters >= 4 && numOfCharacters <= 6 {
			stringArea.insert(contentsOf: " ", at: stringArea.index(stringArea.endIndex, offsetBy: -3))
			
		} else if numOfCharacters >= 7 && numOfCharacters <= 9 {
			stringArea.insert(contentsOf: " ", at: stringArea.index(stringArea.endIndex, offsetBy: -6))
			stringArea.insert(contentsOf: " ", at: stringArea.index(stringArea.endIndex, offsetBy: -3))
		}
		
		return "\(stringArea) km²"
	}
	
	/// функция, которая преобразует популяцию из модели в строку для оторажения на экране
	private func transformPopulation(dataPopulation: Int) -> String {
		if dataPopulation >= 1000000 {
			return "\(Int(dataPopulation/1000000)) mln"
		} else {
			return String(dataPopulation)
		}
	}
	
	/// функция, которая преобразует координаты столицы из модели в строку для оторажения на экране
	private func transformCoordinates(dataCoordinates: [Float]) -> String {
		var stringCoordinates = ""
		
		if dataCoordinates.count > 1{
			for coordinate in dataCoordinates {
				
				let integer = floor(coordinate)
				let decimal = coordinate.truncatingRemainder(dividingBy: 1)
				
				let stringDecimal = String(decimal)
				let startIndex = stringDecimal.index(stringDecimal.startIndex, offsetBy: 2)
				let endIndex = stringDecimal.index(stringDecimal.startIndex, offsetBy: 4)
				let substring = stringDecimal[startIndex..<endIndex]
				
				stringCoordinates += String("\(Int(integer))°\(substring)′, ")
			}
		} else {
			return "Unknown Capital"
		}
		stringCoordinates = String(stringCoordinates.dropLast(2))
		
		return stringCoordinates
	}
}
