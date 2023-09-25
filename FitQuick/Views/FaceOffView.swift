//
//  FaceOffView.swift
//  FitQuick
//
//  Created by Aryan Gandevia on 2023-08-18.
//

import SwiftUI

struct FaceOffView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isMoving = false
    
    @StateObject var viewModel = FaceOffViewViewModel()
    @Binding var showingFaceOff: Bool
    
    @State var currLongerThanOther = true
    
    @State var oneRepOrNot = false
    
    let userId: String
    let otherUserId: String
    
    var body: some View {
        ScrollView(showsIndicators: true) {
            ZStack {
//                Image("versus")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .offset(x: 5, y: UIScreen.main.bounds.height * -0.5)
//                    .frame(width: 250)
                VStack {
                    // Title
                    Text("Head-to-Head")
                        .font(.system(size: 32))
                        .bold()
                        .offset(y: 10)
                    
                    HStack {
                        Image(systemName: "dumbbell.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(colorScheme == .light ? Color.blue : Color.red)
                            .frame(width: 80, height: 80)
                        Image(systemName: "dumbbell.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(colorScheme == .light ? Color.blue : Color.red)
                            .frame(width: 80, height: 80)
                        Image(systemName: "dumbbell.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(colorScheme == .light ? Color.blue : Color.red)
                            .frame(width: 80, height: 80)
                    }
                    
                    HStack {
                        //TODO: make the text change appropriately when it becomes multiple lines
                        //TODO: add better font, maybe make the image importing changes
                        Text(viewModel.currentUser?.userName ?? "")
                           // .font(Font.custom("Papyrus", size: 20))
                            .font(.system(size: 20))
                            .bold()
                          //  .offset(x: UIScreen.main.bounds.width * -0.07)
                            .frame(width: UIScreen.main.bounds.width * 0.4)
                        
                        Image(systemName: "arrowshape.right.fill")
                        Image(systemName: "arrowshape.left.fill")
                        
                        Text(viewModel.otherUser?.userName ?? "")
                         //   .font(Font.custom("Papyrus", size: 20))
                            .font(.system(size: 20))
                            .bold()
                         //   .offset(x: UIScreen.main.bounds.width * 0.07)
                            .frame(width: UIScreen.main.bounds.width * 0.4)
                        
                    }
                    VStack {
                        // users' statistics
                        // gender
                        HStack {
                            Text(viewModel.currentUser?.gender.uppercased() ?? "N/A")
                                .font(.system(size: 20))
                                .foregroundColor(colorScheme == .light ? Color.mint : Color.orange)
                            Spacer()
                            Text(viewModel.otherUser?.gender.uppercased() ?? "N/A")
                                .font(.system(size: 20))
                                .foregroundColor(colorScheme == .light ? Color.mint : Color.orange)
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.95)
                        
                        // weight
                        HStack {
                            Text(String(viewModel.currentUser?.weight ?? 0) + "lbs")
                                .font(.system(size: 20))
                                .foregroundColor(colorScheme == .light ? Color.mint : Color.orange)
                            Spacer()
                            Text(String(viewModel.otherUser?.weight ?? 0) + "lbs")
                                .font(.system(size: 20))
                                .foregroundColor(colorScheme == .light ? Color.mint : Color.orange)
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.95)
                        
                        // age
                        HStack {
                            Text(String(viewModel.currentUser?.age ?? 0) + " years old")
                                .font(.system(size: 20))
                                .foregroundColor(colorScheme == .light ? Color.mint : Color.orange)
                            Spacer()
                            Text(String(viewModel.otherUser?.age ?? 0) + " years old")
                                .font(.system(size: 20))
                                .foregroundColor(colorScheme == .light ? Color.mint : Color.orange)
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.95)
                        
                        Text("     ")
                            .opacity(0)
                            .font(.system(size:30))
                    }
                    
                    if viewModel.currentUserLifts.count == 0 {
                        Text("Add some lifts to start comparing!")
                            .foregroundColor(colorScheme == .light ? Color.green : Color.red)
                            .font(.system(size:20))
                            .multilineTextAlignment(.center)
                            .frame(width:UIScreen.main.bounds.width * 0.9)
                            .offset(y:-10)
                    } else if viewModel.otherUserLifts.count == 0 {
                        Text("The other user either has no lifts or you both have no common lifts save. Try someone else!")
                            .foregroundColor(colorScheme == .light ? Color.green : Color.red)
                            .font(.system(size:20))
                            .multilineTextAlignment(.center)
                            .frame(width:UIScreen.main.bounds.width * 0.9)
                    } else {
                        Button(oneRepOrNot == false ? "Convert to 1RM" : "Revert from 1RM") {
                            oneRepOrNot = oneRepOrNot == false ? true : false
                        }
                        .font(.system(size: 24))
                        .offset(y:-20)
                        
                        if oneRepOrNot {
                            ForEach(Array(zip(viewModel.currentUserLifts, viewModel.otherUserLifts)), id: \.0) { curr, other in
                                ZStack {
                                    
                                    VStack {
                                        compareItemOneRep(curr: curr, other: other)
                                        //                            Text("00")
                                        //                                .font(.system(size:40))
                                        //                                .opacity(0)
                                        
                                        
                                        // dividing lines for each life
                                        Rectangle()
                                            .foregroundColor(colorScheme == .light ? Color.blue : Color.red)
                                            .frame(width: UIScreen.main.bounds.width * 1.2, height:5)
                                            .offset(y:-15)
                                        Rectangle()
                                            .foregroundColor(colorScheme == .light ? Color.blue : Color.red)
                                            .frame(width: UIScreen.main.bounds.width * 1.2, height:5)
                                            .offset(y:-15)
                                        
                                    }
                                }
                            }
                        } else {
                            
                            ForEach(Array(zip(viewModel.currentUserLifts, viewModel.otherUserLifts)), id: \.0) { curr, other in
                                ZStack {
                                    
                                    VStack {
                                        compareItem(curr: curr, other: other)
                                        //                            Text("00")
                                        //                                .font(.system(size:40))
                                        //                                .opacity(0)
                                        
                                        
                                        // dividing lines for each life
                                        Rectangle()
                                            .foregroundColor(colorScheme == .light ? Color.blue : Color.red)
                                            .frame(width: UIScreen.main.bounds.width * 1.2, height:5)
                                            .offset(y:-15)
                                        Rectangle()
                                            .foregroundColor(colorScheme == .light ? Color.blue : Color.red)
                                            .frame(width: UIScreen.main.bounds.width * 1.2, height:5)
                                            .offset(y:-15)
                                        
                                    }
                                }
                            }
                        }
                    }
                        
                    Button("Back") {
                        showingFaceOff = false
                    }
                    .font(.system(size: 20))
                }
                .onAppear {
                    isMoving = true
                    viewModel.fetchUsers(currentUserId: userId, otherUserId: otherUserId)
                    viewModel.fetchInformation(userId: userId, otherUserId: otherUserId)
                }
            }
        }
    }
    
    // the comparison item
    @ViewBuilder
    func compareItem(curr: Lift, other: Lift) -> some View {
        // title
        Text(curr.liftName)
            .font(.system(size:27))
            .bold()
        
        // Reps line
        HStack(spacing: 0) {
            // variables used to center when numbers are not same amount of digits
            let diff = String(curr.numReps).count - String(other.numReps).count
            let absDiff = abs(String(curr.numReps).count - String(other.numReps).count)
            let centeringString = String(repeating: "0", count: absDiff)
            let centeringCheck = viewModel.centeringCheck(diff: diff)
           
            //TODO: use and make animations for winning number
            let winnerCheck = curr.numReps - other.numReps > 0 ? true : false
            let equalCheck = curr.numReps - other.numReps == 0 ? true : false
  
            // if other user's numReps is more digits, fill in empty space
            if centeringCheck {
                Text(centeringString)
                    .font(.system(size:80))
                    .offset(x:-20)
                    .opacity(0)
            }
            // your reps
                Text(String(curr.numReps))
                    .font(.system(size:80))
                    .offset(x: -20)
            Text("REPS")
                .font(.system(size:25))
            // other user's reps
                Text(String(other.numReps))
                    .font(.system(size:80))
                    .offset(x:20)
            // if your numReps has more digits, fill in empty space to center
            if !centeringCheck {
                Text(centeringString)
                    .font(.system(size:80))
                    .offset(x:20)
                    .opacity(0)
            }
            
        }
        .frame(width:UIScreen.main.bounds.width)
        
        // weight line
        HStack(spacing: 0) {
            // variables used to center when numbers are not same amount of digits
            let diff = String(curr.weight).count - String(other.weight).count
            let absDiff = abs(String(curr.weight).count - String(other.weight).count)
            let centeringString = String(repeating: "0", count: absDiff)
            let centeringCheck = viewModel.centeringCheck(diff: diff)
            
            //TODO: use and making animations for winning one
            let winnerCheck = curr.weight - other.weight > 0 ? true : false
            let equalCheck = curr.weight - other.weight == 0 ? true : false
  
            // if other user's numReps is more digits, fill in empty space
            if centeringCheck {
                Text(centeringString)
                    .font(.system(size:80))
                    .offset(x:-20)
                    .opacity(0)
            }
           
                Text(String(curr.weight))
                    .font(.system(size:50))
                    .offset(x: -20)
            
            Text("WEIGHT")
                .font(.system(size:25))
            // other user's reps
                Text(String(other.weight))
                    .font(.system(size:50))
                    .offset(x:20)
          
            // if your weight digits is more than the other user's
            if !centeringCheck {
                Text(centeringString)
                    .font(.system(size:50))
                    .offset(x:20)
                    .opacity(0)
            }
        }
        .frame(width:UIScreen.main.bounds.width)
    }
    
    // the display for the one rep max
    @ViewBuilder
    func compareItemOneRep(curr: Lift, other: Lift) -> some View {
        // title
        Text(curr.liftName)
            .font(.system(size:27))
            .bold()
        
        // weight line
        HStack(spacing: 0) {
            // your one rep max
            let currWeight = Double(curr.weight)
            let currNumReps = Double(curr.numReps)
            let currOneRmDouble = currWeight / (1.0278 - (0.0278 * currNumReps))
            let currOneRm = Int(currOneRmDouble)
            
            // other's one rep max
            let otherWeight = Double(other.weight)
            let otherNumReps = Double(other.numReps)
            let otherOneRmDouble = otherWeight / (1.0278 - (0.0278 * otherNumReps))
            let otherOneRm = Int(otherOneRmDouble)
            
            // variables used to center when numbers are not same amount of digits
            let diff = String(currOneRm).count - String(otherOneRm).count
            let absDiff = abs(String(currOneRm).count - String(otherOneRm).count)
            let centeringString = String(repeating: "0", count: absDiff)
            let centeringCheck = viewModel.centeringCheck(diff: diff)
            
            //TODO: use and making animations for winning one
            let winnerCheck = currOneRm - otherOneRm > 0 ? true : false
            let equalCheck = currOneRm - otherOneRm == 0 ? true : false
  
            // if other user's numReps is more digits, fill in empty space
            if centeringCheck {
                Text(centeringString)
                    .font(.system(size:80))
                    .offset(x:-20)
                    .opacity(0)
            }
           
                Text(String(currOneRm))
                    .font(.system(size:50))
                    .offset(x: -20)
            
            Text("WEIGHT")
                .font(.system(size:25))
            // other user's reps
                Text(String(otherOneRm))
                    .font(.system(size:50))
                    .offset(x:20)
          
            // if your weight digits is more than the other user's
            if !centeringCheck {
                Text(centeringString)
                    .font(.system(size:50))
                    .offset(x:20)
                    .opacity(0)
            }
        }
        .frame(width:UIScreen.main.bounds.width)
    }
}


struct FaceOffView_Previews: PreviewProvider {
    static var previews: some View {
        FaceOffView(showingFaceOff: Binding(get: {
            return true
        }, set: { _ in
            
        })
                    , userId: "example"
                    , otherUserId: "example2")
    }
}
