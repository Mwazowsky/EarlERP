import Foundation

protocol SearchHomeUseCase {
    func execute(
        requestValue: SearchHomeUseCaseRequestValue,
        cached: @escaping (HomePage) -> Void,
        completion: @escaping (Result<HomePage, Error>) -> Void
    ) -> Cancellable?
}

final class DefaultSearchHomeUseCase: SearchHomeUseCase {
    private let homeRepository: IHomeRepository
    private let homeQueriesRepository: IHomeQueriesRepository

    init(
        homeRepository: IHomeRepository,
        homeQueriesRepository: IHomeQueriesRepository
    ) {
        self.homeRepository = homeRepository
        self.homeQueriesRepository = homeQueriesRepository
    }

    func execute(
        requestValue: SearchHomeUseCaseRequestValue,
        cached: @escaping (HomePage) -> Void,
        completion: @escaping (Result<HomePage, Error>) -> Void
    ) -> Cancellable? {

        return homeRepository.fetchHomeList(
            query: requestValue.query,
            page: requestValue.page,
            cached: cached,
            completion: { result in

            if case .success = result {
                self.homeQueriesRepository.saveRecentQuery(query: requestValue.query) { _ in }
            }

            completion(result)
        })
    }
}

struct SearchHomeUseCaseRequestValue {
    let query: HomeQuery
    let page: Int
}
