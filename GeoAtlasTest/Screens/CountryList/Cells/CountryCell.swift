//
//  CountryCell.swift
//  GeoAtlasTest
//
//  Created by Dmitry Serebrov on 13.05.2023.
//

import UIKit
import SnapKit
import SDWebImage
/// класс, ответственный за внешний вид каждой ячейки
class CountryCell: UITableViewCell {
	// создание всех UI элементов
	let backgroundGreyView = UIView()
	let flagImageView = UIImageView()
	let nameLabel = UILabel()
	let capitalLabel = UILabel()
	let arrowImg = UIImageView()
	let populationLabel = UILabel()
	let areaLabel = UILabel()
	let currenciesLabel = UILabel()
	let learnMoreBtn = UIButton()
	let currencyPlaceholder = UILabel()

	/// ячейка хранит view controller, который нужен для навигации через кнопку, которая находится в ячейке
	var viewController: CountryListViewController?
	/// вью модель, которая содержит всю необходимую информацию для отображния в ячейке
	var viewModel: CountryListModel.ViewModel.CountryViewModel?
	
	/// через инициализатор передаем view controller
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.style()
		layout()
	}
	
	/// функция для группировки операций с внешним видом UI элементов
	private func style() {
		backgroundGreyView.backgroundColor = UIColors.greyBackground
		backgroundGreyView.layer.cornerRadius = UIDigits.imgCornerRadius
		
		arrowImg.image = UIColors.arrowImage
		
		nameLabel.numberOfLines = UIDigits.labelNumberOfLines
		nameLabel.font = UIFont.systemFont(ofSize: UIDigits.countryNameFontSize, weight: .semibold)
		
		capitalLabel.font = UIFont.systemFont(ofSize: UIDigits.cityNameFontSize, weight: .regular)
		capitalLabel.textColor = UIColors.greyText
	}
	
	/// функция для группировки операций с разметкой UI элементов на экране
	private func layout() {
		contentView.addSubview(backgroundGreyView)
		backgroundGreyView.addSubview(flagImageView)
		backgroundGreyView.addSubview(arrowImg)
		backgroundGreyView.addSubview(nameLabel)
		backgroundGreyView.addSubview(capitalLabel)
		
		backgroundGreyView.snp.makeConstraints { maker in
			maker.top.equalToSuperview().inset(UIDigits.cellVerticalInsets)
			maker.bottom.equalToSuperview().inset(UIDigits.cellVerticalInsets)
			maker.left.equalToSuperview().inset(UIDigits.cellHorizontalInsets)
			maker.right.equalToSuperview().inset(UIDigits.cellHorizontalInsets)
		}
		flagImageView.snp.makeConstraints { maker in
			maker.left.equalToSuperview().inset(UIDigits.cellContentInsets)
			maker.top.equalToSuperview().inset(UIDigits.cellContentInsets)
			maker.height.equalTo(UIDigits.cellFlagImageHeight)
			maker.width.equalTo(UIDigits.cellFlagImageWidth)
		}
		arrowImg.snp.makeConstraints { maker in
			maker.right.equalToSuperview().inset(UIDigits.cellContentInsets)
			maker.centerY.equalTo(flagImageView.snp.centerY)
		}
		nameLabel.snp.makeConstraints { maker in
			maker.left.equalTo(flagImageView.snp.right).inset(-UIDigits.cellContentInsets)
			maker.right.equalTo(arrowImg.snp.left)
			maker.top.equalTo(flagImageView.snp.top)
		}
		capitalLabel.snp.makeConstraints { maker in
			maker.left.equalTo(flagImageView.snp.right).inset(-UIDigits.cellContentInsets)
			maker.top.equalTo(nameLabel.snp.bottom).inset(-UIDigits.cellCountryCityInset)
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("country cell fatal error")
	}
}

///  расширение для функций обновления данных
extension CountryCell {
	/// функция для обновления свернутой ячейки
	func updateCollapsed(viewModel: CountryListModel.ViewModel.CountryViewModel) {
		// обновление внешнего вида картинки флага
		flagImageView.sd_setImage(with: URL(string: viewModel.flag))
		flagImageView.layer.cornerRadius = UIDigits.imgCornerRadius
		flagImageView.layer.masksToBounds = true
		
		// обновление текста лейблов
		nameLabel.text = viewModel.name
		capitalLabel.text = viewModel.capital
		
		// тк у некоторых стран очень длинное название в 2 строки, то нам нужно убрать старые констрейнты и поставить новые в зависмости от размера текста лейбла страны
		capitalLabel.snp.removeConstraints()
		// если название страны слишком длинное, то расстояние между лейблом страны и лейблом столицы будет короче
		capitalLabel.snp.makeConstraints { maker in
			maker.left.equalTo(flagImageView.snp.right).inset(-UIDigits.cellContentInsets)
			if nameLabel.text?.count ?? 0 > 25{
				maker.top.equalTo(nameLabel.snp.bottom)
			} else {
				maker.top.equalTo(nameLabel.snp.bottom).inset(-UIDigits.cellCountryCityInset)
			}
		}
		
		// делаем невидимыми все элементы развернутой ячейки
		self.setAlpha(to: 0)
	}
	
