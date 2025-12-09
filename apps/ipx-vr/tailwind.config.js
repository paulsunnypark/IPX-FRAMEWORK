/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./resources/**/*.{vue,js,ts,jsx,tsx,blade.php}",
    "./resources/views/**/*.blade.php",
    "../../node_modules/primevue/**/*.{vue,js,ts,jsx,tsx}",
    "../../node_modules/primeicons/**/*.{js,ts}"
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}

