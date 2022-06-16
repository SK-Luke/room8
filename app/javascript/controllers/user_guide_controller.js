import { Controller } from "@hotwired/stimulus"
import { csrfToken } from "@rails/ujs"
import { createPopper } from '@popperjs/core'

export default class extends Controller {
  static targets = ["stopTour"]

  connect() {
    console.log("hello from user_guide_controller!")
  }

  // tourStart(event) {
  //   event.preventDefault()
  //   console.log(event)
  //   const guide1 = document.getElementById('guide1')
  //   // guide1.style.transition = "left 1.0s linear 0s";
  //   // guide1.style.left = "10px";
  // }

  clickCard() {
    const guide1 = document.getElementById('guide1')
    guide1.style.display="none"
    const choreCard = document.querySelector('.chore_card')
    const tooltip = document.getElementById('clickCard')

    createPopper(choreCard, tooltip, {
      modifiers: [
        {
          name: 'offset',
          options: {
            offset: [0, 8],
          },
        },
      ],
    });
    tooltip.setAttribute('data-show', '');
  }

  stopTour() {
    const guide1 = document.getElementById('guide1')
    guide1.style.display = "none"

    const tooltips = document.getElementsByClassName("tooltip")
    Array.from(tooltips).forEach(tooltip => {
      tooltip.style.display = "none"
    })
  }

}
