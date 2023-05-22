module.exports = {
  content: [
    "./app/views/**/*.html.erb",
    "./app/helpers/**/*.rb",
    "./app/assets/stylesheets/**/*.css",
    "./app/javascript/**/*.js"
  ],

  daisyui: {
    base: true,
    darkTheme: "wireframe",
    logs: true,
    prefix: "",
    rtl: false,
    styled: true,
    themes: ["wireframe"],
    utils: true,
  },

  plugins: [require("daisyui")]
}
