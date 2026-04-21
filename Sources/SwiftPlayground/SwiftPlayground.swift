// Created by Samuel Thomas
// Created on 23-07-2025

import Foundation

/// function that gets user input.
func input(forString prompt: String) -> String? {

    // print the prompt/question to the screen.
    print(prompt, terminator: "")

    // ask the user for input. when they press enter, use that text.
    let userInput: String? = readLine()

    // return the user's input to where-ever the function was called.
    return userInput
}

/// found on stackoverflow
func clearScreen() {

    // Clear the console screen.
    print("\u{001B}[2J")
    print("\u{001B}[H")
}
/// function that waits for user input so the user has a chance to stop before moving onto the next thing.
func waitForInput() {

    // Wait for user input before continuing.
    print("Press Enter to continue...")
    _ = readLine()
    clearScreen()
}

/// Cash Build Up Questions (30 total)
let cashBuildUpQuestions = [
    "What is the most populous country in the world?",
    "According to the Guinness book of world records, what's the best selling book of all time?",
    "What is the capital city of Canada?",
    "What is the only food that can never go bad?",
    "The first iPhone was released in what year?",
    "What Harry Potter book holds the record for the fastest selling book in history?",
    "Edward Cullen is a character in what movie series?",
    "What is the longest river in the world?",
    "What is the largest volcano on earth?",
    "How many elements are in the periodic table?",
    "What is the smallest country in the world by land area?",
    "Which element has the chemical symbol 'K'?",
    "In what year did the Titanic sink?",
    "Which artist painted 'The Persistence of Memory'?",
    "What is the hardest natural substance on Earth?",
    "What is the currency of South Korea?",
    "Which planet has the shortest day (fastest rotation)?",
    "Who was the first woman to win a Nobel Prize?",
    "What is the capital city of New Zealand?",
    "What is the national animal of Scotland?",
    "Which ancient civilization built Machu Picchu?",
    "Which Shakespeare play features the characters Rosencrantz and Guildenstern?",
    "What gas do plants mostly release during photosynthesis?",
    "Which sea separates Europe and Africa?",
    "What is the largest internal organ in the human body?",
    "Which country hosted the first modern Olympics in 1896?",
    "What is the SI unit of electric current?",
]

/// Options for each question
let cashBuildUpOptions = [
    ["A. India", "B. USA", "C. China"],
    ["A. Harry Potter", "B. The Bible", "C. The Lord of the Rings"],
    ["A. Ottawa", "B. Montreal", "C. Toronto"],
    ["A. Salt", "B. Honey", "C. Rice"],
    ["A. 2009", "B. 2005", "C. 2007"],
    ["A. Deathly Hallows", "B. Goblet of Fire", "C. Half-Blood Prince"],
    ["A. Hunger Games", "B. Divergent", "C. Twilight"],
    ["A. Amazon", "B. Nile", "C. Yangtze"],
    ["A. Kilimanjaro", "B. Mount Fuji", "C. Mauna Loa"],
    ["A. 118", "B. 112", "C. 120"],
    ["A. Liechtenstein", "B. Vatican City", "C. Monaco"],
    ["A. Calcium", "B. Potassium", "C. Krypton"],
    ["A. 1905", "B. 1912", "C. 1921"],
    ["A. Claude Monet", "B. Salvador Dalí", "C. Pablo Picasso"],
    ["A. Graphite", "B. Obsidian", "C. Diamond"],
    ["A. Won", "B. Yuan", "C. Yen"],
    ["A. Saturn", "B. Neptune", "C. Jupiter"],
    ["A. Florence Nightingale", "B. Rosalind Franklin", "C. Marie Curie"],
    ["A. Christchurch", "B. Auckland", "C. Wellington"],
    ["A. Lion", "B. Unicorn", "C. Horse"],
    ["A. Mayans", "B. Aztecs", "C. Incas"],
    ["A. Macbeth", "B. Hamlet", "C. Othello"],
    ["A. Nitrogen", "B. Oxygen", "C. Carbon Dioxide"],
    ["A. Red Sea", "B. Black Sea", "C. Mediterranean Sea"],
    ["A. Kidneys", "B. Liver", "C. Lungs"],
    ["A. Germany", "B. Greece", "C. France"],
    ["A. Volt", "B. Watt", "C. Ampere"],
]

/// Correct answers
let cashBuildUpAnswers = [
    "A",  // India
    "B",  // The Bible
    "A",  // Ottawa
    "B",  // Honey
    "C",  // 2007
    "A",  // Deathly Hallows
    "C",  // Twilight
    "B",  // Nile
    "C",  // Mauna Loa
    "A",  // 118
    "B",  // Vatican City
    "B",  // Potassium
    "B",  // 1912
    "B",  // Salvador Dalí
    "C",  // Diamond
    "A",  // Won
    "C",  // Jupiter
    "C",  // Marie Curie
    "C",  // Wellington
    "B",  // Unicorn
    "C",  // Incas
    "B",  // Hamlet
    "B",  // Oxygen
    "C",  // Mediterranean Sea
    "B",  // Liver
    "B",  // Greece
    "C",  // Ampere
]

