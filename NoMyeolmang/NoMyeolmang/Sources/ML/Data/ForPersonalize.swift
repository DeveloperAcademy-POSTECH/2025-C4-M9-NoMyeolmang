//
//  ForPersonalize.swift
//  NoMyeolmang
//
//  Created by ohdodin on 7/18/25.
//

import Foundation

func saveUserData(input: MLModelInput, label: Double) {
    let encoder = JSONEncoder()
    encoder.dataEncodingStrategy = .deferredToData
    let userInput = UserData(username: "Name", timestamp: Date(), input: input, label: label)

    // 저장하기 (userdefault)
    do {
        let data = try encoder.encode(userInput)
        var dataList = UserDefaults.standard.array(forKey: "userDataList") as? [Data] ?? []
        dataList.append(data)
        UserDefaults.standard.set(dataList, forKey: "userDataList")
        print("✅ 사용자 입력 데이터 저장 성공!")
    } catch {
        print("⛔️ 사용자 입력 데이터 저장 실패: \(error)")
    }
}

func loadUserData() -> [UserData] {
    print("start loadUserData")
    let defaults = UserDefaults.standard
    if let dataArray = defaults.array(forKey: "userDataList") as? [Data] {
        let decoder = JSONDecoder()
        var inputs = [UserData]()
        for data in dataArray.suffix(10) {
            if let userData = try? decoder.decode(UserData.self, from: data) {
                inputs.append(userData)
            }
        }
        return inputs
    }
    return []
}
