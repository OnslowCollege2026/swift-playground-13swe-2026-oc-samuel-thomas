// Formative Assessment
// Created on 2025/06/16 - 27
// Created by Samuel Thomas

import Foundation

// variable arrays for video data to be entered into
var videoNames: [String] = []
var laNames: [String] = []
var videoDurations: [Int] = []
// array of allowed LA names
let allowedNames = ["bernadette", "brian", "janice", "michelle", "karl", "katie", "sammy", "tonia"]
/// function that displays menu options

    // prints out menu options
func showMenu() {
    print("Choose an item:")
    print("A - Add new video")
    print("B - Remove video")
    print("C - List all videos")
    print("Q - Quit")
}
/// function that adds video to lists

    // gets input for video name - adds to list
    // gets input for teacher name - loops if invalid name is entered - adds to list if valid
    // gets input for video duration - adds to list
@MainActor
func addVideo() {
    print("Enter video name: ")
    if let videoName = readLine() {
        videoNames.append(videoName)
    }
    print("Enter LA lead: ")
    while true {
        if let laName = readLine() {
            if allowedNames.contains(laName.lowercased()) {
                laNames.append(laName)     
                break           
            } else {
                print("please enter a valid Learning Area Leader")
            }
    }
    }
    print("Enter duration in minutes: ")
    if let videoDuration = readLine(), let videoDuration = Int(videoDuration) {
        videoDurations.append(videoDuration)
    }      
    }
/// function that removes video from lists

    // checks if there are any videos in lists - if not returns
    // lists all videos in list
    // gets input for what video the user will like to remove - if picks a valid video, removes it - if not prints invalid
@MainActor
func remove() {
    if videoNames.count == 0 {
        print("no videos to remove")
        return
    }
    for i in 0..<videoNames.count {
        print("\(i+1): \(videoNames[i])")
    }

    print("Which number to remove?")
    
    
    if let input = readLine(), var number = Int(input) {
        number = number - 1
        if videoNames.indices.contains(number) {
            videoNames.remove(at: number)
            print("Removed.")
        } else {
            print("Invalid")
        }
    } else {
        print("Invalid.")
    }
}

/// function that shows the user list of videos

    // counts how many videos are in each list
    // for the amount of videos prints each video
@MainActor
func list() {
    let count = min(videoNames.count, laNames.count, videoDurations.count)
    print("Videos")
    for i in 0..<count {
        let videoName = videoNames[i]
        let videoDuration = videoDurations[i]
        let laName = laNames[i]
        print("Title: \(videoName), Teacher: \(laName), Duration: \(videoDuration)")
        
    }
}

// creates loop for showing the menu
var running = true
while running {
    showMenu()
    // gets input for what option the user wants to pick
    let option = readLine()
    switch option?.uppercased() {
    // for the option that user picks will use function
    case "A":
        addVideo()
    case "B":
        remove()
    case "C":
        list()
    case "Q":
        running = false
        print("goodbye")
    // if the user doesnt pick one of the options, will loop
    default:
        print("??")
    }
}


// not done :(