/// Questions to be asked during the chase round.
let chaseQuestions = [
    "What is the smallest prime number?",
    "Which country hosted the first modern Olympic Games in 1896?",
    "What is the capital city of Iceland?",
    "Which gas do plants use during photosynthesis?",
    "Who painted the ceiling of the Sistine Chapel?",
    "What is the tallest mountain in Africa?",
    "Which Shakespeare play features the characters Rosencrantz and Guildenstern?",
    "What is the chemical symbol for gold?",
    "In computing, what does 'CPU' stand for?",
    "How many legs does a lobster have?",
    "What is the hardest natural substance on Earth?",
    "Which country gifted the Statue of Liberty to the USA?",
    "Who developed the theory of general relativity?",
    "Which element has the atomic number 1?",
    "In what year was the Declaration of Independence signed?",
    "What is the longest bone in the human body?",
    "Which instrument measures atmospheric pressure?",
    "How many stripes are there in the US flag?",
    "Vincent Van Gogh is known to sell just one named painting in his lifetime, what was it called?",
    "Sesquipedalophobia refers to the fear of what?",
    "The RR in JRR Tolkeins name stands for what?",
]

/// The options offered to the player for every question during the chase round.
let chaseOptions = [
    ["A) 1", "B) 2", "C) 3"],
    ["A) France", "B) Italy", "C) Greece"],
    ["A) Oslo", "B) Helsinki", "C) Reykjavik"],
    ["A) Oxygen", "B) Nitrogen", "C) Carbon dioxide"],
    ["A) Leonardo da Vinci", "B) Michelangelo", "C) Botticelli"],
    ["A) Mount Kilimanjaro", "B) Mount Kenya", "C) Mount Stanley"],
    ["A) Hamlet", "B) Macbeth", "C) King Lear"],
    ["A) Au", "B) Ag", "C) Fe"],
    ["A) Central Processing Unit", "B) Computer Power Unit", "C) Control Program Unit"],
    ["A) 8", "B) 10", "C) 12"],
    ["A) Diamond", "B) Graphite", "C) Quartz"],
    ["A) Spain", "B) France", "C) Germany"],
    ["A) Isaac Newton", "B) Albert Einstein", "C) Galileo Galilei"],
    ["A) Hydrogen", "B) Helium", "C) Oxygen"],
    ["A) 1776", "B) 1789", "C) 1812"],
    ["A) Femur", "B) Tibia", "C) Spine"],
    ["A) Thermometer", "B) Barometer", "C) Altimeter"],
    ["A) 11", "B) 13", "C) 15"],
    ["A) The Red Vineyard", "B) Sunset at Montmajour", "C) Stary Night"],
    ["A) Swamps", "B) The number seven", "C) Long words"],
    ["A) Nothing, he made it up", "B) Richard Relvin", "C) Ronald Reul"],
]

/// The answers to the questions during the chase round.
let chaseAnswers = [
    "B",  // 2
    "C",  // Greece
    "C",  // Reykjavik
    "C",  // Carbon dioxide
    "B",  // Michelangelo
    "A",  // Kilimanjaro
    "A",  // Hamlet
    "A",  // Au
    "A",  // CPU
    "B",  // 10
    "A",  // Diamond
    "B",  // France
    "B",  // Einstein
    "A",  // Hydrogen
    "A",  // 1776
    "A",  // Femur
    "B",  // Barometer
    "B",  // 13
    "A",  // The Red Vineyard
    "C",  // Long words
    "C",  // Ronald Reul
]

/// The letters corresponding to the answer options, this is for later when the user enters a wrong answer and the correct answer is displayed.
let letters = ["A", "B", "C"]

/// The rules of the game.
let gameRules = [
    "Welcome to the chase", "Here are the rules:", "1. Cash builder round.",
    " - You will answer your first 10 general knowledge questions",
    " - You earn $1000 per correct question answered",
    "2. Chase round.",
    " - You will start of this round with with your cash from the cash builder round",
    " - You get to choose what chaser to face (each chaser gets some questions wrong and right)",
    " - You can choose to start 3 steps from the chaser with your original amount",
    " - Or you can choose to start 2 steps from the chaser with double the original amount",
    " - Or finally you can choose to start 4 steps from the chaser with halve the original amount",
    " - For every question you answer you will move one step away from the chaser",
]

/// function that prints out game rules.
func showGameRules() {
    for rule in gameRules {
        print(rule)
        do {
            // adds a short delay between printing each line for better readibility.
            sleep(1)
        }
    }
}

