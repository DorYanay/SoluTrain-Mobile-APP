# SoluTrain

## Requirements

* conda
* docker
* docker compose
* flutter
* Android Studio

## Technologies

* python - As programming language for the backend
* conda - For managing python environment
* poetry - For managing python dependencies
* FastAPI - As framework for the backend
* PostgresSQL - As database
* docker - For development in production of the backend
* docker compose - For local development
* flutter - As framework for the mobile app
* Dart - As programming language for the mobile app

## Installation

Run the following commands to install:

```bash
git clone git@github.com:omer-priel/solutrain.git
cd solutrain

conda env create -f environment.yml
conda activate solutrain

cd backend
poetry install
```

## Environment Variables

### Backend

Table of the required environment variables for the backend:

| Variable    | Description               |
|-------------|---------------------------|
| PG_DATABASE | PostgresSQL database name |
| PG_USER     | PostgresSQL user          |
| PG_PASSWORD | PostgresSQL password      |
| PG_HOST     | PostgresSQL host          |

Table of the optional environment variables for the backend:

| Variable | Description      | Default |
|----------|------------------|---------|
| PG_PORT  | PostgresSQL port | 5432    |

For local development add .env file to backend directory that contains the environment variables. \
Exists .env.example file as example.

### Mobile

Table of the optional environment variables for the mobile:

| Variable     | Description          | Default                        |
|--------------|----------------------|--------------------------------|
| API_IS_HTTPS | API is HTTPS of HTTP | true                           |
| API_HOST     | API host             | solutrain-backend.onrender.com |
| API_PORT     | API port             | 443                            |

For local development in Android Studio you can change the environment variables, in the configuration. \
Recommended to add different configuration for production and local development.

## Files Structure

Note: the **API** means the backend and the **app** means the mobile app.

* backend - The Backend API Service
  * src - The source code
    * models - The models of Database for handling the communication with the database
    * routers - The routers of the API
    * __main__.py - The entry point for running the API
    * app.py - The FastAPI application
    * config.py - The configuration of the API
    * exceptions.py - The exceptions of the API
    * logger.py - The logger of the API and handler logging related
    * migrations.py - The migrations of the database
    * security.py - The security of the API, authentication and hashing
  * .env - Environment variables file
  * .env.example - Example of the environment variables file
  * Dockerfile - Dockerfile for building the image of the API
  * poetry.lock - Poetry lock file, for managing the dependencies (changed only by poetry)
  * pyproject.toml - Poetry project file, for managing the dependencies
* mobile - The Mobile App
  * android - The Android App, for customiztion for Android
  * ios - The iOS App, for customiztion for iOS
  * lib - The source code
    * images - Static images for the app
    * pages - Pages of the app
      * main - the page that responsible for presetting the current page (other page in pages)
    * widgets - Custom reusable widgets for the app
    * api.dart - Handling the communication with the API
    * app_model.dart - The model (global state) of the app
    * config.dart - The configuration of the app
    * main.dart - The entry point for the app
    * schemas.dart - The schemas of the API
  * test - The tests of the app (not implemented yet)
  * .env - Environment variables file for local development only. Can be loaded by Android Studio
  * pubspec.lock - Pubspec lock file, for managing the dependencies (changed only by pub)
  * pubspec.yaml - Pubspec project file, for managing the dependencies
* docs - documentation
* res - resources
* scripts - Scripts for development in the project\
  * backend-clean.bat - For cleaning the cache of the backend
  * backend-fix.bat - For running the Formaters of the backend
  * backend-fix-lint.bat - For running the Formaters and Linters of the backend
  * backend-lint.bat - For running the Linters of the backend
  * backend-rebuild-db.bat - For rebuild the local database
  * mobile-fix.bat - For running the Formaters of the mobile
  * mobile-fix-lint.bat - For running the Formaters and Linters of the mobile
  * mobile-lint.bat - For running the Linters of the mobile
* environment.yml - Conda environment file
* database-diagram.jpeg - Database diagram
* docker-compose.yml - Docker compose file for local development
* LICENSE - License file
* README.md - This file

## Diagrams

Database

![Database](database-diagram.png)

Network diagram flow

```mermaid
flowchart LR
    Flutter(Flutter Dart) --- API(FastAPI python) --- PostgresSQL
```

Services diagram

```mermaid
flowchart RL
  subgraph mobile
    UI --> State --> Logic
    UI --> Logic
  end
  Logic --> routers
  subgraph render.com
    subgraph backend
      routers --> models
    end
    subgraph database
      models --> PostgresSQL
      PostgresSQL --> models
    end
    subgraph backend
      models --> routers
    end
  end
  routers --> Logic
  subgraph mobile
    Logic --> State --> UI
  end
```

* You can deploy locally using Docker Compose and not render.com

Pages diagram

```mermaid
flowchart TD
  subgraph auth
    Login
    SignUp
  end
  subgraph main
    Select-Area     
    My-Groups
    My-Meetings
    Profile
  end
  
  Login --> SignUp
  SignUp --> Login
  Login <---> Select-Area
  
  Select-Area --> Search-Groups
  Search-Groups --> View-Group
  View-Group --> View-Meeting & View-Coach
  My-Groups --> View-Group
  View-Group -->|from search| Search-Groups
  View-Meeting --> View-Group & View-Coach
  View-Coach --> View-Group & View-Meeting
  My-Meetings --> View-Meeting
  
  Profile --> Groups
  Groups --> Create-Group
  Create-Group --> Group & Groups
  Group --> Groups
  Group --> Create-Meeting
  Create-Meeting --> Meeting & Group
  Group --> Meeting & View-Trainer
  Meeting --> View-Trainer & Group
  View-Trainer --> Group
  View-Trainer -->|from meeting| Meeting
```

* Note: Any page can navigate to the Select-Area, My-Groups, My-Meetings, Profile and Login (by Logout).

## Get Started

For running the mobile app open the project in Android Studio and run the app. \
It will connect to the API in the cloud on render.com

### Backend Local Development

You can deploy local the backend with the database by docker compose

```bash
docker compose up --build
```

* Note: by docker based you need to create the table by SQL using the SQL in backend/src/migration.py

Or you can create database using docker and the backend on python with conda \
according to the following steps \
For starting the database run in a terminal the following commands:

```bash
docker compose up -d db
```

For create the tables in the database run in a terminal the following commands:

```bash
cd backend
python -m src migrate
```

For running the backend run in a terminal the following commands:

```bash
python -m src
```

And open in a browser the localhost:8000/docs

You can also run the backend in a docker container by running the following commands:

```bash
docker compose up --build backend
```

And open in a browser the 0.0.0.0:8000/docs

## CI

### Linux / MacOS

For running the Formaters and Linters run in a terminal the following commands:

```bash
make fix-lint
```

For cleaning the cache run in a terminal the following commands:

```bash
make clean
```

For rebuild the database run in a terminal the following commands:

```bash
docker-compose rm -f -s db
docker-compose up -d db
sleep 1
cd backend
python -m src migrate
```

### Windows

For running the Formaters and Linters for mobile run the BAT file scripts/mobile-fix-lint.bat

## License

MIT

## Author

* Dor Yanay - [GitHub](http://www.github.com/DorYanay)
* Omer Priel
* Ori Sharaby
* Stav Avitan
* Stav Sharon
