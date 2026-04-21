// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";

import { createIcons, House, GraduationCap, User, Phone } from "lucide";

document.addEventListener("DOMContentLoaded", () => {
  createIcons({
    icons: {
      house: House,
      "graduation-cap": GraduationCap,
      user: User,
      phone: Phone,
    },
  });
  console.log("Icons created");
  console.log("Icons created");
});
