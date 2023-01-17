# Autochecker

### Automatically check for available Global Entry appointments and be notified on the Pushover app when one becomes available.

I have the Pushover env vars set up on my laptop for dev.

Deployment with docker compose on the Raspberry Pi where I am running this, I create a `.env` file for Docker Compose to use.

`cp .env.example .env`

Fill in your details

`docker-compose up --build -d`


To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
