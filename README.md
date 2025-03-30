# 🛍️ Product List App Task

## 📱 Application Description

* The app displays a list of products using an API and updates the UI with live data.
* Allows switching between **Grid** and **List** view.
* Supports **infinite scroll** to load more products (7 at a time).
* Shows detailed view when a product is selected.
* Uses **SkeletonView** for smooth loading states.
* Caches previously loaded data for **offline access**.
* Notifies the user on API failure or no internet.
* Fully responsive across different screen sizes.

---

## 🧠 MVVM + RxSwift Architecture

* Built using **MVVM** architecture for separation of concerns and code reusability.
* Used **RxSwift** for reactive programming and data binding between ViewModel and View.
* Follows clean code principles for scalability and testability.
* Network layer handles API requests and status monitoring.
* Offline caching layer (UserDefaults / File-based) to serve data without internet.

---

## 🛠️ Tech Used

- Swift + UIKit
- MVVM Architecture
- RxSwift + RxCocoa
- SkeletonView
- FakeStore API
- Git for source control

---

## 📦 Setup Steps

1. Clone the repository  
   ```bash
   git clone https://github.com/your-username/product-list-app.git
   cd product-list-app
