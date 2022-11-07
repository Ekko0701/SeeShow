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
  - MainViewController에서 cell을 터치시 modelSelected와 itemSelected 이벤트가 발생하는데 터치한 cell의 공연 ID를 DetailViewModel로 전달하는 방법 생각해볼것
  

### 2022.11.05
- DetailView UI 작업

- Problem & Todo
    - 공연 상세 설명 이미지의 높이가 커서 .scaleAspectFit을 적용하면 상하단에 빈공간이 발생 ✅
    
### 2022.11.06
- 공연 상세 설명 이미지를 받아올때 KingFisherManager를 사용해 UIImageView에 알맞은 사이즈로 Resizing해 적용해 이슈 해결
- Kopis 공연 상세 검색 API테스트 및 모델 설정
