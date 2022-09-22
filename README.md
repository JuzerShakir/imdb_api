# IMDb API

> A Rails API for extracting data of a Movie or Tv-Series via an IMDb link provided by the user.

---

<div align="center">

  <img src="https://img.shields.io/badge/Ruby_3.1.2-CC342D?style=for-the-badge&logo=ruby&logoColor=white">

  <img src="https://img.shields.io/badge/Rails_7.0.4-CC0000?style=for-the-badge&logo=ruby-on-rails&logoColor=white">

  <img src="https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white">

  <img src="https://img.shields.io/badge/redis-%23DD0031.svg?&style=for-the-badge&logo=redis&logoColor=white">
</div>

<div align="center">
  <img src="public/assets/project_logo.png" />
</div>

<div align="center">
  <img src="https://visitor-badge-reloaded.herokuapp.com/badge?page_id=juzershakir.imdb_api&color=000000&lcolor=000000&style=for-the-badge&logo=Github"/>
  <a href="https://wakatime.com/badge/user/ccef187f-4308-4666-920d-d0a9a07d713a/project/509003f7-2b71-4958-be09-1a0d27b03a0c"><img src="https://wakatime.com/badge/user/ccef187f-4308-4666-920d-d0a9a07d713a/project/509003f7-2b71-4958-be09-1a0d27b03a0c.svg" alt="wakatime"></a>
</div>

---

## Table of Contents

