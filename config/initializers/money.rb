MoneyRails.configure do |config|
  # Set the default currency
  config.default_currency = :usd

  # Add exchange rates to current money bank object.
  # (The conversion rate refers to one direction only)
  # Example:
  # config.add_rate "USD", "CAD", 1.24515
  # config.add_rate "CAD", "USD", 0.803115

  # To handle the inclusion of validations for monetized fields
  # The default value is true
  config.include_validations = true

  # Register a custom currency
  # config.register_currency = {
  #   priority:            1,
  #   iso_code:           "EU4",
  #   name:               "Euro with subunit of 4 digits",
  #   symbol:             "€",
  #   symbol_first:       true,
  #   subunit:            "Subcent",
  #   subunit_to_unit:    10000,
  #   thousands_separator: ".",
  #   decimal_mark:       ","
  # }

  # Specify a rounding mode
  # Any one of:
  #
  # BigDecimal::ROUND_UP,
  # BigDecimal::ROUND_DOWN,
  # BigDecimal::ROUND_HALF_UP,
  # BigDecimal::ROUND_HALF_DOWN,
  # BigDecimal::ROUND_HALF_EVEN,
  # BigDecimal::ROUND_CEILING,
  # BigDecimal::ROUND_FLOOR
  #
  # set to BigDecimal::ROUND_HALF_EVEN by default
  #
  # config.rounding_mode = BigDecimal::ROUND_HALF_UP

  # Set default money format globally.
  # Default value is nil meaning "ignore this option".
  # Example:
  # config.default_format = {
  #   no_cents_if_whole: false,
  #   symbol: true,
  #   sign_before_symbol: true
  # }

  # If you would like to use I18n localization (formatting depends on the
  # locale):
  # config.locale_backend = :i18n
  #
  # Example (using default localization from rails-i18n):
  #
  # I18n.locale = :en
  # Money.new(10_000_00, 'USD').format # => $10,000.00
  # I18n.locale = :es
  # Money.new(10_000_00, 'USD').format # => $10.000,00
  #
  # For the legacy behaviour of "per currency" localization (formatting depends
  # only on currency):
  # config.locale_backend = :currency
  #
  # Example:
  # Money.new(10_000_00, 'USD').format # => $10,000.00
  # Money.new(10_000_00, 'EUR').format # => €10.000,00
  #
  # In case you don't need localization and would like to use default values
  # (can be redefined using config.default_format):
  # config.locale_backend = nil

  # Set default raise_error_on_money_parsing option
  # It will be raise error when assigned invalid value to monetized field
  # Defaults to false
  # config.raise_error_on_money_parsing = false
end
