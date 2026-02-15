import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
	static targets = ["icon"]

	connect() {
		this.applyTheme(this.currentTheme)
	}

	toggle() {
		const newTheme = this.currentTheme === "dark" ? "light" : "dark"
		this.applyTheme(newTheme)
		localStorage.setItem("theme", newTheme)
	}

	applyTheme(theme) {
		document.documentElement.setAttribute("data-bs-theme", theme)
		this.updateIcon(theme)
	}

	updateIcon(theme) {
		if (this.hasIconTarget) {
			this.iconTarget.className = theme === "dark" ? "bi bi-moon-stars-fill" : "bi bi-sun-fill"
		}
	}

	get currentTheme() {
		return localStorage.getItem("theme") ||
			(window.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light")
	}
}