- [Summary](#summary)
- [Schema](#schema)
  - [Our Entertainment Model](#our-entertainment-model)
- [Running the App](#running-the-app)
  - [Setup env for the app](#setup-env-for-the-app)
  - [Setup PostgreSQL](#setup-postgresql)
  - [Setup Background Jobs](#setup-background-jobs)
    - [Setting Up Sidekiq](#setting-up-sidekiq)
    - [Setting Up Redis](#setting-up-redis)
- [Feeding the Data](#feeding-the-data)
  - [Manually](#manually)
    - [POST request](#post-request)
    - [GET request](#get-request)
    - [PATCH request](#patch-request)
  - [Via Seed](#via-seed)
- [Business Logic](#business-logic)
  - [Entertainment Model](#entertainment-model)
  - [Producer Model](#producer-model)
  - [Director Model](#director-model)
  - [Genre Model](#genre-model)
  - [Star Model](#star-model)
    - [Shared Scopes](#shared-scope)

---

## Summary

- [x] Using PostgreSQL database to store the data.
- [x] Using the `Watir` & `Webdriver` gem to extract data from IMDb website.
- [x] User can create new entries in db by providing the correct URL.
- [x] Checks if the user input is a valid IMDb URL.
- [x] After validating URL, the process is passed to ActiveJob.
- [x] Checks if the content of a URL is a Movie or TV-Series.
- [x] Checks if the content can be rated by the users.
- [x] If all checks pass then the data extraction process begins.
- [x] Existing data can also be updated via `update` action.
- [x] Users can also instantly instantiate data to the database via `rails db:seed` command.
- [x] Provide business logic.

---

## Schema

<div align="center">
  <img src="public/assets/schema.png" />
</div>

### Our Entertainment Model

|  **Attribute**   |                                          **Desc**                                          |
| :--------------: | :----------------------------------------------------------------------------------------: |
|    **title**     |                              Title of the movie or TV-Series                               |
|    **rating**    |                               Ratings of the respective show                               |
|   **tagline**    |                                A short overview of the show                                |
| **release_date** |                                  Release date of the show                                  |
|  **popularity**  |                        Number of IMDb users who have rated the show                        |
|     **type**     |        An STI attribute, a show can either be an instance of a `Movie` or `TvShow`         |
|  **identifier**  | An unique IMDb id that starts with `tt` followed by exactly 7 or 8 digits found in the URL |
|   **runtime**    |                                  Total runtime of a show.                                  |
|   **revenue**    |                                 Total revenue of the show                                  |
|    **budget**    |                                  Total budget of the show                                  |
|    **profit**    |                    Calculated based on the values of revenue and budget                    |
|     **url**      |                                      URL of the show                                       |

```
has_and_belongs_to_many :genres
has_and_belongs_to_many :stars
has_and_belongs_to_many :producers
has_and_belongs_to_many :directors
```

---

## Running the App

### Setup env for the app

Run the following commands to execute locally:

The following will install required version of ruby (make sure [rvm is installed](https://rvm.io/rvm/install).)

```bash
git clone git@github.com:JuzerShakir/imdb_api.git

gem install rails -v 7.0.4

cd imdb_api

bundle install
```

### Setup PostgreSQL

To successfully create development and test database, you will need to update `config.database.yml` file with correct postgresql username and password.
To edit the it without exposing your credentials, give the following command:

```bash
EDITOR="code --wait" rails credentials:edit
```

_`code` for Visual Studio Code_
_`subl` for sublime_

This will open `credential.yml` file and enter credential as follows in it:

```
database:
  username: your_username
  password: your_password
```

Hit `ctrl + s` to save and then close the `credential.yml` file from the editor. This will save the credentials. To check if it did save, run the following inside rails console:

```
Rails.application.credentials.dig(:database, :username)
```

Create database:

```bash
rails db:create
```

### Setup Background Jobs

You will also need to install and setup sidekiq and redis to enable background jobs for extracting and saving data from IMDb website to db.

#### Setting Up Sidekiq

[Video Tutorial](https://youtu.be/aaGSh38nzq8)

#### Setting Up Redis

[Blog Tutorial](https://www.digitalocean.com/community/tutorials/how-to-install-and-secure-redis-on-ubuntu-18-04)

You're now ready to use this webapp.

---

## Feeding the Data

### Manually

Make sure first you instantiate rails server and sidekiq:

```bash
rails server
sidekiq
```

#### POST request

Performing a POST request by entering the correct URL of a Movie or TV-Series from IMDb website:

```bash
curl --request POST --header "Content-Type: application/json" --data '{"url": "https://www.imdb.com/title/tt0944947/"}' http://localhost:3000/api/entertainment -v
```

#### GET request

Performing a GET request with a valid IMDb ID which returns a JSON object of a Movie or Tv-Series:

```bash
curl --request GET --header "Content-Type: application/json" --data '{"identifier":"tt0944947"}' http://localhost:3000/api/entertainment
```

#### PATCH request

Performing a PATCH request to update an existing entry:

```bash
curl --request PATCH --header "Content-Type: application/json" --data '{"identifier": "tt0944947"}' http://localhost:3000/api/entertainment -v
```

Which will update the following attributes: `ratings`, `popularity`, `budget`, `revenue`

#### DELETE request

Performing a DELETE request to delete an existing entry:

```bash
curl --request DELETE --header "Content-Type: application/json" --data '{"identifier": "tt0944947"}' http://localhost:3000/api/entertainment -v
```

> > **NOTE**:
> > An IMDb ID can be found in the link of the URL which is followed by the 'title' text in the link, for example: _`https://www.imdb.com/title/tt5052448`_, here **tt5052448** is a Unique IMDb ID for that Movie or TV-Series which I call an `identifier` in my project.

---

## Via Seed

The `lib/seed_data` folder contains 2 files, `movie_links.txt` & `tv-series_links.txt`, where each file contains links of Top 250 [Movies](https://www.imdb.com/chart/top/?ref_=nv_mv_250) and [TV-Series](https://www.imdb.com/chart/toptv/?ref_=nv_tvv_250) according to IMDb ratings respectively.

**Few things to note before running `rails db:seed`**

1. Depending on your system specifications, this process might take lots resources or even hang if you have other heavy programs running simultaneously. It is recommended that all programs should be closed.

2. The process of fetching a link, extracting the data and persisting to it to the database takes around ~7 secs. Calculating this time for all 500 shows would take around ~3500 secs (~1 hour).

3. The `seeds.rb` file doesn't execute all links one after the other. It has been divided into batches where each batch consists of 30 links. After executing each batch, the execution pauses for 30 seconds to avoid 'Are you a robot' check from the browser. So, the total time to execute all 500 shows will be ~50 mins.

4. I have provided a constant named `N` in `seeds.rb` file which you can change to however many shows you want to populate in your database. **By default, I have set its value to `125` which means total shows executed will be 250, 125 from each file, which would take around ~33 mins to execute.**

---

## Business Logic

I have provided some class methods that I think will be useful to us to get useful insights of the data or perform further operations with the result returned.

After seeding the data, here are some of the results returned by the logics provided in the model:

### Entertainment Model

_Will work in `Movie` & `TvShow` models_

1. **`Entertainment.highest_ratings(5)`**

```ruby
[#<TvShow:0x00007f4ad7977600
  id: 251,
  title: "Planet Earth II",
  ratings: 9.5,
  ..
  profit: nil>,
 #<TvShow:0x00007f4ad78f3e40
  id: 252,
  title: "Breaking Bad",
  ratings: 9.5,
  ...
  profit: nil>
]
```

2. **`Entertainment.ratings_between(9, 10)`**

```ruby
[#<Movie:0x00007fe3f5b9f628
  id: 3,
  title: "The Dark Knight",
  ratings: 9.0,
  ...
  profit: 821182769>,
 #<Movie:0x00007fe3f5b9f2e0
  id: 4,
  title: "The Godfather: Part II",
  ratings: 9.0,
  ...
  profit: 34961919>]
```

3. **`Entertainment.released_in_year(2022)`**

```ruby
#<TvShow:0x00007fe3f5bb1558
  id: 498,
  title:"RocketBoys",
  ratings: 8.9,
  ...
  profit: nil>,
 #<Movie:0x00007fe3f5bb1288
  id: 504,
  title: "A Thursday",
  ratings: 7.7,
  ...
  profit: nil>
]
```

### Movie Model

1. **`Movie.weekend_release_with_highest_rating.first`**

```ruby
 =>
#<Movie:0x00007f1fd47aacd8
 id: 28,
 title: "Star Wars",
 ratings: 8.6,
 tagline:
  "Luke Skywalker joins forces with a Jedi Knight, a cocky pilot, a Wookiee and two droids to save the galaxy from the Empire's world-destroying battle station, while also attempting to rescue Princess Leia from the mysterious Darth Vader.",
 release_date: Sun, 29 Jan 1978 00:00:00.000000000 UTC +00:00,
 popularity: 1300000,
 type: "Movie",
 identifier: "tt0076759",
 runtime: 120,
 revenue: 775398007,
 budget: 11000000,
 url: "https://www.imdb.com/title/tt0076759",
 created_at: Tue, 20 Sep 2022 14:28:54.828374000 UTC +00:00,
 updated_at: Tue, 20 Sep 2022 14:28:54.828374000 UTC +00:00,
 profit: 764398007>
```

2. **`Movie.weekend_release_with_highest_profit.first`**

```ruby
#<Movie:0x00007f67ba826af8
 id: 28,
 title: "Star Wars",
 ratings: 8.6,
 tagline:
  "Luke Skywalker joins forces with a Jedi Knight, a cocky pilot, a Wookiee and two droids to save the galaxy from the Empire's world-destroying battle station, while also attempting to rescue Princess Leia from the mysterious Darth Vader.",
 release_date: Sun, 29 Jan 1978 00:00:00.000000000 UTC +00:00,
 popularity: 1300000,
 type: "Movie",
 identifier: "tt0076759",
 runtime: 120,
 revenue: 775398007,
 budget: 11000000,
 url: "https://www.imdb.com/title/tt0076759",
 created_at: Tue, 20 Sep 2022 14:28:54.828374000 UTC +00:00,
 updated_at: Tue, 20 Sep 2022 14:28:54.828374000 UTC +00:00,
 profit: 764398007>
```

### Producer Model

1. **`Producer.produced_more_than(20)`**

```ruby
[<Producer:0x00007f2e4b9b7a28
  id: 5, name: "Warner Bros.">,
  <Producer:0x00007f2e4b99c818
  id: 358, name: "British Broadcasting Corporation (BBC)">]
```

### Director Model

1. **`Director.directed_more_than(7)`**

```ruby
[<Director:0x00007f2e500b38a0 id: 3, name: "Christopher Nolan">,
 <Director:0x00007f2e500bfd08 id: 97, name: "Clint Eastwood">,
 <Director:0x00007f2e500bfbf0 id: 179, name: "David Attenborough">,
 <Director:0x00007f2e500bfa88 id: 5, name: "Steven Spielberg">]
```

### Genre Model

1. **`Genre.appeared_more_than(100)`**

```ruby
[<Genre:0x00007f2e51fca6d0 id: 1, name: "Drama">,
 <Genre:0x00007f2e51f21b70 id: 15, name: "Comedy">,
 <Genre:0x00007f2e51f21aa8 id: 3, name: "Action">,
 <Genre:0x00007f2e51f219e0 id: 6, name: "Adventure">,
 <Genre:0x00007f2e51f218c8 id: 2, name: "Crime">,
 <Genre:0x00007f2e51f21198 id: 4, name: "Biography">]
```

### Star Model

1. **`Star.acted_in_more_than(9)`**

```ruby
[<Star:0x00007fe2d843c340 id: 16, name: "Robert De Niro">,
 <Star:0x00007fe2d8448d20 id: 46, name: "Tom Hanks">]
```

#### Shared Scope

And all of these models, `Director, Producer, Genre & Stars` have the following method:

1. **`Star.with_most_profit(1)`**

```ruby
[<Star:0x00007fe2d909ffd8 id: nil, name: "Mark Ruffalo">]
```

2. **`Director.with_most_profit(1)`**

```ruby
[<Director:0x00007fe2da5cdd38 id: nil, name: "Anthony Russo">]
```
