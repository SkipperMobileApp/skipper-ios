//
//  BookedLessonRepository.swift
//  Skipper
//
//  Created by Denis Kovalev on 14.01.2023.
//

import Foundation

protocol BookedLessonRepository {}

class BookedLessonRepositoryImpl: BookedLessonRepository {
    let bookedLessons: [BookedLesson] = []
}
