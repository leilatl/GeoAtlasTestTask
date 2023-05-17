//
//  CountryDetailViewController.swift
//  GeoAtlasTest
//
//  Created by Dmitry Serebrov on 14.05.2023.
//

import Foundation
import UIKit
import SnapKit
/// протокол описывающий класс CountryDetailViewController, им будет пользоваться Presenter для отображения подготовленных данных
protocol ICountryDetailViewController {
	func showDetails(viewModel: CountryDetailModel.ViewModel)
}

/// класс ответственный за внешний вид экрана CountryDetail, на котором отображается детали страны
class CountryDetailViewController: UIViewController {
	/// код страны для запроса в сеть
	var countryCode: String?
	let interactor: ICountryDetailInteractor
	
	// создание UI элементов
	private lazy var scrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.backgroundColor = .white
		return scrollView
	}()
	private lazy var contentView: UIView = {
		let contentView = UIView()
		contentView.backgroundColor = .white
		return contentView
	}()
	private let stackView = UIStackView()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		style()
		layout()
		// вызываем у интерактора данные
		interactor.getCountryDetails(cca2: countryCode ?? UIStrings.defaultCountryCode)
	}
	
	/// через инициализатор передаем интерактор
	init(interactor: ICountryDetailInteractor) {
		
		self.interactor = interactor
		super.init(nibName: nil, bundle: nil)
	}
	required init?(coder: NSCoder) {
		fatalError(UIStrings.initError)
	}
}

/// расширение для протокола ICountryDetailViewController, для пользования Presenter
extension CountryDetailViewController: ICountryDetailViewController {
	/// через эту функцию Presenter передает готовые для отображения данные в ViewController обновляет таблицу со свежими данными
	func showDetails(viewModel: CountryDetailModel.ViewModel) {
		// массивы со значением текста для лейблов
		let labels = UIStrings.detailLabels
		let texts = [viewModel.region, viewModel.capital, viewModel.coordinates, viewModel.area, viewModel.population, viewModel.currencies, viewModel.timezones]
		
		// создание картинки флага
		let flagImageView = UIImageView()
		flagImageView.sd_setImage(with: URL(string: viewModel.flag))
		flagImageView.layer.cornerRadius = UIDigits.imgCornerRadius
		flagImageView.layer.masksToBounds = true
		flagImageView.contentMode = .scaleAspectFill
		stackView.addArrangedSubview(flagImageView)
		flagImageView.snp.makeConstraints { maker in
			maker.height.equalTo(view.frame.width / UIDigits.detailImgHeightRatio)
			maker.left.equalToSuperview()
			maker.right.equalToSuperview()
		}
		
		// цикл, который создает UI элементы для каждого параметра деталей
		for index in 0..<labels.count {
			let uiv = UIView()
			let titleLabel = UILabel()
			let valueLabel = UILabel()
			let dotView = UIView()
			
			uiv.addSubview(dotView)
			dotView.backgroundColor = UIColor.black
			dotView.layer.cornerRadius = UIDigits.detailDotSize/2
			dotView.snp.makeConstraints { maker in
				maker.top.equalToSuperview().inset(UIDigits.detailDotTopInset)
				maker.left.equalToSuperview()
				maker.height.equalTo(UIDigits.detailDotSize)
				maker.width.equalTo(UIDigits.detailDotSize)
			}
			
			uiv.addSubview(titleLabel)
			titleLabel.text = labels[index]
			titleLabel.font = UIFont.systemFont(ofSize: UIDigits.detailTitleFontSize)
			titleLabel.textColor = UIColors.greyText
			titleLabel.snp.makeConstraints { maker in
				maker.top.equalToSuperview()
				maker.left.equalTo(dotView.snp.right).inset(-UIDigits.detailDotToTextInset)
			}
			
			uiv.addSubview(valueLabel)
			valueLabel.text = texts[index]
			valueLabel.numberOfLines = UIDigits.labelNumberOfLines
			valueLabel.font = UIFont.systemFont(ofSize: UIDigits.detailValueFontSize)
			valueLabel.snp.makeConstraints { maker in
				maker.top.equalTo(titleLabel.snp.bottom).inset(-UIDigits.detailLabelsInset)
				maker.left.equalTo(dotView.snp.right).inset(-UIDigits.detailDotToTextInset)
				maker.right.equalToSuperview()
			}
			
			let labelHeight = valueLabel.intrinsicContentSize.height + titleLabel.intrinsicContentSize.height
			uiv.snp.makeConstraints { maker in
				maker.height.equalTo(labelHeight)
			}

			stackView.addArrangedSubview(uiv)
		}
		self.title = viewModel.name
	}
}

/// расширение для приватных функций
extension CountryDetailViewController {
	/// функция для группировки операций с внешним видом UI элементов
	private func style() {
		self.title = UIStrings.detailDefaultLabel
		
		stackView.backgroundColor = .white
	}
	
	/// функция для группировки операций с разметкой UI элементов на экране
	private func layout() {
		stackView.distribution = .fill
		stackView.spacing = UIDigits.detailStackViewSpacing
		stackView.axis = .vertical
		
		scrollView.addSubview(stackView)
		view.addSubview(scrollView)
		
		scrollView.snp.makeConstraints { maker in
			maker.edges.equalToSuperview()
		}
		
		stackView.snp.makeConstraints { maker in
			maker.top.equalToSuperview().inset(UIDigits.detailStackViewSpacing)
			maker.left.equalToSuperview().inset(UIDigits.detailStackViewHorizontalInsets)
			maker.right.equalToSuperview().inset(UIDigits.detailStackViewHorizontalInsets)
			maker.bottom.equalToSuperview()
		}
		
		stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -2*UIDigits.detailStackViewHorizontalInsets).isActive = true
	}

}
