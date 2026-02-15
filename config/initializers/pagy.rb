# Pagy v43 Initializer
# See https://ddnexus.github.io/pagy/docs/upgrade/#upgrade-to-43

# Pagy v43 leverages intelligent autoloading and a simplified API.
# Most configuration is now handled via Pagy.options.

# Default items per page
Pagy.options[:limit] = 20

# Handle cases where the page number is too high
# In v43, this can often be handled via the :overflow option if the extra is available/configured.
# Setting it directly in options for the offset paginator:
Pagy.options[:overflow] = :last_page

# Note: Explicit 'require' for extras like 'bootstrap' is often no longer needed
# if using the new #series_nav(:bootstrap) method, as it autoloads helpers.
