# Popmenu Interview Project

This project was developed by Arthur Bender as part of a selection process.

It is a small JSON API for restaurants, menus, menu items, and a JSON conversion tool that imports restaurant data into the application models, based on the interview guidelines in [PopmenuInterviewProject.pdf](guidelines/PopmenuInterviewProject.pdf).

## Tech Stack

- Ruby
- Ruby on Rails
- PostgreSQL
- RSpec
- RuboCop

## Running the Project

### Requirements

- Ruby `~> 3.x`
- PostgreSQL running locally on `localhost:5432`

### Setup

```bash
bundle install
bin/rails db:prepare
```

### Start the server

```bash
bin/rails server
```

The API will be available at:

```text
http://localhost:3000
```

### Run the test suite

```bash
bundle exec rspec
```

### Run the linter

```bash
bundle exec rubocop
```

## Domain Model

### Restaurant

A restaurant has many menus.

### Menu

A menu belongs to a restaurant.

A menu has many menu entries and many menu items through menu entries.

### MenuItem

A menu item represents the shared item identity.

A menu item can belong to many menus in the same restaurant through menu entries.

### MenuEntry

A menu entry connects a menu and a menu item.

It stores the item price for that specific menu.

## API Endpoints

### Restaurants

- `GET /api/v1/restaurants`
- `GET /api/v1/restaurants/:id`

Example response:

```json
[
  {
    "id": 1,
    "name": "Poppo's Cafe",
    "created_at": "2026-03-04T12:00:00.000Z",
    "updated_at": "2026-03-04T12:00:00.000Z"
  }
]
```

### Menus

- `GET /api/v1/restaurants/:restaurant_id/menus`
- `GET /api/v1/restaurants/:restaurant_id/menus/:id`

Example response:

```json
[
  {
    "id": 1,
    "name": "lunch",
    "restaurant_id": 1,
    "created_at": "2026-03-04T12:00:00.000Z",
    "updated_at": "2026-03-04T12:00:00.000Z"
  }
]
```

### Menu Items

- `GET /api/v1/restaurants/:restaurant_id/menus/:menu_id/menu_items`
- `GET /api/v1/restaurants/:restaurant_id/menus/:menu_id/menu_items/:id`

Example response:

```json
[
  {
    "id": 1,
    "menu_id": 1,
    "menu_item_id": 1,
    "price": 9.0,
    "created_at": "2026-03-04T12:00:00.000Z",
    "updated_at": "2026-03-04T12:00:00.000Z",
    "name": "Burger"
  }
]
```

## Conversion Tool

The project includes a JSON conversion tool that imports restaurant data into the database.

It accepts files compatible with the provided guideline structure, including both `menu_items` and `dishes`.

### HTTP endpoint

```text
POST /api/v1/imports
```

Example using `curl`:

```bash
curl -X POST http://localhost:3000/api/v1/imports \
  -F "file=@guidelines/restaurant_data.json"
```

### Rake task

You can also run the conversion tool from the command line:

```bash
bin/rake imports:process[guidelines/restaurant_data.json]
```

### Conversion response

The import response contains:

- `logs`: one entry per processed menu item
- `totals`: number of created records plus the number of import errors

Example response:

```json
{
  "resources_created": {
    "logs": [
      {
        "status": "success",
        "restaurant": "Poppo's Cafe",
        "menu": "lunch",
        "item": "Burger",
        "price": 9.0,
        "message": "Imported menu item."
      },
      {
        "status": "failed",
        "restaurant": "Casa del Poppo",
        "menu": "lunch",
        "item": "Burger",
        "price": 9.0,
        "message": "Error adding entry for Burger with price 9.0 to menu lunch: Validation failed: Menu item must belong only to menus from the same restaurant."
      }
    ],
    "totals": {
      "restaurants": 2,
      "menus": 4,
      "menu_items": 6,
      "menu_entries": 7,
      "errors": 1
    }
  }
}
```
