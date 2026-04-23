import { Controller } from "@hotwired/stimulus";
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
  ArrowRight,
  Clock,
  PlayCircle,
  Users,
  User,
  Keyboard,
  Volume2,
  Contrast,
  Type,
  Captions,
  HeartHandshake,
  ShieldCheck,
  LogIn,
  Mail,
  MessageCircle,
  MapPin,
  Send,
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
        Star,
        ArrowRight,
        Clock,
        PlayCircle,
        Users,
        User,
        Keyboard,
        Volume2,
        Contrast,
        Type,
        Captions,
        HeartHandshake,
        ShieldCheck,
        LogIn,
        Mail, // Novo (E-mail)
        MessageCircle, // Novo (WhatsApp)
        MapPin, // Novo (Endereço)
        Send, // Novo (Botão Enviar)
      },
    });
  }
}
