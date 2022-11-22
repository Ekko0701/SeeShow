# SeeShow

### 2022.11.01 (프로젝트 생성)
- TabBar 세팅
- MainView UI
  - CollectionView에 UICollectionVIewCompositionalLayout를 적용해 구성
  - BannerCell 자동 스크롤 구현
  - UICollectionViewDataSource 대신에 RxDataSource를 사용
  - CollectionView는 더미 데이터로 구성
- API Service
  - Rx, Alamofire를 이용해 Kopis Open API 사용
- Rx로 LoadingView 구현
  
- Problem & Todo
  - BannerCell 마지막 아이템까지 스크롤 했을 때 첫 번째 아이템으로 자연스럽게 넘어가지 않는다.
  - RxDataSource를 이용해 여러 Section 그리고 SupplementaryView( = Header)를 추가하는 방법 공부 필요 ✅   
### 2022.11.02
- RxDataSource로 Multiple Section 구현
- BannerCell, BannerCellItem에 viewModel의 데이터 전달. Observable 형태로 전달해 BannerCellItem에 바로 바인딩
<p align="center">
    <img src= "https://github.com/Ekko0701/SeeShow/blob/main/gif/2022-11-02/Simulator%20Screen%20Recording%20-%20iPhone%2014%20-%202022-11-02%20at%2023.03.51.gif" width="20%">
    <img src= "https://github.com/Ekko0701/SeeShow/blob/main/gif/2022-11-02/Simulator%20Screen%20Recording%20-%20iPhone%2014%20-%202022-11-02%20at%2023.04.16.gif" width="20%">
</p>

- Problem & Todo
  - 처음 시작할 때 Loading 중에도 Banner가 자동으로 넘어간다.
  - Kopis API에서 받은 데이터 CollectionView에 넣을 것 
 

### 2022.11.03
- MainView코드 정리, 주석 정리
- BoxOfficeStore의 FetchKidsBoxOffice()추가, 아이템 개수 10개로 제한

### 2022.11.04
- Font 적용
- KingFisher 라이브러리를 사용해 포스터 이미지 적용
- MainViewController의 collectionView Cell 터치 이벤트 작업 
    - collectionView.rx.modelSelected, collectionView.rx.itemSelected 를 zip해서 구현 
- DetailView UI

- Problem & Todo
  - MainViewController에서 cell을 터치시 modelSelected와 itemSelected 이벤트가 발생하는데 터치한 cell의 공연 ID를 DetailViewModel로 전달하는 방법 생각해볼것 ✅
  

### 2022.11.05
- DetailView UI 작업

- Problem & Todo
    - 공연 상세 설명 이미지의 높이가 커서 .scaleAspectFit을 적용하면 상하단에 빈공간이 발생 ✅
    
### 2022.11.06
- Kopis 공연 상세 검색 API테스트 및 모델 설정

- Solved Issue
    - 공연 상세 설명 이미지를 받아올때 KingFisherManager를 사용해 UIImageView에 알맞은 사이즈로 Resizing해 적용해 이슈 해결
    
### 2022.11.07
- DetailModel 생성 (KOPIS 공연 상세 정보 response 모델 & XML데이터 파싱 모델) 
- ViewDetail 생성 (DetailModel에서 View를 구성하는데 필요한 데이터 모델)
- KopisAPIService에 공연 상세 검색 요청 추가, DetailFetchable에서 데이터 파싱 진행
- DetailViewModel 생성, UI Component와 바인딩 진행중

- Issue 해결
    - DetailViewController에서 DetailViewModel을 초기화할때 id를 넘겨주었다.

- Problem & Todo 
    - MainViewController에서 Cell 터치시 DetailView로 넘어갈때 이벤트를 발생시키는 Observable를 만들어서 ID를 넘겨보는 방법을 생각해보자. (MVVM) ✅

### 2022.11.08
-  셀 터치 이벤트 재설정
    - 1. Cell을 선택하면 itemSelected Event 발생 MainViewModel의 touchKidsBoxOfficCell ( = PublishSubject)에 indexPath.item을 onNext로 전달.
    - 2. MainViewModel에서 touchKidsBoxOffice를 kidsCellTouching이 Observe
    - 3. kidsCellTouching과 kidsBoxOffice를 CombineLatest후 indexPath번째 데이터의 id를 가지는 Observable 반환 => showDetailPage
    - 4. MainViewCOntroller에서 showDetailPage를 Subscribe하고 DetailViewController과 DetailViewController의 DetailViewModel 생성
    - 5. NavigationPush
    
- DetailView UI 바인딩
    - 공연 상세 포스터가 존재하지 않는 경우가 있기 때문에 존재하는 경우에만 DetailPosterStack에 전처리 작업을 진행한 detailPosterImage를 추가
    
- Problem & Todo
    - Error 예외처리 -> Observable로 처리
    - DetailPosterStack에 Default View 추가

### 2022.11.09
- 연극, 대학로, 오픈런 박스오피스 요청 추가, MainView에 추가

- Problem & Todo
    - MainView에 추가는 잘 돼지만 스크롤시 에러가 발생함.
        - Assertion failed: This is a feature to warn you that there is already a delegate (or data source) set somewhere previously... 에러가 발생
        - 에러 메시지와, RxDataSource 깃허브 이슈를 참고해 UI Binding 전에 datasource = nil 을 추가했지만 해결하지 못했다.

### 2022.11.10
- 에러 관련해서 테스트를 해보니 ViewModel에는 해당사항 없음, UI에서 문제점을 발견. MainView 상단 BannerCell은 Cell 안에 다른 Cell을 추가해서 구성했다. 그래서 BannerCell에서 위의 Assertion failed가 발생했다.
    - BannerCell 재구성

### 2022.11.12
- Cell Touch Event 완료
- ScrollToItem과 Timer를 이용해 AutoScroll을 구현했다. 하지만 ScrollToItem을 할 때 Section 0으로 이동해 CollectionView가 맨위로 스크롤 되는 문제점 발견. -> Cell안에 UICollectionViewCell을 넣고 안에 있는 cell에서 timer가 동작하도록 변경해 해결함.
- Banner Cell - AutoScroll, Paging 구현
- Banner Cell Touch - protocol delegate를 이용해서 구현

### 2022.11.15
- CategoryView (PageView) 구성 시작
- CategoryView ViewPager 추가
- UIPageViewController와 ViewPager CollectionView 연결
- CategoryView의 Page ViewModel 생성
- Page의 tableView 데이터 바인딩

- Problem & Todo
    - Kingfisher를 사용해 이미지를 적용할때 사이즈를 조절해 각 셀의 포스터 이미지 비율과 크기를 동일하게 만들자.
    - MainView에서 카테고리를 선택해 CategoryView로 이동하면 해당하는 카테고리로 이동하지만 ViewPager가 이동하지 않는다.

### 2022.11.16
- tableView.rx.setDelegate로 delegate 채택후 heightForRowAt으로 cell 높이 설정

### 2022.11.19
- NavigationBar 설정

### 2022.11.20
- UI 수정
- Problem & Todo
    - MainView에서 배너 cell을 터치시 showDetail이 2번 동작한다.
    - MainView의 Section간 거리 조절..
    
### 2022.11.21
- MainView UI 완성

### 2022.11.22
- DetailView UI 완성
- MainView의 bannerCell이 재사용 될때마다 disposeBag을 재성정 하지 않아서 touch Event가 여러번 발생하는 오류 해결 ( prepareForReuse )
