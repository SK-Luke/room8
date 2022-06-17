import { Controller } from "@hotwired/stimulus";
// import { csrfToken } from "@rails/ujs";

export default class extends Controller {
  // static targets = ["lists", "form", "alert"];
  // static values = {
  //   flatid: String,
  // };

  connect() {
    const container = this.element.classList[0];

    new Swiper(`.${container}`, {
      direction: "horizontal",
      effect: "cards",
      grabCursor: true,
      overflow: false,
      pagination: {
        el: `.pagination-${container}`,
      },
    });

    const list = document.querySelectorAll(".my-chore-list");
    function activeLink() {
      list.forEach((item) => {
        item.classList.remove("status");
        this.classList.add("status");
      });
    }

    list.forEach((item) => {
      item.addEventListener("click", activeLink);
      console.log("test");
    });

    function openCards(evt, cardName) {
      var i, tabcontent, tablinks;
      tabcontent = document.getElementsByClassName("tabcontent");
      for (i = 0; i < tabcontent.length; i++) {
        tabcontent[i].style.display = "none";
      }
      tablinks = document.getElementsByClassName("tablinks");
      for (i = 0; i < tablinks.length; i++) {
        tablinks[i].className = tablinks[i].className.replace(" active", "");
      }
      document.getElementById(cardName).style.display = "block";
      evt.currentTarget.className += " active";
    }

    document.getElementById("defaultOpen").click();
  }
}
