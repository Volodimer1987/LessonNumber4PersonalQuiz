//
//  QuestionsViewController.swift
//  LessonNumber4PersonalQuiz
//
//  Created by vladimir gennadievich on 14.01.2021.
//

import UIKit

class QuestionsViewController: UIViewController {
    
    let questions = Question.getQuestions()
    var arrayOfAnimalsForAnswer = [AnimalType]()
    
    let animals = AnimalType.allCases
    
    var currentQuestion = 0
    
    @IBOutlet var secondQuestionStackView: UIStackView!
    @IBOutlet var textLeiblsArrayFromSecondQuestion: [UILabel]!
    @IBOutlet var switchArrayFromSecondQuestion: [UISwitch]!
    
    @IBOutlet var mainQuestionLabel: UILabel!
    @IBOutlet var mainProgressView: UIProgressView!
    
    
    @IBOutlet var firstStackWithButtons: UIStackView!
    @IBOutlet var buttonsArray: [UIButton]!
    
    @IBOutlet var sliderFromFierdQuestion: UISlider!
    @IBOutlet var arrayOfTextLeiblsFierdQuestion: [UILabel]!
    @IBOutlet var thierdStackView: UIStackView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainFunction()
}
    
    func nextQuestion() {
        currentQuestion += 1
        if currentQuestion < questions.count {
            mainFunction()
        } else {
            performSegue(withIdentifier: "resultSegue", sender: nil)
        }
    }
    
    func takingTextsFromModel(currentQuestion:Int,arrayOfQuestions:[Question]) -> [String] {
        var arrayOfTextQuestion = [String]()
        let arrayOfAnswersTexts = arrayOfQuestions[currentQuestion].answers
        
        for (index,value) in arrayOfAnswersTexts.enumerated() {
            arrayOfTextQuestion.insert(value.text, at: index)
        }
        return arrayOfTextQuestion
    }
    
    func textsToLeibls(texts:[String],butonLaibls:[UIButton]? = nil ,textLabels:[UILabel]? = nil) {
        if butonLaibls != nil {
            for index in 0..<butonLaibls!.count {
                let textToButton = texts[index]
                butonLaibls![index].setTitle(textToButton, for: .normal)
            }
        }
        if textLabels != nil {
            for index in 0..<textLabels!.count {
                let textToLabel = texts[index]
                textLabels![index].text = textToLabel
            }
        }
    }
    
    func sendingMainQuestionAndUpdateTitle(indexOfQuestion:Int) {
        let text = questions[indexOfQuestion].text
        mainQuestionLabel.text = text
        title = "Вопрос № : \(indexOfQuestion + 1) из 3"
    }
    
    func adjustMaimProgressView() {
        let progress = Float(currentQuestion) / Float(questions.count)
        mainProgressView.setProgress(progress, animated: true)
    }
    
    func hidenOrNotStackView(first:Bool,second:Bool,thierd:Bool) {
        firstStackWithButtons.isHidden = first
        secondQuestionStackView.isHidden = second
        thierdStackView.isHidden = thierd
    }
    
    
    
    func mainFunction() {
        sendingMainQuestionAndUpdateTitle(indexOfQuestion: currentQuestion)
        adjustMaimProgressView()
        
        switch currentQuestion {
        case 0:
            let texts = takingTextsFromModel(currentQuestion: currentQuestion, arrayOfQuestions: questions)
            textsToLeibls(texts: texts,butonLaibls: buttonsArray)
            hidenOrNotStackView(first: false, second: true, thierd: true)
            
        case 1:
            let texts = takingTextsFromModel(currentQuestion: currentQuestion, arrayOfQuestions: questions)
            textsToLeibls(texts: texts,textLabels: textLeiblsArrayFromSecondQuestion)
            hidenOrNotStackView(first: true, second: false, thierd: true)
            
        case 2:
            let texts = takingTextsFromModel(currentQuestion: currentQuestion, arrayOfQuestions: questions)
            textsToLeibls(texts: texts,textLabels: arrayOfTextLeiblsFierdQuestion)
            hidenOrNotStackView(first: true, second: true, thierd: false)
            
            
        default:
            break
        }

    }

    @IBAction func firstAnswerButtomsAction(_ sender: UIButton) {
        let animal = questions[currentQuestion].answers[sender.tag].type
        arrayOfAnimalsForAnswer.append(animal)
        nextQuestion()
    }
    
    @IBAction func unswerFromSecondQuestionButton(_ sender: UIButton) {
        for (indexSwitch,switchCondition) in switchArrayFromSecondQuestion.enumerated() {
            if switchCondition.isOn {
                let animal = questions[currentQuestion].answers[indexSwitch].type
                arrayOfAnimalsForAnswer.append(animal)
            }
        }
        nextQuestion()
    }
    
    @IBAction func buttonAnswerFromFierdQuestion() {
        
        switch sliderFromFierdQuestion.value {
        case  0...0.25:
            arrayOfAnimalsForAnswer.append(.dog)
        case 0.25...0.5:
            arrayOfAnimalsForAnswer.append(.cat)
        case 0.5...0.75:
            arrayOfAnimalsForAnswer.append(.rabbit)
        case 0.75...1:
            arrayOfAnimalsForAnswer.append(.turtle)
        default:
            break
        }
        nextQuestion()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "resultSegue" else { return }
        let resultVC = segue.destination as! AnswerViewController
        resultVC.arrayOfAnimalsForAnswer = arrayOfAnimalsForAnswer
    }
    
    
    
}