/// The starting position for the player during the chase round.
var playerPosition = 0

/// The names of the chasers that the player can choose to face.
let chaserNames = ["The Beast", "The Dark Destroyer", "The Governess"]

/// The accuracy of the chasers, each chaser has a different accuracy.
let chaserAccuracy = [90, 70, 50]

/// The amount of questions that will be asked in the cashBuildUpPhase, quesitons loop will be limited by this amount.
let cashBuildUpQuestionsAmount = 10

/// Function to choose a chaser for the chase round.
@MainActor
func chooseChaser() -> Int {
    // Loop to ensure the user chooses a valid chaser.
    while true {
        // Print the chaser names and ask the user to choose one.
        print("Choose your chaser:")
        for i in 0..<chaserNames.count {
            print("\(i+1): \(chaserNames[i]), Accuracy: \(chaserAccuracy[i])%")
        }

        // Get user input.
        if let inputText = input(forString: "Enter the number of your choice: ") {

            // Check if the input is a valid number.
            if let chaserChoice = Int(inputText) {

                // Makes sure the user enters a valid choice.
                if chaserChoice >= 1 && chaserChoice <= chaserNames.count {
                    print("You have chosen \(chaserNames[chaserChoice - 1])")
                    // Minus one because of zero-indexing.
                    return chaserChoice - 1
                } else {
                    print(
                        "Invalid choice. Please enter a number between 1 and \(chaserNames.count).")
                }
            } else {
                print("Please enter a valid number.")
            }
        }
    }
}

func cashBuildUpPhase() -> Int {
    /// The amount of money the player earns per correct answer.
    let moneyPerCorrect = 1000

    /// The bank for the player throughout the game.
    var playerBank = 0

    /// The amount of questions the player has gotten correct in the cash buildup round.
    var correctAnswers = 0

    //prints a question and options for the player to answer.
    print("Welcome to the cash buildup round!")
    print("You will be asked 10 questions, each correct answer will earn you $1000.")
    print("Let's get started!")
    waitForInput()
    // Loop through each question and its options.
    // Randomly picks 10 questions for the cash build up round
    for i in (0..<cashBuildUpQuestions.count).shuffled().prefix(cashBuildUpQuestionsAmount) {
        var cashBuildUpLoop = true
        while cashBuildUpLoop {

            // Print the question and its options.
            print("")
            print("Question: \(cashBuildUpQuestions[i])")
            for option in cashBuildUpOptions[i] {
                print(option)
            }

            // Get user input for the answer.
            if let cashBuildUpAnswer = input(forString: "Your answer: ") {

                // Check if answer is empty or invalid.
                if cashBuildUpAnswer.isEmpty {
                    print("Please enter an answer.")

                    // Check if the answer is valid (A, B, C, or D).
                } else if cashBuildUpAnswer.uppercased() != "A"
                    && cashBuildUpAnswer.uppercased() != "B"
                    && cashBuildUpAnswer.uppercased() != "C"
                {
                    print("Please enter a valid answer (A, B, or C.)")

                    // Check if the answer is correct.
                } else if cashBuildUpAnswer.uppercased() == cashBuildUpAnswers[i] {
                    print("Correct")
                    print("+ $1000!")

                    // found on stackoverflow.
                    // adds one point to the correctAnswers variable per question answered correctly.
                    correctAnswers += 1
                    waitForInput()
                    cashBuildUpLoop = false
                } else {
                    print("Incorrect")
                    // Find the index of the correct answer in the letters array.
                    // This index is used to find the retrieve the the full correct answer from the options array.
                    if let cashBuildUpAnswerIndex = letters.firstIndex(of: cashBuildUpAnswers[i]) {
                        let cashBuildUpAnswerText = cashBuildUpOptions[i][cashBuildUpAnswerIndex]
                        print("The correct answer was \(cashBuildUpAnswerText).")
                    }
                    waitForInput()
                    cashBuildUpLoop = false
                }
            }
        }
    }

    // per correct answer, the player earns $1000.
    for _ in 0..<correctAnswers {
        playerBank += moneyPerCorrect
    }

    // prints the total amount of money the player has earned in the cash buildup round.
    print("You have answered \(correctAnswers) questions correctly.")
    print("You have earned $\(playerBank) in the cash buildup round.")
    return playerBank
}

