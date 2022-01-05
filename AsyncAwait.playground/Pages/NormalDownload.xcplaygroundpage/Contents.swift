import UIKit



func sayHi() {
    print("Hi")
}

func multiply(_ x: Int, _ y: Int) -> Int {
    x * y
}

func sayBye(result: Int) {
    print("Bye \(result)")
}


func performDownload() {
    Task {
        let imageDetail = try! await downloadMetadata(for: 1)
        print(imageDetail.name)
    }
}

func performMessyStuff(){
    sayHi()
    let x = 10
     performDownload()
    let y = 5
    let result = multiply(x, y)
    sayBye(result: result)
}

performMessyStuff()
