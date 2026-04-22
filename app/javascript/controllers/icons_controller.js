import { Controller } from "@hotwired/stimulus";
// Trocamos House por Home aqui
import { createIcons, Home, GraduationCap, BookOpen, Phone } from "lucide";

export default class extends Controller {
  connect() {
    createIcons({
      icons: {
        Home,
        GraduationCap,
        BookOpen,
        Phone,
      },
    });
  }
}