/// Function to pick the starting position for the player in the chase round.
func pickStartPosition(playerBank: Int) -> (playerPosition: Int, playerBank: Int) {

    /// Calculate the low and high offers based on the player's bank.
    let lowOffer = playerBank / 2
    let highOffer = playerBank * 2

    // Print the options for the player to choose their starting position.
    print("Choose your starting position:")
    print("1. High Offer: $\(highOffer) (2 steps from the chaser)")
    print("2. Middle Offer: $\(playerBank) (3 steps from the chaser)")
    print("3. Low Offer: $\(lowOffer) (4 steps from the chaser)")

    // Loop to ensure the player makes a valid choice.
    var validChoiceLoop = true
    while validChoiceLoop {

        /// Get user input for the starting position.
        if let startPosition = input(forString: "Enter 1, 2, or 3: ") {
            switch startPosition {
            case "1":

                /// Ends loop
                validChoiceLoop = false

                // Returns player position and player bank
                return (2, highOffer)
            case "2":
                validChoiceLoop = false
                return (3, playerBank)
            case "3":
                validChoiceLoop = false
                return (4, lowOffer)
            default:
                print("Invalid choice. Please enter 1, 2, or 3.")
            }
        }
    }
}

/// Function that runs the chase part of the game.
func chasePhase(startPosition: Int, playerBank: Int, selectedChaser: Int) -> Int {

    /// The players start position.
    var playerPosition = startPosition

    /// The chasers start position.
    var chaserPosition = 0

    /// The accuracy of the chaser chosen.
    let chaserAccuracyValue = chaserAccuracy[selectedChaser]

    /// The total number of steps to reach the end.
    let totalSteps = 8
    waitForInput()

    // For every question prints out all inside.
    for i in (0..<chaseQuestions.count).shuffled() {

        // Starts loop.
        var chaseLoop = true
        while chaseLoop {
            print("")

            // Print the question and options.
            print("Question: \(chaseQuestions[i])")
            for option in chaseOptions[i] {
                print(option)
            }

            // Wait for user input.
            if let chaseAnswer = input(forString: "Your answer: ") {

                // If the answer is empty or doesn't have a desired letter, loop continues.
                if chaseAnswer.isEmpty {
                    print("Please enter an answer.")
                } else if chaseAnswer.uppercased() != "A" && chaseAnswer.uppercased() != "B"
                    && chaseAnswer.uppercased() != "C"
                {
                    print("Please enter a valid answer (A, B, or C).")

                    // If the answer is correct
                } else if chaseAnswer.uppercased() == chaseAnswers[i] {
                    print("Correct")

                    /// Move the player one step away from the chaser.
                    playerPosition += 1
                    waitForInput()

                    // Ends loop.
                    chaseLoop = false
                } else {
                    print("Incorrect")
                    // Find the index of the correct answer in the letters array.
                    // This index is used to find the retrieve the the full correct answer from the options array.
                    if let chaseAnswerIndex = letters.firstIndex(of: chaseAnswers[i]) {
                        let chaseAnswerText = chaseOptions[i][chaseAnswerIndex]
                        print("The correct answer was \(chaseAnswerText).")
                    }
                    waitForInput()
                    chaseLoop = false
                }
            }
        }
        print("")

        // Chasers turn to answer question
        print("Chaser's turn...")

        // Simulate chaser answering the question
        if Int.random(in: 1...100) < chaserAccuracyValue {
            print("Chaser answered correctly.")
            chaserPosition += 1
        } else {
            print("Chaser answered incorrectly.")
        }
        print("")

        // prints chaser and player positions
        print("Chaser's position: \(chaserPosition)")
        print("Your position: \(playerPosition)")
        print("Positions till end: \(totalSteps - playerPosition)")

        // Check if the chaser has caught the player, returns 0 as user made no money.
        if chaserPosition >= playerPosition {
            return 0
        }

        // Check if the player has reached the end, returns the playersbank amount.
        if playerPosition >= totalSteps {
            return playerBank
        }
    }

    // Just here in case the neither the chaser catches the player or the player reaches the end, which never happens, just here to make swift happy.
    return 0
}

// Main program starts here
showGameRules()
waitForInput()

/// Cash build-up phase
let playerBank = cashBuildUpPhase()
waitForInput()

// Check if player has enough money from the cash build up round to continue.
if playerBank == 0 {
    print("You have no money to take into the chase round. Game over.")
    exit(0)
}

/// Choose a chaser
let selectedChaser = chooseChaser()
waitForInput()

/// The start position and startingBank comes from the pickStartPosition function.
let (startPosition, startingBank) = pickStartPosition(playerBank: playerBank)

print("You start \(startPosition) steps from the chaser with $\(startingBank).")
print("The chase is about to begin...")

/// The final amount of money that was made during the chasePhase
let finalBank = chasePhase(
    startPosition: startPosition, playerBank: startingBank, selectedChaser: selectedChaser)

// if user makes money from the chase phase, the amount of money they made will be printed. If not, a message will be displayed.
print("")
if finalBank > 0 {
    print("Congratulations! You've successfully outrun the chaser.")
    print("You have made \(finalBank) dollars!")
} else {
    print("The chaser has caught you. Better luck next time!")
}
