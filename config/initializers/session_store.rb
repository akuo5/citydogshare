# Be sure to restart your server when you modify this file.

Citydogshare::Application.config.session_store :cookie_store, key: '_citydogshare_session', expire_after: 6.hours

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Citydogshare::Application.config.session_store :active_record_store
