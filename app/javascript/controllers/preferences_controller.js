import { Controller } from "@hotwired/stimulus"
import { csrfToken } from "@rails/ujs"

export default class extends Controller {
  static targets = ["prefCard", "notif"]

  connect() {
    console.log("hello from preferences_controller!")
  }

  color_red(event) {
    //console.log(event);
    const unhappy = event.target
    const id = unhappy.id.split("-")[0]
    unhappy.style.color = "indianred"
    const neutral = document.getElementById(`${id}-neutral-2`)
    const happy = document.getElementById(`${id}-happy-3`)
    neutral.style.color = "grey"
    happy.style.color = "grey"
  }

  color_orange(event) {
    //console.log(event);
    const neutral = event.target
    const id = neutral.id.split("-")[0]
    neutral.style.color = "orange"
    const unhappy = document.getElementById(`${id}-unhappy-1`)
    const happy = document.getElementById(`${id}-happy-3`)
    unhappy.style.color = "grey"
    happy.style.color = "grey"
  }

  color_green(event) {
    //console.log(event);
    const happy = event.target
    const id = happy.id.split("-")[0]
    happy.style.color = "forestgreen"
    const neutral = document.getElementById(`${id}-neutral-2`)
    const unhappy = document.getElementById(`${id}-unhappy-1`)
    neutral.style.color = "grey"
    unhappy.style.color = "grey"
  }

  update(event) {
    event.preventDefault();
    let selected = []
    this.prefCardTargets.forEach(pref => {
      const ratings = pref.querySelectorAll("i")
      selected.push(Array.from(ratings).filter(rating => rating.style.color !== "grey")[0])
    })
    console.log(selected)

    selected.forEach(element => {
      const prefid = element.id.split("-")[0]
      const rating = element.id.split("-")[2]
      console.log(`selected rating ${rating}`)
      // edit_preference_81
      const form = document.getElementById(`edit_preference_${prefid}`)
      let inputValue = form.querySelector("#preference_rating")
      inputValue.value = rating
      console.log(`form input value: ${inputValue.value}`)

      fetch(`/preferences/${prefid}`, {
        method: "PATCH",
        headers: { "Accept": "text/plain" , "X-CSRF-Token": csrfToken() },
        body: new FormData(document.getElementById(`edit_preference_${prefid}`))
      })
      .then(response => response.redirect("/preferences"))
      .then((data) => {
        //console.log(data)
      })
    })
    //alert("your preference has been saved")
    //location.reload(true);
    //this.notifTarget.style.display = "block"
    const body = document.getElementById('preferences')
    const notice = `<div class="flash flash-warning alert alert-dismissible fade show" role="alert">
                  Your preference has been saved 📂
                  <a data-bs-dismiss="alert" aria-label="Close">
                    <i class="fas fa-times"></i>
                  </a>
                </div>`

    body.insertAdjacentHTML("afterbegin", notice)
    window.scrollTo({ top: 0, behavior: 'smooth' });
    window.setTimeout(function(){document.querySelector(".flash").remove()},3000)
    //window.setTimeout(function(){location.reload()},3000)
  }

  closeNotif() {
    this.notifTarget.style.display = "none"
  }
}
