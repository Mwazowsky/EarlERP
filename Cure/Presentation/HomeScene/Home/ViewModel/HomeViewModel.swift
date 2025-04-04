import Foundation

struct HomeViewModelActions {
    //    let showHomeQueriesSuggestions: (@escaping (_ didSelect: HomeQuery) -> Void) -> Void
    //    let closeHomeQueriesSuggestions: () -> Void
}

enum HomeViewModelLoading {
    case fullScreen
    case nextPage
}

protocol HomeViewModelInput {
    func viewDidLoad()
    func didSearch(query: String)
    func didCancelSearch()
}

protocol HomeViewModelOutput {
    var loading: Observable<HomeViewModelLoading?> { get }
    var query: Observable<String> { get }
    var error: Observable<String> { get }
    var screenTitle: String { get }
    var emptyDataTitle: String { get }
    var errorTitle: String { get }
    var searchBarPlaceholder: String { get }
}

typealias HomeViewModel = HomeViewModelInput & HomeViewModelOutput

final class DefaultHomeViewModel: HomeViewModel {
    private let actions: HomeViewModelActions?
    
    // External Use Case
    private let getUserTokenDataUseCase: GetUserTokenUseCase
    
    private var homeLoadTask: Cancellable? { willSet { homeLoadTask?.cancel() } }
    private let mainQueue: DispatchQueueType
    
    // MARK: - OUTPUT
    let loading: Observable<HomeViewModelLoading?> = Observable(.none)
    let query: Observable<String> = Observable("")
    let error: Observable<String> = Observable("")
    let screenTitle = NSLocalizedString("Home", comment: "")
    let emptyDataTitle = NSLocalizedString("Search results", comment: "")
    let errorTitle = NSLocalizedString("Error", comment: "")
    let searchBarPlaceholder = NSLocalizedString("Search Chat", comment: "")
    
    // MARK: - Init
    init(
        getUserTokenDataUseCase: GetUserTokenUseCase,
        actions: HomeViewModelActions? = nil,
        mainQueue: DispatchQueueType = DispatchQueue.main
    ) {
        self.getUserTokenDataUseCase = getUserTokenDataUseCase
        self.actions = actions
        self.mainQueue = mainQueue
    }
    
    private func handle(error: Error) {
        self.error.value = error.isInternetConnectionError ?
        NSLocalizedString("No internet connection", comment: "") :
        NSLocalizedString("Failed loading movies", comment: "")
    }
}

// MARK: - INPUT. View event methods
extension DefaultHomeViewModel {
    
    func viewDidLoad() {
        print("Get Saved User Token Data: ", getUserTokenDataUseCase.execute() as Any)
    }
    
    func didLoadNextPage() {
        print("Next Page Loaded...")
    }
    
    func didSearch(query: String) {
        guard !query.isEmpty else { return }
    }
    
    func didCancelSearch() {
        homeLoadTask?.cancel()
    }
    
    func showQueriesSuggestions() {
        //        actions?.showMovieQueriesSuggestions(update(homeQuery:))
        print("Show Query Suggestion Shown")
    }
    
    func closeQueriesSuggestions() {
        //        actions?.closeHomeQueriesSuggestions()
        print("Show Query Suggestion Closed")
    }
}