	/// функция для обновления развернутой ячейки
	func updateExpanded(viewModel: CountryListModel.ViewModel.CountryViewModel, viewController: CountryListViewController) {
		self.viewController = viewController
		updateCollapsed(viewModel: viewModel)
		
		// делаем видимыми все элементы развернутой ячейки
		self.setAlpha(to: 1)
		
		// обновление внешнего вида
		populationLabel.attributedText = viewModel.population
		populationLabel.font = UIFont.systemFont(ofSize: UIDigits.cellDetailsFontSize)
		
		areaLabel.attributedText = viewModel.area
		areaLabel.font = UIFont.systemFont(ofSize: UIDigits.cellDetailsFontSize)
		
		currencyPlaceholder.text = UIStrings.currenciesLabelText
		currencyPlaceholder.textColor = UIColors.greyText
		currencyPlaceholder.font = UIFont.systemFont(ofSize: UIDigits.cellDetailsFontSize)
		
		currenciesLabel.text = viewModel.currencies
		currenciesLabel.numberOfLines = UIDigits.labelNumberOfLines
		currenciesLabel.font = UIFont.systemFont(ofSize: UIDigits.cellDetailsFontSize)
		
		learnMoreBtn.setTitle(UIStrings.learnMoreBtnText, for: .normal)
		learnMoreBtn.setTitleColor(UIColors.blueText, for: .normal)
		
		// обновление разметки
		backgroundGreyView.addSubview(populationLabel)
		backgroundGreyView.addSubview(areaLabel)
		backgroundGreyView.addSubview(currencyPlaceholder)
		backgroundGreyView.addSubview(currenciesLabel)
		backgroundGreyView.addSubview(learnMoreBtn)
		
		populationLabel.snp.makeConstraints { maker in
			maker.top.equalTo(flagImageView.snp.bottom).inset(-UIDigits.cellContentInsets)
			maker.left.equalTo(flagImageView.snp.left)
		}
		areaLabel.snp.makeConstraints { maker in
			maker.top.equalTo(populationLabel.snp.bottom).inset(-UIDigits.cellDetailElementsInsets)
			maker.left.equalTo(flagImageView.snp.left)
			
		}
		currencyPlaceholder.snp.makeConstraints { maker in
			maker.top.equalTo(areaLabel.snp.bottom).inset(-UIDigits.cellDetailElementsInsets)
			maker.left.equalTo(flagImageView.snp.left)
			maker.width.equalTo(UIDigits.cellFlagImageWidth)
		}
		currenciesLabel.snp.makeConstraints { maker in
			maker.top.equalTo(areaLabel.snp.bottom).inset(-UIDigits.cellDetailElementsInsets)
			maker.left.equalTo(currencyPlaceholder.snp.right)
			maker.right.equalToSuperview()
		}
		learnMoreBtn.snp.makeConstraints { maker in
			maker.centerX.equalToSuperview()
			maker.bottom.equalToSuperview().inset(UIDigits.cellContentInsets)
		}
		
		// обновляем вью модель
		self.viewModel = viewModel
		// присваиваем кнопке таргет, который выполняется по нажатию на кнопку
		learnMoreBtn.addTarget(self, action: #selector(learnMoreBtnTapped), for: .touchUpInside)
	}
	/// кнопка, которая осуществляет переход на следующий экран
	@objc func learnMoreBtnTapped(_ sender: UIButton) {
		if let viewController {
			let router = MainRouter()
			router.routeToDetailsViewController(vc: viewController, cca2: viewModel?.cca2 ?? "")
		}

	}
}
/// расширение для приватных функций
extension CountryCell {
	private func setAlpha(to alpha: CGFloat) {
		populationLabel.alpha = alpha
		areaLabel.alpha = alpha
		currenciesLabel.alpha = alpha
		learnMoreBtn.alpha = alpha
		currencyPlaceholder.alpha = alpha
	}
}
