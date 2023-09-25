//
//  TipsView.swift
//  FitQuick
//
//  Created by Aryan Gandevia on 2023-09-20.
//

import SwiftUI

struct TipsView: View {
    
    @Binding var display: Bool
    
    // Local values for information regarding each lift
    let liftImage =
    [["Barbell\nBench\nPress", "bench-press"],
     ["Barbell\nInclined\nBench\nPress", "incline-bench-press"],
     ["Barbell\nDeadlift", "deadlift"],
     ["Barbell\nRomanian\nDeadlift", "romanian-deadlift"],
     ["Barbell\nRow", "bent-over-row"],
     ["Barbell\nSquat", "squat"],
     ["Barbell\nShoulder\nPress", "shoulder-press"]]
    
    let liftDescription: [String: [String]] = [
        "Barbell Bench Press": ["Lie flat on the bench with your shoulder blades contracted, shoulders dropped, feet flat and a slight arch in your lower back", "Find a grip width that works for you so you aren't straining your shoulders or triceps excessively on each repetition (typically a bit more than shoulder width works)", "Keep your wrists straight and your lats tight", "Lower the bar towards your middle/lower chest (and touch the bar to your chest), then push it to chin level at the top of the movement", "Use leg drive - when pushing the barbell up, keep your glutes on the bench and push yourself into the bench with your feet (hard technique to master)"],

        "Barbell Inclined Bench Press": ["Lie flat on the bench with your shoulder blades contracted, shoulders dropped, feet flat and a slight arch in your lower back", "Find a grip width that works for you so you aren't straining your shoulders or triceps excessively on each repetition (typically a bit more than shoulder width works)", "Keep your wrists straight and your lats tight", "Lower the bar towards your upper chest (and touch the bar to your chest), then push it to chin level at the top of the movement", "Keep the bench on an incline between 15-30 degrees, inclusive, to optimally focus upper chest"],

        "Barbell Deadlift": ["Keep your back straight and your feet shoulder width apart, and keep your feet close enough to the barbell so that when you perform the movement, it is very close to your shins", "Grip the barbell at or a little further than shoulder-width", "The motion is not the same as a squat, and you want to bend more at your hips (treat them like a hinge) while also bending with your knees", "Be sure to brace your core, and keep your lower back straight at all points, your upper back may bend a little naturally", "Try hook or mixed grip when your grip strength cannot keep up"],

        "Barbell Romanian Deadlift": ["Keep your feet hip-width and your heels firm on the ground, and bend your knees slightly, but hinge with your hips and keep your back straight throughout the movement", "Grip the barbell at or a little further than shoulder-width", "Go as low as you can without your back bending for each repetition"],

        "Barbell Row": ["Keep your feet shoulder width apart, knees slightly bent, back straight, and bend at your hips until your torso is 45 degrees or less from the ground", "Grip the barbell at a width a little further than shoulder width", "Pull the barbell towards your lower ribcage, and keep your shoulders dropped", "Imagine squeezing a tennis ball between your shoulder blades at the top of each repetition"],

        "Barbell Squat": ["Keep your feet a little wider than shoulder-width apart, keep your traps tight to provide a platform for the barbell to rest on, and brace both your core and lower back (breathe 'into' your stomach instead of your chest)", "Find a grip width that suits you and doesn't hurt your wrists, neck, back, or make you imablanced during the movement (make a 90 degree corner with your inner elbow and flare your arms, that is conventional grip)", "Keep your heels planted, your back straight, and knees tracking over your toes during the movement", "Bend your knees and hips simultaneously, and the bottom of the movement should be when your legs form a 90 degree bend", "Your foot can either point straight or outwards, find what works for you"],

        "Barbell Shoulder Press": ["Keep your feet hip-width apart, your back straight, and your core braced", "Grip the barbell slightly wider than shoulder-width, and keep your palms facing forward", "Press the barbell directly up, extending your arms fully"],
    ]
    
    // Displaying the the tips or not
    @State var showMore = [
        "Barbell Bench Press": false,
        "Barbell Inclined Bench Press": false,
        "Barbell Deadlift": false,
        "Barbell Romanian Deadlift": false,
        "Barbell Row": false,
        "Barbell Squat": false,
        "Barbell Shoulder Press": false,
    ]
    
    var body: some View {
        ScrollView {
            VStack {
                // Title
                Text("Tips!")
                    .font(Font.custom("ChunkFive-Regular", size:35))
                    .bold()
                    .offset(y: 10)
                    .foregroundColor(Color.black)
                Text("Click anywhere on an image or lift name to open or collapse tips")
                    .font(.system(size:25))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.blue)
                    .offset(y:5)
                HStack {
                    ForEach(0..<3, id: \.self) { index in
                        Circle()
                            .foregroundColor(Color.red)
                            .frame(width: 15, height:15)
                            .offset(y:5)
                    }
                }
                
                // Loop to go through all the lifts and displat information
                ForEach(liftImage, id : \.self) { item in
                    let liftName = item[0].replacingOccurrences(of: "\n", with: " ")
                    
                    VStack {
                                // The general display which is a button
                                Button {
                                    showMore[liftName] = showMore[liftName] == false ? true: false
                                } label: {
                                    HStack {
                                        Text(item[0])
                                            .font(Font.custom("ChunkFive-Regular", size:30))
                                            .foregroundColor(Color.black)
                                            .bold()
                                            .multilineTextAlignment(.leading)
                                        Spacer()
                                        Image(item[1])
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 200, height: 200)
                                        
                                    }
                                    .padding()
                                }
                        
                        // If show extra information button is clicked
                        if showMore[liftName] == true {
                            let arr = liftDescription[liftName] ?? []
                            VStack {
                                // Body positioning section
                                Text("Body Positioning:")
                                    .font(Font.custom("ChunkFive-Regular", size:20))
                                    .foregroundColor(Color.black)
                                    .bold()
                                Text(liftDescription[liftName]?[0] ?? "error")
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color.black)
                                
                                // Grip technique section
                                Text("Grip Technique:")
                                    .font(Font.custom("ChunkFive-Regular", size:20))
                                    .foregroundColor(Color.black)
                                    .bold()
                                    .offset(y:10)
                                Text(liftDescription[liftName]?[1] ?? "error")
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color.black)
                                    .offset(y:10)
                                
                                // General tips section
                                Text("General Tips:")
                                    .font(Font.custom("ChunkFive-Regular", size:20))
                                    .foregroundColor(Color.black)
                                    .bold()
                                    .offset(y:10)
                                
                                // dividing imagery
                                ForEach(2..<arr.count, id: \.self) { index in
                                    HStack {
                                        Text(liftDescription[liftName]?[index] ?? "error")
                                            .offset(y:10)
                                            .foregroundColor(Color.black)
                                            .multilineTextAlignment(.center)
                                            .frame(width: UIScreen.main.bounds.width * 0.95)
                                    }
                                    HStack {
                                        ForEach(0..<3, id: \.self) { index in
                                            Rectangle()
                                                .foregroundColor(Color.blue)
                                                .frame(width: UIScreen.main.bounds.width * 0.05, height:3)
                                                .offset(y: 10)
                                        }
                                    }
                                }
                                    
                            }
                        }
                    }
                }
                Button("Go Back") {
                    display = false
                }
                .padding()
            }
        }
        .background(Color.white)
    }
}

struct TipsView_Previews: PreviewProvider {
    static var previews: some View {
        TipsView(display: Binding(get: {
            return true
        }, set: { _ in
    
        }))
    }
}
