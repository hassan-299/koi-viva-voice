# Koi Viva Voce

Koi Viva Voce is a powerful quiz management tool designed to streamline learning and assessment in educational institutions. Whether you're an educator or student, Koi Viva Voce offers an intuitive platform to create, manage, and evaluate quizzes that foster interactive learning experiences.

## Prerequisites

Before you begin, ensure that you have the following installed on your machine:

- [Ruby (version 3.3.4 or higher)](https://www.ruby-lang.org/en/downloads/)
- [Node.js (version 20.11.1 or higher)](https://nodejs.org/)
- [PostgreSQL (as your database server)](https://www.postgresql.org/download/)

## 1. Installation

If you haven't cloned the repository yet, you can do so by running:

```

git clone https://github.com/hassan-299/koi-viva-voice.git
cd koi-viva-voice
```

## 2. Install Ruby dependencies

Make sure you're using the correct version of Ruby. If you're using `rbenv` or `rvm`, you can set the Ruby version for this project.

Then, install the Ruby gems defined in your Gemfile by running:

```
bundle install
```

## 3. Install Node.js dependencies

Run the following command to install Node.js packages:

```
yarn install
```

## 4. Set up the database

Create the database and run migrations:

```
rails db:setup
```

This will:

1. Create the database.
2. Load the schema.
3. Seed the database with default data (if any).

## 5. Environment variables

The application uses environment variables to manage sensitive information. Copy the example environment file and update it with your credentials:

```
cp .env.example .env
```

Ensure you provide values for the following variables:

- `ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY`
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_REGION`
- `AWS_BUCKET_NAME`

## 6. Start the server

Run the Rails server to start the application:

```
bin/dev
```

Visit [http://localhost:3000](http://localhost:3000) in your browser to see the application.

## Teacher Credentials

To gain access as a teacher, please contact [Hassan](https://github.com/hassan-299) to receive your login credentials and additional setup instructions.

## Technologies Used

- **Ruby on Rails**: Backend framework for building the application.
- **PostgreSQL**: Database server.
- **Tailwind CSS**: Utility-first CSS framework.
- **Stimulus**: JavaScript framework for interactions.
- **Polaris View Components**: UI components for building user interfaces.
- **AWS S3**: Image and video management.
- **Acts as Tenant**: Multi-tenancy support.

## Key Gems Used

Here are some of the key gems used in the project and their purpose:

- `rails`: Web application framework.
- `propshaft`: Modern asset pipeline.
- `pg`: PostgreSQL database adapter.
- `puma`: Web server.
- `turbo-rails` and `stimulus-rails`: Hotwire for SPA-like experiences.
- `cssbundling-rails`: CSS bundling with Tailwind CSS.
- `dotenv-rails`: Environment variable management.
- `decent_exposure`: Simplifies controller code.
- `slim-rails`: Template engine for cleaner HTML.
- `polaris_view_components`: UI components for Polaris design system.
- `cocoon`: Nested forms.
- `aws-sdk-s3`: File and image management.
- `rails_charts` and `groupdate`: Data visualization and charting.
- `acts_as_tenant`: Multi-tenancy support.

## Contributing

We welcome contributions to Koi Viva Voce! To contribute:

1. Fork the repository.
2. Create a new branch for your feature or bugfix.
3. Commit your changes with clear commit messages.
4. Submit a pull request to the main repository.

## License

Koi Viva Voce is a private product licensed under the koi-viva-voice License.

## Contact

For questions or support, please contact [Hassan](https://github.com/hassan-299) or open an issue on the repository.

---

Happy coding!
