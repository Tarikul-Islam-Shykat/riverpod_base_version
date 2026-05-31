# User Save + Sync Checklist

This note is the step-by-step plan for adding a save-user flow to the existing user feature.

The goal is:

```text
Save user data locally with Drift
-> show saved users at the top of the users list
-> later sync saved users with the API
```

Do not build everything at once. Finish one small step, understand it, then move to the next one.

## Current Goal

For now, the main goal is local storage:

- save a user locally
- read saved users from Drift
- show saved users before API users

Sync will come after the local flow is working.

## Clean Architecture Rule

Drift belongs only in the data layer or core database service.

Good flow:

```text
UI
-> Riverpod provider/controller
-> use case
-> repository contract
-> repository implementation
-> local data source
-> Drift database
```

Avoid:

```text
UI -> Drift directly
```

Also avoid:

```text
Domain -> Drift table/model
```

The domain layer should know only about entities and repository contracts.

## Phase 1: Save User Locally

### Step 1: Decide The Local User Fields

Before writing code, decide the first saved-user shape.

Start small:

- [ ] `id`
- [ ] `name`
- [ ] `email`
- [ ] `phone`
- [ ] `website`
- [ ] `createdAt`
- [ ] `syncStatus`

Why this is first:

- Drift table design depends on these fields
- the form depends on these fields
- the entity/model mapping depends on these fields
- sync depends on knowing which local rows are not synced yet

Recommended `syncStatus` values:

```text
pending
synced
failed
```

For the first local-only version, every newly saved user can start as:

```text
pending
```

### Step 2: Update Or Create The Drift Table

Add a table for saved users.

Checklist:

- [ ] check the current Drift database file
- [ ] decide whether the existing `Users` table is enough or needs changes
- [ ] add missing columns
- [ ] update `schemaVersion` if the table shape changes
- [ ] regenerate Drift code

Expected table idea:

```text
saved_users / users
- id
- name
- email
- phone
- website
- createdAt
- syncStatus
```

Important:

- keep database code in `lib/core/services/local_storage_service/shared`
- do not import Drift classes into domain files

### Step 3: Create User Local Data Source

Create a data-layer class that talks to Drift.

Responsibilities:

- [ ] save user
- [ ] get saved users
- [ ] watch saved users if the UI should update automatically
- [ ] update sync status later

Expected flow:

```text
UserLocalDataSource
-> AppDatabase
-> Drift table
```

This is the first user-feature file that should know about the database.

### Step 4: Map Drift Row To User Entity

The UI and domain should keep using `UserEntity`.

Checklist:

- [ ] create mapping from Drift row to `UserEntity`
- [ ] create mapping from `UserEntity` or form input to Drift companion/row
- [ ] keep JSON mapping separate from Drift mapping

Reason:

```text
API model != local database row != domain entity
```

They can have similar fields, but they are not the same responsibility.

### Step 5: Add Repository Contract Methods

Update the domain repository contract.

Add methods like:

```dart
Future<void> saveUser(UserEntity user);
Future<List<UserEntity>> getSavedUsers();
```

Later, for sync:

```dart
Future<void> syncSavedUsers();
```

Checklist:

- [ ] repository contract mentions only domain entities
- [ ] no Drift import
- [ ] no API model import
- [ ] no UI import

### Step 6: Add Save And Get Saved Use Cases

Create small use cases:

```text
SaveUserUseCase
GetSavedUsersUseCase
```

Checklist:

- [ ] use case receives repository
- [ ] use case calls one repository method
- [ ] use case does not know about Drift
- [ ] use case does not know about widgets

### Step 7: Update Repository Implementation

The implementation should connect the contract to the data source.

Checklist:

- [ ] inject `UserRemoteDataSource`
- [ ] inject `UserLocalDataSource`
- [ ] existing `getUsers()` still uses remote data source
- [ ] new `saveUser()` uses local data source
- [ ] new `getSavedUsers()` uses local data source

At this point, the repository has two sides:

```text
remote data source -> API users
local data source -> saved users
```

### Step 8: Add Riverpod Providers

Add providers to wire the new local flow.

Checklist:

- [ ] `userLocalDataSourceProvider`
- [ ] `saveUserUseCaseProvider`
- [ ] `getSavedUsersUseCaseProvider`
- [ ] `savedUsersProvider`
- [ ] save action provider/controller

Provider flow:

```text
UI
-> save action provider/controller
-> SaveUserUseCase
-> UserRepository
-> UserLocalDataSource
-> Drift
```

### Step 9: Add A Simple Save UI

Start with a small form.

Fields:

- [ ] name
- [ ] email
- [ ] phone
- [ ] website

Submit behavior:

- [ ] call save provider/controller
- [ ] clear form after success
- [ ] refresh or update saved users
- [ ] show success or error

Keep this UI simple. The goal is to learn the flow, not design a perfect form.

### Step 10: Show Saved Users At The Top

In `UsersPage`, combine local saved users with API users.

Display order:

```text
saved users first
API users second
```

Checklist:

- [ ] watch API users provider
- [ ] watch saved users provider
- [ ] combine lists in UI
- [ ] show saved users at the top
- [ ] avoid duplicate display later if sync creates matching remote data

Simple idea:

```dart
final allUsers = [
  ...savedUsers,
  ...apiUsers,
];
```

## Phase 2: Sync Saved Users

Start sync only after local save and local display are working.

### Step 11: Add Sync Status To Local Users

Each local saved user should know whether it needs syncing.

Checklist:

- [ ] new saved user starts as `pending`
- [ ] successful sync changes it to `synced`
- [ ] failed sync changes it to `failed`
- [ ] UI can optionally show sync status

### Step 12: Add Remote Save API Method

Add a remote data source method for saving to API.

Flow:

```text
UserRemoteDataSource.saveUser(...)
-> NetworkService
-> POST /users
```

For JSONPlaceholder, this will be a fake save response. That is okay for learning the flow.

### Step 13: Add Sync Use Case

Create:

```text
SyncSavedUsersUseCase
```

Responsibilities:

- [ ] get pending local users
- [ ] send each pending user to API
- [ ] mark success as `synced`
- [ ] mark failure as `failed`

### Step 14: Add Sync Provider Or Controller

The UI should trigger sync through Riverpod.

Checklist:

- [ ] create sync provider/controller
- [ ] expose loading/error/success state
- [ ] do not call repository directly from widgets
- [ ] refresh saved users after sync

### Step 15: Decide When Sync Happens

Pick one simple trigger first.

Options:

- [ ] manual sync button
- [ ] sync immediately after local save
- [ ] sync when opening users page

Recommended first version:

```text
manual sync button
```

Reason:

- easier to understand
- easier to debug
- easier to see local pending data before sync

## Recommended Build Order

Follow this order when coding:

1. decide local fields
2. update Drift table
3. create local data source
4. add mapping
5. add repository contract methods
6. add use cases
7. update repository implementation
8. add providers
9. add simple save UI
10. show saved users at the top
11. add sync status behavior
12. add remote save method
13. add sync use case
14. add sync provider/controller
15. add manual sync button

## First Step To Do Now

Start with:

```text
Step 1: Decide the local user fields
```

Do not create the local data source yet.
Do not create the UI yet.
Do not add sync yet.

First decide the exact fields that the local Drift table should store.
