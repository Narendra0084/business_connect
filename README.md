# Bihar Business Connect

A Flutter MVP starter for connecting Bihar sellers and buyers with trust, safe contact, order confirmation, delivery coordination, ratings, and reporting.

## Architecture

The project uses feature-first Clean Architecture:

- `domain`: entities and repository contracts
- `data`: repository implementations and temporary in-memory data
- `presentation`: pages, widgets, and BLoC state management

Current repositories are in-memory so the app is runnable before Firebase setup. Replace repository implementations inside each feature's `data` layer with Firebase Auth, Firestore, Storage, and FCM integrations when backend credentials are ready.

## Main MVP Modules

- Auth and role onboarding
- Seller listings and buyer discovery
- Safe call request flow
- Order confirmation and delivery status
- Ratings and reports

## Run

```bash
flutter pub get
flutter run
```

If the local Flutter SDK crashes while running `flutter create` or `flutter pub get`, repair/update the SDK first. This source tree is already structured as a Flutter app.
