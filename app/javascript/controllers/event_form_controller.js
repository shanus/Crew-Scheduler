import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "boatSelect", "dateInput", "startTime", "endTime", "boatMessage", "timeMessage", "tideSummary", "boatDetail" ]

  connect() {
    this.boatMessageTarget = document.getElementById("boat_message")
    this.timeMessageTarget = document.getElementById("time_message")
    this.tideSummaryTarget = document.getElementById("tide_summary")
    this.boatDetailTarget = document.getElementById("boat_detail")
  }

  boatChanged(event) {
    this.checkAvailability()
    this.updateBoatDetail()
  }

  updateTides() {
    const date = event.target.value
    if (!date) return

    fetch(`/tides/summary/5?date=${this.formatDateForTides(date)}`)
      .then(response => response.text())
      .then(html => {
        this.tideSummaryTarget.innerHTML = html
      })
  }

  checkAvailability() {
    const boatId = document.getElementById("event_boat_id").value
    const date = document.getElementById("event_event_on").value
    const start = document.getElementById("event_start_time").value
    const end = document.getElementById("event_end_time").value

    if (!boatId || !date || !start || !end) return

    fetch(`/boats/check_availability?id=${boatId}&date=${this.formatDate(date)}&start=${start}&end=${end}`)
      .then(response => response.text())
      .then(html => {
        this.boatMessageTarget.innerHTML = html
        this.boatMessageTarget.classList.remove("d-none")
      })
    
    this.checkTideTime(date, start, end)
  }

  checkTideTime(date, start, end) {
    fetch(`/tides/check_time?date=${this.formatDate(date)}&start=${start}&end=${end}`)
      .then(response => response.text())
      .then(html => {
        if (html.trim() !== "") {
          this.timeMessageTarget.innerHTML = html
          this.timeMessageTarget.classList.remove("d-none")
        } else {
          this.timeMessageTarget.classList.add("d-none")
        }
      })
  }

  updateBoatDetail() {
    const boatId = document.getElementById("event_boat_id").value
    if (!boatId) {
      this.boatDetailTarget.classList.add("d-none")
      return
    }

    fetch(`/boats/details?id=${boatId}`)
      .then(response => response.text())
      .then(html => {
        this.boatDetailTarget.innerHTML = html
        this.boatDetailTarget.classList.remove("d-none")
      })
  }

  formatDate(dateStr) {
    // Input is YYYY-MM-DD, output needs to be DD-MM-YYYY for legacy controller compatibility
    const [y, m, d] = dateStr.split("-")
    return `${d}-${m}-${y}`
  }

  formatDateForTides(dateStr) {
    // Tides summary expects MM-DD-YYYY
    const [y, m, d] = dateStr.split("-")
    return `${m}-${d}-${y}`
  }
}
