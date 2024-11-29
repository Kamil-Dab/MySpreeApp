# My Spree App

## How to Start

To get started with My Spree App using Docker, follow these steps:

1. **Clone the repository:**

    ```bash
    git clone https://github.com/yourusername/MySpreeApp.git
    cd MySpreeApp
    ```

2. **Start the Docker containers:**

    ```bash
    docker-compose up --build
    ```

3. **Set up the database:**

    ```bash
    docker-compose run app bin/rails db:setup
    ```

4. **Access the application:**

    Your application should now be running on `http://localhost:3000`.

To sign in into the admin dashboard go to `https://localhost:3000/admin` and use the following credentials:

```bash
Email: spree@example.com
Password: spree123
```
Note that sample data does not automatically get loaded when deploying to Render with the default configuration. In order to add sample data, run the following commands in the web service shell:

```bash
bin/rake spree_sample:load
```


To stop the Docker containers, use:

```bash
docker-compose down
```


If you want to use sample data (products, categories), you can load it using the following command:

```bash
bin/rake spree_sample:load
```


