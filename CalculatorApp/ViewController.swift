//
//  ViewController.swift
//  CalculaotorApp
//
//  Created by Daisuke Iuchi on 2020/05/07.
//  Copyright © 2020 Daisuke Iuchi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    enum CalculationStatus{
        case none,plus,minus,multiplication,division
    }
    var firstNumber = ""
    var secondNumber = ""
    var calculationStatus: CalculationStatus = .none
    
    let numbers=[
        ["C","%","$","÷"],
        ["7","8","9","×"],
        ["4","5","6","-"],
        ["1","2","3","+"],
        ["0",".","="],
    ]
    
    let cellId="cellId"
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var calculatorCollectionview: UICollectionView!
    @IBOutlet weak var calculatorHeightConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    func setupViews(){
        calculatorCollectionview.delegate=self
        calculatorCollectionview.dataSource=self
        calculatorCollectionview.register(CalculatorViewCell.self, forCellWithReuseIdentifier: cellId)
        calculatorHeightConstraint.constant=view.frame.width*1.4
        calculatorCollectionview.backgroundColor = .clear
        calculatorCollectionview.contentInset = .init(top: 0, left: 24, bottom: 0, right: 14)
        numberLabel.text="0"
        view.backgroundColor = .black

    }
    
    func clear(){
        firstNumber=""
        secondNumber=""
        numberLabel.text = "0"
        calculationStatus = .none
    }
}

// MARK: -UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
extension ViewController:UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numbers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numbers[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: collectionView.frame.width, height: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: CGFloat = 0
        width=((collectionView.frame.width - 10) - 14 * 5 ) / 4
        let height = width
        
        if indexPath.section == 4 && indexPath.row == 0{
            width=width * 2 + 14 + 7
        }
        return .init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 14
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=calculatorCollectionview.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CalculatorViewCell
        cell.numberLabel.text=numbers[indexPath.section][indexPath.row]
        
        numbers[indexPath.section][indexPath.row].forEach{(numberString) in
            if "0"..."9"~=numberString || numberString.description=="."{
                cell.numberLabel.backgroundColor = .darkGray
            } else if numberString == "C" || numberString == "%" || numberString == "$"{
                cell.numberLabel.backgroundColor = UIColor.init(white:1,alpha: 0.7)
                cell.numberLabel.textColor = .black
            }
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let number = numbers[indexPath.section][indexPath.row]
        
        switch calculationStatus {
        case .none:
            handleFirstNumberSelected(number: number)
            
        case .plus, .minus, .multiplication, .division:
            handleSecondNumberSelected(number: number)
        }
    }
    
    
    private func handleFirstNumberSelected(number: String){
        switch number {
        case "0"..."9":
            firstNumber += number
            numberLabel.text = firstNumber
            
            if firstNumber.hasPrefix("0"){
                firstNumber=""
            }
        case ".":
            if !confirmIncludeDecimalPoint(numberString: firstNumber){
                firstNumber += number
                numberLabel.text = firstNumber
            }
        case "+":
            calculationStatus = .plus
        case "-":
            calculationStatus = .minus
        case"×":
            calculationStatus = .multiplication
        case "÷":
            calculationStatus = .division
        case "C":
            clear()
        default:
            break
        }
    }
    
    private func handleSecondNumberSelected(number: String){
        switch number {
        case "0"..."9":
            secondNumber += number
            numberLabel.text = secondNumber
            if secondNumber.hasPrefix("0"){
                secondNumber=""
            }
        case ".":
            if !confirmIncludeDecimalPoint(numberString: secondNumber){
                secondNumber += number
                numberLabel.text = secondNumber
            }
        case "=":
            calculateResultNumber()
        case "C":
            clear()
        default:
            break
        }

        
    }
    
    private func calculateResultNumber(){
        let firstNum=Double(firstNumber) ?? 0
        let secondNum=Double(secondNumber) ?? 0
        
        var resultString: String?
        switch calculationStatus {
        case .plus:
            resultString = String(firstNum + secondNum)
        case .minus:
            resultString = String(firstNum - secondNum)
        case .multiplication:
            resultString = String(firstNum * secondNum)
        case .division:
            resultString = String(firstNum / secondNum)
        default:
            break
        }
        if let result = resultString, result.hasSuffix(".0"){
            resultString = result.replacingOccurrences(of: ".0", with: "")
        }
        numberLabel.text=resultString
        firstNumber = ""
        secondNumber = ""
        
        firstNumber += resultString ?? ""
        calculationStatus = .none

        
    }
    
    private func confirmIncludeDecimalPoint(numberString: String) -> Bool{
        if numberString.range(of: ".") != nil ||  numberString.count == 0{
            return true
        } else {
            return false
        }

    }
}

