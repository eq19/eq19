from freqtrade.resolvers import ExchangeResolver

# Initialize the exchange
exchange = ExchangeResolver.load_exchange_from_config("config.json")

# Fetch tickers for all pairs
tickers = exchange.fetch_tickers()

# Print all ticker data
for pair, ticker in tickers.items():
    print(f"{pair}: {ticker}")
