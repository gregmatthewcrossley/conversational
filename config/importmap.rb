# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "@rails/actioncable", to: "actioncable.esm.js"
pin_all_from "app/javascript/channels", under: "channels"

pin_all_from "app/javascript/audio_playback_services", under: "audio_playback_services"
pin_all_from "app/javascript/conversation_services", under: "conversation_services"
pin_all_from "app/javascript/location_services", under: "location_services"
pin_all_from "app/javascript/remark_services", under: "remark_services"
