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
- [ ] Provide business logic.

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

## Feeding Data

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

Performing a GET request with a valid IMDb ID to return a JSON object of a Movie or Tv-Series:

```bash
curl --request GET --header "Content-Type: application/json" --data '{"identifier":"tt0944947"}' http://localhost:3000/api/entertainment
```

#### PATCH request

Performing a PATCH request to update an existing entry:

```bash
curl --request PATCH --header "Content-Type: application/json" --data '{"identifier": "tt0944947"}' http://localhost:3000/api/entertainment -v
```

Which will update the following attributes: `ratings`, `popularity`, `budget`, `revenue`

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
