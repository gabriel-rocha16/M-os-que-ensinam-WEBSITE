import { Controller } from "@hotwired/stimulus";
// Adicionamos a Star na importação
import {
  createIcons,
  Home,
  GraduationCap,
  BookOpen,
  Phone,
  Heart,
  UserPlus,
  ArrowDown,
  Calendar,
  Star,
} from "lucide";

export default class extends Controller {
  connect() {
    createIcons({
      icons: {
        Home,
        GraduationCap,
        BookOpen,
        Phone,
        Heart,
        UserPlus,
        ArrowDown,
        Calendar,
        Star, // Adicionado aqui
      },
    });
  }
}
