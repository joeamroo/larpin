// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Clear inline forms (comments, DMs) after a successful Turbo submission
document.addEventListener("turbo:submit-end", (event) => {
  if (event.detail.success && event.target.querySelector("input[type=text], textarea")) {
    event.target.reset()
  }
})
