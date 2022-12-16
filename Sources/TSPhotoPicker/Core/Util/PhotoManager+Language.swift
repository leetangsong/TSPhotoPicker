//
//  PhotoManager+Language.swift
//  TSPhotoPicker
//
//  Created by leetangsong on 2022/12/13.
//

import Foundation

extension PhotoManager {
    
    
    var languageStr: String {
        var language = "en"
        for preferredLanguage in Locale.preferredLanguages {
            if preferredLanguage.hasPrefix("zh") {
                if preferredLanguage.range(of: "Hans") != nil {
                    language = "zh-Hans"
                }else {
                    language = "zh-Hant"
                }
                break
            }else if preferredLanguage.hasPrefix("ja") {
                language = "ja"
                break
            }else if preferredLanguage.hasPrefix("ko") {
                language = "ko"
                break
            }else if preferredLanguage.hasPrefix("th") {
                language = "th"
                break
            }else if preferredLanguage.hasPrefix("id") {
                language = "id"
                break
            }else if preferredLanguage.hasPrefix("vi") {
                language = "vi"
                break
            }else if preferredLanguage.hasPrefix("ru") {
                language = "ru"
                break
            }else if preferredLanguage.hasPrefix("de") {
                language = "de"
                break
            }else if preferredLanguage.hasPrefix("fr") {
                language = "fr"
                break
            }else if preferredLanguage.hasPrefix("en") {
                language = "en"
                break
            } else if preferredLanguage.hasPrefix("ar") {
                language = "ar"
                break
            }
        }
        return language
    }
}
