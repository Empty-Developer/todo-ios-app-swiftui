import Combine
import SwiftUI

class ViewModelQuickSort {
    var arr: [String] = []
    
    func quickSort(_ arr: [String]) -> [String] {
        if (arr.count < 2) {
            return arr
        }
        
        let pivot = arr[0]
        var less: [String] = []
        var greater: [String] = []
            
        for i in arr.dropFirst() {
            if i.lowercased() <= pivot.lowercased() {
                less += [i]
            }
            
            if i.lowercased() > pivot.lowercased() {
                greater += [i]
            }
        }
        
        return quickSort(less) + [pivot] + quickSort(greater)
    }

}
