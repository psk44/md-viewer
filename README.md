# Markdown Viewer

## Overview

Markdown Viewer is a Ruby on Rails web application designed to manage and display Markdown (.md) documents. It allows users to upload Markdown files, extract their content, store it in a database, and render it as HTML using the `redcarpet` gem. The app includes advanced full-text search capabilities powered by `pg_search` and file upload handling via Rails' Active Storage. It runs in a Dockerized environment for easy setup and development.

## Features

- **Markdown Upload and Parsing**: Upload `.md` files, automatically extract their content, and store it in a database.
- **Markdown Rendering**: Convert Markdown content to HTML using the `redcarpet` gem for clean, formatted display.
- **Full-Text Search**: Search across document titles and content with partial matching, powered by PostgreSQL’s `pg_search`.
- **File Validation**: Restrict uploads to Markdown or plain text files using `activestorage-validator`.
- **Dockerized Setup**: Run the app and PostgreSQL database in containers with Docker Compose for consistent development.

## Tech Stack

- **Backend**: Ruby on Rails
- **Database**: PostgreSQL
- **Gems**:
  - `redcarpet`: Markdown parsing and rendering
  - `pg_search`: Full-text search
  - `activestorage-validator`: File type validation
- **Containerization**: Docker and Docker Compose

## Getting Started

### Prerequisites

- Docker and Docker Compose installed
- Git installed
- Ruby 3.2 (specified in the Dockerfile)

### Installation

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/psk44/md-viewer.git
   cd md-viewer
   ```

2. **Set Up Docker**:
   - Ensure your `docker-compose.yml` is configured as follows:
     ```yaml
     version: '3.8'
     services:
       app:
         build: .
         command: bash -c "rm -f tmp/pids/server.pid && rails server -b 0.0.0.0"
         volumes:
           - .:/app
         ports:
           - "3000:3000"
         environment:
           - RAILS_ENV=development
           - DATABASE_URL=postgres://postgres:password@db:5432/md_viewer_development
         depends_on:
           - db
       db:
         image: postgres:15
         volumes:
           - postgres_data:/var/lib/postgresql/data
         environment:
           - POSTGRES_USER=postgres
           - POSTGRES_PASSWORD=password
           - POSTGRES_DB=md_viewer_development
     volumes:
       postgres_data:
     ```

3. **Build and Run**:
   ```bash
   docker-compose up --build
   ```

4. **Set Up the Database**:
   - In a new terminal:
     ```bash
     docker-compose exec app rails db:create
     docker-compose exec app rails db:migrate
     ```

5. **Access the App**:
   - Open `http://localhost:3000/documents` in your browser.

### Usage

- **Upload a Document**:
  - Navigate to `http://localhost:3000/documents/new`.
  - Enter a title and optionally upload a `.md` file.
  - The file’s content is extracted and stored; non-Markdown files are rejected.
- **View Documents**:
  - Visit `http://localhost:3000/documents` to see all documents.
  - Click a document to view its rendered Markdown content.
- **Search**:
  - Use the search bar on the index page to find documents by title or content (supports partial matches).

### Project Structure

- **Models**:
  - `Document`: Stores `title` (string), `content` (text), and an attached `markdown_file` (via Active Storage).
- **Controllers**:
  - `DocumentsController`: Handles CRUD actions, file parsing, and search.
- **Views**:
  - `documents/index.html.erb`: Lists documents with a search bar.
  - `documents/show.html.erb`: Displays rendered Markdown.
  - `documents/_form.html.erb`: Form for creating/editing documents with file upload.
- **Helpers**:
  - `ApplicationHelper`: Includes a `markdown` method for rendering Markdown with `redcarpet`.

### Development Notes

- **Dockerfile**:
  ```Dockerfile
  FROM ruby:3.2
  RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
  WORKDIR /app
  COPY Gemfile Gemfile.lock ./
  RUN bundle install
  COPY . .
  EXPOSE 3000
  CMD ["rails", "server", "-b", "0.0.0.0"]
  ```
- **Gems**:
  - Ensure `Gemfile` includes:
    ```ruby
    gem 'redcarpet'
    gem 'pg_search'
    gem 'activestorage-validator'
    ```
- **File Validation**: Only `.md` and plain text files are allowed, enforced by:
  ```ruby
  validates :markdown_file, content_type: ['text/markdown', 'text/plain'], allow_nil: true
  ```

### Troubleshooting

- **Pending Migrations**:
  - Run `docker-compose exec app rails db:migrate` if you see migration errors.
- **Validator Errors**:
  - Ensure `activestorage-validator` is in `Gemfile` and installed (`docker-compose run app bundle install`).
- **File Parsing Issues**:
  - The app uses `@document.markdown_file.blob.download` to extract file content. If errors occur, verify the file is valid Markdown.
- **Search Not Working**:
  - Confirm `pg_search` is set up in `Document` model with `pg_search_scope`.

### Contributing

1. Fork the repo and create a branch:
   ```bash
   git checkout -b feature-name
   ```
2. Make changes and test locally.
3. Commit and push:
   ```bash
   git add .
   git commit -m "Add feature-name"
   git push origin feature-name
   ```
4. Open a pull request on GitHub.

### License

This project is open-source and available under the MIT License.

---

This README reflects the `md-viewer` branch’s functionality, focusing on its core features and setup. Let me know if you need further tweaks or additions!
