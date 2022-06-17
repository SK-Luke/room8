import flatpickr from "flatpickr";

const initFlatpickr = () => {
  flatpickr(".datepicker", {
    altInput: true,
    enableTime: true,
    altFormat: "F j, Y",
    dateFormat: "Y-m-d",
    disableMobile: true,
  });
};

export { initFlatpickr };
